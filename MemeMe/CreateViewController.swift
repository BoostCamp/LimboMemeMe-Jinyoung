//
//  CreateViewController.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 20..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let textCotroller = TextFieldDelegate()
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: CGFloat(40.0))!,
        NSStrokeWidthAttributeName: 5.0
    ]
    
    // MARK: - Life Cycle
    
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
    
    
    // MARK: - Keyborad에 따른 View 조절
    func keyboardWillShow(_ notification:Notification) {
        // 뷰가 올라가지 않았고, 터치한 textField의 Y좌표가 중앙보다 클 경우에 뷰의 위치를 조정한다.
        if view.frame.origin.y == 0 && appDelegate.textFieldPointY > self.view.frame.midY {
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
    
    
    // MARK: - Pick Image & Save Image
    
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
        
        // 네비게이션, 툴바를 제외한 뷰 이미지를 저장한다.
        self.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        return memedImage
    }
    
    func save() {
        let meme = Meme.init(textArray:[(topTextField.text!, topTextField.frame), (bottomTextField.text!, bottomTextField.frame)],
            memedImage: generateMemedImage(),
            originalImage: imageView.image!,
            originalImagePoint: imageView.frame)
        appDelegate.memes.append(meme)
    }
    
    
    // MARK: Actions
    
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
    
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activityImage, completed, object, error) in
            if completed {
                // 이미지를 저장 후, 편집창을 닫는다.
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

