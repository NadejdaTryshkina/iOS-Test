import UIKit

typealias BaseViewControllerPublicInterface = UIViewController

protocol BaseViewControllerProtocol: AnyObject {

    associatedtype OptionsType
    associatedtype PublicInterface
    associatedtype ControllerType: UIViewController

    static func instantiate(appContainer: AppContainerProtocol, options: OptionsType) -> ControllerType

}

class BaseViewController: UIViewController {

    weak var appContainer: AppContainerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension BaseViewControllerProtocol {

    static func unwrap<T>(_ block: () -> T?) -> T {
        guard let result = block() else {
            fatalError("Can not instantiate view controller from storyboard")
        }
        return result
    }

}
