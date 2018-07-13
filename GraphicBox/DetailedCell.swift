//
//  DetailedCell.swift
//  GraphicBox
//
//  Created by Alessandro Marconi on 13/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import UIKit

class DetailedCell: UITableViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
