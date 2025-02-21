package com.example.flutter_bluetooth

import android.annotation.SuppressLint
import android.app.Application
import android.bluetooth.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import android.os.Process
import android.text.TextUtils
import androidx.annotation.NonNull
import com.alibaba.fastjson.JSON
import com.example.flutter_bluetooth.ble.DeviceManager
import com.example.flutter_bluetooth.ble.DeviceManager.createBTDevice
import com.example.flutter_bluetooth.ble.DeviceManager.createBleDevice
import com.example.flutter_bluetooth.ble.DeviceManager.locateBTDevice
import com.example.flutter_bluetooth.ble.DeviceManager.locateBleDevice
import com.example.flutter_bluetooth.ble.callback.BluetoothCallback
import com.example.flutter_bluetooth.ble.config.BLEGattAttributes
import com.example.flutter_bluetooth.ble.protocol.ProtoMaker
import com.example.flutter_bluetooth.ble.scan.ScanLeCallBack
import com.example.flutter_bluetooth.ble.scan.ScanManager
import com.example.flutter_bluetooth.bt.A2dpConnectHelper
import com.example.flutter_bluetooth.bt.A2dpManager
import com.example.flutter_bluetooth.bt.IBondStateListener
import com.example.flutter_bluetooth.bt.spp.ISPPConnectStateListener
import com.example.flutter_bluetooth.bt.spp.ISPPDataListener
import com.example.flutter_bluetooth.dfu.BleDFUConfig
import com.example.flutter_bluetooth.dfu.BleDFUState
import com.example.flutter_bluetooth.logger.LogTransfer
import com.example.flutter_bluetooth.logger.Logger
import com.example.flutter_bluetooth.proxy.MyMethodChannel
import com.example.flutter_bluetooth.utils.*
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.AUTO_CONNECT
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.CANCEL_PAIR
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.CONNECT
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.CONNECT_SPP
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.DISCONNECT
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.DISCONNECT_SPP
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.GET_A2DP_STATE
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.GET_DEVICE_STATE
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.GET_DOCUMENT_PATH
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.GET_SPP_STATE
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.SEND_DATA
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.SEND_SPP_DATA
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.START_DFU
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.START_PAIR
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.START_SCAN
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.STATE
import com.example.flutter_bluetooth.utils.Constants.RequestMethod.STOP_SCAN
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*


/** FlutterBluetoothPlugin */
@SuppressLint("MissingPermission")
class FlutterBluetoothPlugin : FlutterPlugin, MethodCallHandler,
    IBondStateListener, ISPPDataListener, ISPPConnectStateListener, ScanLeCallBack, BleDFUState.IListener,
    A2dpConnectHelper.OnA2dpConnectChangedListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    companion object {
        private const val TAG = "FlutterBluetoothPlugin"
        const val REQUEST_BLUETOOTH_PERMISSIONS = 1520
        const val METHOD_CHANNEL_NAME = "flutter_bluetooth_IDO"
        const val METHOD_CHANNEL_NAME_DATA = "firmware_data"
        const val METHOD_CHANNEL_NAME_SPP = "send_spp_data"
        const val METHOD_CHANNEL_NAME_SPP_SEND_STATE = "send_spp_data_state"
        const val METHOD_CHANNEL_NAME_SPP_RECEIVE = "receive_spp_data"
        const val EVENT_CHANNEL_NAME = "bluetoothState"
        const val EVENT_CHANNEL_DEVICE_STATE = "deviceState"
    }


    private var initializationLock = Any()
    private var context: Context? = null

    private var application: Application? = null

    /**
     * 回调事件给Dart层
     */
    private var stateChannel: EventChannel? = null

    /**
     * 回调事件给Dart层
     */
    private var deviceStateChannel: EventChannel? = null

    /**
     * FlutterEngine提供的资源
     */
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    /**
     * 延迟方法调用，如需要申请权限后才能调用的方法
     */
    private var pendingCall: MethodCall? = null

    /**
     * 延迟结果回调
     */
    private var pendingResult: Result? = null

    private var createBondReceiver: BroadcastReceiver? = null

    private var channel: MethodChannel? = null
    private var dataChannel: MethodChannel? = null
    private var sppChannel: BasicMessageChannel<Any?>? = null
    private var sppSendStateChannel: BasicMessageChannel<Any?>? = null
    private var sppReceiveDataChannel: BasicMessageChannel<Any?>? = null

    private var mBluetoothManager: BluetoothManager? = null
    private var mBluetoothAdapter: BluetoothAdapter? = null
    private val mHandler = Handler(Looper.getMainLooper())

    private fun onConnectResult(
        deviceAddress: String,
        connectState: Int = Constants.BleConnectState.STATE_DISCONNECTED,
        error: Constants.BleConnectFailedError = Constants.BleConnectFailedError.DEFAULT,
        platform: Int = BLEGattAttributes.PLATFORM_IDO
    ) {
        Logger.p("onConnectResult, connectState = ${Constants.BleConnectState.getName(connectState)}, error = $error,  sink = ${deviceStateHandler.sink}, platform = $platform")
        sendDeviceState(ProtoMaker.makeConnectState(deviceAddress, 0, connectState, error.ordinal,platform))
//        invokeChannelMethod(
//            Constants.ResponseMethod.DEVICE_STATE, ProtoMaker.makeConnectState(deviceAddress, 0, connectState, error.ordinal)
//        )
    }

    private inner class IDOBleDeviceCallback(val deviceAddress: String) : BluetoothCallback {

        override fun callOnServices(services: List<String>) {
            Logger.e("callOnServices")
            callServices(deviceAddress,services)
        }

        override fun callOnConnectStart() {
        }

        override fun callOnConnecting() {
            onConnectResult(deviceAddress, connectState = Constants.BleConnectState.STATE_CONNECTING)
        }

        override fun callOnConnectTimeOut() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.TIMEOUT)
        }

        override fun callOnConnectBreakByGATT(status: Int, newState: Int,platform: Int) {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_BREAK, platform = platform)
        }

        override fun callOnConnectFailedByGATT(status: Int, newState: Int,platform: Int) {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_FAILED, platform = platform)
        }

        override fun callOnConnectFailedByErrorMacAddress() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.WRONG_MAC_ADDRESS)
        }

        override fun callOnConnectFailedByBluetoothSwitchClosed() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.BLE_SWITCH_CLOSED)
        }

        override fun callOnConnectFailedByEncryptedFailed() {
        }

        override fun callOnDiscoverServiceFailed() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.DISCOVER_SERVICE_FAILED)
        }

        override fun callOnInDfuMode() {
        }

        override fun callOnConnectedAndReady(platform: Int) {
            onConnectResult(
                deviceAddress,
                connectState = Constants.BleConnectState.STATE_CONNECTED,
                platform = platform
            )
        }

        override fun callOnEnableNormalNotifyFailed() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_FAILED)
        }

        override fun callOnEnableHealthNotifyFailed() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_FAILED)
        }

        override fun callOnGattErrorAndNeedRebootBluetooth() {
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.GATT_ERROR)
        }

        override fun callOnConnectClosed() {
//            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_BREAK)
        }

        override fun callOnCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
            if (gatt != null) {
                if (characteristic != null) {
                    invokeDataChannelMethod(
                        Constants.ResponseMethod.SEND_STATE, ProtoMaker.makeSendResult(status, gatt.device.address)
                    )
                } else {
                    Logger.e("onCharacteristicRead characteristic is null")
                }
            } else {
                Logger.e("onCharacteristicRead gatt is null")
            }
        }

        override fun callOnCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
            if (gatt != null) {
                if (characteristic != null) {
                    invokeDataChannelMethod(
                        Constants.ResponseMethod.RECEIVE_DATA, ProtoMaker.makeReceiveData(gatt.device, characteristic)
                    )
                } else {
                    Logger.e("onCharacteristicRead characteristic is null")
                }
            } else {
                Logger.e("onCharacteristicRead gatt is null")
            }
        }

    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        setup(
            flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext as Application
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Logger.p("onDetachedFromEngine")
        tearDown()
    }

    /**
     * @param messenger [io.flutter.embedding.engine.FlutterEngine.getDartExecutor]
     */
    private fun setup(
        messenger: BinaryMessenger,
        application: Application,
    ) {
        synchronized(initializationLock) {
            this.application = application
            this.context = application
            Config.init(application)
            channel = MyMethodChannel(messenger, METHOD_CHANNEL_NAME)
            channel?.setMethodCallHandler(this)
            dataChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME_DATA)
            dataChannel?.setMethodCallHandler { call, result ->
                handleDataMethodCall(call, result)
            }
            sppChannel = BasicMessageChannel(messenger, METHOD_CHANNEL_NAME_SPP, StandardMessageCodec.INSTANCE)
            sppChannel?.setMessageHandler { message, reply ->
                handleSPPMessageCall(message, reply)
            }
            sppSendStateChannel = BasicMessageChannel(messenger, METHOD_CHANNEL_NAME_SPP_SEND_STATE, StandardMessageCodec.INSTANCE)
            sppReceiveDataChannel = BasicMessageChannel(messenger, METHOD_CHANNEL_NAME_SPP_RECEIVE, StandardMessageCodec.INSTANCE)
            stateChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
            stateChannel?.setStreamHandler(stateHandler)
            deviceStateChannel = EventChannel(messenger, EVENT_CHANNEL_DEVICE_STATE)
            deviceStateChannel?.setStreamHandler(deviceStateHandler)
            mBluetoothManager = application.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager?
            mBluetoothAdapter = mBluetoothManager?.adapter
            LogTransfer.instance.init(channel)
            registerA2dpListener()
            val isMagic = OSUtil.isMagicOS()
            Logger.p("onAttachedToEngine, engin = ${pluginBinding?.flutterEngine}, isMagic = $isMagic, pid = ${Process.myPid()}")
        }
    }

    private fun registerA2dpListener() {
        A2dpManager.instance.initA2dpListener()
    }

    private fun tearDown() {
        Logger.p("tearDown")
//        if (createBondReceiver != null) {
//            context?.unregisterReceiver(createBondReceiver)
//            createBondReceiver = null
//        }
//        context = null
//        channel?.setMethodCallHandler(null)
//        channel = null
//        stateChannel?.setStreamHandler(null)
//        stateChannel = null
//        mBluetoothAdapter = null
//        mBluetoothManager = null
//        application = null
//        pluginBinding = null
//        LogTransfer.instance.destroy()
    }

    private fun handleDataMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (mBluetoothAdapter == null) {
            mBluetoothAdapter = mBluetoothManager?.adapter
            if (mBluetoothAdapter == null) {
                Logger.e("bluetooth not support")
            }
            return
        }
        when (call.method) {
            SEND_DATA, SEND_SPP_DATA -> {
                sendData(call, result)
            }
        }
    }

    private fun handleSPPMessageCall(call: Any?, result: BasicMessageChannel.Reply<Any?>) {
        if (mBluetoothAdapter == null) {
            mBluetoothAdapter = mBluetoothManager?.adapter
            if (mBluetoothAdapter == null) {
                Logger.e("bluetooth not support")
            }
            result.reply(BluetoothError.BLUETOOTH_UNAVAILABLE)
            return
        }
        val params: Map<String, Any?>? = call as Map<String, Any?>?
        val macAddress = params?.get("macAddress") as String?
        val btMacAddress = params?.get("btMacAddress") as String?
        val sendDataType = params?.get("type") as Int?
        val data: ByteArray? = params?.get("data") as ByteArray?
        //发送spp数据
        if (btMacAddress.isNullOrEmpty() || (data == null || data.isEmpty())) {
            Logger.p("sendSppData invalid param")
            result.reply(BluetoothError.BLUETOOTH_INVALID_PARAMS)
            return
        }
        val btDevice = locateBTDevice(btMacAddress)
        if (btDevice == null) {
            Logger.p("sendSppData not found cached device for $btMacAddress")
            result.reply(BluetoothError.BLUETOOTH_INVALID_PARAMS)
            return
        }
        btDevice.writeData(data)
        result.reply(0)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (mBluetoothAdapter == null) {
            mBluetoothAdapter = mBluetoothManager?.adapter
            if (mBluetoothAdapter == null) {
                Logger.e("bluetooth not support")
            }
            return
        }
        when (call.method) {
            STATE -> {
                result.success(ProtoMaker.makeBleState(mBluetoothAdapter!!.state))
            }

            START_SCAN -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    try {
                        val params: Map<String, Any?>? = call.arguments()
                        ScanManager.getInstance().startLeScan(params, this)
                    } catch (_: Exception) {
                    }
                    result.success(true)
                }
            }

            STOP_SCAN -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    try {
                        ScanManager.getInstance().stopLeScan()
                    } catch (e: Exception) {
                        Logger.e("stopLeScan, $e")
                        e.printStackTrace()
                    }
                    result.success(true)
                }
            }

            GET_DEVICE_STATE -> {
                val params: Map<String, Any?>? = call.arguments()
                val deviceAddress = params?.get("macAddress") as String?
                if (deviceAddress.isNullOrEmpty()) {
                    Logger.p("getDeviceState, empty mac")
                    result.success(ProtoMaker.makeConnectState("", 0, Constants.BleConnectState.STATE_DISCONNECTED))
                    return
                }
//                    val device = mBluetoothAdapter?.getRemoteDevice(deviceAddress)
//                    val state = mBluetoothManager?.getConnectionState(device, BluetoothProfile.GATT) ?: 0
                val bleDevice = locateBleDevice(deviceAddress)
                if (bleDevice != null) {
                    result.success(ProtoMaker.makeConnectState(deviceAddress, 0, bleDevice.getConnectState()))
                } else {
                    result.success(ProtoMaker.makeConnectState(deviceAddress, 0, Constants.BleConnectState.STATE_DISCONNECTED))
                }
            }

            CONNECT -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    connectDevice(call, result)
                }
            }

            DISCONNECT -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    disconnectDevice(call, result)
                }
            }

            START_PAIR -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    createBond(call, result)
                }
            }

            CANCEL_PAIR -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    removeBond(call, result)
                }
            }

            CONNECT_SPP -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    connectSPP(call, result)
                }
            }

            DISCONNECT_SPP -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    disconnectSPP(call, result)
                }
            }
            GET_SPP_STATE -> {
                val params: Map<String, Any?>? = call.arguments()
                val btMacAddress = params?.get("btMac") as String?
                if (btMacAddress.isNullOrEmpty()) {
//                    result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                    result.success(false)
                    return
                }
                val btDevice = locateBTDevice(btMacAddress)
                if (btDevice == null) {
                    Logger.p("disconnectSPP not found cached device for $btMacAddress")
                    result.success(false)
                    return
                }
                result.success(btDevice.isSPPConnected())
            }

            START_DFU -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    startDFU(call, result)
                }
            }

            AUTO_CONNECT -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    autoConnect(call, result)
                }
            }

            GET_A2DP_STATE -> {
                if (checkIfHasBluetoothPermissions(call, result)) {
                    getA2dpState(call, result)
                }
            }

            GET_DOCUMENT_PATH -> {
                val path = this.context?.filesDir?.parent
                result.success(path)
            }
        }
    }

    private fun autoConnect(call: MethodCall, result: Result) {
        val params: Map<String, Any?>? = call.arguments()
        val macAddress = params?.get("macAddress") as String?
        Logger.d("autoConnect , params = $params")
        if (macAddress.isNullOrEmpty()) {
//            result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
            return
        }
        var bleDevice = locateBleDevice(macAddress)
        if (bleDevice == null) {
            bleDevice = createBleDevice(macAddress, IDOBleDeviceCallback(macAddress))
        } else {
            Logger.d("autoConnect, device already exist: $bleDevice")
        }
        val isDueToPhoneBluetoothSwitch = params?.get("isDueToPhoneBluetoothSwitch") as Boolean? ?: false
        bleDevice?.autoConnect(isDueToPhoneBluetoothSwitch = isDueToPhoneBluetoothSwitch)
        registerA2dpListener()
    }

    private fun startDFU(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.d("startDFU , params = $params")
            if (params == null) {
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                return
            }
            Logger.d("startDFU, json = ${JSON.toJSONString(params)}")
//            val dfuConfig = JSON.parseObject(JSON.toJSONString(params), BleDFUConfig::class.java)
//            {isNeedAuth=false, macAddress=E3:D3:2F:A1:8F:EF, isDeviceSupportPairedWithPhoneSystem=false, filePath=/data/user/0/com.watch.life.test/app_flutter/ota/379/ID206_dfu_V115.zip, isNeedReOpenBluetoothSwitchIfFailed=true, maxRetryTime=6, otaWorkMode=0, uuid=, deviceId=null, PRN=0, platform=0}
            val dfuConfig = BleDFUConfig()
            dfuConfig.filePath = params["filePath"] as String?
            dfuConfig.macAddress = params["macAddress"] as String?
            dfuConfig.deviceId = params["deviceId"] as String?
            dfuConfig.prn = params["PRN"] as Int
            dfuConfig.platform = params["platform"] as Int
            dfuConfig.isNeedReOpenBluetoothSwitchIfFailed = params["isNeedReOpenBluetoothSwitchIfFailed"] as Boolean
            dfuConfig.maxRetryTime = params["maxRetryTime"] as Int
            dfuConfig.isNeedAuth = params["isNeedAuth"] as Boolean
            dfuConfig.isDeviceSupportPairedWithPhoneSystem = params["isDeviceSupportPairedWithPhoneSystem"] as Boolean
            dfuConfig.otaWorkMode = params["otaWorkMode"] as Int
            Logger.d("startDFU , dfuConfig = $dfuConfig")
            if (!checkDfuParams(dfuConfig)) {
                Logger.d("startDFU , dfuConfig is wrong!")
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                return
            }
            val macAddress = dfuConfig.macAddress
            var bleDevice = locateBleDevice(macAddress)
            if (bleDevice == null) {
                bleDevice = createBleDevice(macAddress, IDOBleDeviceCallback(macAddress))
            }
            bleDevice?.startDFU(dfuConfig, this)
            result.success(true)
        } catch (e: Exception) {
            e.printStackTrace()
            Logger.e("startDFU failed: $e")
        }
    }

    private fun checkDfuParams(params: BleDFUConfig): Boolean {
        return !(params.filePath.isNullOrEmpty() || params.macAddress.isNullOrEmpty() || !BluetoothAdapter.checkBluetoothAddress(params.macAddress))
    }

    private fun disconnectSPP(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.d("disconnectSPP start , params = $params")
            val btMacAddress = params?.get("btMacAddress") as String?
            if (btMacAddress.isNullOrEmpty()) {
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                return
            }
            val btDevice = locateBTDevice(btMacAddress)
            if (btDevice == null) {
                Logger.p("disconnectSPP not found cached device for $btMacAddress")
                result.notFoundDevice(btMacAddress)
                return
            }
            btDevice.unregisterSPPDataListener(this)
            btDevice.disconnectSPP()
            result.success(true)
        } catch (e: Exception) {
            Logger.p("disconnectSPP failed: $e")
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(false)
        }
    }

    private fun connectSPP(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.d("connectSPP start , params = $params")
            val btMacAddress = params?.get("btMacAddress") as String?
            if (TextUtils.isEmpty(btMacAddress)) {
                Logger.e("connectSPP failed, empty mac")
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                return
            }
            var btDevice = locateBTDevice(btMacAddress)
            if (btDevice == null) {
                btDevice = createBTDevice(btMacAddress)
            }
            btDevice?.registerSPPDataListener(this)
            btDevice?.connectSPP(this)
            result.success(true)
        } catch (e: Exception) {
            Logger.p("connectSPP failed: $e")
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(false)
        }
    }

    private fun sendData(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            val macAddress = params?.get("macAddress") as String?
            val btMacAddress = params?.get("btMacAddress") as String?
            val commandType = params?.get("commandType") as Int?
            val writeType = params?.get("writeType") as Int?
            val sendDataType = params?.get("type") as Int?
            val data: ByteArray? = params?.get("data") as ByteArray?
            val platform = params?.get("platform") as Int??:0
//            Logger.d("sendData, params = $params, data size = ${data?.size}")
            if (sendDataType == Constants.SendDataType.SPP.ordinal) {
                //发送spp数据
                if (btMacAddress.isNullOrEmpty() || (data == null || data.isEmpty())) {
                    Logger.p("sendData invalid param")
//                    result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                    result.success(false)
                    return
                }
                val btDevice = locateBTDevice(btMacAddress)
                if (btDevice == null) {
                    Logger.p("sendSPPData not found cached device for $btMacAddress")
                    result.notFoundDevice(btMacAddress)
                    return
                }
                btDevice.writeData(data)
            } else {
                if (macAddress.isNullOrEmpty() || (data == null || data.isEmpty())) {
                    Logger.p("sendData invalid param")
//                    result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                    result.success(false)
                    return
                }
                val bleDevice = locateBleDevice(macAddress)
                if (bleDevice == null) {
                    Logger.p("sendData not found cached device for $macAddress")
                    result.notFoundDevice(macAddress)
                    return
                }
                Logger.d("sendData isConnected = ${bleDevice.isConnected()}")
                bleDevice.writeDataToDevice(data,platform)
            }
            result.success(true)
        } catch (e: Exception) {
            Logger.p("sendData failed: $e")
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(false)
        }
    }

    private fun getA2dpState(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.p("getA2dpState start, params = $params")
            val btMacAddress = params?.get("btMac") as String?
            if (btMacAddress.isNullOrEmpty() || !BluetoothAdapter.checkBluetoothAddress(btMacAddress)) {
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(ProtoMaker.makeA2dpState("", BluetoothProfile.STATE_DISCONNECTED))
                Logger.p("getA2dpState failed!")
                return
            }
            var btDevice = locateBTDevice(btMacAddress)
            if (btDevice == null) {
                btDevice = createBTDevice(btMacAddress)
            }
            result.success(ProtoMaker.makeA2dpState(btMacAddress, btDevice?.getA2dpState()))
        } catch (e: Exception) {
            Logger.e("getA2dpState error: $e")
            e.printStackTrace()
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(ProtoMaker.makeA2dpState("", BluetoothProfile.STATE_DISCONNECTED))
        }
        registerA2dpListener()
    }

    private fun createBond(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.p("createBond start, params = $params")
            val btMacAddress = params?.get("btMacAddress") as String?
            val macAddress = params?.get("macAddress") as String?
            if (btMacAddress.isNullOrEmpty() || macAddress.isNullOrEmpty() || !BluetoothAdapter.checkBluetoothAddress(btMacAddress)) {
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                Logger.p("createBond failed!")
                return
            }
            var btDevice = locateBTDevice(btMacAddress)
            if (btDevice == null) {
                btDevice = createBTDevice(btMacAddress)
            }
            btDevice?.registerA2dpStateListener(this)
            btDevice?.createPair(this)
            result.success(true)
        } catch (e: Exception) {
            Logger.e("createBond error: $e")
            e.printStackTrace()
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(false)
        }
        registerA2dpListener()
    }

    private fun removeBond(call: MethodCall, result: Result) {
        try {
            val params: Map<String, Any?>? = call.arguments()
            Logger.p("removeBond start, params = $params")
            val btMacAddress = params?.get("btMacAddress") as String?
            if (btMacAddress.isNullOrEmpty() || !BluetoothAdapter.checkBluetoothAddress(btMacAddress)) {
//                result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
                result.success(false)
                Logger.p("removeBond failed!")
                return
            }
            val btDevice = locateBTDevice(btMacAddress)
            val removeResult = btDevice?.removePair() ?: PairedDeviceUtils.removeBondState(btMacAddress)
            Logger.p("removeBond result: $removeResult")
            result.success(removeResult)
        } catch (e: Exception) {
//            result.error(BluetoothError.BLUETOOTH_ERROR)
            result.success(false)
        }
    }

    private fun disconnectDevice(call: MethodCall, result: Result) {
        val params: Map<String, Any?>? = call.arguments()
        val deviceAddress = params?.get("macAddress") as String?
        Logger.p("disconnectDevice, params = $params")
        if (deviceAddress.isNullOrEmpty()) {
//            result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
            result.success(false)
            return
        }
        Logger.p("disconnectDevice, deviceAddress = $deviceAddress")
        val bleDevice = locateBleDevice(deviceAddress)
        if (bleDevice == null) {
            Logger.p("disconnectDevice, not found device $deviceAddress")
//            result.notFoundDevice(deviceAddress)
//            return
            onConnectResult(deviceAddress, error = Constants.BleConnectFailedError.CONNECT_BREAK)
        } else {
            bleDevice.toDisconnectDevice()
        }
        result.success(true)
    }

    private fun connectDevice(call: MethodCall, result: Result) {
        //1.解析连接参数
        val params: Map<String, Any?>? = call.arguments()
        val deviceAddress = params?.get("macAddress") as String?
        if (deviceAddress.isNullOrEmpty()) {
//            result.error(BluetoothError.BLUETOOTH_INVALID_PARAMS)
            result.success(false)
            return
        }
        Logger.p("connectDevice, deviceAddress = $deviceAddress")
        var bleDevice = locateBleDevice(deviceAddress)
        if (bleDevice == null) {
            bleDevice = createBleDevice(deviceAddress, IDOBleDeviceCallback(deviceAddress))
        }
        bleDevice?.toConnectDevice()
        result.success(true)
        Logger.p("connectDevice, connect started")
        registerA2dpListener()
    }

    /**
     * 开启蓝牙
     */
    private fun enableBluetooth(): Boolean {
        return mBluetoothAdapter?.enable() ?: false
    }

    /**
     * 关闭蓝牙
     */
    private fun disableBluetooth(): Boolean {
        return mBluetoothAdapter?.disable() ?: false
    }

    private val deviceStateHandler = object : EventChannel.StreamHandler {
        var sink: EventChannel.EventSink? = null
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            Logger.p("deviceStateHandler, onListen: $arguments")
            sink = events
        }

        override fun onCancel(arguments: Any?) {
            Logger.p("deviceStateHandler, onCancel: $arguments")
            sink = null
        }
    }


    private val stateHandler = object : EventChannel.StreamHandler {
        private var sink: EventChannel.EventSink? = null
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            sink = events
            val filter = IntentFilter()
            filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED)
            context?.registerReceiver(stateReceiver, filter)
            if (mBluetoothAdapter == null) {
                sink?.success(ProtoMaker.makeBleState(Constants.BluetoothState.NOT_SUPPORT.ordinal))
            }
        }

        override fun onCancel(arguments: Any?) {
            sink = null
            context?.unregisterReceiver(stateReceiver)
        }

        private val stateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val action = intent?.action
                if (BluetoothAdapter.ACTION_STATE_CHANGED == action) {
                    val state = intent.getIntExtra(
                        BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR
                    )
                    Logger.p("BluetoothStateChanged: $state")
                    if (state == BluetoothAdapter.STATE_OFF) {
                        //蓝牙关闭断开所有设备
                        DeviceManager.disconnectAll()
                    }
                    sink?.success(ProtoMaker.makeBleState(state))
                }
            }
        }
    }


    private fun checkIfHasBluetoothPermissions(@NonNull call: MethodCall, @NonNull result: Result): Boolean {
        //检查权限
        return if (!IDOPermission.hasBlePermission(context!!)) {
            Logger.p("没有蓝牙权限")
//            result.error(BluetoothError.NO_BLUETOOTH_PERMISSIONS)
            result.success(false)
            false
        } else {
            true
        }
    }

    override fun onBondFailed(btMacAddress: String?, code: Int, msg: String?) {
        Logger.d("onBondFailed, btMacAddress = $btMacAddress, code = $code, msg = $msg")
        btMacAddress?.let {
            invokeChannelMethod(Constants.ResponseMethod.PAIR_STATE, ProtoMaker.makePairResult(btMacAddress, false))
        }
    }

    override fun onBonded(btMacAddress: String?) {
        Logger.d("onBonded, btMacAddress = $btMacAddress")
        btMacAddress?.let {
            invokeChannelMethod(Constants.ResponseMethod.PAIR_STATE, ProtoMaker.makePairResult(it, true))
        }
    }

    /***dfu升级回调**/
    override fun onDfuPrepare(deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.PREPARE)
    }

    override fun onDfuModeEnter(deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.DEVICE_ENTER_DFU_MODE)
    }

    override fun onDfuProgress(progress: Int, deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.PROGRESS, progress)
    }

    override fun onDfuSuccess(deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.SUCCESS)
    }

    override fun onDfuSuccessAndNeedToPromptUser(deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.SUCCESS_BUT_UNKNOWN)
    }

    override fun onDfuFailed(failReason: BleDFUState.FailReason?, deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.FAILED, failReason?.ordinal)
    }

    override fun onDfuCanceled(deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.CANCEL)
    }

    override fun onDfuRetry(count: Int, deviceAddress: String) {
        sendDfuState(deviceAddress, BleDFUState.RETRY, count)
    }

    override fun onDfuStatusChanged(state: BleDFUState.DfuStatus, deviceAddress: String) {
        makeDfuState(deviceAddress, state, null, null)
    }

    private fun makeDfuState(deviceAddress: String, state: BleDFUState.DfuStatus?, error: Int?, progress: Int?) {
        val stateDesc = BleDFUState.dfuStatusDescription(state)
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = deviceAddress
        if (stateDesc.isNotEmpty()) {
            map["state"] = stateDesc
        }
        error?.let {
            map["error"] = error
        }
        progress?.let {
            map["progress"] = progress
        }
        Logger.d("makeDfuState: $map")
        invokeChannelMethod(Constants.ResponseMethod.DFU_STATE, map)
    }


    private fun callServices(deviceAddress: String, services: List<String>) {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = deviceAddress
        services?.let {
            map["servicesUUID"] = services
        }
        Logger.d("callServices: $map")
        invokeChannelMethod(Constants.ResponseMethod.IS_OTA_WITH_SERVICES, map)
    }
    private fun sendDfuState(deviceAddress: String, state: Int, value: Any? = null) {
        when (state) {
            BleDFUState.PROGRESS -> {
                makeDfuState(deviceAddress, null, null, value as Int?)
            }

            BleDFUState.SUCCESS -> {
                makeDfuState(deviceAddress, BleDFUState.DfuStatus.completed, null, null)
            }

            BleDFUState.FAILED -> {
                makeDfuState(deviceAddress, null, value as Int?, null)
            }

            else -> {
                //拦截其他状态
                return
            }
        }
    }

    private fun getFailedReason(state: Int, value: Any?): String {
        return when (state) {
            BleDFUState.FAILED -> {
                BleDFUState.getReasonDesc((value as Int?) ?: -1)
            }

            else -> "$value"
        }
    }

    /********************/

    /***spp回调**/
    override fun onStart(deviceAddress: String) {
        Logger.d("SPP onStart($deviceAddress)")
        sendSppState(Constants.SPPConnectState.START)
    }

    override fun onSuccess(deviceAddress: String?) {
        Logger.d("SPP onSuccess($deviceAddress)")
        sendSppState(Constants.SPPConnectState.SUCCESS)
    }

    override fun onFailed(deviceAddress: String) {
        Logger.d("SPP onFailed($deviceAddress)")
        sendSppState(Constants.SPPConnectState.FAILED)
    }

    override fun onBreak(deviceAddress: String) {
        Logger.d("SPP onBreak($deviceAddress)")
        sendSppState(Constants.SPPConnectState.BREAK)
    }

    private fun sendSppState(state: Int) {
        invokeChannelMethod(Constants.ResponseMethod.SPP_STATE, hashMapOf(Pair("state", state)))
    }

    override fun onSPPReceive(data: ByteArray?, deviceAddress: String) {
        if (data == null) {
            Logger.p("onSPPReceive empty data!")
            return
        }
        Logger.p("spp receive <= ${ByteDataConvertUtil.bytesToHexString(data)}")
        runOnUiThread {
            sppReceiveDataChannel?.send(ProtoMaker.makeSPPReceiveData(deviceAddress, data)) {

            }
        }
//        invokeSppChannelMethod(
//            Constants.ResponseMethod.RECEIVE_DATA, ProtoMaker.makeSPPReceiveData(deviceAddress, data)
//        )
    }

    override fun onSPPSendOneDataComplete(deviceAddress: String) {
        Logger.d("SPP onSPPSendOneDataComplete($deviceAddress)")
        runOnUiThread {
            sppSendStateChannel?.send(hashMapOf(Pair("btMacAddress", deviceAddress))) {

            }
        }
//        invokeSppChannelMethod(Constants.ResponseMethod.SPP_WRITE_COMPLETE, hashMapOf(Pair("btMacAddress", deviceAddress)))
    }


    override fun onA2dpConnectChanged(deviceAddress: String, previousState: Int, newState: Int) {
        Logger.d("onA2dpConnectChanged(${deviceAddress}), state = $newState")
        invokeChannelMethod(Constants.ResponseMethod.A2DP_STATE, ProtoMaker.makeA2dpState(deviceAddress, newState))
    }


    /********************/


    override fun onScanLeStart() {
    }

    override fun onScanLeResult(scanResult: Map<String, Any?>) {
        invokeChannelMethod(Constants.ResponseMethod.SCAN_RESULT, scanResult)
    }

    override fun onScanLeFinished() {
    }

    private fun sendDeviceState(data: Any) {
        Logger.p("sendDeviceState, result: ${GsonUtil.toJson(data)}, sink is ${if (deviceStateHandler.sink == null) "null" else "not null"}")
        runOnUiThread {
            try {
                deviceStateHandler.sink?.success(data)
            } catch (e: Exception) {
                Logger.p("sendDeviceState error: $e")
            }
        }
    }

    /**
     * 在主线程调用上层plugin的方法
     */
    private fun invokeChannelMethod(methodName: String, result: Map<String, Any?>?) {
        Logger.p("invokeChannelMethod [$methodName] result: ${GsonUtil.toJson(result)}, channel is ${if (channel == null) "null" else "not null"}")
        if (channel != null) {
            runOnUiThread {
                try {
                    channel?.invokeMethod(methodName, result, object : Result {
                        override fun success(result: Any?) {
                            Logger.p("invokeChannelMethod [$methodName], send ok!")
                        }

                        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                            Logger.p("invokeChannelMethod [$methodName], send error($errorCode, $errorMessage, $errorDetails)")
                        }

                        override fun notImplemented() {
                            Logger.p("invokeChannelMethod [$methodName], notImplemented")
                        }

                    })
                } catch (e: Exception) {
                    Logger.p("invokeChannelMethod [$methodName], error: $e")
                }
            }
        }
    }


    /**
     * 在主线程调用上层plugin的方法
     */
    private fun invokeDataChannelMethod(methodName: String, result: Map<String, Any?>?) {
        if (dataChannel != null) {
            if (Looper.myLooper() != Looper.getMainLooper()) {
                mHandler.post {
                    try {
                        dataChannel?.invokeMethod(methodName, result, object : Result {
                            override fun success(result: Any?) {
                            }

                            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                                Logger.p("invokeDataChannelMethod [$methodName], send error($errorCode, $errorMessage, $errorDetails)")
                            }

                            override fun notImplemented() {
                                Logger.p("invokeDataChannelMethod [$methodName], notImplemented")
                            }

                        })
                    } catch (e: Exception) {
                        Logger.p("invokeDataChannelMethod [$methodName], error: $e")
                    }
                }
            } else {
                try {
                    dataChannel?.invokeMethod(methodName, result, object : Result {
                        override fun success(result: Any?) {
                        }

                        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                            Logger.p("invokeDataChannelMethod [$methodName], result = $result, send error($errorCode, $errorMessage, $errorDetails)")
                        }

                        override fun notImplemented() {
                            Logger.p("invokeDataChannelMethod [$methodName], result = $result, notImplemented")
                        }

                    })
                } catch (e: Exception) {
                    Logger.p("invokeDataChannelMethod [$methodName], error: $e")
                }
            }
        } else {
            Logger.p("invokeChannelMethod, channel = null")
        }
    }

    private fun runOnUiThread(callback: () -> Unit) {
        val isMainThread = Looper.myLooper() == Looper.getMainLooper()
        if (isMainThread) {
//            Logger.p("主线程，执行")
            callback()
        } else {
//            Logger.p("子线程")
            mHandler.post {
//                Logger.p("子线程，执行")
                callback()
            }
        }
    }

}

fun Result.error(code: Int, msg: String = "") {
    error("$code", BluetoothError.parse(code, msg), null)
}

fun Result.notFoundDevice(deviceAddress: String) {
    error("${BluetoothError.BLUETOOTH_NOT_FOUND_DEVICE}", "not found device $deviceAddress", null)
}

/**
 * dart->native
 * 扫描参数
 */
data class IDOScanSettings(val serviceUuidsList: MutableList<String>?, val deviceAddress: String?)
