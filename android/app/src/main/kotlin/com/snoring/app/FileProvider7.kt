package com.snoring.app

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import java.io.File

object FileProvider7 {
    fun getUriForFile(context: Context, file: File): Uri? {
        var fileUri: Uri? = null
        fileUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            getUriForFile24(context, file)
        } else {
            Uri.fromFile(file)
        }
        return fileUri
    }

    private fun getUriForFile24(context: Context, file: File): Uri {
        return FileProvider.getUriForFile(context, context.packageName + ".snoring_app", file)
    }

    fun setIntentDataAndType(
        context: Context,
        intent: Intent,
        type: String?,
        file: File,
        writeAble: Boolean
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.setDataAndType(getUriForFile(context, file), type)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            if (writeAble) {
                intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            }
        } else {
            intent.setDataAndType(Uri.fromFile(file), type)
        }
    }

    fun setIntentData(context: Context, intent: Intent, file: File, writeAble: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.data = getUriForFile(context, file)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            if (writeAble) {
                intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            }
        } else {
            intent.data = Uri.fromFile(file)
        }
    }
}