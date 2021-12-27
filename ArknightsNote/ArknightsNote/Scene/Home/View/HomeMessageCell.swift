//
//  HomeMessageCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import UIKit

class HomeMessageCell: UITableViewCell {
    @IBOutlet var bgView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var platformLabel: UILabel!
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        bgView.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
}
