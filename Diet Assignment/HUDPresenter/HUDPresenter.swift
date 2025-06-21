//
//  HUD.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

final class HUDPresenter {
    static let shared = HUDPresenter()
    
    private var loaderWindow: UIWindow?
    
    private init() {}
    
    func show() {
        DispatchQueue.main.async {
            guard self.loaderWindow == nil else { return }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.windowLevel = .alert + 1
                
                let hostingController = UIHostingController(rootView: LoadingView())
                hostingController.view.backgroundColor = .clear
                window.rootViewController = hostingController
                
                
                window.isHidden = false
                self.loaderWindow = window
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.loaderWindow?.isHidden = true
            self.loaderWindow = nil
        }
    }
}
