//
//  TextFieldDDelegate.swift
//  PickerImage
//
//  Created by 장진영 on 2017. 1. 21..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import Foundation
import UIKit

class EditViewTextFieldDelegate : NSObject, UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

