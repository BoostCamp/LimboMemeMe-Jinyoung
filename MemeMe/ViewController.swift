//
//  ViewController.swift
//  PickerImage
//
//  Created by 장진영 on 2017. 1. 20..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let textCotroller = TextFieldDelegate()
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: CGFloat(40.0))!,
        NSStrokeWidthAttributeName: 5.0
    ]
    
    struct Meme {
        var topText : String?
        var bottomText : String?
        var originalImage : UIImage?
        var memedImage : UIImage?
    }
    
    var memeSaver : [Meme]?
    
    override func viewDidLoad() {
        self.topTextField.delegate = textCotroller
        self.bottomTextField.delegate = textCotroller
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.textAlignment = .center
        self.bottomTextField.textAlignment = .center
        
        if self.imageView.image == nil {
            self.shareButton.isEnabled = false
        }
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    func keyboardWillShow(_ notification:Notification) {

        if view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboradSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboradSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageView.image = image
                if self.imageView.image != nil {
                    self.shareButton.isEnabled = true
                }
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        self.toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolbar.isHidden = false
        
        return memedImage
    }
    
    func save() {
         let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:imageView.image!, memedImage: generateMemedImage())
        memeSaver = [meme]
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func shareImage(_ sender: Any) {

        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activityImage, completed, object, error) in
            if completed {
                self.save()
                print(self.memeSaver!)
            } else {
                print(error.debugDescription)
            }
        }
        
    }
}

