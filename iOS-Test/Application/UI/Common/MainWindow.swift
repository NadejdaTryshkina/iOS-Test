import UIKit

internal protocol MainWindowDelegate: AnyObject {
    func mainWindowDidShake(_ mainWindow: MainWindow)
}

internal class MainWindow: UIWindow {

    weak var mainWindowDelegate: MainWindowDelegate?

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if let eventActual = event, eventActual.type == .motion && eventActual.subtype == .motionShake {
            mainWindowDelegate?.mainWindowDidShake(self)
        }
    }

}
