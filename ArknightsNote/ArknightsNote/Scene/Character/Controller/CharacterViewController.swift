//
//  CharacterViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var collectionViewIndexPaths: [UICollectionView : IndexPath] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CharacterCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }
    
    // MARK: - Utility
    private func updateRowHeight() {
        DispatchQueue.main.async {
            // Disable animation
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
}

// MARK: - Table View Data Source
extension CharacterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterTableViewCell,
            let collectionView = cell.characterTagCollectionView as? TagCloudCollectionView
        else {
            return UITableViewCell()
        }
        
        collectionViewIndexPaths.updateValue(indexPath, forKey: collectionView)

        cell.characterImageView.image = UIImage(named: "假日威龙陈")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.didLayoutAction = updateRowHeight
        
        return cell
    }
}

// MARK: - Table View Delegate
extension CharacterViewController: UITableViewDelegate {
    
}

// MARK: - Collection View Data Source
extension CharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterTag", for: indexPath)
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension CharacterViewController: UICollectionViewDelegate {
    
}
