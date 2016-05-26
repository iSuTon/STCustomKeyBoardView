//
//  ViewController.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/22.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        keyBoardView.textView = textView
        
        /// 键盘可高度，其他设置没用
        textView.inputView = keyBoardView
        // 弹出键盘
        textView.becomeFirstResponder()

    }

    private lazy var keyBoardView:STKeyBoardView = STKeyBoardView()
}

extension ViewController{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        STPrint(items: textView.getEmoticonNameText())
    }
}
