//
//  DetailViewController.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 27..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme : Meme?
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        if let meme = meme {
            memeDetailImageView.image = meme.memedImage
        }
    }
    
    
}
