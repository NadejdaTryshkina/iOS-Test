//
//  SingleContributorViewController.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//

import UIKit

struct SingleContributorViewControllerOptions {
    let contributor: Contributor?
}

final class SingleContributorViewController: BaseViewController {

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!

    private var options: SingleContributorViewControllerOptions?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

private extension SingleContributorViewController {

    func setupUI() {
        nameLabel.font = StyleSheet.sharedInstance.font.interUIRegular32
        nameLabel.textColor = StyleSheet.sharedInstance.color.customDarkGray
        nameLabel.text = options?.contributor?.login

        avatarImageView.loadImage(at: options?.contributor?.avatarURL, withPlaceholder: R.image.avatarPlaceholder())
    }

}

// MARK: - BaseViewControllerProtocol

extension SingleContributorViewController: BaseViewControllerProtocol {

    typealias OptionsType = SingleContributorViewControllerOptions
    typealias PublicInterface = BaseViewControllerPublicInterface
    typealias ControllerType = SingleContributorViewController

    static func instantiate(appContainer: AppContainerProtocol, options: OptionsType) -> ControllerType {
        let viewController = unwrap { R.storyboard.main.singleContributorViewControllerID() }

        viewController.title = NSLocalizedString("", comment: "")
        viewController.options = options
        return viewController
    }

}

// MARK: - TransitionableViewController

extension SingleContributorViewController: TransitionableViewController {

    func transitioningView() -> TransitionViewWithFrame? {

//        let constraints = view.constraints.filter { ($0.firstItem as? UIView) == avatarImageView }
//
//        let widthConst = constraints.first(where: { $0.firstAttribute == .width })?.multiplier ?? 1
//        let w = view.frame.width * widthConst
//        let heightConst = avatarImageView.constraints.first(where: { $0.secondAttribute == .height})?.multiplier ?? 1
//        let h = w / heightConst
//        let dy = constraints.first(where: { $0.firstAttribute == .centerY })?.constant ?? 0

        return (imageView: avatarImageView, frame: .zero)
//                frame: CGRect(x: (view.frame.width - w) / 2.0,
//                              y: (view.frame.height - h) / 2 + dy,
//                              width: w,
//                              height: h)
//        )
    }

    func transitionDirection() -> TransitionDirection {
        return .pop
    }

}
