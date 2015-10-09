//
//  WebPreviewViewController.swift
//  WaitnBuy
//
//  Created by Ilya Velilyaev on 28.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//





import UIKit
import Parse

class WebPreviewViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
    }
    @IBAction func safariButtonPressed(sender: UIBarButtonItem) {
        UIApplication.sharedApplication().openURL(NSURL(string: link)!)
    }
    
    var link = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
        webView.loadRequest(NSURLRequest(URL: NSURL(string: link)!))
    }
    
}
