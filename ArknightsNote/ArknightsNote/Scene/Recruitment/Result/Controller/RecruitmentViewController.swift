//
//  RecruitmentTableViewController.swift
//  RecruitmentTableViewController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import UIKit

class RecruitmentViewController: UIViewController {
    
    struct Section {
        let name: String
        let numberOfRows: Int?
        let cellIdentifier: String?
    }
    
    enum State {
        case initial
        case showResults
    }
    
    @IBOutlet weak var tableView: UITableView!
    weak var collectionView: UICollectionView!

    private var state: State = .initial
    private var selectedTags: [String] = [] {
        didSet {
            self.state = self.selectedTags.count == 0 ? .initial : .showResults
//            DispatchQueue.main.async {
//                self.tableView.beginUpdates()
//                self.state = self.selectedTags.count == 0 ? .initial : .showResults
//                self.tableView.endUpdates()
//            }
        }
    }
    
    private let logicController = RecruitmentLogicController()
    private let recruitmentStore = RecruitmentStore()
    private var recruitmentResults = [[String]: [Character]]()
    private var recruitmentResultTags = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

        if #available(iOS 15, *) {} else {
            preventLargeTitleCollapsing()
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
    
    // See https://stackoverflow.com/a/66504612
    private func preventLargeTitleCollapsing() {
        let dummyView = UIView()
        view.addSubview(dummyView)
        view.sendSubviewToBack(dummyView)
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
    func sections(for state: State) -> [Section] {
        switch state {
        case .initial:
            return [Section(name: "招募结果", numberOfRows: nil, cellIdentifier: "recruitmentResultRow")]
        case .showResults:
            return [Section(name: "招募需求", numberOfRows: 1, cellIdentifier: "displaySelectedTags"), Section(name: "招募结果", numberOfRows: nil, cellIdentifier: "recruitmentResultRow")]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections(for: state).count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections(for: state).count > section else { return 0 }
        
        return sections(for: state)[section].numberOfRows ?? recruitmentResults.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellIdentifier = sections(for: state)[indexPath.section].cellIdentifier else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch cellIdentifier {
        case "displaySelectedTags":
            guard let cell = cell as? RecruitmentResultTableViewCell,
                  let collectionView = cell.collectionView as? TagCollectionView
            else { return cell }
            
            collectionView.didLayoutAction = updateRowHeight
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()

            self.collectionView = collectionView
        case "recruitmentResultRow":
            let resultTags = recruitmentResultTags[indexPath.row]
            let resultChars = recruitmentResults[resultTags]
            cell.textLabel?.text = resultTags.joined(separator: ", ")
            cell.detailTextLabel?.text = (resultChars?.map { $0.name })?.joined(separator: ", ")
        default:
            fatalError("tableView(_:willDisplay:forRowAt:) - Unknown cell identifier")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections(for: state)[section].name
    }
}

// MARK: - Table View Delegate
extension RecruitmentViewController: UITableViewDelegate {
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

extension RecruitmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentTag", for: indexPath) as! TagCloudCollectionViewCell
        guard indexPath.item < selectedTags.count else { return cell }

        cell.layer.cornerRadius = 6
        cell.backgroundColor = .systemBlue
        cell.tagLabel.textColor = .white
        cell.tagLabel.text = selectedTags[indexPath.item]

        return cell
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
