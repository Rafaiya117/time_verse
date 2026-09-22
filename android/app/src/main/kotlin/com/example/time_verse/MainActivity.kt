package com.infiniquote.app

import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.FileNotFoundException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.infiniquote.app/ringtone"
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDefaultRingtoneUri" -> {
                    try {
                        val ringtoneUri = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE)
                        result.success(ringtoneUri?.toString() ?: "")
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Failed to get ringtone: ${e.message}", null)
                    }
                }
                "playRingtone" -> {
                    val uriString = call.argument<String>("uri")
                    try {
                        stopNativePlayer() // Clear running instances safely
                        
                        mediaPlayer = MediaPlayer().apply {
                            setAudioAttributes(
                                AudioAttributes.Builder()
                                    .setUsage(AudioAttributes.USAGE_ALARM)
                                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                    .build()
                            )
                            
                            // 🛠️ STRATEGY CHANGE: Safely handle fallback without triggering application lifecycle crashes
                            if (!uriString.isNullOrEmpty() && uriString.startsWith("content://")) {
                                setDataSource(context, Uri.parse(uriString))
                            } else {
                                try {
                                    // Try loading your specific target flutter deployment asset directory path structure
                                    val assetDescriptor = context.assets.openFd("flutter_assets/assets/alarm.mp3")
                                    setDataSource(assetDescriptor.fileDescriptor, assetDescriptor.startOffset, assetDescriptor.length)
                                    assetDescriptor.close()
                                } catch (e: FileNotFoundException) {
                                    // 🛠️ FIX: If asset directory parsing string fails, fallback natively instead of crashing app
                                    val alertUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM) 
                                        ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                                    setDataSource(context, alertUri)
                                }
                            }
                            isLooping = true
                            prepare()
                            start()
                        }
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("PLAY_ERROR", "Could not play audio track: ${e.message}", null)
                    }
                }
                "stopRingtone" -> {
                    stopNativePlayer()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun stopNativePlayer() {
        try {
            mediaPlayer?.let {
                if (it.isPlaying) {
                    it.stop()
                }
                it.release()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            mediaPlayer = null
        }
    }

    override fun onDestroy() {
        stopNativePlayer()
        super.onDestroy()
    }
}