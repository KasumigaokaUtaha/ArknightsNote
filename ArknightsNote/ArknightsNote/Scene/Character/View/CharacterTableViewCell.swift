//
//  CharacterTableViewCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import UIKit
import Combine

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterProfessionLabel: UILabel!
    @IBOutlet weak var characterSubProfessionLabel: UILabel!
    @IBOutlet weak var characterObtainApproachLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var characterTagCollectionView: UICollectionView!
    
    var cancellable: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.characterTagCollectionView.register(TagCloudCollectionViewCell.self, forCellWithReuseIdentifier: "characterTag")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.characterImageView.image = nil // reset image for reuse
        self.cancellable = nil // cancel any subscription for reuse
    }
    
}
