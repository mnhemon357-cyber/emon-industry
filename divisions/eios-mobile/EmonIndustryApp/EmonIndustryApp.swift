import SwiftUI
import WebKit

@main
struct EmonIndustryApp: App {
    var body: some Scene {
        WindowGroup {
            EmonWebView().ignoresSafeArea().preferredColorScheme(.dark)
        }
    }
}

struct EmonWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let cc = WKUserContentController()
        cc.addUserScript(WKUserScript(
            source: "window.webkit=window.webkit||{};window.webkit.messageHandlers=window.webkit.messageHandlers||{};window.webkit.messageHandlers.emonIOS={postMessage:function(){}};",
            injectionTime: .atDocumentStart, forMainFrameOnly: true))
        let cfg = WKWebViewConfiguration()
        cfg.userContentController = cc
        let wv = WKWebView(frame: .zero, configuration: cfg)
        wv.backgroundColor = UIColor(red: 0.03, green: 0.04, blue: 0.06, alpha: 1.0)
        if let u = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Resources") {
            wv.loadFileURL(u, allowingReadAccessTo: u.deletingLastPathComponent())
        }
        return wv
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
