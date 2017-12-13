//
//  KeychainViewController.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

internal final class KeychainViewController: UITableViewController {

    /// Array of recently found keychain items.
    fileprivate(set) var items = [KeychainItem]()
    
    /// A reuse identifier for keychain view cells
    fileprivate let reuseIdentifier = "KeychainViewCellReuseIdentifier"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Reloads view controller content with received items.
    ///
    /// - Parameter newItems: Keychain items which should be displayed by view controller.
    public func reload(with newItems: [KeychainItem]) {
        items = newItems
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .OVLDarkBlue
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.register(KeyValueEntryCell.self, forCellReuseIdentifier: String(describing: KeyValueEntryCell.self))
        tableView.estimatedRowHeight = 44.0
    }
    
}

// MARK: UITableViewDataSource

extension KeychainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: KeyValueEntryCell.self), for: indexPath) as! KeyValueEntryCell
        let item = items[indexPath.row]
        
        cell.keyLabel.text = "key".localized + ": " + item.key
        cell.valueLabel.text = "value".localized + ": " + item.value
        return cell
    }
}
