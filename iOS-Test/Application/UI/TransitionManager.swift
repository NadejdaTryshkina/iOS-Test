//
//  TransitionManager.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 28.01.2022.
//

import UIKit

enum TransitionDirection {
    case push
    case pop
}

protocol TransitionableViewController: UIViewController {
    typealias TransitionViewWithFrame = (imageView: UIImageView, frame: CGRect)

    func transitioningView() -> TransitionViewWithFrame?
    func transitionDirection() -> TransitionDirection
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    var duration: CGFloat = 0.7

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? TransitionableViewController,
              let toViewController = transitionContext.viewController(forKey: .to) as? TransitionableViewController else {
                    return
              }
        let transitionDirection = fromViewController.transitionDirection()
        switch transitionDirection {
        case .push:
            forwardAnimation(from: fromViewController, to: toViewController, using: transitionContext)
        case .pop:
            backwardAnimation(from: fromViewController, to: toViewController, using: transitionContext)
        }
    }

    func forwardAnimation(from fromViewController: TransitionableViewController,
                          to toViewController: TransitionableViewController,
                          using transitionContext: UIViewControllerContextTransitioning) {
        guard let smallView = fromViewController.transitioningView(),
              let largeView = toViewController.transitioningView(),
              let smallImage = smallView.imageView.image else {
                  return
              }
        let smallImageView = smallView.imageView
        let smallFrame = smallView.frame

        let containerView = transitionContext.containerView

        let snapshotsmallView = UIImageView()
        snapshotsmallView.contentMode = smallImageView.contentMode
        snapshotsmallView.image = smallImage
        snapshotsmallView.layer.cornerRadius = smallImageView.layer.cornerRadius
        snapshotsmallView.frame = smallFrame//containerView.convert(imageView.frame, from: smallView)

        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotsmallView)

        let mainFrame = transitionContext.initialFrame(for: fromViewController)
        toViewController.view.frame = mainFrame.offsetBy(dx: mainFrame.width, dy: 0)
        toViewController.view.alpha = 0.5

        let largeImageView = largeView.imageView
        let largeFrame = largeView.frame
        largeImageView.isHidden = true

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotsmallView.frame = largeFrame
            snapshotsmallView.layer.cornerRadius = 0
            toViewController.view.frame = mainFrame
            toViewController.view.alpha = 1
        }

        animator.addCompletion { position in
            largeImageView.isHidden = false
            snapshotsmallView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }

    func backwardAnimation(from fromViewController: TransitionableViewController,
                           to toViewController: TransitionableViewController,
                           using transitionContext: UIViewControllerContextTransitioning) {
        guard let smallView = toViewController.transitioningView(),
                  let largeView = fromViewController.transitioningView() else {
                      return
                  }

        let containerView = transitionContext.containerView

        let largeImageView = largeView.imageView
        let largeFrame = largeView.frame

        let snapshotLargeView = UIImageView()
        snapshotLargeView.contentMode = largeImageView.contentMode
        snapshotLargeView.image = largeImageView.image
        snapshotLargeView.frame = largeFrame

        let mainFrame = transitionContext.initialFrame(for: fromViewController)
        let smallFrame = smallView.frame
        toViewController.view.frame = mainFrame
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(snapshotLargeView)

        largeImageView.isHidden = true

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotLargeView.frame = smallFrame
            snapshotLargeView.layer.cornerRadius = 0
            fromViewController.view.frame = mainFrame.offsetBy(dx: mainFrame.width * 2, dy: 0)
            fromViewController.view.alpha = 0
        }

        animator.addCompletion { position in
            snapshotLargeView.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
}

extension TransitionManager: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return self
    }
}
