//
//  WaitingTableViewController.swift
//  Wait & Buy
//
//  Created by Ilya Velilyaev on 27.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//
import UIKit
import Parse

class WaitingTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var data : [PFObject] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: "updateData:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        errorLabel.enabled = false
        addButton.enabled = false
        updateData(refreshControl)
        
        
    }
    
    
    func updateData(sender: UIRefreshControl) {
        //actInd.startAnimating()
        let query = PFQuery(className: "Data")
        self.data.removeAll()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                let objects = objects!
                for object in objects {
                    if let tmp = object["deleted"] as? Bool {
                        if (tmp == false) {
                            self.data.append(object)
                        }
                    }
                }
                for object in objects {
                    print(object.objectId)
                }
                self.tableView.reloadData()
                sender.endRefreshing()
               // self.actInd.stopAnimating()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }

        
    }
    
    @IBAction func addButtonAction(sender: UIButton) {
        var new_url = String()
        let alert = UIAlertController(title: "Enter the URL", message: "Enter the URL of preferred item in your online shop", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler{ (textfield :UITextField) -> Void in
            textfield.placeholder = NSLocalizedString("http://...", comment: "URL")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            if let tmp_new_url = alert.textFields![0].text {
                if tmp_new_url.characters.count != 0 {
                    new_url = tmp_new_url
                    print("Adding: \(new_url)")
                    let query = PFQuery(className: "Data")
                    query.whereKey("link", equalTo:new_url)
                    query.findObjectsInBackgroundWithBlock() { (objects: [PFObject]?, error: NSError?) -> Void in
                        if objects!.count != 0 {
                            let alertInAlert = UIAlertController(title: "Oops", message: "You have already added this link to watching list", preferredStyle: UIAlertControllerStyle.Alert)
                            alertInAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertInAlert, animated: true, completion: nil)
                            
                        } else {
                            let newObject = PFObject(className: "Data")
                            newObject["link"] = new_url
                            newObject.ACL = PFACL(user: PFUser.currentUser()!)
                            newObject["owner"] = PFUser.currentUser()?.objectId
                            newObject.saveInBackgroundWithBlock() { (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    print("saved new link")
                                    let alertInAlert = UIAlertController(title: "Success", message: "This link will appear in your tracking table soon", preferredStyle: UIAlertControllerStyle.Alert)
                                    alertInAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alertInAlert, animated: true, completion: nil)
                                    PFCloud.callFunctionInBackground("bSave", withParameters: ["link":new_url])
                                    
                                } else {
                                    print("error: \(error?.description)")
                                    let alertInAlert = UIAlertController(title: "Unknown error", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                                    alertInAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alertInAlert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    
                    
                } else {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                self.presentViewController(alert, animated: true, completion: nil)
            }
            }
            ))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (data.count > 0) {
            errorLabel.hidden = true
            addButton.enabled = false
            addButton.hidden = true
            return 1
        } else {
            if Reachability.isConnectedToNetwork() {
                errorLabel.text = "You have not added any items yet"
                errorLabel.sizeToFit()
                errorLabel.enabled = true
                errorLabel.hidden = false
                addButton.hidden = false
                addButton.enabled = true
                addButton.setTitle("Add first item", forState: UIControlState.Normal)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            } else {
                errorLabel.text = "You have problems with internet connection"
                errorLabel.sizeToFit()
                errorLabel.enabled = true
                errorLabel.hidden = false
            }
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openWebSegue" {
            if let destination = segue.destinationViewController as? WebPreviewViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    if let link = data[index]["link"] as? String {
                        destination.link = link
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       /* if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.beginUpdates()
            data[indexPath.row]["deleted"] = true
            data[indexPath.row].saveInBackground()
            data.removeAtIndex(indexPath.row)
            //updateData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }*/
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Archivate") { (tableAction: UITableViewRowAction, indexPath : NSIndexPath) -> Void in
            self.data[indexPath.row]["deleted"] = true
            self.data[indexPath.row].saveInBackgroundWithBlock({ (b: Bool, error : NSError?) -> Void in
                if b == true {
                    self.data.removeAtIndex(indexPath.row)
                    if self.data.count > 0 {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    } else {
                        tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                }
            })
            
        }
        return [action]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WaitingTableViewCell
        
        // Configure the cell...
        for var i = Int(0); i < data.count; i++ {
            if indexPath.row == i {
                if let url = NSURL(string: String(data[i]["photoURL"]!)) {
                    if let temp_data = NSData(contentsOfURL: url){
                        cell.previewImage.contentMode = UIViewContentMode.ScaleAspectFit
                        cell.previewImage.image = UIImage(data: temp_data)
                    }
                }
                cell.descripText.text = String(data[i]["description"])
                let date = data[i].createdAt
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd.MM.YY"
                cell.dateLabel.text = dateFormatter.stringFromDate(date!)
                let price = String(data[i]["price"])
                cell.priceLabel.text = "\(price) ₽"
            }
        }
        
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("Touched table cell: \(indexPath.row, indexPath.section)")
    }
    
}