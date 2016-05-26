//
//  STEmoticonPageCell.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/22.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

// 一个页按钮个数 20
let numberOfItemsAtPage = 20
// 一页有多少列 7
private let numberOfItemsAtColumn = 7
// 一页有多少行 3
private let numberOfItemsAtRow = 3

// MARK: - ====================================
// MARK: STEmoticonPageCell 代理
// MARK: ====================================
protocol STEmoticonPageCellDelegate:NSObjectProtocol{
    
    // 点击删除按钮
    func emoticonPageCellDidClickDeleteButton()
    // 点击表情按钮
    func emoticonPageCellDidClickEmoticonButton(emoticonModel: STEmoticonModel)

}
// MARK: - ====================================
// MARK: STEmoticonPageCell
// MARK: ====================================
class STEmoticonPageCell: UICollectionViewCell {
    
    weak var delegate:STEmoticonPageCellDelegate?
    
    var indexPath: NSIndexPath?{
        didSet{
//            STPrint(items: "indexPath==>\(indexPath?.section)\(indexPath?.item)")
            recentLabel.hidden = indexPath?.section != 0
        }
    }
    
    /// cell一页需要的模型
    var pageEmoticon: [STEmoticonModel]?{
        didSet{

//            STPrint(items: "来数据了==》》》\(pageEmoticon)")
            for button in emoticonButtons{
                button.hidden = true
            }
            // 遍历 获取 一个模型和对应的按钮
            for i in 0..<pageEmoticon!.count{
                // 获取到这个模型对应的按钮
                let button = emoticonButtons[i]                
                // 按钮显示模型数据
                button.emoticonModel = pageEmoticon![i]
                // 需要显示模型的按钮显示出来
                button.hidden=false
            }
        }
    }
    
    /// 20个表情按钮,方便后面使用,遍历
    private var emoticonButtons = [STEmoticonButton]()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.clearColor()
        setupUI()
    }
    private func setupUI() {
        contentView.backgroundColor = UIColor.whiteColor()
        // 添加20个表情按钮
        addEmoticonButtons()
        contentView.addSubview(deleteButton)
        contentView.addSubview(recentLabel)
    }
    /// 添加20个表情按钮
    private func addEmoticonButtons() {
        for _ in 0..<numberOfItemsAtPage {
            let button = STEmoticonButton()
            button.backgroundColor = UIColor.clearColor()
            // 设置字体
            button.titleLabel?.font = UIFont.systemFontOfSize(32)
            button.addTarget(self, action: Selector("didClickEmoticonButton:"), forControlEvents: UIControlEvents.TouchUpInside)
            // 添加到cell里面
            contentView.addSubview(button)
            // 添加到表情数组,方便后面遍历
            emoticonButtons.append(button)
        }
    }
    // MARK: - Button Action
    /// 表情按钮的点击事件：设置代理，传出该点击按钮的模型
    @objc private func didClickEmoticonButton(button:STEmoticonButton){
//        STPrint(items: "按钮的模型：\(button.emoticonModel)")
        delegate?.emoticonPageCellDidClickEmoticonButton(button.emoticonModel!)
    }
    @objc private func didClickDeleteButton(){
        
        delegate?.emoticonPageCellDidClickDeleteButton()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        /// 距离最左边，最右边间距
        let margin_L_R:CGFloat = 5
        /// 距离底部toolBar的高度
        let margin_H:CGFloat = 25
        
        let buttonW = (self.frame.width-2*margin_L_R)/CGFloat(numberOfItemsAtColumn)
        let buttonH = (self.frame.height-margin_H)/CGFloat(numberOfItemsAtRow)
        
        var index = 0
        for button in emoticonButtons{
            // 计算按钮在哪行
            let row = index / numberOfItemsAtColumn
            // 计算按钮在哪列
            let column = index % numberOfItemsAtColumn
            let buttonX = margin_L_R+buttonW*CGFloat(column)
            let buttonY = buttonH*CGFloat(row)
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            index++
        }
        // 计算删除按钮的frame
        // 删除按钮的列数和行数是固定的
        let deleteX = margin_L_R + CGFloat(numberOfItemsAtColumn - 1) * buttonW
        let deleteY = CGFloat(numberOfItemsAtRow - 1) * buttonH
        deleteButton.frame = CGRect(x: deleteX, y: deleteY, width: buttonW, height: buttonH)
        
        /// 计算 "最近使用表情"Label frame
        recentLabel.center=CGPoint(x: self.center.x, y: self.frame.height-recentLabel.frame.height*0.5)

    }
    /// 删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        // 设置图片
        button.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: Selector("didClickDeleteButton"), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    /// 在"最近"页面创建 "最近使用表情"Label
    private var recentLabel:UILabel = {
        let recentLabel = UILabel()
        recentLabel.text = "最近使用表情"
        recentLabel.textColor = UIColor.lightGrayColor()
        recentLabel.font = UIFont.systemFontOfSize(13.0)
        recentLabel.textAlignment = NSTextAlignment.Center
        recentLabel.sizeToFit()
        return recentLabel
    }()
    
    
    
}
