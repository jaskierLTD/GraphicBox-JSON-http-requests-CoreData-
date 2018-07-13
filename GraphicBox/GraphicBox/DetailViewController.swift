//
//  DetailViewController.swift
//  DetailedTableView
//
//  Created by Alessandro Marconi on 07/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var titleText: UITextField?
    @IBOutlet weak var contentText: UITextField?

    var defaults = UserDefaults.standard
    var theFieldsVC: DetailedCell?
    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    //data from previous controller
    var titlePrev:String?
    var contentPrev:String?
    var idPrev:Int?
    var new:Bool?
    
    //data from Cell
    var idFromCell:Int?
    var titleFromCell:String?
    var contentFromCell:String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "detailedCellSegue"
        {
            
            if let vc = segue.destination as? DetailedCell
            {
                theFieldsVC = vc
                self.defaults.set(self.idPrev, forKey: "id")
                self.defaults.set(self.titlePrev, forKey: "title")
                self.defaults.set(self.contentPrev, forKey: "content")
                self.defaults.set(self.new, forKey: "new")
                
                idFromCell      = UserDefaults.standard.object(forKey: "idFromCell") as? Int ?? Int()
                titleFromCell   = UserDefaults.standard.object(forKey: "titleFromCell") as? String ?? String()
                contentFromCell = UserDefaults.standard.object(forKey: "contentFromCell") as? String ?? String()
            }
            
        }
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
        print("Previous index",idPrev as Any)
    }
    
    @IBAction func saveNote(_ sender: Any)
    {
        //DispatchQueue.main.async
        //{
            var msg : String
            
            DetailedCell().confirmData()
            //Make sure about newest textFields Values
            self.idFromCell      = UserDefaults.standard.object(forKey: "idFromCell") as? Int ?? Int()
            self.titleFromCell   = UserDefaults.standard.object(forKey: "titleFromCell") as? String ?? String()
            self.contentFromCell = UserDefaults.standard.object(forKey: "contentFromCell") as? String ?? String()
            
            //Now we gonna check is it new Item, ot we should update existant
            if ((self.titleFromCell != "") && (self.contentFromCell != "")) || (self.titleFromCell != nil) && (self.contentFromCell != nil)
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController
                if (self.new == true)
                {
                    // "new" is true so we create ITEM
                    self.addItem(self.idFromCell!, self.titleFromCell!, self.contentFromCell!)
                    self.navigationController?.pushViewController(vc, animated: true)
                    msg = "Note: " + self.titleFromCell! + " successfuly added!"
                }else{
                    // "new" is not New Item - UPDATE context
                    self.updateItem(self.idFromCell!, self.titleFromCell!, self.contentFromCell!)
                    self.navigationController?.pushViewController(vc, animated: true)
                    msg = "Note: " + self.titleFromCell! + " successfuly updated!"
                }
            }
            else
                {
                    msg = "Title or Content is empty! Please check"
                }
            self.showAlertController(msg)
        //}
    }
    
    func showAlertController(_ msg: String)
    {
        let alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:.alert)
        let alertAction: UIAlertAction
        
        if msg == "Title or Content is empty! Please check"
        {
            alertAction = UIAlertAction(title: "Fill in, please", style: .default)
        }
        else
        {
            alertAction = UIAlertAction(title: "Good Job man!", style: .default, handler:{
                action in
            })
        }
        alert.addAction(alertAction)
        self.present(alert, animated:false, completion:nil);
    }
    
    func addItem(_ id: Int, _ title: String, _ content: String)
    {
        APIManager().POST(title, content)
    }
    
    func updateItem(_ id: Int, _ title: String, _ content: String)
    {
        APIManager().PUT(id, title, content)
    }
}
