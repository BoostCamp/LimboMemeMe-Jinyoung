//
//  TableViewController.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 26..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    var memes = [Meme]()
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! TableViewCell
        cell.memeTableImageView?.contentMode = .scaleAspectFit
        cell.memeTableImageView?.image = memes[indexPath.row].memedImage! as UIImage
        cell.memeTableTitle?.text = "\(memes[indexPath.row].topText!)...\(memes[indexPath.row].bottomText!)"
        return cell
    }
    

}
