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
        let alertMessage = NSLocalizedString("Are you sure you want to remove all messages", comment: "Alert message in settings screen")
        let cancelActionTitle = NSLocalizedString("Cancel", comment: "Title of cancel action in settings screen")
        let removeActionTitle = NSLocalizedString("Remove", comment: "Title of remove action in settings screen")

        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: removeActionTitle, style: .destructive, handler: {_ in
            do {
                MessageStore.shared.messageCache.removeAll()
                try FileHelper.delete(from: .documentDirectory, fileName: Defaults.Cache.Message.rawValue)
                logger.info("Removed cached messages", metadata: nil, source: "\(#file).\(#function)")
            } catch {
                logger.debug("\(error)", metadata: nil, source: "\(#file).\(#function)")
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
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()

        switch indexPath.row {
        case 0:
            let cellText = NSLocalizedString("Remove Messages", comment: "Text of remove messages option in settings screen")
            configuration.text = cellText
            configuration.textProperties.color = .red
            configuration.image = UIImage(systemName: "trash")
            configuration.imageProperties.tintColor = .red
        case 1:
            let cellText = NSLocalizedString("About", comment: "Text of about option in settings screen")
            configuration.text = cellText
            configuration.image = UIImage(systemName: "exclamationmark.circle")
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
