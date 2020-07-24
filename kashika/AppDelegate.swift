//
//  AppDelegate.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/26.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Firebase
import Ballcap
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: AppRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        setupKeyboard()
        setupWindow()

        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let webpageURL = userActivity.webpageURL else {
                return true
        }
        let dynamicLinks = DynamicLinks.dynamicLinks()
        return dynamicLinks.handleUniversalLink(webpageURL) { [weak self] (link, _) in
            guard let url = link?.url else {
                return
            }
            self?.router?.handleDeeplink(url)
            print(url.absoluteString)
        }
    }
}

// MARK: - Configure

extension AppDelegate {

    private func setupFirebase() {
        FirebaseApp.configure()
    }

    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        router = AppRouter(window: window!)
        router?.presentRootViewController()

        window?.makeKeyAndVisible()
    }
}
