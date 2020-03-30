//
//  CustomButton.swift
//  OntheMap
//
//  Created by Osmar Hernández on 26/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.udacityBlue
    }
}
