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
        let contentController = WKUserContentController()
        let bridgeScript = WKUserScript(
            source: "window.webkit = window.webkit || {}; window.webkit.messageHandlers = window.webkit.messageHandlers || {}; window.webkit.messageHandlers.emonIOS = { postMessage: function(){} };",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        contentController.addUserScript(bridgeScript)
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = UIColor(red: 0.02, green: 0.08, blue: 0.16, alpha: 1.0)
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Resources") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
