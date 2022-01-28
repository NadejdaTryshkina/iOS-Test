import Foundation
import Shakuro_iOS_Toolbox

internal protocol AppContainerProtocol: AppRouterProtocol, AppErrorsHandler {

    // submodules
    var taskManager: AppTaskManagerProtocol { get }

    @discardableResult
    func present<ControllerType: UIViewController & BaseViewControllerProtocol>(type controllerType: ControllerType.Type,
                                                                                options: ControllerType.OptionsType,
                                                                                from: UIViewController?,
                                                                                style: NavigationStyle,
                                                                                animated: Bool) -> ControllerType.PublicInterface
    @discardableResult
    func present(controller: UIViewController, from: UIViewController?, style: NavigationStyle, animated: Bool) -> UIViewController?

    func showAlert(with title: String?,
                   message: String?,
                   actions: [UIAlertAction]?,
                   fromViewController viewController: UIViewController?)
    func showActionSheet(with title: String?,
                         message: String?,
                         actions: [UIAlertAction]?,
                         fromViewController viewController: UIViewController?)

}

/// Main root object of the app.
/// Handles navigation direct between screens, app events, holds all other components.
internal class AppContainer {

    // submodules
    internal let appRouter: AppRouter
    internal let internalTaskManager: AppTaskManager

    internal var currentDeprecatedStateDidChangeToken: EventHandlerToken?

    internal init(appRouter: AppRouter,
                  taskManager: AppTaskManager) {
        self.appRouter = appRouter
        self.internalTaskManager = taskManager
    }

}

// MARK: - AppContainerProtocol

extension AppContainer: AppContainerProtocol {
    var isModalViewControllerOnScreen: Bool {
        return false
    }


    var taskManager: AppTaskManagerProtocol {
        return internalTaskManager
    }

    @discardableResult
    func present<ControllerType: UIViewController & BaseViewControllerProtocol>(type controllerType: ControllerType.Type,
                                                                                options: ControllerType.OptionsType,
                                                                                from: UIViewController?,
                                                                                style: NavigationStyle,
                                                                                animated: Bool) -> ControllerType.PublicInterface {
        let controller = controllerType.instantiate(appContainer: self, options: options)
        guard let result = controller as? ControllerType.PublicInterface else {
            Logger.fatalError("\(controllerType) do not conform to \(ControllerType.PublicInterface.self)")
        }
        present(controller: controller, from: from, style: style, animated: animated)
        return result
    }

    @discardableResult
    func present(controller: UIViewController, from: UIViewController?, style: NavigationStyle, animated: Bool) -> UIViewController? {
        return presentViewController(controller: controller, from: from, style: style, animated: animated)
    }

    @discardableResult
    func presentViewController(controller: UIViewController,
                               from: UIViewController?,
                               style: NavigationStyle,
                               animated: Bool) -> UIViewController? {
        // TODO: rename presentViewController to present in app router
        return appRouter.presentViewController(controller: controller, from: from, style: style, animated: animated)
    }

    func popToViewController(_ controller: UIViewController, sender: UIViewController, animated: Bool) {
        appRouter.popToViewController(controller, sender: sender, animated: animated)
    }

    func popToFirstViewController<ControllerType>(_ controllerType: ControllerType.Type,
                                                  sender: UIViewController,
                                                  animated: Bool) {
        appRouter.popToFirstViewController(controllerType, sender: sender, animated: animated)
    }

    func dismissViewController(_ controller: UIViewController, animated: Bool) {
        appRouter.dismissViewController(controller, animated: animated)
    }

}

extension AppContainer {

    func showAlert(with title: String?,
                   message: String?,
                   actions: [UIAlertAction]?,
                   fromViewController viewController: UIViewController?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let actualActions = actions, !actualActions.isEmpty {
            actualActions.forEach { controller.addAction($0) }
        } else {
            controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        }
        appRouter.presentViewController(controller: controller,
                                        from: viewController,
                                        style: .modalDefault,
                                        animated: true)
    }

    func showActionSheet(with title: String?,
                         message: String?,
                         actions: [UIAlertAction]?,
                         fromViewController viewController: UIViewController?) {
        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .actionSheet)

        if let actualActions = actions, !actualActions.isEmpty {
            actualActions.forEach { controller.addAction($0) }
        } else {
            controller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        }
        appRouter.presentViewController(controller: controller,
                                        from: viewController,
                                        style: .modalDefault,
                                        animated: true)
    }

}
