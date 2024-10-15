package com.snoring.app

import android.annotation.SuppressLint
import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class MyApp : FlutterApplication() {

    companion object {

        @SuppressLint("StaticFieldLeak")
        private lateinit var app: MyApp
        fun getApp(): MyApp {
            return app
        }
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    override fun onCreate() {
        super.onCreate()
        app = this
    }

}