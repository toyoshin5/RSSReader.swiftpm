import SwiftUI
import WebKit
struct WebUIView: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    } 
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct WebView: View{
    var url:URL
    var body: some View{
        WebUIView(url:url)
    }
}
