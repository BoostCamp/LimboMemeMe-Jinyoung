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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 화면이 사라지면, 기존의 tabBar를 다시 나타낸다.
        self.tabBarController?.tabBar.isHidden = false
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
        
        // 3. 텍스트 컨테이너
        self.textFieldContainer.addGestureRecognizer(gesture)
        self.textFieldContainer.isUserInteractionEnabled = true
    }
    
    // userDragged : 텍스트 컨테이너의 위치를 사용자의 드래그 위치로 변경
    func userDragged(gesture: UIPanGestureRecognizer){
        let loc = gesture.location(in: self.view)
        self.textFieldContainer.center = loc
    }
    
    // countOfTextFieldInView : view 안에 textField를 개수 반환
    func countOfTextFieldInView(superView: UIView)-> Int{
        var count = 0
        for textView in superView.subviews{
            if (textView is UITextField){
                count += 1
            }
        }
        print(count)
        return count
    }
    
    
    func generateMemedImage() -> UIImage {
        // 네비게이션, 툴바를 제외한 뷰 이미지를 저장한다.
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
            print(appDelegate.memes[memeIndex!])
        }
        
    }
    

    // MARK: - Action
    
    // addTextCilcked : 텍스트 필드를 추가한다.
    @IBAction func addTextCilcked(_ sender: Any) {
        
        // 0. text는 총 10개 미만으로 생성한다.
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
            self.view.addSubview(addTextField)
        } else {
            self.addTextButton.isEnabled = false
        }
    }
    
    // saveButtonClicked : 텍스트 필드의 위치, 텍스트, 이미지를 저장한다.
    @IBAction func saveButtonClicked(_ sender: Any) {
        save()
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
            }
        }
    }
    
    
    
}
