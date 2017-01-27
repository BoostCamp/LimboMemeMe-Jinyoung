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

    // 텍스트 필드 편집 시작 시, 초기화
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

