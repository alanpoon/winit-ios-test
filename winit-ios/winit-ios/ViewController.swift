//
//  ViewController.swift
//  winit-ios
//
//  Created by user265135 on 8/3/24.
//
import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var Once:Bool = false
    override func loadView() {
        print("loadView")
        let webViewConfiguration = WKWebViewConfiguration()
        let schemeHandler = CustomSchemeHandler2()
        //webViewConfiguration.setURLSchemeHandler(schemeHandler, forURLScheme: "http")
        
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        //URLProtocol.registerClass(CustomSchemeHandler.self)
        //webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let url = URL(string: "https://ambient.run/games")!
        let url = URL(string:"https://ambient.run/packages/h3gv2vnpcajq75woh5nmiemeahfpaku4")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
       
        
    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!,decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
                   print("Intercepted request to URL: \(url)")
                   // Perform custom actions with the URL here
               }
               // Allow the navigation to continue
               decisionHandler(.allow)
        
        let js = """
        alert("hi1");
        (function() {

            setTimeout(function(){
                var elements = document.getElementsByClassName('ContentCardDescription');
                for(var i = 0; i < elements.length; i++) {
                    elements[i].style.display = 'none';
                }
                var elements = document.getElementsByClassName('ContentCardOptions');
                for(var i = 0; i < elements.length; i++) {
                    elements[i].style.display = 'none';
                }
                var elements = document.getElementsByClassName('ContentCardName');
                for(var i = 0; i < elements.length; i++) {
                    elements[i].style.fontSize = 'calc(var(--base-scale) * 12)';
                }

                var form = document.createElement("form");

                // Optionally set attributes like id, class, action, method, etc.
                form.id = "myForm";
                form.className = "formClass";
                form.action = "/submit";
                form.method = "get";

                // Create an input element
                var input = document.createElement("input");
                input.type = "text";
                input.name = "textInput";
                input.id = "textInput";
                input.className = "inputClass";
                // input.value = "192.168.1.7:4433";
                input.value = "localhost:4433";
                input.placeholder = "Enter text here";

                // Create a submit button
                var submitButton = document.createElement("input");
                submitButton.type = "submit";
                submitButton.value = "Submit";
                submitButton.id = "submitButton";
                submitButton.className = "buttonClass";

                // Append the input and submit button to the form
                form.appendChild(input);
                form.appendChild(submitButton);

                // Append the form to the div with the ID "formContainer"
                document.getElementsByClassName("footer")[0].appendChild(form);
                alert("hi");
            },5000)

        })()
        """
        webView.evaluateJavaScript(js, completionHandler: {(result,error) in
            if true{
                print("error")
                print(error)
            }else{
                print("result")
                print(result)
            }
        })
        if !self.Once{
            self.Once = true
            DispatchQueue.main.asyncAfter(deadline: .now()+8){
                var js3 = """
                    var elements = document.getElementsByClassName('PackagePageTomlCopy');
                              elements[0].innerText.split("=")[2].replaceAll('"',"").replace("}","").replaceAll(" ","").trim()
                """
                webView.evaluateJavaScript(js3, completionHandler: {(result,error) in
                    
                        print("error js3")
                        print(error)
                                    print("result js3")
                    if result != nil{
                        print("result js3")
                        print(result!)
                        let deployment_id = result!
                        let url = URL(string: "https://api.ambient.run/servers/ensure-running?deployment_id=\(deployment_id)&max_players=5&region=Auto")!
                        print(url)
                        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                            guard let data = data else { return }
                            print(String(data: data, encoding: .utf8)!)
                            let success = writeDataToFile(fileName: "ws_path.txt", data: data)
                           
                            
                            print(success)
                        }

                        task.resume()
               
                    }
                    
                })
                
            }
        }
        
        }

}
extension String {

    func trimmingTrailingSpaces() -> String {
        var t = self
        while t.hasSuffix(" ") {
          t = "" + t.dropLast()
        }
        return t
    }

    mutating func trimmedTrailingSpaces() {
        self = self.trimmingTrailingSpaces()
    }

}


