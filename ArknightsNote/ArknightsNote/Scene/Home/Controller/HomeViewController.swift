//
//  HomeViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Combine
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    private var messages: [Message]?
    private var cancellable: AnyCancellable?
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let lastUpdateDate = UserDefaults.standard.value(forKey: "lastUpdateDate") as? Date

        let refreshControl = UIRefreshControl()
        updateRefreshControlTitle(with: lastUpdateDate, for: refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // subscribe to the message cache
        cancellable = MessageStore.shared.messageCache.$elements
            .dropFirst()
            .sink(receiveValue: { value in
                self.render(with: value)
            })
        refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // cancel the subscription to message cache
        cancellable = nil
    }

    // MARK: - Updating Appearance

    func render(with value: [Message]) {
        DispatchQueue.main.async {
            self.messages = value
            self.updateRefreshControlTitle(with: value.first?.date)

            self.tableView.reloadData()
            // do not animate table view changes
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            // update refresh control
            if let refreshControl = self.tableView.refreshControl {
                refreshControl.endRefreshing()
                // fix the problem that the content of table view
                // appears underneath the navigation title
                let top = self.tableView.adjustedContentInset.top
                self.tableView.setContentOffset(CGPoint(x: 0, y: -top), animated: false)
            }
        }
    }

    func updateRefreshControlTitle(with lastUpdateDate: Date?, for control: UIRefreshControl? = nil) {
        var refreshControl = tableView.refreshControl
        if control != nil {
            refreshControl = control
        }

        guard let lastUpdateDate = lastUpdateDate else {
            let text = NSLocalizedString(
                "Last update: unknown",
                comment: "Text of unknown last update date in home screen"
            )
            refreshControl?.attributedTitle = NSAttributedString(string: text)
            return
        }

        UserDefaults.standard.set(lastUpdateDate, forKey: "lastUpdateDate")
        refreshControl?.attributedTitle = NSAttributedString(string: formatLastUpdateDate(lastUpdateDate))
    }

    // MARK: - Format

    func formatLastUpdateDate(_ date: Date) -> String {
        let seconds = date.distance(to: Date())
        let days = seconds / 86400.0
        var text: String
        if days < 1.0 {
            let hours = seconds / 3600.0
            let hoursAgoText = NSLocalizedString("%.1f hours ago", comment: "Hours ago template text in home screen")
            text = String(format: hoursAgoText, hours)
        } else {
            let daysAgoText = NSLocalizedString("%d days ago", comment: "Days ago template text in home screen")
            text = String(format: daysAgoText, Int(days))
        }

        let lastUpdateText = NSLocalizedString("Last update: %@", comment: "Last update template text in home screen")
        return String(format: lastUpdateText, text)
    }

    // MARK: - Actions

    @objc func openDetailURL(sender: UIButton) {
        let selectedRow = sender.tag
        guard let message = messages?[selectedRow], let detailURL = URL(string: message.detailLink) else {
            return
        }

        UIApplication.shared.open(detailURL, options: [:])
    }

    @objc func refresh() {
        tableView.refreshControl?.beginRefreshing()
        MessageStore.shared.fetchMessages(of: .weibo, for: Defaults.UID.Weibo.arknights)
    }
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return messages?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)

        guard let messages = messages else {
            return cell
        }

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
