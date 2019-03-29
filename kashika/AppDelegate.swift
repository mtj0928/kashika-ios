//
//  AppDelegate.swift
//  kashika
//
//  Created by 松本淳之介 on 2019/03/26.
//  Copyright © 2019 JunnosukeMatsumoto. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: AppRouter = AppRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        setupWindow()

        return true
    }
}

// MARK: - Configure

extension AppDelegate {

    private func setupFirebase() {
        FirebaseApp.configure()
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.createRootViewController()
        window?.makeKeyAndVisible()
    }
}
