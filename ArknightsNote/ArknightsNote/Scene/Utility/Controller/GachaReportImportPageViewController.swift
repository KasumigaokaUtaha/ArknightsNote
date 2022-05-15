//
//  GachaReportImportViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

enum GachaReportImportPage {
    case login
    case fetch
    case paste
}

class GachaReportImportPageViewController: UIViewController {
    private(set) var page: GachaReportImportPage?

    init(for page: GachaReportImportPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        guard let page = page else {
            return
        }

        let importPageView = GachaReportImportPageView(for: page)
        importPageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(importPageView)

        NSLayoutConstraint.activate([
            importPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            importPageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            importPageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            importPageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        setup(importPageView)
    }

    func setup(_ pageView: GachaReportImportPageView) {
        guard let page = page else {
            return
        }

        pageView.titleLabel?.numberOfLines = 0
        pageView.titleLabel?.textColor = .label
        pageView.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        pageView.detailLabel?.numberOfLines = 0
        pageView.detailLabel?.textAlignment = .center
        pageView.detailLabel?.textColor = .secondaryLabel
        pageView.detailLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        pageView.actionButton?.setTitleColor(.label, for: .normal)
        pageView.actionButton?.backgroundColor = .systemGray4//.secondarySystemBackground
        pageView.actionButton?.layer.cornerRadius = 8

        pageView.nextStepButton?.setTitleColor(.secondaryLabel, for: .normal)
        pageView.nextStepButton?.backgroundColor = .systemGray4//.secondarySystemBackground
        pageView.nextStepButton?.setTitle("Next", for: .normal)
        pageView.nextStepButton?.layer.cornerRadius = 8
        // TODO: add action to next step button
        
        pageView.tokenTextView?.layer.cornerRadius = 8

        switch page {
        case .login:
            pageView.titleLabel?.text = "Log In"
            pageView.detailLabel?.text = "Log in to your account on the official website to access your gacha history"
            pageView.actionButton?.setTitle("Log in", for: .normal)
        // TODO: add action to action button
        case .fetch:
            pageView.titleLabel?.text = "Fetch Token"
            pageView.detailLabel?.text = "Copy the whole content in the opend web page"
            pageView.actionButton?.setTitle("Fetch", for: .normal)
        // TODO: add action to action button
        case .paste:
            pageView.titleLabel?.text = "Paste Token"

            pageView.tokenTextView?.delegate = self
            pageView.tokenTextView?.text = "Paste your token here"
            pageView.tokenTextView?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            pageView.tokenTextView?.textColor = .placeholderText
            pageView.tokenTextView?.backgroundColor = .secondarySystemBackground

            pageView.actionButton?.setTitle("Analyze", for: .normal)
            // TODO: add action to action button
        }
    }
}

// MARK: UITextViewDelegate

extension GachaReportImportPageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Paste your token here"
            textView.textColor = .placeholderText
        }
    }
}
