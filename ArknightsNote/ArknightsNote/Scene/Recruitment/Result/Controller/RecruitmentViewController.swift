//
//  RecruitmentTableViewController.swift
//  RecruitmentTableViewController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import UIKit

class RecruitmentViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case presentChosenTags
        case recruitmentResults
    }
    
    @IBOutlet weak var tableView: UITableView!
    weak var collectionView: UICollectionView!

    private var numberOfSections: Int {
        Section.allCases.count
    }
    private let logicController = RecruitmentLogicController()
    private let recruitmentStore = RecruitmentStore()
    private var selectedTags: [String] = []
    private var recruitmentResults = [[String]: [Character]]()
    private var recruitmentResultTags = [[String]]()
//    private var recruitmentChars: [Character] {
//        recruitmentResults.values.flatMap { $0 }
//    }

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Internal
    func numberOfRows(in section: Int) -> Int {
        switch Section(rawValue: section) {
        case .presentChosenTags:
            return 1
        case .recruitmentResults:
            return recruitmentResults.keys.count
//            return recruitmentChars.count
        case .none:
            fatalError("Invalid section")
        }
    }

    // MARK: - Actions
    func setSelectedTags(_ tags: [String]) {
        selectedTags = tags
        
        DispatchQueue.global().async {
            var results = [[String] : [Character]]()
            for (key, value) in self.logicController.computeCharactersWith(tags: tags) {
                results.updateValue(
                    self.sortedCharacters(value),
                    forKey: key.sorted(by: { $0 <= $1 })
                )
            }
            self.recruitmentResults = results
            self.recruitmentResultTags = self.sortedTags(results.keys.map({ $0 }))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Layout Actions
    private func updateRowHeight() {
        DispatchQueue.main.async {
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
    private func sortedCharacters(_ chars: [Character]) -> [Character] {
        return chars.sorted(by: { $0.rarity >= $1.rarity })
    }
    
    private func sortedTags(_ tags: [[String]]) -> [[String]] {
        return tags.sorted(by: {
            let maxTagRarityInFirst = $0.filter({ recruitmentStore.tagsOfCategory(.seniority).contains($0) }).map({ $0.count }).max()
            let maxTagRarityInSecond = $1.filter({ recruitmentStore.tagsOfCategory(.seniority).contains($0) }).map({ $0.count }).max()
            if maxTagRarityInFirst != nil && maxTagRarityInSecond == nil {
                return true
            } else if maxTagRarityInFirst == nil && maxTagRarityInSecond != nil {
                return false
            } else if maxTagRarityInFirst != nil && maxTagRarityInSecond != nil {
                return maxTagRarityInFirst! >= maxTagRarityInSecond!
            }
            if $0.count != $1.count {
                let less: [String] = $0.count < $1.count ? $0 : $1
                let more: [String] = $0.count < $1.count ? $1 : $0
                let maxRarityInLess = recruitmentResults[less]!.map({ $0.rarity }).max()!
                let maxRarityInMore = recruitmentResults[more]!.map({ $0.rarity }).max()!
                return maxRarityInLess >= maxRarityInMore
            } else {
                let maxRarityInFirst = recruitmentResults[$0]!.map({ $0.rarity }).max()!
                let maxRarityInSecond = recruitmentResults[$1]!.map({ $0.rarity }).max()!
                return maxRarityInFirst >= maxRarityInSecond
            }
        }).map {
            $0.sorted(by: {
                $0 <= $1
            })
        }
    }

}

// MARK: - Table View Data Source
extension RecruitmentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .presentChosenTags:
            return "招募需求"
        case .recruitmentResults:
            return "招募结果"
        case .none:
            fatalError("Invalid section")
        }
    }
}

// MARK: - Table View Delegate
extension RecruitmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .presentChosenTags:
            return tableView.dequeueReusableCell(withIdentifier: "displaySelectedTags", for: indexPath)
        case .recruitmentResults:
            let resultCell = tableView.dequeueReusableCell(withIdentifier: "recruitmentResultRow", for: indexPath)
//            resultCell.textLabel?.text = recruitmentChars[indexPath.row].name
//            resultCell.detailTextLabel?.text = String(describing: recruitmentChars[indexPath.row].rarity)
            let resultTags = recruitmentResultTags[indexPath.row]
            resultCell.textLabel?.text = resultTags.joined(separator: ", ")
            let resultChars = recruitmentResults[resultTags]
            resultCell.detailTextLabel?.text = (resultChars?.map { $0.name })?.joined(separator: ", ")
            return resultCell
        case .none:
            fatalError("Invalid section")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RecruitmentResultTableViewCell,
              let collectionView = cell.collectionView as? RecruitmentTagCollectionView
        else { return }
        
        collectionView.didLayoutAction = updateRowHeight
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        cell.layoutIfNeeded()
        self.collectionView = collectionView
    }
}

extension RecruitmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentTag", for: indexPath) as! RecruitmentTagCloudCollectionViewCell
        
        cell.backgroundColor = .systemBlue
        cell.tagLabel.textColor = .white
        cell.layer.cornerRadius = 6
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RecruitmentTagCloudCollectionViewCell,
              indexPath.item < selectedTags.count
        else { return }
        
        cell.tagLabel.text = selectedTags[indexPath.item]
    }
}

extension RecruitmentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < selectedTags.count else { return .zero }
        
        return computeItemSize(selectedTags[indexPath.item])
    }
}

extension RecruitmentViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseRecruitmentTags":
            guard let destination = segue.destination as? RecruitmentTagViewController else { return }
            
            destination.configure(recruitmentStore: recruitmentStore, selectedTags: selectedTags)
            destination.viewWillDisappearAction = { data in
                self.setSelectedTags(data)
            }
        default:
            preconditionFailure("Unknown segue identifier: \(String(describing: segue.identifier))")
        }
    }
}
