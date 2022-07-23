//
//  GachaReportImportPageView.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

class GachaHistoryImportPageView: UIView {
    private var bar: UIView!

    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private(set) var tokenTextView: UITextView!
    private var actionButton: UIButton!
    private var nextStepButton: UIButton!
    
    private var origin: CGPoint!
    private var page: GachaHistoryImportPage

    var nextStepBlock: (() -> ())?
    var actionBlock: (() ->())?

    init(for page: GachaHistoryImportPage) {
        self.page = page

        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        origin = frame.origin
    }

    private func setup() {
        // setup subviews
        bar = UIView()
        bar.layer.cornerRadius = 4
        bar.backgroundColor = .separator
        addSubview(bar)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        addSubview(titleLabel)

        detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.textColor = .secondaryLabel
        detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(detailLabel)

        tokenTextView = UITextView()
        tokenTextView.layer.cornerRadius = 8
        addSubview(tokenTextView)
        
        nextStepButton = UIButton(type: .system)
        nextStepButton.setTitleColor(.secondaryLabel, for: .normal)
        nextStepButton.backgroundColor = .systemGray4
        nextStepButton.setTitle("Next", for: .normal)
        nextStepButton.layer.cornerRadius = 8
        nextStepButton.addTarget(self, action: #selector(nextStepButtonClicked), for: .touchUpInside)
        addSubview(nextStepButton)

        actionButton = UIButton(type: .system)
        actionButton.backgroundColor = .systemGray4
        actionButton.layer.cornerRadius = 8
        actionButton.addTarget(self, action: #selector(actionButtonClicked), for: .touchUpInside)
        addSubview(actionButton)
        
        switch page {
        case .login:
            titleLabel.text = "Log In"
            detailLabel.text = "Log in to your account on the official website to access your gacha history"
            actionButton.setTitle("Log in", for: .normal)
            
            tokenTextView.isHidden = true
            // TODO: add action to action button
        case .fetch:
            titleLabel.text = "Fetch Token"
            detailLabel.text = "Copy the whole content in the opened web page"
            actionButton.setTitle("Fetch", for: .normal)
            
            tokenTextView.isHidden = true
            // TODO: add action to action button
        case .paste:
            titleLabel.text = "Paste Token"
//            tokenTextView.delegate = self.delegate
            tokenTextView.text = "Paste your token here"
            tokenTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            tokenTextView.textColor = .placeholderText
            tokenTextView.backgroundColor = .secondarySystemBackground
            actionButton.setTitle("Analyze", for: .normal)
            
            detailLabel.isHidden = true
            nextStepButton.isHidden = true
            // TODO: add action to action button
        }
        
        // layout subviews
        bar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        tokenTextView.translatesAutoresizingMaskIntoConstraints = false
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bar.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),
            bar.heightAnchor.constraint(equalToConstant: 6),
            bar.centerXAnchor.constraint(equalTo: centerXAnchor),
            bar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8)
        ])

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
        ])

        switch page {
        case .login, .fetch:
            NSLayoutConstraint.activate([
                detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                detailLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
                nextStepButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                nextStepButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
                nextStepButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
                actionButton.bottomAnchor.constraint(equalTo: nextStepButton.topAnchor, constant: -8)
            ])
        case .paste:
            NSLayoutConstraint.activate([
                tokenTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
                tokenTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
                tokenTextView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
                tokenTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
                actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        }
    }

    // MARK: - Actions
    
    @objc private func actionButtonClicked() {
        actionBlock?()
    }

    @objc private func nextStepButtonClicked() {
        nextStepBlock?()
    }
}
