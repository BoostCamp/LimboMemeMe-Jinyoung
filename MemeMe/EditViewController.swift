//
//  EditViewController.swift
//  MemeMe
//
//  Created by 장진영 on 2017. 1. 27..
//  Copyright © 2017년 Jinyoung. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var meme : Meme?
    var memeIndex : Int?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let textCotroller = TextFieldDelegate()

    
    // textFieldContainer : 텍스트의 이동과 변경을 위해 meme의 텍스트 OR 사용자가 생성할 텍스트를 담는다.
    var textFieldContainer = UITextField()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editToolBar: UIToolbar!
    
    // memeTextAttributes : meme 텍스트 속성을 설정한다.
    @IBOutlet weak var addTextButton: UIBarButtonItem!
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: CGFloat(40.0))!,
        NSStrokeWidthAttributeName: 5.0
    ]
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        textFieldContainer.delegate = textCotroller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let meme = meme {
            // 1. EditBar를 나타날 수 있도록, 기존의 tabBar를 숨긴다.
            self.tabBarController?.tabBar.isHidden = true
            
            // 2. 오리지널 이미지를 위치시킨다.
            imageView.image = meme.originalImage
            
            // 3. 텍스트를 위치시킨다.
            textFieldInit()
        }
        // 4. 키보드의 등장과 사라짐을 인지한다.
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 화면이 사라지면, 기존의 tabBar를 다시 나타낸다.
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MAAK: - textField Function
    func textFieldInit() {
        for memeText in (meme?.textArray)! {
            // 1. 기존에 가진 텍스트를 생성하고, 속성을 설정한다.
            let textField = UITextField.init(frame: memeText.1)
            textField.text = memeText.0
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
            
            textField.delegate = textCotroller

            
            // 2. 텍스트에서 터치이벤트가 발생했을 때, 사용자의 드래그에 반응할 수 있도록 등록한다.
            textField.addTarget(self, action: #selector(EditViewController.registDragGesture(sender:)), for: UIControlEvents.allTouchEvents)
            
            // 3. 뷰에 나타낸다.
            self.view.addSubview(textField)
        }
    }
    
    @objc(registDragGesture:)
    func registDragGesture(sender: UITextField) {
        // 1. 텍스트 컨테이너에 드래그 액션을 등록할 텍스트 필드를 담는다.
        self.textFieldContainer = sender
        
        // 2. 드래그를 할 때, 수행할 함수를 등록한다.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(gesture:)))
        
        // 3. 텍스트 컨테이너를 드래그이벤트에 등록하고, 사용자 드래그를 활성화한다.
        self.textFieldContainer.addGestureRecognizer(gesture)
        self.textFieldContainer.isUserInteractionEnabled = true
    }
    
    
    // userDragged : 텍스트 컨테이너의 위치를 사용자의 드래그 위치로 변경한다.
    func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        self.textFieldContainer.center = loc
    }
    
    // countOfTextFieldInView : view 안에 textField를 개수 반환한다.
    func countOfTextFieldInView(superView: UIView)-> Int{
        var count = 0
        for textView in superView.subviews{
            if (textView is UITextField){
                count += 1
            }
        }
        return count
    }
    
    // generateMemedImage : 네비게이션, 툴바를 제외한 뷰 이미지를 저장한다.
    func generateMemedImage() -> UIImage {
        self.navigationController?.navigationBar.isHidden = true
        self.editToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.isHidden = false
        self.editToolBar.isHidden = false
        return memedImage
    }
    
    // save : 텍스트필드의 텍스트, 위치와 이미지를 meme 배열에 저장한다.
    func save() {
        if let meme = self.meme {
            meme.textArray = []
            for textView in self.view.subviews{
                if (textView is UITextField){
                    let textField = textView as! UITextField
                    print(textField.frame)
                    meme.textArray += [(textField.text!, textField.frame)]
                }
            }
            meme.memedImage = generateMemedImage()
            appDelegate.memes[memeIndex!] = self.meme!
        }
        
    }
    
    
    
    // MARK: - Keyborad에 따른 View 조절
    
    func keyboardWillShow(_ notification:Notification) {
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
    
    

    // MARK: - Action
    
    // addTextCilcked : 텍스트 필드를 추가한다.
    @IBAction func addTextCilcked(_ sender: Any) {
        
        // 0-1. text는 총 10개 미만으로 생성한다.
        if countOfTextFieldInView(superView: self.view) < 10 {
            
            // 1. X좌표, Y좌표의 중앙에 텍스트를 생성한다.
            //let addTextField = UITextField.init(frame: CGRect.init(origin: CGPoint.init(x: self.view.frame.midX - CGFloat(Float(arc4random()/UINT32_MAX)), y: self.view.frame.midY), size: CGSize.init(width: 100, height: 20)))
            
            let addTextField = UITextField.init(frame: CGRect.init(x: self.view.frame.midX - 200, y: self.view.frame.midY, width: self.view.frame.width, height: 20))
            
            // 2. 텍스트 속성을 설정한다.
            addTextField.text = "Text"
            addTextField.defaultTextAttributes = memeTextAttributes
            addTextField.textAlignment = .center
            
            addTextField.delegate = textCotroller

        
            // 3. 텍스트에서 터치이벤트가 발생했을 때, 사용자의 드래그에 반응할 수 있도록 등록한다.
            addTextField.addTarget(self, action: #selector(EditViewController.registDragGesture(sender:)), for: UIControlEvents.allTouchEvents)
            
            // 4. 텍스트를 뷰에 나타낸다.
            self.view.addSubview(addTextField)
        }
            
        // 0-2. text가 10개 이상이면, 추가 버튼을 비활성화하고 경고창을 띄운다.
        else {
            self.addTextButton.isEnabled = false
            let alert = UIAlertController(title: "", message: "더 이상 추가할 수 없습니다", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    // saveButtonClicked : 텍스트 필드의 위치, 텍스트, 이미지를 저장한다.
    @IBAction func saveButtonClicked(_ sender: Any) {
        save()
    }

    @IBAction func shareButtonClicked(_ sender: Any) {
        // 1. 엑티비티 컨트롤러를 등장시킨다.
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        // 2. 완료되면, 이미지를 저장하고 편집창을 닫는다.
        activityController.completionWithItemsHandler = {(activityImage, completed, object, error) in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else {
            }
        }
    }
    
    
    
}
