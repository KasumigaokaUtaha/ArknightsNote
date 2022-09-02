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
    private var keyboardOffset: CGFloat?

    init(for page: GachaHistoryImportPage) {
        self.page = page
        panGestureRecognizer = UIPanGestureRecognizer()
        hasSetOriginPoint = false

        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        deregisterFromKeyboardNotifications()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotifications()

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
        importPageView.tokenTextField.delegate = self
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

    // MARK: - Keyboard Handler

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let info = notification.userInfo,
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey]! as? NSValue)?.cgRectValue.size,
            let keyWindow = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first(where: { $0.isKeyWindow }),
            let rootViewController = keyWindow.rootViewController
        else {
            return
        }

        let rect = importPageView.convert(importPageView.tokenTextField.frame, to: rootViewController.view)
        var offset = rootViewController.view.frame.size.height - (rect.origin.y + rect.size.height)
        offset = keyboardSize.height - offset
        if offset > 0 && keyboardOffset == nil {
            keyboardOffset = offset
            view.frame.origin.y -= offset
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        guard let keyboardOffset = keyboardOffset else {
            return
        }

        view.frame.origin.y += keyboardOffset
        self.keyboardOffset = nil
    }
}

// TODO: request for paste right

// MARK: - UITextFieldDelegate

extension GachaHistoryImportPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
