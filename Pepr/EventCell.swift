//
//  EventCell.swift
//  Mega
//
//  Created by Tope Abayomi on 08/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet var typeImageView : UIImageView!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: PeprTheme.semiBoldFontName, size: 18)
        titleLabel.textColor = UIColor.blackColor()
        
        descriptionLabel.font = UIFont(name: PeprTheme.fontName, size: 12)
        descriptionLabel.textColor = UIColor(white: 0.70, alpha: 1.0)
        
    }
}
