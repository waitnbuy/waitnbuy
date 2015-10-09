//
//  Login.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 27.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class LoginController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    @IBAction func loginPressed(sender: UIButton) {
        
        let loginViewController = PFLogInViewController()
        loginViewController.delegate = self
        let signupViewController = PFSignUpViewController()
        signupViewController.delegate = self
        loginViewController.signUpController! = signupViewController
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (PFUser.currentUser() != nil) {logged_in()};

    }
    
    func logged_in() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewControllerWithIdentifier("revealVC")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func logInViewController(logInController : PFLogInViewController, shouldBeginLogInWithUsername username : String, password : String) -> Bool {
        if username.characters.count != 0 && password.characters.count != 0 { return true }
        
        let alertController = UIAlertController(title: "Missing information", message: "Make sure you fill out all the information!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        return false;
    }
    
    func logInViewController(logInController : PFLogInViewController, didLogInUser user :PFUser) {
        NSLog("\(user.username)")
        self.dismissViewControllerAnimated(true, completion: nil)
        //logged_in()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}







/*


curl -X POST \
-H "X-Parse-Application-Id: 8gjlvPcqeoOcMy6AHEEeAzwinCgFVfv7XWdzmUl6" \
-H "X-Parse-REST-API-Key: BAZ1TZTEruRVhyeb86enQuMKijbYXvdYApGiDE5a" \
-H "Content-Type: application/json" \
-d '{
    "link":"http://www.eldorado.ru/cat/detail/71086135/?category=1121193",
    "price":8989,
    "description":"Утюг с парогенератором TEFAL GV5246 Easy Pressing",
    "photoURL":"http://static.eldorado.ru/photos/71/new_71086135_l_294.jpeg",
    "prev_price":8989
    }' \
        https://api.parse.com/1/classes/Data


"ACL":{
"UAqtRkeAqD": {
"read": true,
"write": true
},
"*": {
"read": false
}
}

eldorado
<a data-price="xxx"....

var catalogDetailItemData = {
xmlId: '71086135',
name: 'Утюг с парогенератором TEFAL GV5246 Easy Pressing',
detailUrl: '/cat/detail/71086135/?category=5061',
pictureUrl: 'http://static.eldorado.ru/photos/71/new_71086135_l_294.jpeg',
price: '8&nbsp;989 <span class="rub">р.</span>',
rating: 5,
id: '26250598',
priceValue: 8989,
oldPriceValue: 8989,
buttonStatus: 'available'
}

*/