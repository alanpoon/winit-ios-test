//
//  CustomSchemeHandler.swift
//  winit-ios
//
//  Created by user265135 on 8/4/24.
//

import Foundation
//class CustomSchemeHandler: NSObject{
//    let request = urlSchemeTask.request
//    print(request)
//    
//    func webView(_ webView:WKWebView, stop urlSchemeTask:WKURLSchemeTask){
//        
//    }
//}
class CustomSchemeHandler: URLProtocol{
    override class func canInit(with request: URLRequest) -> Bool {
        print(request)
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        
    }
}
