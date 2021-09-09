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
    private var recruitmentStore: RecruitmentStore! = nil
    private var collectionViewIndexPaths = [UICollectionView: IndexPath]()
    private var collectionViewTags = [UICollectionView: [String]]()
    private let maximumSelectedTagsCount = 4

    // MARK: - Initializer
    
    func configure(recruitmentStore store: RecruitmentStore) {
        recruitmentStore = store
    }

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

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let parentVC = presentingViewController as? RecruitmentTableViewController else { return }
        parentVC.setSelectedTags(selectedTags)
    }
    
    // MARK: - Layout actions
    // See https://stackoverflow.com/a/64390373
    private func updateRowHeight() {
        // TODO disable animation
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - Utility functions
    private func computeItemSize(_ item: String) -> CGSize {
        var itemSize = item.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        itemSize.width += itemSize.height
        itemSize.height += itemSize.height / 2
        
        return itemSize
    }
    
}

// MARK: - Table View Data Source & Delegate
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

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let cell = cell as? RecruitmentSelectionTableViewCell,
            let collectionView = cell.getCollectionView() as? RecruitmentTagCollectionView,
            let category = RecruitmentStore.Category(rawValue: indexPath.section)
        else {
            return
        }
        
        let tags = recruitmentStore.tagsOfCategory(category)
        collectionViewIndexPaths.updateValue(indexPath, forKey: collectionView)
        collectionViewTags.updateValue(tags, forKey: collectionView)
        
//        collectionView.collectionViewLayout = RecruitmentTagCloudLayout(data: collectionViewTags[collectionView] ?? [], computeCellSize: self.computeItemSize(_:))
        collectionView.didLayoutAction = updateRowHeight
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        cell.layoutIfNeeded()
    }
}

// MARK: - Collection View Data Source & Flow Layout Delegate
extension RecruitmentSelectionTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let indexPath = collectionViewIndexPaths[collectionView],
            let tagCategory = RecruitmentStore.Category(rawValue: indexPath.section)
        else {
            return 0
        }
        
        return recruitmentStore.tagsOfCategory(tagCategory).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentTag", for: indexPath) as! RecruitmentTagCloudCollectionViewCell
        
        cell.backgroundColor = .lightGray
        cell.tagLabel.textColor = .white
        cell.layer.cornerRadius = 6
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = cell as? RecruitmentTagCloudCollectionViewCell,
            let tags = collectionViewTags[collectionView]
        else {
            return
        }
        
        cell.tagLabel.text = tags[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return selectedTags.count < maximumSelectedTagsCount
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitmentTagCloudCollectionViewCell else { return }
        
        cell.backgroundColor = .systemBlue
        
        guard let tag = cell.tagLabel.text, !selectedTags.contains(tag) else { return }
        
        selectedTags.append(tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitmentTagCloudCollectionViewCell else { return }
        
        cell.backgroundColor = .lightGray
        
        guard let tag = cell.tagLabel.text, let index = selectedTags.firstIndex(of: tag) else { return }
        
        selectedTags.remove(at: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tags = collectionViewTags[collectionView] else { return .zero }
        
        let tag = tags[indexPath.row]
        return computeItemSize(tag)
    }
}
