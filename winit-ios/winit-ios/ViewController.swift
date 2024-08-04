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

    override func loadView() {
        print("loadView")
        let webViewConfiguration = WKWebViewConfiguration()
        let schemeHandler = CustomSchemeHandler()
        webViewConfiguration.setURLSchemeHandler(schemeHandler, forURLScheme: "http")
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)

        //webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://ambient.run/games")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
       
        let js = """
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
        webView.evaluateJavaScript(js, completionHandler: nil)
    }


}


