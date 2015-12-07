//
//  IAPurchaseViewController.swift
//  WaitnBuy
//
//  Created by Ilya Velilyaev on 08.11.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import UIKit
import StoreKit


class IAPurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate {
    var productIDs: Array <String!> = []
    var productsArray: Array <SKProduct!> = []
    
    @IBOutlet weak var tblview: UITableView!
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
        productIDs.append("com.waitnbuy.credit6")
        
        requestProductIndo()
    }
    
    func requestProductIndo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("Cannot perform iap")
        }
    
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            tblview.reloadData()
        } else {
            print ("no products")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print (response.invalidProductIdentifiers.description)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellProduct", forIndexPath: indexPath)
        
        let product = productsArray[indexPath.row]
        cell.textLabel?.text = product.localizedTitle
        cell.detailTextLabel?.text = product.localizedDescription
        
        return cell
        
    }
}