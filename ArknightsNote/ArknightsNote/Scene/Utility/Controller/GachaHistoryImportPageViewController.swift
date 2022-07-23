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
    private var page: GachaHistoryImportPage
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

        setupImagePageView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !hasSetOriginPoint {
            hasSetOriginPoint = true
            originPoint = view.frame.origin
        }
    }

    func setupImagePageView() {
        importPageView = GachaHistoryImportPageView(for: page)
        importPageView.translatesAutoresizingMaskIntoConstraints = false
        importPageView.tokenTextView.delegate = self
        importPageView.nextStepBlock = { [weak self] in
            guard let self = self else { return }
            guard self.page == .login || self.page == .fetch else { return }

            self.importPageView.removeFromSuperview()
            if self.page == .login {
                self.page = .fetch
            } else {
                self.page = .paste
            }
            self.setupImagePageView()
        }
        importPageView.actionBlock = { [weak self] in
            guard let self = self else { return }
            // TODO: complete action for different cases
            switch self.page {
            case .login:
                print("action block called")
            case .fetch:
                print("action block called")
            case .paste:
                print("action block called")
            }
        }
        view.addSubview(importPageView)
        NSLayoutConstraint.activate([
            importPageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            importPageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            importPageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            importPageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Actions

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

// MARK: - UITextViewDelegate

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
