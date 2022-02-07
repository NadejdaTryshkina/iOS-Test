//
//  ContributorCell.swift
//  iOS-Test
//
//  Created by Nadejda Tryshkina on 26.01.2022.
//

import UIKit

final class ContributorCell: UITableViewCell {

    @IBOutlet private(set) var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = StyleSheet.sharedInstance.font.interUIRegular16
        nameLabel.textColor = StyleSheet.sharedInstance.color.primaryTextColor
        idLabel.font = StyleSheet.sharedInstance.font.interUIRegular16
        idLabel.textColor = StyleSheet.sharedInstance.color.secondaryTextColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        idLabel.text = ""
        avatarImageView.sd_cancelCurrentImageLoad()
    }

    func configure(with contributor: Contributor?) {
        avatarImageView.loadImage(at: contributor?.avatarURL, withPlaceholder: R.image.avatarPlaceholder())
        nameLabel.text = contributor?.login
        idLabel.text = contributor?.id.description
    }

}
