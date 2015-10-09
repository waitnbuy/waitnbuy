//
//  HistoryTableViewController.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 29.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import UIKit
import Parse

class HistoryTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
  //  @IBOutlet weak var actInd: UIActivityIndicatorView!
    var data : [PFObject] = []
    let messageLabel = UILabel()
    
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
        self.refreshControl?.addTarget(self, action: "updateData:", forControlEvents: UIControlEvents.ValueChanged)
  //      actInd.hidesWhenStopped = true
     //   actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        updateData(self.refreshControl!)
        
        
    }
    
    
    func updateData(sender: UIRefreshControl) {
     //   actInd.startAnimating()
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
                        if (tmp == true) {
                            self.data.append(object)
                        }
                    }
                }
                for object in objects {
                    print(object.objectId)
                }
                self.tableView.reloadData()
                sender.endRefreshing()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (data.count > 0) {
            messageLabel.hidden = true
            return 1
        }
        messageLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.height, height: self.view.bounds.size.width)
        messageLabel.hidden = false
        messageLabel.text = "History is empty"
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont(name: "Avenir Next Condensed", size: 26.0)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return 0;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.data.count
    }


    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let alert = UIAlertController(title: "Choose Action", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Restore", style: UIAlertActionStyle.Default, handler: { (alertAction: UIAlertAction) -> Void in
            self.data[indexPath.row]["deleted"] = false
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
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (alertAction: UIAlertAction) -> Void in
            self.data[indexPath.row].deleteInBackgroundWithBlock({ (b: Bool, error: NSError?) -> Void in
                if b == true {
                    self.data.removeAtIndex(indexPath.row)
                    if self.data.count > 0 {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    } else {
                        tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.modalPresentationStyle = UIModalPresentationStyle.Popover
        self.presentViewController(alert, animated: true, completion: nil)
        
        print("Touched table cell: \(indexPath.row, indexPath.section)")
    }

}