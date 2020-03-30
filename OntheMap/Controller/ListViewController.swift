//
//  ListViewController.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

private let listCellIdentifier = "listCell"

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLeftBarButtonFont()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: updateLocationsDataNotification, object: nil)
    }
    
    @objc func updateView() {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = LocationsSingleton.shared.locations[indexPath.row]
        let toOpen = location.mediaURL
        let app = UIApplication.shared
        
        app.open(URL(string: toOpen)!, options: [ : ], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsSingleton.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: listCellIdentifier) as! ListTableViewCell
        let location = LocationsSingleton.shared.locations[indexPath.row]
        
        listCell.nameLabel.text = location.firstName + " " + location.lastName
        listCell.webLinkLabel.text = location.mediaURL
        
        return listCell
    }
}
