package bd.emonindustry.academy;
import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.ViewGroup;

public class MainActivity extends Activity {
  private WebView web;
  @Override public void onCreate(Bundle state) {
    super.onCreate(state);
    getWindow().setStatusBarColor(0xFF09111E);
    getWindow().setNavigationBarColor(0xFF09111E);
    web = new WebView(this);
    web.setLayoutParams(new ViewGroup.LayoutParams(-1,-1));
    WebSettings s = web.getSettings();
    s.setJavaScriptEnabled(true);
    s.setDomStorageEnabled(true);
    s.setAllowFileAccess(true);
    s.setAllowContentAccess(false);
    s.setMixedContentMode(WebSettings.MIXED_CONTENT_NEVER_ALLOW);
    web.setWebViewClient(new WebViewClient());
    setContentView(web);
    web.loadUrl("file:///android_asset/index.html");
  }
  @Override public void onBackPressed() {
    if (web != null && web.canGoBack()) web.goBack(); else super.onBackPressed();
  }
  @Override protected void onDestroy() {
    if (web != null) { web.destroy(); web = null; }
    super.onDestroy();
  }
}
