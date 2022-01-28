//
//  ContributorsListInteractor.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//
import Shakuro_iOS_Toolbox

protocol ContributorsInteractorOutput: AnyObject {
    func willSendServerRequest()
    func interactor(_ interactor: ContributorsListInteractor, didLoadContributors list: [Contributor])
    func interactor(_ interactor: ContributorsListInteractor, didReceiveResponseWithError error: AppError?)
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
            case .failure(let error):
                appError = AppError(error)
                actualSelf.output?.interactor(actualSelf, didReceiveResponseWithError: appError)

            case .success(let contributors):
                actualSelf.contributors = contributors
                actualSelf.output?.interactor(actualSelf, didLoadContributors: contributors)
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
