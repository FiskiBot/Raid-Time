//
//  RaidListVC.swift
//  RaidTime
//
//  Created by Patrick Moening on 1/8/18.
//  Copyright © 2018 Patrick Moening. All rights reserved.
//

import UIKit

class RaidListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.loadRaid()
        NotificationCenter.default.addObserver(self, selector: #selector(RaidListVC.onRaidsLoaded), name: NSNotification.Name(rawValue: "raidLoaded"), object: nil)
    }

    @objc func onRaidsLoaded () {
        tableView.reloadData()
    }

}

extension RaidListVC : UITableViewDelegate {
    
}


extension RaidListVC : UITableViewDataSource {
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.ds.loadedRaids.count
    }

    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let raid = DataService.ds.loadedRaids[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RaidCell") as? RaidListCell {
            cell.configureCell(raid: raid)
            return cell
        } else {
            print("FCUK")
            let cell = RaidListCell()
            cell.configureCell(raid: raid)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            DataService.ds.deleteRaid(index: indexPath.row)
            
        }
    }
}
