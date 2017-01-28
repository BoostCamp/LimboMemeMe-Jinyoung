//
//  TextFieldDDelegate.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 21..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        appDelegate.textFieldPointY = textField.frame.midY
        return true
    }
    
    // 텍스트 필드 편집 시작 시, 초기화
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

