//
//  STKeyBoardView.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/22.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

//自定义DEBUG下打印：buildSetting -> 搜索 swift flag,在DEBUG模式下配置 -D DEBUG
func STPrint(file: String = __FILE__, line: Int = __LINE__, items: Any){
    #if DEBUG
        print("文件：\((file as NSString).lastPathComponent), 行数: \(line)  ==> \(items)")
    #endif
}
// MARK: - ====================================
// MARK: STKeyBoardView 键盘整体 view
// MARK: ====================================
class STKeyBoardView: UIView {

    /// 关联外部 UITextView
    var textView:UITextView?
    
    
    private var num:Int = 0

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
        setupUI()
    }
    private func setupUI(){
        self.backgroundColor = UIColor.blackColor()
        
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        self.addSubview(emoticonToolBar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints=false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        emoticonToolBar.translatesAutoresizingMaskIntoConstraints=false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cv":self.collectionView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tb":self.emoticonToolBar]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-[tb(tb_H)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["tb_H":44], views: ["cv":self.collectionView,"tb":self.emoticonToolBar]))
        
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pc]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["pc":self.pageControl]))
//        
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-147-[pc]-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["pc":self.pageControl]))
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: emoticonToolBar, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: emoticonToolBar, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.frame.size
//        STPrint(items: "\(layout.itemSize)")
    }
    
    // MARK: UICollectionView基本设置
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 水平滚动
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 创建collectionView
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        cv.backgroundView = UIImageView(image: UIImage(named: "emoticon_keyboard_background"))
        // 注册cell,使用自定义的cell
        cv.registerClass(STEmoticonPageCell.self, forCellWithReuseIdentifier:"cell")
        // 取消弹簧效果
        cv.bounces = false
        // 分页
        cv.pagingEnabled = true
        // 实现数据源
        cv.dataSource = self
        cv.delegate = self
//        cv.contentOffset = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
        return cv
    }()
    
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        
        
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        /// 打印，动态获取显示私有属性
//        UIPageControl.printIvarList()
        
        return pageControl
    }()
    
    private lazy var emoticonToolBar:STEmoticonToolBar = {
        let toolBar = STEmoticonToolBar()
        toolBar.delegate = self
        return toolBar
    }()
    // TODO: 测试,每组的cell数量
//    private var cellCounts = [1, 6, 4, 2]
}
// MARK: - =====++++++ 遵循协议 ++++++=====
extension STKeyBoardView:UICollectionViewDataSource,UICollectionViewDelegate,STEmoticonToolBarDelegate{
    /// STEmoticonToolBarDelegate
    func didSelectButtonType(type: STEmoticonToolBarType) {
//        let num = type.rawValue
//        STPrint(items: "选择了 ==> \(num)")
        let indexPath = NSIndexPath(forItem: 0, inSection: type.rawValue)
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
        setPageControl(indexPath)
    }
    /// UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return STEmoticonViewModel.shareManager.packageModelArray.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 当前组没有表情图片时，创建一个空对象返回，不然点击其它选项时会崩！！！
        let rowCount = STEmoticonViewModel.shareManager.packageModelArray[section].pageEmoticonArray.count
        
        return rowCount
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! STEmoticonPageCell
        
        cell.indexPath = indexPath
//        cell.backgroundColor = UIColor.randomColor()
        // 获取到cell对应这页的模型
        // 总表情包数组（管理）--> 每一个表情包
        cell.pageEmoticon = STEmoticonViewModel.shareManager.packageModelArray[indexPath.section].pageEmoticonArray[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    /// UICollectionViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var centerPoint = collectionView.center
        centerPoint.x += scrollView.contentOffset.x
        /// 获得可见cell数组
        for cell in collectionView.visibleCells(){
            if cell.frame.contains(centerPoint){
                let indexPath = collectionView.indexPathForCell(cell)
                emoticonToolBar.switchSelectedButtonWitchSection(indexPath!.section)
                /// 设置 pageControl 的页数和当前页
                setPageControl(indexPath!)
            }
        }
    }
    /// 根据传入的索引，设置 pageControl 的页数和当前页
    private func setPageControl(indexPath:NSIndexPath){
        let count = STEmoticonViewModel.shareManager.packageModelArray[indexPath.section].pageEmoticonArray.count
        pageControl.numberOfPages = count
        pageControl.currentPage = indexPath.item
    }
}
// MARK: - 遵循表情按钮点击代理协议
extension STKeyBoardView:STEmoticonPageCellDelegate {
    /// 点击表情删除按钮
    func emoticonPageCellDidClickDeleteButton() {
//        STPrint(items: "点击了删除表情按钮")
        textView?.deleteBackward()
    }
    /// 点击表情按钮
    func emoticonPageCellDidClickEmoticonButton(emoticonModel: STEmoticonModel) {
//        STPrint(items: "STEmoticonModel ：\(emoticonModel)")
        // 将模型对应的内容添加到textView上面
//        self.addEmoticonModel(emoticonModel)
        textView?.insertEmoticon(emoticonModel)
        STEmoticonViewModel.shareManager.addEmoticonToRecentEmoticon(emoticonModel)
    }
    /// 将模型对应的内容添加到textView上面
//    private func addEmoticonModel(emoticonModel: STEmoticonModel){
//        guard let textV = textView else{
//            STPrint(items: "没有关联 UItextView！")
//            return
//        }
//        
//        if let emoji = emoticonModel.codeIconString{
//            textV.insertText(emoji)
//        }
//    }
}
// MARK: ====================================
// MARK: - === Tool 协议 ===
protocol STEmoticonToolBarDelegate: NSObjectProtocol {
    // 2.定义协议方法
    func didSelectButtonType(type: STEmoticonToolBarType)
}
// MARK: - === Tool 枚举 ===
enum STEmoticonToolBarType: Int {
    case Recent     // 最近
    case Default    // 默认
    case Emoji      // emoji
    case Lxh        // 浪小花
}
// MARK: - ====================================
// MARK: ToolView 工具视图栏
// MARK: ====================================
/// 表情键盘toolBar
class STEmoticonToolBar: UIView {
    
    weak var delegate:STEmoticonToolBarDelegate?
    /// 记录当前哪个按钮选中了
    private var selectedButton: UIButton?
    /// 按钮数组,便于布局
    private var buttonArray = [UIButton]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    // MARK: - 设置UI
    private func prepareUI() {
        backgroundColor = UIColor.lightGrayColor()
        
        /// ToolView TitleArray
        let toolTitles:[String] = ["最近","默认","Emoji","浪小花"]
        
        for i in 0..<toolTitles.count{
        
            let button = UIButton(type: UIButtonType.Custom)
            button.setTitle(toolTitles[i], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_normal"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_selected"), forState: UIControlState.Highlighted)
            button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_selected"), forState: UIControlState.Selected)
            button.tag = i
            // 按钮添加点击事件
            button.addTarget(self, action: "didClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            self.buttonArray.append(button)
        }
        self.switchSelectedButtonWitchSection(0)
    }
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算一个按钮的宽度
        let buttonWidth = self.frame.width / CGFloat(buttonArray.count)
        // 设置按钮的frame
        var index = 0
        for button in buttonArray {
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: self.frame.height)
            index++
        }
    }
    /// 切换按钮选择状态
    private func switchSelectedButton(button: UIButton) {
        // 0.如果要选中的button已经选中了,不需要再去选中了
        if button == selectedButton { return }
        // 1.将之前的选中按钮设置为不选中
        selectedButton?.selected = false
        // 2.设置传入按钮为选中状态
        button.selected = true
        // 3.记录下传入的按钮为选中的按钮
        selectedButton = button
    }
    // MARK: - Button Action
    // MARK: - 点击事件
    @objc private func didClickButton(button: UIButton) {
        let type = STEmoticonToolBarType(rawValue: button.tag)!
//        STPrint(items: "\(type)")
        // 选中点击的按钮
        switchSelectedButton(button)
        // 告诉外面的对象选中了一个按钮
        // 4.调用代理方法
        delegate?.didSelectButtonType(type)
    }
    // MARK: - ToolBar 公开方法
    /// 根据索引下标，切换选中按钮
    func switchSelectedButtonWitchSection(section: Int) {
        // 获取section对应的按钮
        switchSelectedButton(buttonArray[section])
    }
}


















