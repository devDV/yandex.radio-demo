//
//  RadioWKWebView.swift
//  yandex.radio-demo
//
//  Created by dattk on 03/08/2019.
//  Copyright © 2019 dattk. All rights reserved.
//

import WebKit

class RadioWKWebView : WKWebView {
    
    init() {
        let config = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: config)
        
        let url = URL(string: "https://radio.yandex.ru")!
        let request = URLRequest(url: url)
        self.load(request)
        self.uiDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RadioWKWebView : WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard let url = navigationAction.request.url?.absoluteString else { return nil }
//        https://clck.yandex.ru/redir/dtype=stred/pid=616/cid=123/pageID=654095022156481590006866345127980777/experiment=on/*https://passport.yandex.ru/auth?origin=radio_player-controls&retpath=https%3A%2F%2Fmusic.yandex.ru%2Fsettings%2F%3Ffrom-passport%26reqid%3D654095022156481590006866345127980777
//        https://clck.yandex.ru/redir/dtype=stred/pid=616/cid=123/pageID=654095022156481590006866345127980777/experiment=on/*https://passport.yandex.ru/auth?origin=radio_like&retpath=https%3A%2F%2Fmusic.yandex.ru%2Fsettings%2F%3Ffrom-passport%26reqid%3D654095022156481590006866345127980777
        
        if url.contains("?origin=radio_player-controls") {
            self.toggle()
        }
        
        return nil
    }
}

extension RadioWKWebView : FlowControl {
    func toggle() {
        let script = apiFlowTogglePlayPause
        evaluateJavaScript(script, completionHandler: nil)
    }
}
