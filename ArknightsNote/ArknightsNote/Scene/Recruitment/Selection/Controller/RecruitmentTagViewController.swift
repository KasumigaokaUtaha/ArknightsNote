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

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
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
    
    private func toggleSelected(for cell: TagCloudCollectionViewCell) {
        guard let tag = cell.tagLabel.text else { return }
        
        if !selectedTags.contains(tag) {
            // didSelectItem
            cell.tagLabel.textColor = .white
            cell.backgroundColor = .systemBlue
            selectedTags.append(tag)
        } else {
            // didDeselectItem
            cell.tagLabel.textColor = .label
            cell.backgroundColor = .secondarySystemBackground
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
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "recruitmentTagCategory", for: indexPath) as? RecruitmentSelectionTableViewCell,
            let collectionView = cell.getCollectionView() as? TagCollectionView,
            let category = RecruitmentStore.Category(rawValue: indexPath.section)
        else {
            return UITableViewCell()
        }
        
        let tags = recruitmentStore.tagsOfCategory(category)
        collectionViewTags.updateValue(tags, forKey: collectionView)
        collectionViewIndexPaths.updateValue(indexPath, forKey: collectionView)
        
//        collectionView.collectionViewLayout = RecruitmentTagCloudLayout(data: collectionViewTags[collectionView] ?? [], computeCellSize: self.computeItemSize(_:))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.didLayoutAction = updateRowHeight

        return cell
    }
}

// MARK: - Table View Delegate
extension RecruitmentTagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        var configuration = header?.defaultContentConfiguration()
        configuration?.text = self.tableView(tableView, titleForHeaderInSection: section)
        configuration?.textProperties.color = .label
        
        var backgroundConfiguration = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfiguration.backgroundColor = .systemBackground
        
        header?.contentConfiguration = configuration
        header?.backgroundConfiguration = backgroundConfiguration
        return header
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentTag", for: indexPath) as? TagCloudCollectionViewCell,
              let tags = collectionViewTags[collectionView]
        else { return UICollectionViewCell() }
        
        cell.layer.cornerRadius = 6
        cell.tagLabel.textColor = .label
        cell.backgroundColor = .secondarySystemBackground
        
        let tag = tags[indexPath.item]
        cell.tagLabel.text = tag
        // restore selected cell
        guard let index = selectedTags.firstIndex(of: tag) else { return cell }
        selectedTags.remove(at: index)
        // necessary to enable the deselection, see https://stackoverflow.com/a/31387259
        cell.isSelected = true
        toggleSelected(for: cell)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return selectedTags.count < maximumSelectedTagsCount
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCloudCollectionViewCell else { return }

        toggleSelected(for: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagCloudCollectionViewCell else { return }
        
        toggleSelected(for: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let tags = collectionViewTags[collectionView] else { return .zero }
        
        let tag = tags[indexPath.item]
        return computeItemSize(tag)
    }
}
