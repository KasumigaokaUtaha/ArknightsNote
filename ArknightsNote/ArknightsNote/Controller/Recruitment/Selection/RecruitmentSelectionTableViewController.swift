//
//  RecruitmentSelectionTableViewController.swift
//  RecruitmentSelectionTableViewController
//
//  Created by Kasumigaoka Utaha on 14.08.21.
//

import UIKit

class RecruitmentSelectionTableViewController: UITableViewController {
    
    // MARK: - Properties

    private var selectedTags: [String] = [] // store selected tags
    private let recruitmentStore = RecruitmentStore()
    private var collectionViewIndexPaths = [UICollectionView: IndexPath]()

    // MARK: - Actions
    
    func tagButtonTapped(_ sender: UIButton) {
        // check if the tag of the tapped button can be found in the selectedTags variable
        // if yes, then we can set the tapped button back to normal state instead of tapped state
        // (indicated by another background color) and remove the represented tag from the variable selectedTags.
        // otherwise, change button state to tapped and add the represented tag to selectedTags
    }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecruitmentSelectionTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Each category case occupies one section
        return self.recruitmentStore.numberOfCategoryCases()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each category case uses one row in each section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruitmentTagCategory", for: indexPath)

        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RecruitmentSelectionTableViewCell else {
            return
        }
        
        guard let collectionView = cell.getCollectionView() else {
            return
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionViewIndexPaths.updateValue(indexPath, forKey: collectionView)
    }
}

extension RecruitmentSelectionTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indexPath = collectionViewIndexPaths[collectionView] else {
            return 0
        }
        
        if let tagCategory = RecruitmentStore.Category(rawValue: indexPath.section) {
            return recruitmentStore.tagsOfCategory(tagCategory).count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentTag", for: indexPath)
        
        cell.backgroundColor = UIColor.black
        // TODO configure the recruitment tag
        
        return cell
    }
}
