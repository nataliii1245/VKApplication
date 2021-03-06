//
//  AuthorizationViewController.swift
//  VKApplication
//
//  Created by Natalia Volkova on 14.10.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet
    private weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Приватные свойства
    
    private weak var webView: WKWebView! {
        willSet {
            newValue.navigationDelegate = self
        }
    }
    
}


// MARK: - UIViewController

extension AuthorizationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webView)
        webView.layoutAttachAll(to: self.view)
        
        webView.alpha = 0
        
        if let url = AuthorizationService.getUrl() {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        self.webView = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.activityIndicator.alpha == 1 {
            self.activityIndicator.startAnimating()
        }
    }
    
}


// MARK: - WKNavigationDelegate

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 1
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
    }
    
    /// Метод вызывается до того, как произойдет переход на другую страницу
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // Проверяем: если экран отображает не токен, то позволяем переход
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        // Парсим полученную строку
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        // Если получили токен - останавливаем WebView
        if let token = params["access_token"]{
            decisionHandler(.cancel)
            
            // Добавляем токен в хранилище Keychain
            KeychainWrapper.standard.set(token, forKey: KeychainKey.token)
            
            let defaults = UserDefaults(suiteName: "group.VKApplication")
            defaults?.set(token, forKey: "token")
            defaults?.synchronize()
            
            // Устанавливаем флаг авторизации пользователя
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserAuthorized)
            performSegue(withIdentifier: .showTabBarControllerFromAuthorization, sender: nil)
        }
    }
    
}
