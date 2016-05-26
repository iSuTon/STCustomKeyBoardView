
//
//  UITextView+Extension.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/24.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

/// 功能：实现 图片--->对应的字符串显示

extension UITextView{
    
    ///  获取表情图片对应名称
    func getEmoticonNameText() -> String {
        
        var resultString = ""
        // 遍历textView.attributedText的每一段,拼接起来
        self.attributedText.enumerateAttributesInRange(NSRange(location: 0, length: self.attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (infoDict, range, _) -> Void in
            
            if let attachment = infoDict["NSAttachment"] as? STTextAttachment{
                /// 附件
                resultString += attachment.chs!
            }else{
                // 截取,文字, emoji
                let text = (self.attributedText.string as NSString).substringWithRange(range)
                resultString += text
            }
        }
        return resultString
    }
    /// 将模型对应的内容添加到textView上面
    func insertEmoticon(emoticonModel: STEmoticonModel) {
        // 添加emoji表情
        if let emoji = emoticonModel.codeIconString {
            self.insertText(emoji)
        } else {
            // 图片
            // 1.附件
            let attachment = STTextAttachment()
            // 2.附件设置图片大小
            attachment.image = UIImage(named: emoticonModel.fullPngPath!)
            // 根据 textView 的 UIFont 来设置字体大小
            let wh = self.font!.lineHeight * 0.85
            // 2.1设置附件的大小
            attachment.bounds = CGRect(x: 0, y: -3, width: wh, height: wh)
            // 2.2设置附件的名称
            attachment.chs = emoticonModel.chs
            
            // 3.将附件转成属性文本
            let imageAttr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            // 3.1附件缺少文本属性,在后面的附件都会变得很小
            imageAttr.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: 1))
            
            // 3.1获取之前的内容
            let beforeAttr = NSMutableAttributedString(attributedString: self.attributedText)
            
            // 3.2 获取textView选中的范围
            let textSelectedRange = self.selectedRange
            // 3.3将带附件的属性文本替换到之前的内容里面来
            beforeAttr.replaceCharactersInRange(textSelectedRange, withAttributedString: imageAttr)
            
            // 4.将设置后的属性文本赋值回来
            self.attributedText = beforeAttr
            
            // 4.1设置光标位置
            self.selectedRange = NSRange(location: textSelectedRange.location + 1, length: 0)
        }
    }
}


