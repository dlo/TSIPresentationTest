//
//  ImageViewController.swift
//  PresentationTest
//
//  Created by Daniel Loewenherz on 1/31/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//

import UIKit
import LionheartExtensions
import SuperLayout

final class ImageViewController: UIViewController {
    let image = UIImage(named: "9_1_Andersen Bed.750")!
    var imageView: UIImageView!

    var imageViewCopy: UIImageView {
        return UIImageView(image: imageView.image)
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true

        imageView = UIImageView(image: image)

        view.addSubview(imageView)

        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor ~~ view.centerXAnchor
        imageView.centerYAnchor ~~ view.centerYAnchor - 200
        imageView.leftAnchor ~~ view.leftAnchor
        imageView.rightAnchor ~~ view.rightAnchor

        let aspect = image.size.height / image.size.width
        imageView.heightAnchor ~~ imageView.widthAnchor * aspect

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureDetected))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    func gestureDetected() {
        let controller = ZoomViewController()
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ImageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageAnimator(presenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageAnimator(presenting: false)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ImagePresentationController(presentedViewController: presented, presenting: source)
    }
}
