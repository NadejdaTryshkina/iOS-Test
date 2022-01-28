import Shakuro_iOS_Toolbox

typealias ViewController = UIViewController & BaseViewControllerProtocol
typealias AppRouterProtocol = RouterProtocol & RouterHelperProtocol

protocol RouterHelperProtocol {

}

class AppRouter: Router {

    init(rootViewController: UINavigationController) {
        super.init(rootController: rootViewController)
    }

}

// MARK: - AppRouterProtocol

extension AppRouter: RouterHelperProtocol {

}
