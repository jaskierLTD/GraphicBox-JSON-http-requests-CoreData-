//
//  DetailViewController.swift
//  DetailedTableView
//
//  Created by Alessandro Marconi on 07/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    //data from previous controller
    var titlePrev:String!
    var contentPrev:String!
    var idPrev:Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem{
            if let label = contentText{
                label.text = detail.title!.description
            }
        }
    }

    func updateUI(){
        print("Previous index",idPrev)
        //self.titleText.text.append(titlePrev)
        //self.contentText.text.append(contentPrev)
    }
}
