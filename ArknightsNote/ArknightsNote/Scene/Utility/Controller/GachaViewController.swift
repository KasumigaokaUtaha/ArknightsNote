//
//  GatchaViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 02.05.22.
//

import UIKit

class GachaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setup() {
        let gachaImportButton = UIButton()
        gachaImportButton.setImage(UIImage(named: "plus.circle.dashed"), for: .normal)
        gachaImportButton.addTarget(self, action: #selector(importGachaHistory), for: .primaryActionTriggered)

        let gachaImportTitleLabel = UILabel()
        gachaImportTitleLabel.numberOfLines = 0
        gachaImportTitleLabel.text = "Import gacha Logs"
        gachaImportTitleLabel.textColor = UIColor.label
        gachaImportTitleLabel.textAlignment = .center
        gachaImportTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        let gachaImportHintLabel = UILabel()
        gachaImportHintLabel.numberOfLines = 0
        gachaImportHintLabel.text = "It looks like you haven't imported any gacha record yet"
        gachaImportHintLabel.textColor = UIColor.secondaryLabel
        gachaImportHintLabel.textAlignment = .center
        gachaImportHintLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        let stackView = UIStackView(arrangedSubviews: [gachaImportButton, gachaImportTitleLabel, gachaImportHintLabel])
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4)
        ])
    }

    @objc func importGachaHistory() {
        let importPageViewController = GachaHistoryImportPageViewController(for: .login)
        importPageViewController.modalPresentationStyle = .custom
        importPageViewController.transitioningDelegate = self

        present(importPageViewController, animated: true)
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension GachaViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source _: UIViewController
    ) -> UIPresentationController? {
        CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
