//
//  ContributorsListInteractor.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//
import Shakuro_iOS_Toolbox

protocol ContributorsInteractorOutput: AnyObject {
    func willSendServerRequest()
    func interactorDidLoadContributors()
    func interactorDidReceiveResponse(with error: AppError?)
}

class ContributorsListInteractor {

    private let taskManager: AppTaskManagerProtocol

    private var contributors: [Contributor] = []
    private weak var output: ContributorsInteractorOutput?

    var contributionsCount: Int {
        return contributors.count
    }

    init(taskManager: AppTaskManagerProtocol, output: ContributorsInteractorOutput) {
        self.taskManager = taskManager
        self.output = output
    }

    func requestContributorsList() {
        output?.willSendServerRequest()
        taskManager.loadContributors().onComplete(queue: .main, closure: { [weak self] (_, result) in
            guard let actualSelf = self else {
                return
            }

            var appError: AppError?
            switch result {
            case .success(let contributors):
                actualSelf.contributors = contributors
                actualSelf.output?.interactorDidLoadContributors()
            case .failure(let error):
                appError = AppError(error)
                actualSelf.output?.interactorDidReceiveResponse(with: appError)
            default: break
            }
        })
    }

    func contributor(at index: Int) -> Contributor? {
        guard !contributors.isEmpty && index < contributionsCount else {
            return nil
        }
        return contributors[index]
    }

}
