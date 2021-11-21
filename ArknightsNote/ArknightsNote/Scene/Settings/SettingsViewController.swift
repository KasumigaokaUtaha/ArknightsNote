//
//  SettingsViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 12.11.21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let removeMessagesAlert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to remove all messages", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove Messages", style: .destructive, handler: {_ in
            do {
                MessageStore.shared.messageCache.removeAll()
                try FileHelper.delete(from: .documentDirectory, fileName: Defaults.Cache.Message.rawValue)
                logger.info("Removed cached messages", metadata: nil, source: "\(#file).\(#function)")
            } catch {
                logger.debug("\(error.localizedDescription)", metadata: nil, source: "\(#file).\(#function)")
            }
        }))
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITabelView Data Source
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            configuration.text = "Remove Messages"
            configuration.textProperties.color = .red
            configuration.image = UIImage(systemName: "trash")
            configuration.imageProperties.tintColor = .red
        case (1, 0):
            configuration.text = "About"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        cell.contentConfiguration = configuration
        return cell
    }
}

// MARK: - TableView Delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 && indexPath.row == 0 {
            // Present an alert view
            self.present(removeMessagesAlert, animated: true, completion: nil)
        }
    }
}
