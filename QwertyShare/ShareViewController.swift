//
//  ShareViewController.swift
//  QwertyShare
//
//  Created by Peter O'Leary on 5/15/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import Social
import os.log

class QwertyShareViewController: UIViewController {
    

    private func setupViews() {
        
        // view.translatesAutoresizingMaskIntoConstraints = false
        
        let vr = ViewRouter()
        let qrcode_store = QRCodeStore(viewRouter: vr)
        let hostingController = UIHostingController(rootView: MainView(viewRouter: vr).environmentObject(qrcode_store))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = .systemGray6
        setupNavBar()
        
        setupViews()
    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "Qwerty Share v0.06"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        os_log("doneAction()")
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
// 1: Set the `objc` annotation
@objc(QwertyShareNavigationController)
class QwertyShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 2: set the ViewControllers
        self.setViewControllers([QwertyShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
