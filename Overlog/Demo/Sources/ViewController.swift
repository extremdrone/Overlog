//
// ViewController.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
// Licensed under the MIT License.
//

import UIKit
import Overlog

final class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

        let configuration = URLSessionConfiguration.default

        Overlog.shared.enableNetworkDebugging(inConfiguration: configuration)
        let session = URLSession(configuration: configuration)
        let request = URLRequest(url: URL(string: "https://cljsbin-bkhgroqzwe.now.sh/headers")!)
        session.dataTask(with: request).resume()


        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            let delayedRequest = URLRequest(url: URL(string: "https://cljsbin-bkhgroqzwe.now.sh/get")!)
            session.dataTask(with: delayedRequest).resume()

        }

    }
}
