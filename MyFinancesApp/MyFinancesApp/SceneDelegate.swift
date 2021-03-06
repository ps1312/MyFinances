//
//  SceneDelegate.swift
//  MyFinancesApp
//
//  Created by Paulo Sergio da Silva Rodrigues on 15/04/21.
//

import UIKit
import MyFinancesiOS
import MyFinances

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = URLSessionHTTPClient()

    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        configureView()
    }

    func configureView() {
        let url = URL(string: "https://my-finances-715d4-default-rtdb.firebaseio.com/expenses.json")!
        let loader = RemoteExpensesLoader(url: url, client: httpClient)
        let controller = UINavigationController(rootViewController: ExpensesUIComposer.compose(loader: loader))

        window?.rootViewController = controller
    }


}
