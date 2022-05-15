//
//  GachaReportImportViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

enum GachaHistoryImportPage {
    case login
    case fetch
    case paste
}

class GachaHistoryImportPageViewController: UIViewController {
    private(set) var page: GachaHistoryImportPage? {
        didSet {
            guard let page = page else {
                return
            }

            importPageView.removeFromSuperview()
            loadImportPageView(for: page)
            setup(for: page)
        }
    }

    private var importPageView: GachaHistoryImportPageView!

    private var panGestureRecognizer: UIPanGestureRecognizer

    private var hasSetOriginPoint: Bool
    private var originPoint: CGPoint?

    init(for page: GachaHistoryImportPage) {
        self.page = page
        panGestureRecognizer = UIPanGestureRecognizer()
        hasSetOriginPoint = false

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(dismissController))

        guard let page = page else {
            return
        }

        loadImportPageView(for: page)
        setup(for: page)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasSetOriginPoint {
            hasSetOriginPoint = true
            originPoint = view.frame.origin
        }
    }

    // MARK: - Setup

    func loadImportPageView(for page: GachaHistoryImportPage) {
        importPageView = GachaHistoryImportPageView(for: page)
        importPageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(importPageView)
    }

    func setup(for page: GachaHistoryImportPage) {
        importPageView.titleLabel?.numberOfLines = 0
        importPageView.titleLabel?.textColor = .label
        importPageView.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        importPageView.detailLabel?.numberOfLines = 0
        importPageView.detailLabel?.textAlignment = .center
        importPageView.detailLabel?.textColor = .secondaryLabel
        importPageView.detailLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        importPageView.actionButton?.setTitleColor(.label, for: .normal)
        importPageView.actionButton?.backgroundColor = .systemGray4 // .secondarySystemBackground
        importPageView.actionButton?.layer.cornerRadius = 8

        importPageView.nextStepButton?.setTitleColor(.secondaryLabel, for: .normal)
        importPageView.nextStepButton?.backgroundColor = .systemGray4 // .secondarySystemBackground
        importPageView.nextStepButton?.setTitle("Next", for: .normal)
        importPageView.nextStepButton?.layer.cornerRadius = 8
        importPageView.nextStepButton?.addTarget(self, action: #selector(handleNextStepButton), for: .touchUpInside)

        importPageView.tokenTextView?.layer.cornerRadius = 8

        switch page {
        case .login:
            importPageView.titleLabel?.text = "Log In"
            importPageView.detailLabel?
                .text = "Log in to your account on the official website to access your gacha history"
            importPageView.actionButton?.setTitle("Log in", for: .normal)
        // TODO: add action to action button
        case .fetch:
            importPageView.titleLabel?.text = "Fetch Token"
            importPageView.detailLabel?.text = "Copy the whole content in the opend web page"
            importPageView.actionButton?.setTitle("Fetch", for: .normal)
        // TODO: add action to action button
        case .paste:
            importPageView.titleLabel?.text = "Paste Token"

            importPageView.tokenTextView?.delegate = self
            importPageView.tokenTextView?.text = "Paste your token here"
            importPageView.tokenTextView?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            importPageView.tokenTextView?.textColor = .placeholderText
            importPageView.tokenTextView?.backgroundColor = .secondarySystemBackground

            importPageView.actionButton?.setTitle("Analyze", for: .normal)
            // TODO: add action to action button
        }

        configureConstraints()
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            importPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            importPageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            importPageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            importPageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc func handleNextStepButton() {
        if page == .login {
            page = .fetch
        } else if page == .fetch {
            page = .paste
        }
    }

    @objc func dismissController(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        guard translation.y >= 0, let originPoint = originPoint else {
            return
        }

        view.frame.origin.y = originPoint.y + translation.y

        if sender.state == .ended {
            if translation.y > view.bounds.height * 0.5 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.view.frame.origin = originPoint
                }
            }
        }
    }
}

// MARK: UITextViewDelegate

extension GachaHistoryImportPageViewController: UITextViewDelegate {
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
