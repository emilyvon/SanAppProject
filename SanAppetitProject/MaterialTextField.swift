//
//  MaterialTextField.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/13/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {

    layer.cornerRadius = 2.0
    layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
    layer.borderWidth = 1.0
}

//For the placeholder
override func textRectForBounds(bounds: CGRect) -> CGRect {
    
    return CGRectInset(bounds, 10, 0)
}

//For editable text
override func editingRectForBounds(bounds: CGRect) -> CGRect {
    
    return CGRectInset(bounds, 10, 0)
    }
}
