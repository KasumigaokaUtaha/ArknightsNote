//
//  CharacterViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import Nuke
import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    /// A dictionary containing collection view in a character table view cell as key and the corresponding index path of this table view cell as value
    private var collectionViewIndexPaths: [UICollectionView : IndexPath] = [:]
    
    private lazy var characters: [Character] = {
        let characters = CharacterStore.shared.getCharacters().sorted { lhs, rhs in
            if lhs.rarity != rhs.rarity {
                return lhs.rarity > rhs.rarity
            }
            return lhs.name < rhs.name
        }
        return characters
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CharacterCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Utility
    private func computeItemSize(_ item: String) -> CGSize {
        var itemSize = item.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13)])
        itemSize.width += itemSize.height
        itemSize.height += itemSize.height / 2
        
        return itemSize
    }

    private func makeXMLElementContentAttributedString(of text: String) -> NSAttributedString {
        let (extractedText, contentRanges) = Util.extractXMLContent(from: text, with: Defaults.Pattern.characterDescription)
        
        let attributedText = NSMutableAttributedString(string: extractedText)
        for contentRange in contentRanges {
            attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(contentRange, in: extractedText))
        }

        return attributedText
    }
}

// MARK: - Table View Data Source
extension CharacterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterTableViewCell,
            let collectionView = cell.characterTagCollectionView as? TagCloudCollectionView
        else {
            return UITableViewCell()
        }
        
        let character = self.characters[indexPath.row]
        Nuke.loadImage(with: Defaults.URL.Character.avatar(of: character.name), into: cell.characterImageView)
        cell.characterNameLabel.text = character.name
        cell.characterDescriptionLabel.attributedText = self.makeXMLElementContentAttributedString(of: character.description)
        cell.characterProfessionLabel.text = NSLocalizedString(character.profession, comment: "Character Profession")
        cell.characterSubProfessionLabel.text = NSLocalizedString(character.subProfessionId, comment: "Character Subprofession")
        cell.characterObtainApproachLabel.text = character.itemObtainApproach ?? NSLocalizedString("Unknown", comment: "Unknown character obtain approach")
//        cell.cancellable = ImagePipeline.shared.imagePublisher(with: Defaults.URL.Character.avatar(of: character.name))
//            .sink(receiveCompletion: { print("ImagePipeline receives completion \($0)") }, receiveValue: { cell.characterImageView.image = $0.image })
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionViewIndexPaths.updateValue(indexPath, forKey: collectionView)
        
        return cell
    }
}

// MARK: - Table View Delegate
extension CharacterViewController: UITableViewDelegate {
    
}

// MARK: - Collection View Data Source
extension CharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let indexPath = collectionViewIndexPaths[collectionView],
            indexPath.row < characters.count
        else {
            return 0
        }
        
        let character = characters[indexPath.row]
        return 2 + character.tagList.count // rarity, position and tags
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let tableViewCellIndexPath = collectionViewIndexPaths[collectionView],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterTag", for: indexPath) as? TagCloudCollectionViewCell,
            tableViewCellIndexPath.row < characters.count
        else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        cell.tagLabel.textColor = .label
        cell.tagLabel.font = UIFont.systemFont(ofSize: 13)
        cell.backgroundColor = UIColor.secondarySystemBackground

        let character = characters[tableViewCellIndexPath.row]
        switch indexPath.item {
        case 0:
            // display rarity
            let rarityText = NSLocalizedString(String(character.rarity), comment: "Character Rarity \(character.rarity)")
            cell.tagLabel.text = rarityText
            cell.tagLabel.textColor = .white

            switch character.rarity {
            case 0:
                cell.backgroundColor = UIColor.systemGray
            case 1:
                cell.backgroundColor = UIColor.systemGreen
            case 2:
                cell.backgroundColor = UIColor.systemBlue
            case 3:
                cell.backgroundColor = UIColor.systemPurple
            case 4:
                cell.backgroundColor = UIColor.systemOrange
            case 5:
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor, UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
                gradientLayer.locations = [0.0, 0.25, 0.5, 0.75 ,1.0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
                gradientLayer.frame.origin = CGPoint.zero
                gradientLayer.frame.size = cell.frame.size
                
                cell.gradientLayer = gradientLayer
                cell.layer.insertSublayer(gradientLayer, at: 0)
            default:
                break
            }
        case 1:
            // display position
            let positionText = NSLocalizedString(character.position, comment: "Character Position \(character.position)")
            cell.tagLabel.text = positionText
        case 2 ..< 2 + character.tagList.count:
            let tag = character.tagList[indexPath.item - 2]
            cell.tagLabel.text = tag
        default:
            break
        }
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension CharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard
            let tableViewCellIndexPath = collectionViewIndexPaths[collectionView],
            tableViewCellIndexPath.row < characters.count
        else {
            return .zero
        }

        let character = characters[tableViewCellIndexPath.row]
        var tag: String
        switch indexPath.item {
        case 0:
            // display rarity
            tag = NSLocalizedString(String(character.rarity), comment: "Character Rarity \(character.rarity)")
        case 1:
            // display position
            tag = NSLocalizedString(character.position, comment: "Character Position \(character.position)")
        case 2 ..< 2 + character.tagList.count:
            tag = character.tagList[indexPath.item - 2]
        default:
            return .zero
        }

        let itemSize = computeItemSize(tag)
        return itemSize
    }
}
