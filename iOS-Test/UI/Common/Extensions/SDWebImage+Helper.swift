import SDWebImage
import UIKit

extension UIImageView {

    func loadImage(at url: URL?, withPlaceholder placeholder: UIImage?) {
        sd_setImage(with: url, placeholderImage: placeholder)
    }

}

extension UIButton {

    func loadBackgroundImage(at url: URL?, withPlaceholder placeholder: UIImage?) {
        sd_setBackgroundImage(with: url, for: .normal, placeholderImage: placeholder)
    }

    func loadImage(at url: URL?, withPlaceholder placeholder: UIImage?) {
        sd_setImage(with: url, for: .normal, placeholderImage: placeholder)
    }

}
