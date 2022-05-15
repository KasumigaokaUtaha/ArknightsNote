//
//  ANButton.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

class ANButton: UIButton {
    init() {
        super.init(frame: .zero)

        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonPressed), for: .touchDragEnter)
        addTarget(self, action: #selector(buttonPressed), for: .touchDragInside)

        addTarget(self, action: #selector(buttonReleased), for: .touchCancel)
        addTarget(self, action: #selector(buttonReleased), for: .touchDragExit)
        addTarget(self, action: #selector(buttonReleased), for: .touchDragOutside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.4
        }
    }

    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
}
