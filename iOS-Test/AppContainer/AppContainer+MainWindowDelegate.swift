import UIKit

extension AppContainer: MainWindowDelegate {

    func mainWindowDidShake(_ mainWindow: MainWindow) {
        let topViewController = appRouter.rootNavigationController

        topViewController.view.endEditing(true)
        let alertVC = UIAlertController(title: "",
                                        message: NSLocalizedString("DebugSettings", comment: ""),
                                        preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        appRouter.presentViewController(controller: alertVC, from: topViewController, style: .modalDefault, animated: true)
    }

}
