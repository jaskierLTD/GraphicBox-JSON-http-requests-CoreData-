//
//  MasterViewController.swift
//  DetailedTableView
//
//  Created by Alessandro Marconi on 07/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
var detailViewController: DetailViewController? = nil
var managedObjectContext: NSManagedObjectContext? = nil
    
//dataArrays
var idArray2 = [Int]()
var titleArray2 = [String]()
var contentArray2 = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.rowHeight = 44;
        tableView.delegate = self
        tableView.dataSource = self
        
        // GET request
        APIManager().GET(Void.self)
        self.idArray2 = UserDefaults.standard.object(forKey: "idArray2") as? [Int] ?? [Int]()
        self.titleArray2 = UserDefaults.standard.object(forKey: "titleArray2") as? [String] ?? [String]()
        self.contentArray2 = UserDefaults.standard.object(forKey: "contentArray2") as? [String] ?? [String]()
        UserDefaults.resetStandardUserDefaults()
        print(titleArray2)
        AppDelegate().deleteAllData(entity: "Event")
        
        // MARK: - SaveContext
        do { try managedObjectContext?.save()
                for i in 0...idArray2.count-1
                {
                    let note = NSEntityDescription.insertNewObject(forEntityName: "Event",
                                                                       into: self.managedObjectContext!) as! Event
                    note.id = Int16(i)
                    note.note_id = Int16(idArray2[i])
                    note.title = titleArray2[i]
                    note.content = contentArray2[i]
                }
        }
        catch {
            NSLog("Unresolved error \(error), \(String(describing: error._userInfo))")
            abort()
        }

        //Change Add button
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController
        {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func insertNewObject(_ sender: Any)
    {
        /*let context = self.fetchedResultsController.managedObjectContext
        let newEvent = Event(context: context)
        
        // If appropriate, configure the new managed object.
        newEvent.title = String()
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }*/
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return titleArray2.count
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
        //cell.myCellLabel.text = self.titleArray2[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            do
            {
                try context.save()
            } catch
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, withEvent event: Event)
    {
        cell.textLabel!.text = event.title?.description
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        //fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type{
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:

            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     tableView.reloadData()
     }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray2.count
    }*/
    
    ///for showing next detailed screen with the downloaded info
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.idPrev = idArray2[indexPath.row]
        vc.titlePrev = titleArray2[indexPath.row]
        vc.contentPrev = contentArray2[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

