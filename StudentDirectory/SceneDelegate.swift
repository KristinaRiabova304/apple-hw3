import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    /// The single shared store, injected into every screen.
    private let store = StudentStore()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let listController = StudentListViewController(store: store)
        window.rootViewController = UINavigationController(rootViewController: listController)
        window.makeKeyAndVisible()
        self.window = window
    }
}
