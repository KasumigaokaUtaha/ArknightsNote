//
//  CharacterTableViewCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import Combine
import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var characterNameLabel: UILabel!
    @IBOutlet var characterProfessionLabel: UILabel!
    @IBOutlet var characterSubProfessionLabel: UILabel!
    @IBOutlet var characterObtainApproachLabel: UILabel!
    @IBOutlet var characterDescriptionLabel: UILabel!
    @IBOutlet var characterTagCollectionView: UICollectionView!

    var cancellable: AnyCancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        characterTagCollectionView.register(TagCloudCollectionViewCell.self, forCellWithReuseIdentifier: "characterTag")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        characterImageView.image = nil // reset image for reuse
        cancellable = nil // cancel any subscription for reuse
    }
}
