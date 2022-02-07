//
//  UIActivityIndicatorView+Refresh.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 07.02.2022.
//

import Shakuro_iOS_Toolbox
import UIKit

extension UIActivityIndicatorView: PullToRefreshContentViewProtocol {
    public func updateState(currentPullDistance: CGFloat, targetPullDistance: CGFloat, state: PullToRefreshView.State) {
        switch state {
        case .idle, .readyToTrigger:
            isHidden = false
            stopAnimating()
        case .refreshing:
            isHidden = false
            startAnimating()
        case .finishing:
            isHidden = true
            stopAnimating()
        }
    }

}

