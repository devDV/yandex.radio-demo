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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
