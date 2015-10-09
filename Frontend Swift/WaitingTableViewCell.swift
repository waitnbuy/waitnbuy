//
//  WaitingTableViewCell.swift
//  WaitnBuy
//
//  Created by Leonid Tuzenko on 28.09.15.
//  Copyright © 2015 Wait & Buy. All rights reserved.
//

import UIKit

class WaitingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var previewImage:UIImageView!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var descripText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
  
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
