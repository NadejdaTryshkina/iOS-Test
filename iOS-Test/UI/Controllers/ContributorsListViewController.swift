//
//  ContributorsListViewController.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//

import Shakuro_iOS_Toolbox
import UIKit

final class ContributorsListViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    private var refresher: PullToRefreshView?

    private var interactor: ContributorsListInteractor!
    private var transitionManager: TransitionManager = TransitionManager()
    private var indexPathForLastSelectedCell: IndexPath?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshIndicator = UIActivityIndicatorView()
        refreshIndicator.hidesWhenStopped = false
        refresher = PullToRefreshView(scrollView: tableView, length: 60.0, contentView: refreshIndicator)
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.delegate = transitionManager
        loadContributorsList()
        refresher?.eventHandler = { self.loadContributorsList() }
    }

    private func loadContributorsList() {
        interactor.requestContributorsList()
    }
}

// MARK: - UITableViewDelegate

extension ContributorsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contributor = interactor.contributor(at: indexPath.row)
        indexPathForLastSelectedCell = indexPath
        appContainer?.present(type: SingleContributorViewController.self,
                              options: SingleContributorViewControllerOptions(contributor: contributor),
                              from: self,
                              style: .push(asRoot: false),
                              animated: true)

    }

}

// MARK: - UITableViewDataSource

extension ContributorsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContributorCell = tableView.dequeueReusableCell(indexPath: indexPath,
                                                 reuseIdentifier: R.reuseIdentifier.contributorCell.identifier)
        cell.configure(with: interactor.contributor(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.contributionsCount
    }

}

// MARK: - ContributorsInteractorOutput

extension ContributorsListViewController: ContributorsInteractorOutput {
    func interactorDidLoadContributors() {
        loadingIndicator.stopAnimating()
        tableView.reloadData()
    }

    func willSendServerRequest() {
        refresher?.endRefreshingAnimation()
        loadingIndicator.startAnimating()
    }

    func interactorDidReceiveResponse(with error: AppError?) {
    loadingIndicator.stopAnimating()

        guard let appContainerActual = appContainer else {
            return
        }
        if let errorActual = error,
           !appContainerActual.handleError(errorActual) {
            let title = errorActual.errorTitle()
            let message = errorActual.errorDescription()

            appContainerActual.showAlert(with: title, message: message, actions: nil, fromViewController: self)
        }
    }

}

// MARK: - BaseViewControllerProtocol

extension ContributorsListViewController: BaseViewControllerProtocol {

    typealias OptionsType = Void
    typealias PublicInterface = BaseViewControllerPublicInterface
    typealias ControllerType = ContributorsListViewController

    static func instantiate(appContainer: AppContainerProtocol, options: OptionsType) -> ControllerType {
        let viewController = unwrap { R.storyboard.main.contributorsListViewControllerID() }

        viewController.title = NSLocalizedString("Contributors", comment: "")
        viewController.appContainer = appContainer
        viewController.interactor = ContributorsListInteractor(taskManager: appContainer.taskManager,
                                                               output: viewController)

        return viewController
    }

}

// MARK: - TransitionableViewController

extension ContributorsListViewController: TransitionableViewController {

    func transitioningView() -> TransitionViewWithFrame? {
        guard let indexPath = indexPathForLastSelectedCell,
              let cell = tableView.cellForRow(at: indexPath) as? ContributorCell else {
            return nil
        }

        tableView.deselectRow(at: indexPath, animated: true)
        let frame = view.convert(cell.avatarImageView.frame, from: cell)
        return (imageView: cell.avatarImageView, frame: frame)
    }

    func transitionDirection() -> TransitionDirection {
        return .push
    }

}
