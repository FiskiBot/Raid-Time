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

        // Do any additional setup after loading the view.
    }


}


extension RaidTimeSetVC : UITableViewDelegate {
    
}

extension RaidTimeSetVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.ds.loadedRaids.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
