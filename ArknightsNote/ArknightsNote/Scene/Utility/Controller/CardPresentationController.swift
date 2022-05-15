//
//  CardPresentationController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 14.05.22.
//

import UIKit

class CardPresentationController: UIPresentationController {
    private var dimmingView: UIView!

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let inset: CGFloat = 16

        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let targetWidth = safeAreaFrame.width - 2 * inset

        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += safeAreaFrame.size.height * 0.6
        frame.size.width = targetWidth
        frame.size.height = safeAreaFrame.size.height * 0.4

        return frame
    }

    override func presentationTransitionWillBegin() {
        dimmingView = UIView()
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black
        containerView?.addSubview(dimmingView)

        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[dimmingView]|",
            metrics: nil,
            views: ["dimmingView": dimmingView]
        ))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[dimmingView]|",
            metrics: nil,
            views: ["dimmingView": dimmingView]
        ))

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.5
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
