//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 26..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    var memes = [Meme]()
    
    override func viewWillAppear(_ animated: Bool) {
        // 1. appDelegate의 meme를 저장한다.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // 2. 화면이 보여질 때마다 뷰를 갱신하여 저장된 meme를 보여준다.
        self.collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: view.frame.width / 4)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! CollectionViewCell

        cell.memeImageView?.image = memes[indexPath.row].memedImage
        cell.memeImageView?.contentMode = .scaleAspectFit
        return cell
    }

}
