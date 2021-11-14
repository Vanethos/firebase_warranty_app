package com.vanethos.post_test

import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        fab.setOnClickListener { view ->
            val webView = findViewById<WebView>(R.id.webview)
            //webView.getSettings().setJavaScriptEnabled(true)
            //webView.setWebViewClient(WebViewClient())
            //webView.loadUrl("https://master.d2vuulidoapnuq.amplifyapp.com/")
            webView.postUrl("https://samltest.id/Shibboleth.sso/SAML2/POST", null)

            //val uri = Uri.parse("https://samltest.id/Shibboleth.sso/SAML2/POST")
            //    .buildUpon()
            //val browserIntent = Intent(Intent.ACTION_VIEW, uri)
            //startActivity(browserIntent)
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> true
            else -> super.onOptionsItemSelected(item)
        }
    }
}
