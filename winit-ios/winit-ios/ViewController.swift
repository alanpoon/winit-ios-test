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
    @IBOutlet var metalV: MetalView!
    var appWrapper: OpaquePointer?
    lazy var displayLink: CADisplayLink = {
        CADisplayLink.init(target: self, selector: #selector(enterFrame))
    }()
    override func loadView() {
        print("loadView")
        // let webViewConfiguration = WKWebViewConfiguration()
        // let schemeHandler = CustomSchemeHandler2()
        // webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        // URLProtocol.registerClass(CustomSchemeHandler.self)
        // webView.navigationDelegate = self
        // view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let url = URL(string: "https://ambient.run/games")!
        let url = URL(string:"https://ambient.run/packages/h3gv2vnpcajq75woh5nmiemeahfpaku4")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.displayLink.add(to: .current, forMode: .default)
        self.displayLink.isPaused = true

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = .white
        if appWrapper == nil {
            let viewPointer = Unmanaged.passUnretained(self.metalV).toOpaque()
            let metalLayer = Unmanaged.passUnretained(self.metalV.layer).toOpaque()
            let maximumFrames = UIScreen.main.maximumFramesPerSecond

            let viewObj = ios_view_obj(view: viewPointer, metal_layer: metalLayer,maximum_frames: Int32(maximumFrames), callback_to_swift: callback_to_swift)

            appWrapper = create_wgpu_canvas(viewObj)
        }
        self.displayLink.isPaused = false
    }
    @objc func enterFrame() {
        guard let canvas = self.appWrapper else {
            return
        }
        // call rust
        enter_frame(canvas)
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
        var js2 = """
           const elements = document.getElementsByClassName('PackagePageTomlCopy');
           if (elements.length >0){
             var deploymentText = elements[0].querySelector("div").innerText;
             const deploymentMatch = deploymentText.match(//"(.*?)"//g)
            return deploymentMatch[0].replace("'","");
           }else{
            return "Cannot find"
           }
        """
        webView.evaluateJavaScript(js2, completionHandler: {(result,error) in

                print("error")
                print(error)
                            print("result")
                print(result)

        })
        }

}


func callback_to_swift(arg: Int32) {
    DispatchQueue.main.async {
        switch arg {
        case 0:
            print("wgpu canvas created!")
            break
        case 1:
            print("canvas enter frame")
            break
            
        default:
            break
        }
    }
    
}
