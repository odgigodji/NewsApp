//
//  SceneDelegate.swift
//  News
//
//  Created by Nikita Evdokimov on 05.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow()
        window?.rootViewController = NewsListVC()
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
}

