package ru.gc986.testhybridappandroidflutter

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugin.common.MethodChannel
import kotlinx.android.synthetic.main.activity_main.*
import ru.gc986.testhybridappandroidflutter.MyApplication.Companion.ENGINE_ID


class MainActivity : AppCompatActivity() {

    private var flutterFragment: FlutterFragment? = null
    private val TAG_FLUTTER_FRAGMENT = "TAG_FLUTTER_FRAGMENT"
    private val FLATTER_CHANEL = "samples.flutter.dev/battery"
    private var channelResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        openFlutterScreen()

        btRoot.setOnClickListener {
            Toast.makeText(this, "/", Toast.LENGTH_LONG).show()
            try {
                channelResult?.success("/")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        btOpenCalculator.setOnClickListener {
            Toast.makeText(this, "calculator", Toast.LENGTH_LONG).show()
            try {
                channelResult?.success("/calculator")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        btOpenSettings.setOnClickListener {
            Toast.makeText(this, "settings", Toast.LENGTH_LONG).show()
            try {
                channelResult?.success("/settings")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        btBack.setOnClickListener {
            Toast.makeText(this, "back", Toast.LENGTH_LONG).show()
            try {
                channelResult?.success("back")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun openFlutterScreen() {

        flutterFragment = FlutterFragment.withCachedEngine(ENGINE_ID).build()

        flutterFragment?.let {
            replaceFragment(it, TAG_FLUTTER_FRAGMENT)
        }

        MethodChannel(
            MyApplication.flutterEngine.dartExecutor.binaryMessenger,
            FLATTER_CHANEL
        ).setMethodCallHandler { call, result ->
            channelResult = result
        }
    }

    private fun replaceFragment(flutterFragment: FlutterFragment, tag: String) {
        supportFragmentManager
            .beginTransaction()
            .replace(
                R.id.flFlutterContainer,
                flutterFragment,
                tag
            )
            .commit()
    }

}