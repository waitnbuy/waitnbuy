//
//  SettingsTableViewController.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 04.10.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import UIKit
import Parse
import StoreKit


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var creditsCountCell: SettingsTableViewCreditCell!
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
    
    
    override func viewWillAppear(animated: Bool) {
        if let user = PFUser.currentUser() {
            user.fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    if let a = user.objectForKey("credits") {
                        self.creditsCountCell.creditCount.text = String(a.integerValue)
                    }
                    print(PFUser.currentUser()!.objectForKey("credits"))

                }
            })
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //delete history (0 row)
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
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (act: UIAlertAction) -> Void in
            }));
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //add credits (row 2)
        if (indexPath.row == 0) {
            //IMPLEMENT BUYING
            
        }

        
        
    }
    
}