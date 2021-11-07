//
//  HomeViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var progressView: UIActivityIndicatorView!
    
    private var lastUpdateDate: Date! {
        didSet {
            guard let lastUpdateDate = lastUpdateDate else { return }
            let seconds = lastUpdateDate.distance(to: Date())
            let days = seconds / 86400.0
            lastUpdateLabel.text = String(format: "距离鹰角上一次更新已经 %.2f 天了", days)
        }
    }
    private var messages: [Message]?
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        progressView = UIActivityIndicatorView()
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        MessageStore.shared.fetchMessages(of: .Weibo, for: Defaults.UID.Weibo.arknights) {
            if let messages = $0 {
                DispatchQueue.main.async {
                    let dates = messages.compactMap({ $0.date }).sorted(by: { $0 < $1 })
                    if let lastUpdateDate = dates.last {
                        self.lastUpdateDate = lastUpdateDate
                    }
                    self.messages = messages
                    self.progressView.stopAnimating()
                    self.progressView.removeFromSuperview()
                    self.tableView.reloadData()
                    // animating table view changes
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            } else {
                print("fetch messages failed")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressView.startAnimating()
    }

}

// MARK: - UITableView Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return messages?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)

        guard let messages = messages else { return cell }

        if let cell = cell as? HomeMessageCell {
            let message = messages[indexPath.row]
            cell.profileImage.image = UIImage(data: message.profile)
            cell.contentLabel.text = message.content
            cell.platformLabel.text = message.platform
            cell.publisherLabel.text = message.username
            if let date = message.date {
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
        }
        
        return cell
    }
}
