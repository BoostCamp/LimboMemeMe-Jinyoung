//
//  Meme.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 26..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    // textArray : UITextField.text, UITextField.frame를 튜블로 묶어 저장한다.
    var textArray : [(String, CGRect)] = []
    var memedImage : UIImage?
    var originalImage : UIImage?
    var originalImagePoint : CGRect?
    
    init(textArray: [(String, CGRect)], memedImage : UIImage, originalImage : UIImage, originalImagePoint : CGRect) {
        self.textArray = textArray
        self.memedImage = memedImage
        self.originalImage = originalImage
        self.originalImagePoint = originalImagePoint
    }
}

