//
//  ViewController.swift
//  LastDayCoreData
//
//  Created by MrLoong on 15/10/17.
//  Copyright © 2015年 MrLoong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    var people = [NSManagedObject]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "名字列表"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "新的名字", message: "添加一个新的名字", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(action:UIAlertAction) -> Void in
            
            let textField = alert.textFields!.first
            self.save(textField!.text!)
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        print("view")
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func save(name:String){
        let appDeleate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageContext = appDeleate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: manageContext)
        let Person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
        Person.setValue(name, forKey: "name")
        do{
            try manageContext.save()

        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let person = people[indexPath.row]
        cell!.textLabel!.text  = person.valueForKey("name") as? String;
        
        return cell!
    }

}

