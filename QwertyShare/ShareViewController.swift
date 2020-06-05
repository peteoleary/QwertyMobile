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
import MobileCoreServices

class QwertyShareViewController: UIViewController {
    
    private func setupViews() {
                
        let viewRouter = ViewRouter()
        
        fetchAndSetContentFromContext(viewRouter: viewRouter)
        
        let qrcodeStore = QRCodeStore(credentials: nil)
        let hostingController = UIHostingController(rootView: MainView(viewRouter: viewRouter).environmentObject(qrcodeStore))
        
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
    
    private func fetchAndSetContentFromContext(viewRouter: ViewRouter) {

        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {

                        itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (url, _error) in
                            viewRouter.shareURL = URL(string: (url as! NSURL).absoluteString!)
                        })
                    }
                }
            }
        }
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
        self.navigationItem.title = "Qwerty Share v0.10"

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
