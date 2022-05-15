//
//  GachaReportImportPageView.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

class GachaReportImportPageView: UIView {
    var bar: UIView!

    var titleLabel: UILabel?
    var detailLabel: UILabel?
    var tokenTextView: UITextView?

    var actionButton: UIButton?
    var nextStepButton: UIButton?

    private var origin: CGPoint!

    private var panGestureRecognizer: UIPanGestureRecognizer

    private var page: GachaReportImportPage?

    init(for page: GachaReportImportPage) {
        self.page = page
        panGestureRecognizer = UIPanGestureRecognizer()

        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        bar = UIView()
        bar.layer.cornerRadius = 4
        bar.backgroundColor = .separator
        addSubview(bar)

        bar.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture))

        guard let page = page else {
            return
        }

        titleLabel = UILabel()
        addSubview(titleLabel!)

        actionButton = ANButton()
        addSubview(actionButton!)

        switch page {
        case .fetch,
             .login:
            detailLabel = UILabel()
            addSubview(detailLabel!)

            nextStepButton = ANButton()
            addSubview(nextStepButton!)
        case .paste:
            tokenTextView = UITextView()
            addSubview(tokenTextView!)
        }

        configureLayout()
    }

    func configureLayout() {
        guard let page = page else {
            return
        }

        bar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        actionButton?.translatesAutoresizingMaskIntoConstraints = false
        detailLabel?.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton?.translatesAutoresizingMaskIntoConstraints = false
        tokenTextView?.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bar.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),
            bar.heightAnchor.constraint(equalToConstant: 6),
            bar.centerXAnchor.constraint(equalTo: centerXAnchor),
            bar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            titleLabel!.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel!.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 8),
            actionButton!.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton!.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
        ])

        switch page {
        case .fetch,
             .login:
            NSLayoutConstraint.activate([
                detailLabel!.centerXAnchor.constraint(equalTo: centerXAnchor),
                detailLabel!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 10),
                detailLabel!.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
                actionButton!.bottomAnchor.constraint(equalTo: nextStepButton!.topAnchor, constant: -8),
                nextStepButton!.centerXAnchor.constraint(equalTo: centerXAnchor),
                nextStepButton!.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
                nextStepButton!.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
            ])
        case .paste:
            NSLayoutConstraint.activate([
                tokenTextView!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 10),
                tokenTextView!.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
                tokenTextView!.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
                tokenTextView!.centerXAnchor.constraint(equalTo: centerXAnchor),
                actionButton!.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        origin = frame.origin
    }

    @objc private func handlePanGesture() {
        let translation = panGestureRecognizer.translation(in: self)

        guard translation.y >= 0 else {
            return
        }

        frame.origin.y = origin.y + translation.y

        if panGestureRecognizer.state == .ended {
            if translation.y <= bounds.height {
                frame.origin = origin
            }
        }
    }
}
