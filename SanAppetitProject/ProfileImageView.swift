//
//  ProfileImageView.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 4/2/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
                
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 2
    }
    
}
