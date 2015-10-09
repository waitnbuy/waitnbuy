//
//  SettingsTableViewController.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 04.10.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import UIKit
import Parse


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            let alert = UIAlertController(title: "Are you sure?", message: "This will delete all your history", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .Destructive, handler: { (act: UIAlertAction) -> Void in
                let query = PFQuery(className: "Data")
                query.whereKey("deleted", equalTo: true)
                query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        for var i = 0; i < objects!.count; i++ {
                            objects?[i].deleteEventually()
                        }
                    }
                })
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}