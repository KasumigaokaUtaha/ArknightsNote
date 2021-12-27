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

    @IBOutlet var tableView: UITableView!
    weak var collectionView: UICollectionView!

    /// The sum of offset of status bar and navigation bar with large title
    var topOffset: CGFloat = .init(0.0)

    private var state: State = .initial
    private var selectedTags: [String] = [] {
        didSet {
            state = selectedTags.count == 0 ? .initial : .showResults
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // always show whole content of the table view
        tableView.setContentOffset(.init(x: 0, y: topOffset), animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let top = tableView.adjustedContentInset.top
        topOffset = min(topOffset, -top)
    }

    // MARK: - Actions

    func setSelectedTags(_ tags: [String]) {
        selectedTags = tags

        DispatchQueue.global().async {
            var results = [[String]: [Character]]()
            for (key, value) in self.logicController.computeCharactersWith(tags: tags) {
                results.updateValue(
                    self.sortedCharacters(value),
                    forKey: key.sorted(by: { $0 <= $1 })
                )
            }
            self.recruitmentResults = results
            self.recruitmentResultTags = self.sortedTags(results.keys.map { $0 })
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
        chars.sorted(by: { $0.rarity >= $1.rarity })
    }

    private func sortedTags(_ tags: [[String]]) -> [[String]] {
        tags.sorted(by: {
            let maxTagRarityInFirst = $0.filter { recruitmentStore.tagsOfCategory(.seniority).contains($0) }
                .map(\.count).max()
            let maxTagRarityInSecond = $1.filter { recruitmentStore.tagsOfCategory(.seniority).contains($0) }
                .map(\.count).max()
            if maxTagRarityInFirst != nil, maxTagRarityInSecond == nil {
                return true
            } else if maxTagRarityInFirst == nil, maxTagRarityInSecond != nil {
                return false
            } else if maxTagRarityInFirst != nil, maxTagRarityInSecond != nil {
                return maxTagRarityInFirst! >= maxTagRarityInSecond!
            }
            if $0.count != $1.count {
                let less: [String] = $0.count < $1.count ? $0 : $1
                let more: [String] = $0.count < $1.count ? $1 : $0
                let maxRarityInLess = recruitmentResults[less]!.map(\.rarity).max()!
                let maxRarityInMore = recruitmentResults[more]!.map(\.rarity).max()!
                return maxRarityInLess >= maxRarityInMore
            } else {
                let maxRarityInFirst = recruitmentResults[$0]!.map(\.rarity).max()!
                let maxRarityInSecond = recruitmentResults[$1]!.map(\.rarity).max()!
                return maxRarityInFirst >= maxRarityInSecond
            }
        }).map {
            $0.sorted(by: {
                $0 <= $1
            })
        }
    }
}

// MARK: UITableViewDataSource

extension RecruitmentViewController: UITableViewDataSource {
    func sections(for state: State) -> [Section] {
        let recruitmentResultSectionName = NSLocalizedString("Recruitment Result", comment: "recruitment result")
        let recruitmentRequirementSectionName = NSLocalizedString(
            "Recruitment Requirement",
            comment: "recruitment requirement"
        )

        switch state {
        case .initial:
            return [Section(
                name: recruitmentResultSectionName,
                numberOfRows: nil,
                cellIdentifier: "recruitmentResultRow"
            )]
        case .showResults:
            return [
                Section(
                    name: recruitmentRequirementSectionName,
                    numberOfRows: 1,
                    cellIdentifier: "displaySelectedTags"
                ),
                Section(name: recruitmentResultSectionName, numberOfRows: nil, cellIdentifier: "recruitmentResultRow")
            ]
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        sections(for: state).count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections(for: state).count > section else {
            return 0
        }

        return sections(for: state)[section].numberOfRows ?? recruitmentResults.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellIdentifier = sections(for: state)[indexPath.section].cellIdentifier
        else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch cellIdentifier {
        case "displaySelectedTags":
            guard let cell = cell as? RecruitmentResultTableViewCell,
                  let collectionView = cell.collectionView as? TagCloudCollectionView
            else {
                return cell
            }

            collectionView.didLayoutAction = updateRowHeight
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()

            self.collectionView = collectionView
        case "recruitmentResultRow":
            let resultTags = recruitmentResultTags[indexPath.row]
            let resultChars = recruitmentResults[resultTags]
            cell.textLabel?.text = resultTags.joined(separator: ", ")
            cell.detailTextLabel?.text = (resultChars?.map(\.name))?.joined(separator: ", ")
        default:
            fatalError("tableView(_:willDisplay:forRowAt:) - Unknown cell identifier")
        }

        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections(for: state)[section].name
    }
}

// MARK: UITableViewDelegate

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

// MARK: UICollectionViewDataSource

extension RecruitmentViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        selectedTags.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            indexPath.item < selectedTags.count,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "recruitmentTag",
                for: indexPath
            ) as? TagCloudCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 6
        cell.backgroundColor = .systemBlue
        cell.tagLabel.textColor = .white
        cell.tagLabel.text = selectedTags[indexPath.item]

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RecruitmentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard indexPath.item < selectedTags.count else {
            return .zero
        }

        return computeItemSize(selectedTags[indexPath.item])
    }
}

extension RecruitmentViewController {
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        switch segue.identifier {
        case "chooseRecruitmentTags":
            guard let destination = segue.destination as? RecruitmentTagViewController else {
                return
            }

            destination.configure(recruitmentStore: recruitmentStore, selectedTags: selectedTags)
            destination.viewWillDisappearAction = { data in
                self.setSelectedTags(data)
            }
        default:
            preconditionFailure("Unknown segue identifier: \(String(describing: segue.identifier))")
        }
    }
}
