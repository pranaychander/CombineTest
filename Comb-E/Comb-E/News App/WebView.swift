//
//  WebView.swift
//  Comb-E
//
//  Created by pranay chander on 03/07/21.
//

import SwiftUI
import Foundation
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    func makeUIView(context: Context) -> WKWebView {
        print(self.url)
        guard let url = URL(string: self.url)else {
            return WKWebView.pageNotFound()
        }
        let request = URLRequest(url: url)
        let webV = WKWebView()
        webV.load(request)
        return webV

    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: self.url)else {
            return
        }
        let request = URLRequest(url: url)
        let webV = WKWebView()
        webV.load(request)
    }


}

extension WKWebView {
    static func pageNotFound() -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString("<html><body><h1>Psge Not Found</hl></body></html>", baseURL: nil)
        return webView
    }
}
