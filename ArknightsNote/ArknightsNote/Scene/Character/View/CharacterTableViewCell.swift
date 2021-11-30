//
//  CharacterTableViewCell.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterTraitLabel: UILabel!
    @IBOutlet weak var characterModuleLabel: UILabel!
    @IBOutlet weak var characterAcquirementLabel: UILabel!
    @IBOutlet weak var characterSkillLabel: UILabel!
    @IBOutlet weak var characterTagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
