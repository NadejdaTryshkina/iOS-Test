//
//  AppDelegate.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: MainWindow?

    private var appEventsHandler: AppEventsHandler?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = MainWindow(frame: UIScreen.main.bounds)

        let rootNavigationController = UINavigationController()

        let appContainer = AppContainer(appRouter: AppRouter(rootViewController: rootNavigationController),
                                        taskManager: AppTaskManager())
        appEventsHandler = appContainer

        window?.rootViewController = rootNavigationController
        window?.mainWindowDelegate = appContainer
        window?.makeKeyAndVisible()
        return appContainer.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
       // appEventsHandler?.applicationDidBecomeActive(application)
    }

}

