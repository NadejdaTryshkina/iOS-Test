import NVActivityIndicatorView
import UIKit

enum ActivityIndicatorSize {
    static let big: CGSize = CGSize(width: 80, height: 80)
    static let small: CGSize = CGSize(width: 40, height: 40)
}

class ActivityIndicatorView: UIView {

    var color: UIColor {
        get {
            return indicator.color
        }
        set {
            indicator.color = newValue
        }
    }

    private var indicator: NVActivityIndicatorView!
    private var indicatorWidthConstraint: NSLayoutConstraint!
    private var indicatorHeightConstraint: NSLayoutConstraint!
    private var internalIsHidden: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var indicatorSize: CGSize {
        get {
            return CGSize(width: indicatorWidthConstraint.constant, height: indicatorHeightConstraint.constant)
        }
        set {
            indicatorWidthConstraint.constant = newValue.width
            indicatorHeightConstraint.constant = newValue.height
        }
    }

    func setHidden(_ hidden: Bool, animated: Bool) {
        guard internalIsHidden != hidden || !animated else {
            return
        }
        internalIsHidden = hidden
        let actualAlpha: CGFloat = hidden ? 0.0 : 1.0
        if animated {
            if !hidden {
                isHidden = false
                if !indicator.isAnimating {
                    indicator.startAnimating()
                }
            }
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: [.curveEaseInOut, .beginFromCurrentState],
                           animations: {
                            self.alpha = actualAlpha
            }, completion: { (_) in
                if self.internalIsHidden && hidden {
                    self.indicator.stopAnimating()
                    self.isHidden = hidden
                }
            })
        } else {
            isHidden = hidden
            alpha = actualAlpha
            if hidden {
                indicator.stopAnimating()
            } else {
                indicator.startAnimating()
            }
        }
    }

    private func setup() {
        isHidden = true
        internalIsHidden = true
        alpha = 0.0
        clipsToBounds = true
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let indicatorFrame: CGRect = CGRect(origin: CGPoint.zero, size: ActivityIndicatorSize.big)
        indicator = NVActivityIndicatorView(frame: indicatorFrame,
                                            type: .circleStrokeSpin,
                                            color: UIColor.white.withAlphaComponent(0.8),
                                            padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicatorHeightConstraint = indicator.heightAnchor.constraint(equalToConstant: indicatorFrame.size.height)
        indicatorWidthConstraint = indicator.widthAnchor.constraint(equalToConstant: indicatorFrame.size.width)
        indicatorHeightConstraint.isActive = true
        indicatorWidthConstraint.isActive = true
        addSubview(indicator)

        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
