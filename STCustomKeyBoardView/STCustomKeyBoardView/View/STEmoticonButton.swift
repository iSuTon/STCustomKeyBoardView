//
//  STButton.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/23.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

class STEmoticonButton: UIButton {

    /// 表情模型
    var emoticonModel:STEmoticonModel?{
        didSet{
            guard let model = emoticonModel else{
                STPrint(items: "emoticonModel 为nil ！！")
                return
            }
            if model.codeIconString != nil{
                setImage(nil, forState: UIControlState.Normal)
                setTitle(model.codeIconString, forState: UIControlState.Normal)
            }else{
//                STPrint(items: "model:\(model)")
                setImage(UIImage(named: model.fullPngPath!), forState: UIControlState.Normal)
                setTitle(nil, forState: UIControlState.Normal)
            }
        }
    }

}
