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

        let containerBounds = containerView.bounds
        var frame = containerBounds
        frame.origin.y += containerBounds.height * 0.55
        frame.size.height = containerBounds.height * 0.45

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
            views: ["dimmingView": dimmingView!]
        ))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[dimmingView]|",
            metrics: nil,
            views: ["dimmingView": dimmingView!]
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

    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.roundedCorners([.topLeft, .topRight], radius: 12)
    }
}
