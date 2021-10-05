//
//  RecruitmentSelectionTableViewController.swift
//  RecruitmentSelectionTableViewController
//
//  Created by Kasumigaoka Utaha on 14.08.21.
//

import UIKit

class RecruitmentTagViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private var selectedTags: [String] = [] // store selected tags
    private var recruitmentStore: RecruitmentStore!
    private var collectionViewIndexPaths = [UICollectionView: IndexPath]()
    private var collectionViewTags = [UICollectionView: [String]]()
    private let maximumSelectedTagsCount = 4

    var viewWillDisappearAction: (([String]) -> Void)?

    // MARK: - Configuration
    
    func configure(recruitmentStore store: RecruitmentStore, selectedTags tags: [String]) {
        recruitmentStore = store
        selectedTags = tags
    }

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearAction?(selectedTags)
//        guard let parentVC = presentingViewController as? RecruitmentTableViewController else { return }
//        parentVC.setSelectedTags(selectedTags)
    }
    
    // MARK: - Layout actions
    // See https://stackoverflow.com/a/64390373
    private func updateRowHeight() {
        DispatchQueue.main.async {
            // Disable animation
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    // MARK: - Utilities
    private func computeItemSize(_ item: String) -> CGSize {
        var itemSize = item.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        itemSize.width += itemSize.height
        itemSize.height += itemSize.height / 2
        
        return itemSize
    }
    
    private func toggleSelected(for cell: RecruitmentTagCloudCollectionViewCell) {
        guard let tag = cell.tagLabel.text else { return }
        
        if !selectedTags.contains(tag) {
            // didSelectItem
            cell.backgroundColor = .systemBlue
            selectedTags.append(tag)
        } else {
            // didDeselectItem
            cell.backgroundColor = .lightGray
            let index = selectedTags.firstIndex(of: tag)!
            selectedTags.remove(at: index)
        }
    }
}

// MARK: - Table View Data Source
extension RecruitmentTagViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Each category case occupies one section
        return self.recruitmentStore.numberOfCategoryCases()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each category case uses one row in each section
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch RecruitmentStore.Category(rawValue: section) {
        case .seniority:
            return "资质"
        case .position:
            return "位置"
        case .profession:
            return "职业"
        case .trait:
            return "特性"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recruitmentTagCategory", for: indexPath)

        return cell
    }
}

// MARK: - Table View Delegate
extension RecruitmentTagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
extension RecruitmentTagViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indexPath = collectionViewIndexPaths[collectionView],
              let tagCategory = RecruitmentStore.Category(rawValue: indexPath.section)
        else { return 0 }
        
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
        guard let cell = cell as? RecruitmentTagCloudCollectionViewCell,
              let tags = collectionViewTags[collectionView]
        else { return }
        
        let tag = tags[indexPath.item]
        cell.tagLabel.text = tag
        // restore selected cell
        guard let index = selectedTags.firstIndex(of: tag) else { return }
        selectedTags.remove(at: index)
        // necessary to enable the deselection, see https://stackoverflow.com/a/31387259
        cell.isSelected = true
        toggleSelected(for: cell)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return selectedTags.count < maximumSelectedTagsCount
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitmentTagCloudCollectionViewCell else { return }

        toggleSelected(for: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecruitmentTagCloudCollectionViewCell else { return }
        
        toggleSelected(for: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tags = collectionViewTags[collectionView] else { return .zero }
        
        let tag = tags[indexPath.item]
        return computeItemSize(tag)
    }
}
