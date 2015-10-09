//
//  MenuController.swift
//  Wait & Buy
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import Parse

class MenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Recieved user: \(PFUser.currentUser()?.objectId)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var new_url = String()
        NSLog("Touched table cell: \(indexPath.row, indexPath.section)")
        if indexPath == NSIndexPath(forRow: 5, inSection: 0) {
            PFUser.logOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewControllerWithIdentifier("initial")
            self.presentViewController(controller, animated: true, completion: nil)
        }
        if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
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
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
