import Foundation
import Shakuro_CommonTypes
import Shakuro_iOS_Toolbox

internal protocol AppEventsHandler: AnyObject {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
}

// MARK: - AppEventsHandler

extension AppContainer: AppEventsHandler {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Logger.setup()
        present(type: ContributorsListViewController.self,
                options: Void(),
                from: nil,
                style: .push(asRoot: true),
                animated: true)
        return true
    }

}

internal class AppCoordinator {

    internal weak var appContainer: AppContainerProtocol?

    // MARK: - Public

    func handleStartup() {
        appContainer?.present(type: ContributorsListViewController.self,
                              options: (),
                              from: nil,
                              style: .push(asRoot: true),
                              animated: false)
    }

}
