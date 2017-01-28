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
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        // 1. appDelegate의 meme를 저장한다.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        // 2. 화면이 보여질 때마다 뷰를 갱신하여 저장된 meme를 보여준다.
        self.collectionView?.reloadData()
    }
    
    // MARK: - Collection view data source

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! CollectionViewCell
        
        cell.memeImageView?.image = memes[indexPath.row].memedImage
        cell.memeImageView?.contentMode = .scaleAspectFit
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editController = self.storyboard!.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editController.meme = memes[indexPath.row]
        editController.memeIndex = indexPath.row
        navigationController!.pushViewController(editController, animated: true)
    }

}
