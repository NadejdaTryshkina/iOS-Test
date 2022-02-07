import Foundation
import Shakuro_CommonTypes
import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

internal protocol AppErrorsHandler: AnyObject {
    func handleError(_ error: AppError) -> Bool
}

// MARK: - AppErrorsHandler

extension AppContainer: AppErrorsHandler {

    func handleError(_ error: AppError) -> Bool {
        return false
    }

}
