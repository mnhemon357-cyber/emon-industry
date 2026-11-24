import SwiftUI
import WebKit

@main
struct EmonIndustryApp: App {
    var body: some Scene {
        WindowGroup {
            EmonWebView()
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
}

struct EmonWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.03, green: 0.04, blue: 0.06, alpha: 1.0)
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Resources") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
