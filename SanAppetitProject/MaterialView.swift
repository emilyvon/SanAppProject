//
//  MaterialView.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/13/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        
        //ADDING A RADIUS AND A SHADOW
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
