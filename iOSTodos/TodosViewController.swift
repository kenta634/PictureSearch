//
//  TodosViewController.swift
//  Image Search
//
//  Created by 高橋健太 on 2015/06/18.
//  Copyright (c) 2015年 高橋健太. All rights reserved.
//

import UIKit
import CoreData

class TodosViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedResultController = self.getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInsection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInsection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let todo = fetchedResultController.objectAtIndexPath(indexPath) as! Todos
        cell.textLabel?.text = todo.content
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject: NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as!NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        managedObjectContext?.save(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let todoDetailController: TodoDetailViewController = segue.destinationViewController as! TodoDetailViewController
            let todo: Todos = fetchedResultController.objectAtIndexPath(indexPath!) as! Todos
            
            todoDetailController.todo = todo
        }
    }

    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: self.todoFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func todoFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Todos")
        let sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
   }