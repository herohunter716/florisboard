package dev.patrickgold.florisboard.ime.keylab

import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object KeyLabLogger {
    private val baseDir = File("/storage/emulated/0/KeyLab/raw")
    private val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)

    private fun todayFile(): File {
        if (!baseDir.exists()) baseDir.mkdirs()
        val name = dateFormat.format(Date()) + ".jsonl"
        return File(baseDir, name)
    }

    fun log(type: String, value: String? = null, layout: String = "unknown") {
        try {
            val ts = System.currentTimeMillis()
            val safeValue = value?.replace("\"", "\\\"")
            val line = if (safeValue != null) {
                """{"ts":$ts,"type":"$type","val":"$safeValue","layout":"$layout"}"""
            } else {
                """{"ts":$ts,"type":"$type","layout":"$layout"}"""
            }
            todayFile().appendText(line + "\n")
        } catch (e: Exception) {
            // Never let logging crash the keyboard — fail silently
        }
    }
}
