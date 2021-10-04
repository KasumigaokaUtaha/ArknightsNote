//
//  RecruitmentTableViewController.swift
//  RecruitmentTableViewController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import UIKit

class RecruitmentTableViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case presentChosenTags
        case recruitmentResults
    }
    
    @IBOutlet weak var tableView: UITableView!

    private var numberOfSections: Int {
        Section.allCases.count
    }
    private let logicController = RecruitmentLogicController()
    private let recruitmentStore = RecruitmentStore()
    private var selectedTags: [String] = []
    private var recruitmentResults = [[String]: [Character]]()
    private var recruitmentResultTags: [[String]] {
        return recruitmentResults.keys.map { $0 }
    }
    private var recruitmentChars: [Character] {
        recruitmentResults.values.flatMap { element in
            return element
        }
    }

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
            self.recruitmentResults = self.logicController.computeCharactersWithCombinationsOf(tags: tags)
            print(self.recruitmentResults)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - Table View Data Source
extension RecruitmentTableViewController: UITableViewDataSource {
    
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
extension RecruitmentTableViewController: UITableViewDelegate {
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
}

extension RecruitmentTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseRecruitmentTags":
            guard let destination = segue.destination as? RecruitmentSelectionTableViewController else { return }
            
            destination.configure(recruitmentStore: recruitmentStore, selectedTags: selectedTags)
            destination.viewWillDisappearAction = { data in
                self.setSelectedTags(data)
            }
        default:
            preconditionFailure("Unknown segue identifier: \(String(describing: segue.identifier))")
        }
    }
}
