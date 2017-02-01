//
//  ImageAnimator.swift
//  PresentationTest
//
//  Created by Daniel Loewenherz on 1/31/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//

import UIKit

final class ImageAnimator: NSObject {
    let duration: TimeInterval = 0.75
    var presenting = false

    init(presenting isPresenting: Bool) {
        super.init()

        presenting = isPresenting
    }
}

extension ImageAnimator: UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animationEnded(_ transitionCompleted: Bool) {
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }

        let fromView = fromVC.view!
        let toView = toVC.view!

        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        // MARK: ??? These return nil?
//        let fromView = transitionContext.view(forKey: .from)!
//        let toView = transitionContext.view(forKey: .to)!

        let containerView = transitionContext.containerView
        containerView.layoutIfNeeded()

        // MARK: !!! Important. Need this to get correct final snapshot frame.
        toView.layoutIfNeeded()
        fromView.layoutIfNeeded()

        containerView.addSubview(toView)
        toView.frame = toViewFinalFrame

        let imageViewCopy: UIView
        var finalSnapshotFrame: CGRect
        var viewToUnhide: UIView?
        if presenting {
            guard let imageViewController = fromVC as? ImageViewController,
                let zoomViewController = toVC as? ZoomViewController else {
                    transitionContext.completeTransition(false)
                    return
            }

            let imageView = imageViewController.imageView!
            let zoomImageView = zoomViewController.imageView!

            let initialSnapshotFrame = fromView.convert(imageView.frame, to: containerView)
            finalSnapshotFrame = toView.convert(zoomImageView.frame, to: containerView)

            imageViewCopy = imageViewController.imageViewCopy
            imageViewCopy.backgroundColor = .green
            imageViewCopy.frame = initialSnapshotFrame

            containerView.addSubview(imageViewCopy)

            viewToUnhide = toView
            imageView.isHidden = true
            toView.isHidden = true
        } else {
            guard let imageViewController = toVC as? ImageViewController,
                let zoomViewController = fromVC as? ZoomViewController else {
                    transitionContext.completeTransition(false)
                    return
            }

            let imageView = imageViewController.imageView!
            let galleryImageView = zoomViewController.imageView!

            let initialSnapshotFrame = fromView.convert(galleryImageView.frame, to: containerView)
            finalSnapshotFrame = toView.convert(imageView.frame, to: containerView)

            imageViewCopy = imageViewController.imageViewCopy
            imageViewCopy.frame = initialSnapshotFrame

            containerView.addSubview(imageViewCopy)
        }

        UIView.animate(withDuration: duration, animations: {
            imageViewCopy.frame = finalSnapshotFrame
        }) { finished in
            let success = !transitionContext.transitionWasCancelled

            let failedToPresent: Bool = self.presenting && !success
            let successfullyDismissed: Bool = !self.presenting && success
            if failedToPresent || successfullyDismissed {
                toView.removeFromSuperview()
            }

            viewToUnhide?.isHidden = false
            imageViewCopy.removeFromSuperview()
            
            transitionContext.completeTransition(success)
        }
    }
}
