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
        setTheme(android.R.style.Theme_Material_NoActionBar); // Switch from Splash to Main
        
        webView = new WebView(this);
        WebSettings s = webView.getSettings();
        s.setJavaScriptEnabled(true);
        s.setDomStorageEnabled(true);
        s.setAllowFileAccess(true);
        s.setAllowContentAccess(true);
        s.setAllowFileAccessFromFileURLs(true);
        s.setAllowUniversalAccessFromFileURLs(true);
        s.setCacheMode(WebSettings.LOAD_NO_CACHE);
        
        webView.setWebViewClient(new WebViewClient());
        webView.addJavascriptInterface(new EmonBridge(), "EmonAndroid");
        webView.loadUrl("file:///android_asset/index.html");
        setContentView(webView);
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack(); // Allows navigating back inside the app
        } else {
            super.onBackPressed(); // Closes app if at root
        }
    }

    public class EmonBridge {
        @JavascriptInterface
        public String getDeviceInfo() {
            return "{\"platform\":\"Android\",\"model\":\"" + Build.MODEL + "\",\"manufacturer\":\"" + Build.MANUFACTURER + "\",\"sdk\":" + Build.VERSION.SDK_INT + "}";
        }
    }
}
