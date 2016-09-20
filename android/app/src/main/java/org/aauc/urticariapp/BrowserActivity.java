package org.aauc.urticariapp;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;


public class BrowserActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_urticaria);
        WebView browser = (WebView) findViewById(R.id.urticariaBrowser);
        browser.setWebViewClient(new WebViewClient());
        browser.getSettings().setJavaScriptEnabled(true);
        browser.loadUrl(getIntent().getData().toString());
    }

}
