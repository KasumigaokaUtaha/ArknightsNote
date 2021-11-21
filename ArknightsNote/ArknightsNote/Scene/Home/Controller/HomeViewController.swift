//
//  HomeViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var messages: [Message]?
    private var cancellable: AnyCancellable?
    private var lastUpdateDate: Date? {
        didSet {
            guard let lastUpdateDate = lastUpdateDate else {
                lastUpdateLabel.text = "距离鹰角上一次更新已经 ?? 天了"
                return
            }
            UserDefaults.standard.set(lastUpdateDate, forKey: "lastUpdateDate")
            let seconds = lastUpdateDate.distance(to: Date())
            let days = seconds / 86400.0
            lastUpdateLabel.text = String(format: "距离鹰角上一次更新已经 %.2f 天了", days)
        }
    }
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // subscribe to the message cache
        self.cancellable = MessageStore.shared.messageCache.$elements.sink(receiveValue: { value in
            self.render(with: value)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // cancel the subscription to message cache
        self.cancellable = nil
    }
    
    @objc func refresh() {
        MessageStore.shared.fetchMessages(of: .Weibo, for: Defaults.UID.Weibo.arknights)
    }
    
    func render(with value: [Message]) {
        DispatchQueue.main.async {
            self.messages = value
            self.lastUpdateDate = value.first?.date

            self.tableView.reloadData()
            // do not animate table view changes
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            // update refresh control
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Actions
    @objc func openDetailURL(sender: UIButton) {
        let selectedRow = sender.tag
        guard let message = self.messages?[selectedRow], let detailURL = URL(string: message.detailLink) else { return }

        UIApplication.shared.open(detailURL, options: [:])
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
            cell.dateLabel.text = dateFormatter.string(from: message.date)
            cell.moreButton.tag = indexPath.row
            cell.moreButton.addTarget(self, action: #selector(openDetailURL(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
}
