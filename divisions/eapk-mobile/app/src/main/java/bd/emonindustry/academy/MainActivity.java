package bd.emonindustry.academy;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        webView = new WebView(this);
        WebSettings s = webView.getSettings();
        
        // Core Settings
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true); // Enables localStorage for Sprint & Certs
        s.setAllowFileAccess(true);
        s.setAllowContentAccess(true);
        s.setAllowFileAccessFromFileURLs(true);
        s.setAllowUniversalAccessFromFileURLs(true);
        
        // Cache Busting: Force the app to load the newest HTML, not old cached versions
        s.setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.clearCache(true);
        webView.clearHistory();

        webView.setWebViewClient(new WebViewClient());
        webView.addJavascriptInterface(new EmonBridge(), "EmonAndroid");
        
        // Load the local v6.0 OffSec portal
        webView.loadUrl("file:///android_asset/index.html");
        setContentView(webView);
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) webView.goBack();
        else super.onBackPressed();
    }

    public class EmonBridge {
        @JavascriptInterface
        public String getDeviceInfo() {
            return "{\"platform\":\"Android\",\"model\":\"" + Build.MODEL
                 + "\",\"manufacturer\":\"" + Build.MANUFACTURER
                 + "\",\"sdk\":" + Build.VERSION.SDK_INT + "}";
        }
        @JavascriptInterface
        public String getVersion() { return "6.0"; }
    }
}
