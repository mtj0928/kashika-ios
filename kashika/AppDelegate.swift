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
    var router: AppRouter = AppRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        setupKeyboard()
        setupWindow()

        return true
    }
}

// MARK: - Configure

extension AppDelegate {

    private func setupFirebase() {
        FirebaseApp.configure()
        BallcapApp.configure(Firestore.firestore().document("version/1"))
    }

    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CalendarViewController.createFromStoryboard()//router.createRootViewController()
        window?.makeKeyAndVisible()
    }
}
