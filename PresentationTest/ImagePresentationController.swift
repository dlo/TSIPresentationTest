//
//  ImagePresentationController.swift
//  PresentationTest
//
//  Created by Daniel Loewenherz on 1/31/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//

import UIKit

class ImagePresentationController: UIPresentationController {
    var dimmingView: UIView!

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        guard let presentingViewController = presentingViewController else {
            fatalError()
        }

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        dimmingView = UIView(frame: presentingViewController.view.bounds)
        dimmingView.isUserInteractionEnabled = true

        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = dimmingView.bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dimmingView.addSubview(visualEffectView)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewDidTouchUpInside))
        tapRecognizer.numberOfTapsRequired = 1
        dimmingView.addGestureRecognizer(tapRecognizer)
    }

    // Called if cancelled.
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    func dimmingViewDidTouchUpInside() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0

        containerView.insertSubview(dimmingView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView,
            let presentedView = presentedView else {
                return
        }

        dimmingView.frame = containerView.bounds
        presentedView.frame = frameOfPresentedViewInContainerView
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: 540, height: 329)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let containerSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        let middleY = containerView.bounds.size.height / 2 - containerSize.height / 2
        return CGRect(origin: CGPoint(x: 0, y: middleY), size: containerSize)
    }

    // Add rotation support. See WWDC 2014 #228
    override func containerViewDidLayoutSubviews() {
        guard let containerView = containerView,
            let presentedView = presentedView else {
                return
        }

        dimmingView.frame = containerView.bounds
        presentedView.frame = frameOfPresentedViewInContainerView
    }
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
