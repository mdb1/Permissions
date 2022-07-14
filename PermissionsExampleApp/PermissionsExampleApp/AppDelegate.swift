//
//  AppDelegate.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        guard let window = window else { fatalError("Can't start without a window") }

        navigationController.setViewControllers([HomeViewController()], animated: true)
        window.rootViewController = navigationController
        window.tintColor = .purple
        window.makeKeyAndVisible()

        return true
    }
}
