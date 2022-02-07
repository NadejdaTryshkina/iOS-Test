import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

protocol AppTaskManagerProtocol {
    func loadContributors() -> Task<[Contributor]>
}

class AppTaskManager: TaskManager {

    private let apiClient: AppAPIClient = AppAPIClient()

    init() {
        super.init(name: "\(UIApplication.bundleIdentifier).app.taskmanager.queue",
                   qualityOfService: .userInteractive,
                   maxConcurrentOperationCount: 5)
    }

    override func willPerformOperation(newOperation: TaskManager.OperationInQueue,
                                       enqueuedOperations: [TaskManager.OperationInQueue]) -> TaskManager.OperationInQueue {
        return newOperation
    }

}

// MARK: - AppTaskManagerProtocol

extension AppTaskManager: AppTaskManagerProtocol {

    func loadContributors() -> Task<[Contributor]> {
        return performOperation(operationType: LoadContributorsOperation.self,
                                options: LoadContributorsOperationOptions(apiClient: apiClient))
    }

}
