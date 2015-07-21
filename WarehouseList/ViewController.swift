//
//  ViewController.swift
//  WarehouseList
//
//  Created by Lynch Wong on 7/21/15.
//  Copyright (c) 2015 Nobodyknows. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var warehouses = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "仓库管理"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Warehouse")
        
        //3
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            warehouses = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(sender: AnyObject) {
        var alert = UIAlertController(title: "添加仓库", message: "输入仓库名", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "保存", style: .Default) {
            (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            self.saveName(textField.text)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Default) {
                (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity = NSEntityDescription.entityForName("Warehouse", inManagedObjectContext: managedContext)
        let warehouse = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        //3
        warehouse.setValue(name, forKey: "name")
        //4
        var error: NSError?
        managedContext.save(&error)
        if error != nil {
            println("Could not save \(error), \(error!.userInfo)") }
        //5
        warehouses.append(warehouse)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return warehouses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        let warehouse = warehouses[indexPath.row]
        cell.textLabel!.text = warehouse.valueForKey("name") as? String
        return cell
    }

}

