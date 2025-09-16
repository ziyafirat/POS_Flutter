package com.example.self_checkout_app

import android.content.Context
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbInterface
import android.hardware.usb.UsbManager
import android.hardware.usb.UsbConstants
import android.content.IntentFilter
import android.content.Intent
import android.app.PendingIntent
import android.content.BroadcastReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "usb_printer"
    private val ACTION_USB_PERMISSION = "com.example.self_checkout_app.USB_PERMISSION"
    
    private var usbManager: UsbManager? = null
    private var usbDevice: UsbDevice? = null
    private var usbConnection: UsbDeviceConnection? = null
    private var usbInterface: UsbInterface? = null
    private var usbEndpoint: UsbEndpoint? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "connectPrinter" -> {
                    val vendorId = call.argument<Int>("vendorId") ?: 1208
                    val productId = call.argument<Int>("productId") ?: 514
                    val printerName = call.argument<String>("printerName") ?: "TM-M30"
                    connectPrinter(vendorId, productId, printerName, result)
                }
                "disconnectPrinter" -> {
                    disconnectPrinter(result)
                }
                "printData" -> {
                    val data = call.argument<ByteArray>("data")
                    if (data != null) {
                        printData(data, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Print data is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun connectPrinter(vendorId: Int, productId: Int, printerName: String, result: MethodChannel.Result) {
        try {
            val deviceList = usbManager?.deviceList
            var targetDevice: UsbDevice? = null

            // Find the TM-M30 printer device
            deviceList?.values?.forEach { device ->
                if (device.vendorId == vendorId && device.productId == productId) {
                    targetDevice = device
                    return@forEach
                }
            }

            if (targetDevice == null) {
                // Try to find any Epson device
                deviceList?.values?.forEach { device ->
                    if (device.vendorId == 1208) { // Seiko Epson Corporation
                        targetDevice = device
                        return@forEach
                    }
                }
            }

            if (targetDevice == null) {
                result.success(mapOf("success" to false, "error" to "TM-M30 printer not found"))
                return
            }

            usbDevice = targetDevice

            // Request permission if not already granted
            if (usbManager?.hasPermission(usbDevice) == true) {
                establishConnection(result, printerName)
            } else {
                requestUsbPermission(result, printerName)
            }

        } catch (e: Exception) {
            result.success(mapOf("success" to false, "error" to "Connection failed: ${e.message}"))
        }
    }

    private fun requestUsbPermission(result: MethodChannel.Result, printerName: String) {
        val permissionIntent = PendingIntent.getBroadcast(
            this, 0, Intent(ACTION_USB_PERMISSION), 
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        val filter = IntentFilter(ACTION_USB_PERMISSION)
        registerReceiver(object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                synchronized(this) {
                    if (ACTION_USB_PERMISSION == intent.action) {
                        if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                            establishConnection(result, printerName)
                        } else {
                            result.success(mapOf("success" to false, "error" to "USB permission denied"))
                        }
                        unregisterReceiver(this)
                    }
                }
            }
        }, filter)

        usbManager?.requestPermission(usbDevice, permissionIntent)
    }

    private fun establishConnection(result: MethodChannel.Result, printerName: String) {
        try {
            usbConnection = usbManager?.openDevice(usbDevice)
            
            if (usbConnection == null) {
                result.success(mapOf("success" to false, "error" to "Failed to open USB connection"))
                return
            }

            // Get the first interface (usually the printer interface)
            usbInterface = usbDevice?.getInterface(0)
            
            if (usbInterface == null) {
                result.success(mapOf("success" to false, "error" to "No USB interface found"))
                return
            }

            // Claim the interface
            if (!usbConnection!!.claimInterface(usbInterface, true)) {
                result.success(mapOf("success" to false, "error" to "Failed to claim USB interface"))
                return
            }

            // Find the OUT endpoint for sending data to printer
            for (i in 0 until usbInterface!!.endpointCount) {
                val endpoint = usbInterface!!.getEndpoint(i)
                if (endpoint.direction == UsbConstants.USB_DIR_OUT) {
                    usbEndpoint = endpoint
                    break
                }
            }

            if (usbEndpoint == null) {
                result.success(mapOf("success" to false, "error" to "No OUT endpoint found"))
                return
            }

            result.success(mapOf(
                "success" to true, 
                "printerName" to printerName,
                "deviceInfo" to "VID:${usbDevice?.vendorId} PID:${usbDevice?.productId}"
            ))

        } catch (e: Exception) {
            result.success(mapOf("success" to false, "error" to "Connection establishment failed: ${e.message}"))
        }
    }

    private fun disconnectPrinter(result: MethodChannel.Result) {
        try {
            usbConnection?.releaseInterface(usbInterface)
            usbConnection?.close()
            
            usbConnection = null
            usbInterface = null
            usbEndpoint = null
            usbDevice = null
            
            result.success(mapOf("success" to true))
        } catch (e: Exception) {
            result.success(mapOf("success" to false, "error" to "Disconnect failed: ${e.message}"))
        }
    }

    private fun printData(data: ByteArray, result: MethodChannel.Result) {
        try {
            if (usbConnection == null || usbEndpoint == null) {
                result.success(mapOf("success" to false, "error" to "Printer not connected"))
                return
            }

            val timeout = 5000 // 5 seconds timeout
            val bytesTransferred = usbConnection!!.bulkTransfer(usbEndpoint, data, data.size, timeout)
            
            if (bytesTransferred >= 0) {
                result.success(mapOf("success" to true, "bytesTransferred" to bytesTransferred))
            } else {
                result.success(mapOf("success" to false, "error" to "Data transfer failed: $bytesTransferred"))
            }
            
        } catch (e: Exception) {
            result.success(mapOf("success" to false, "error" to "Print failed: ${e.message}"))
        }
    }
}
