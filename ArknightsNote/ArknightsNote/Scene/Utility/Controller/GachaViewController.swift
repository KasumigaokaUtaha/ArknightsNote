//
//  GatchaViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 02.05.22.
//

import UIKit

class GachaViewController: UIViewController {
    let pages: [GachaReportImportPage] = [.login, .fetch, .paste]

    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gachaImportButton = UIButton()
        gachaImportButton.setImage(UIImage(named: "plus.circle.dashed"), for: .normal)
        gachaImportButton.addTarget(self, action: #selector(importGachaReports), for: .primaryActionTriggered)

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

    @objc func importGachaReports() {
        pageViewController = ANPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.modalPresentationStyle = .custom
        pageViewController.transitioningDelegate = self

        pageViewController.setViewControllers(
            [GachaReportImportPageViewController(for: .login)],
            direction: .forward,
            animated: true
        )

        present(pageViewController, animated: true)
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

// MARK: UIPageViewControllerDataSource

extension GachaViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let importPageViewController = viewController as? GachaReportImportPageViewController,
            let page = importPageViewController.page,
            let index = pages.firstIndex(of: page),
            index - 1 >= 0
        else {
            return nil
        }

        let prevPage = pages[index - 1]
        return GachaReportImportPageViewController(for: prevPage)
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let importPageViewController = viewController as? GachaReportImportPageViewController,
            let page = importPageViewController.page,
            let index = pages.firstIndex(of: page),
            index + 1 < pages.count
        else {
            return nil
        }

        let nextPage = pages[index + 1]
        return GachaReportImportPageViewController(for: nextPage)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard self.pageViewController === pageViewController else {
            return 0
        }

        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            self.pageViewController === pageViewController,
            let viewControllers = pageViewController.viewControllers,
            let importPageViewController = viewControllers[0] as? GachaReportImportPageViewController,
            let page = importPageViewController.page,
            let index = pages.firstIndex(of: page)
        else {
            return 0
        }

        return index
    }
}
