//
//  SceneDelegate.swift
//  FallbackDataSource
//
//  Created by Windy on 08/12/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()

        let nav = UINavigationController(rootViewController: buildVC())
        nav.navigationBar.prefersLargeTitles = true
        
        window?.rootViewController = nav
    }
    
    func buildVC() -> ViewController {
        
        let remoteDataService = DecoratorRemoteDataSource(
            decorate: RemoteDataSource(apiService: .shared),
            coreDataService: .shared)
        
        let localDataService = LocalDataSource(coreDataService: .shared)
        
        let fallBackLoader = FallBackDataSource(
            localDataSource: localDataService,
            remoteDataSource: remoteDataService)
                
        let vc = ViewController(dataLoader: fallBackLoader)
        vc.title = "Posts"
        
        return vc
    }
    
}
