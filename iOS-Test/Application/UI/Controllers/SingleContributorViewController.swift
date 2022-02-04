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
    @IBOutlet private var avatarVerticalOffsetConstraint: NSLayoutConstraint!
    @IBOutlet private var avatarWidthScalingConstraint: NSLayoutConstraint!
    @IBOutlet private var avatarHeightAspectConstraint: NSLayoutConstraint!

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
        let width = view.frame.width * avatarWidthScalingConstraint.multiplier
        let height = width / avatarHeightAspectConstraint.multiplier
        let verticalOffset = avatarVerticalOffsetConstraint.constant

        return (imageView: avatarImageView,
                frame: CGRect(x: (view.frame.width - width) / 2.0,
                              y: (view.frame.height - height) / 2 + verticalOffset,
                              width: width,
                              height: height)
        )
    }

    func transitionDirection() -> TransitionDirection {
        return .pop
    }

}
