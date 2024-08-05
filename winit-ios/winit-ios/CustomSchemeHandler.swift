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
    //private(set) var once : Bool = false
    static var once = false
    override class func canInit(with request: URLRequest) -> Bool {
        print(request)
        guard let url = request.url?.absoluteString else {
                   return false
        }
        print("url")
        print(url)
        if url.contains("ambient.toml") && !once{
                   // Only handle the request if it has not been handled before
            var new_url = url.replacingOccurrences(of: "%2F", with: "/")
            var arr = new_url.split(separator: "/")
            var deployment_id = arr.index(after: arr.count-2)
            let url = URL(string: "https://api.ambient.run/servers/ensure-running?deployment_id=\(deployment_id)&max_players=5&region=Auto")!

            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                //print(String(data: data, encoding: .utf8)!)
                let success = writeDataToFile(fileName: "ws_path.txt", data: data)
                print(success)
                once = true
            }

            task.resume()
   
            
        }
        
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print("canonical")
        print(request)
        return request
    }
    override func startLoading() {
        
    }
}
func writeDataToFile(fileName: String, data: Data) -> Bool {
    // Get the path to the Documents directory
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Could not find the Documents directory")
        return false
    }

    // Create the full file path
    let fileURL = documentsDirectory.appendingPathComponent(fileName)

    do {
        // Write data to the file
        try data.write(to: fileURL)
        print("File written successfully to \(fileURL)")
        return true
    } catch {
        print("Failed to write data to file: \(error.localizedDescription)")
        return false
    }
}
