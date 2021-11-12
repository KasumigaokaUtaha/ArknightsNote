//
//  HomeMessageCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import UIKit

class HomeMessageCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        bgView.layer.cornerRadius = 8
//        bgView.layer.shadowColor = UIColor.lightGray.cgColor
//        bgView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        bgView.layer.shadowOpacity = 0.5
//        bgView.layer.shadowRadius = 4.0

        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

}
