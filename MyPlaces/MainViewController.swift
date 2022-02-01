//
//  MainViewController.swift
//  MyPlaces
//
//  Created by user207855 on 2/1/22.
//

import UIKit

class MainViewController: UITableViewController {
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai",
        "X.O", "Sherlock Holmes", "Speak Easy"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        
        return cell
    }

}
