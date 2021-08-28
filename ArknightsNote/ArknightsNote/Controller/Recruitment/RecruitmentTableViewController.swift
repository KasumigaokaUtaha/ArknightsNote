//
//  RecruitmentTableViewController.swift
//  RecruitmentTableViewController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import UIKit

class RecruitmentTableViewController: UITableViewController {
    
    enum Section: Int, CaseIterable {
        case selectTags
        case presentChosenTags
        case recruitmentResults
    }

    private var numberOfSections: Int {
        Section.allCases.count
    }
    private let logicController = RecruitmentLogicController()
    private let recruitmentStore = RecruitmentStore()
    private var selectedTags: [String]! = nil
    private var recruitmentResults = [[String]: [Character]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Internal
    func numberOfRows(in section: Int) -> Int {
        switch Section(rawValue: section) {
        case .selectTags:
            return 1
        case .presentChosenTags:
            return 1
        case .recruitmentResults:
            return recruitmentResults.keys.count
        case .none:
            fatalError("Invalid section")
        }
    }

    // MARK: - Actions
    func setSelectedTags(_ tags: [String]) {
        selectedTags = tags
        
        DispatchQueue.global().async {
            self.recruitmentResults = self.logicController.computeCharactersWithCombinationsOf(tags: tags)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - Table View Data Source & Delegate
extension RecruitmentTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .selectTags:
            return tableView.dequeueReusableCell(withIdentifier: "selectRecruitmentTags", for: indexPath)
        case .presentChosenTags:
            return tableView.dequeueReusableCell(withIdentifier: "displaySelectedTags", for: indexPath)
        case .recruitmentResults:
            return tableView.dequeueReusableCell(withIdentifier: "recruitmentResultRow", for: indexPath)
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
            
            destination.configure(recruitmentStore: recruitmentStore)
        default:
            preconditionFailure("Unknown segue identifier: \(String(describing: segue.identifier))")
        }
    }
}
