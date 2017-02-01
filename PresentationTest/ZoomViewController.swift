//
//  ZoomViewController.swift
//  PresentationTest
//
//  Created by Daniel Loewenherz on 1/31/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//

import UIKit
import SuperLayout

final class ZoomViewController: UIViewController {
    let image = UIImage(named: "9_1_Andersen Bed.1080")!
    var imageView: UIImageView!

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        imageView = UIImageView(image: image)

        view.addSubview(imageView)

        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor ~~ view.centerXAnchor
        imageView.centerYAnchor ~~ view.centerYAnchor
        imageView.leftAnchor ~~ view.leftAnchor
        imageView.rightAnchor ~~ view.rightAnchor

        let aspect = image.size.height / image.size.width
        imageView.heightAnchor ~~ imageView.widthAnchor * aspect
    }
}
