//
//  STEmoticonViewModel.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/23.
//  Copyright © 2016年 SuTon. All rights reserved.
//
// MARK: - 管理 EmoticonModel
import UIKit

/// 表情包全路径
let emoticonFilePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")!
/// 管理 EmoticonModel
class STEmoticonViewModel: NSObject {

    static let shareManager:STEmoticonViewModel = STEmoticonViewModel()
    private override init() {
        super.init()
    }
    
    /// 懒加载，只加载一次即可
    lazy var packageModelArray:[STEmoticonPackageModel] = self.loadPackageModelArray()

    /// 归档到的文件路径
    private let writeToFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/emoticons.plist"
    
    /// 加载表情包，返回多个表情包模型数组
    private func loadPackageModelArray()->[STEmoticonPackageModel]{
        let recent = STEmoticonPackageModel(id: "", group_name_cn: "最近", emoticons: loadRecentEmoticons())
        let defaultModel=loadEmoticonData("com.sina.default")
        let emoji = loadEmoticonData("com.apple.emoji")
        let lxh = loadEmoticonData("com.sina.lxh")
        
        return [recent,defaultModel,emoji,lxh]
    }
    /// 拼接路径，加载数据，返回一个表情包模型
    private func loadEmoticonData(id:String) -> STEmoticonPackageModel{
        /// 拼接 info.plist 路径
        let infoPath = emoticonFilePath+"/"+id+"/info.plist"
        /// 读取info.plist里面的内容
        let infoDict = NSDictionary(contentsOfFile: infoPath)!
//        STPrint(items: "加载到了info.plist数据：\(infoDict)")
        // 获取infoDict里面的内容
        let group_name_cn = infoDict["group_name_cn"] as! String
        let emoticonsArr = infoDict["emoticons"] as! [[String: String]]
        // 定义空数组存放表情模型
        var emoticonModelArray = [STEmoticonModel]()
        for dict in emoticonsArr{
            /// 将数组中的字典封装成一个对象，然后加入到表情模型数组中
            emoticonModelArray.append(STEmoticonModel(dict: dict,id: id))
        }
        return STEmoticonPackageModel(id: id, group_name_cn: group_name_cn, emoticons: emoticonModelArray)
    }
    /// 传入点击按钮获取到的模型，添加到最近使用表情组中
    func addEmoticonToRecentEmoticon(emoitconModel: STEmoticonModel){
        // 获取最近这组的第一页数据
        var pageEmoticon = packageModelArray[0].pageEmoticonArray[0]
        
        // 判断里面是否已存在，存在则把原有的删除，再在第一个位置插入新值
        var sameEmoticon:STEmoticonModel?
        
        for emoticon in pageEmoticon{
            // 1.判断类图片的字符串 2.判断图片的字符串
            if (emoticon.codeIconString != nil && emoticon.codeIconString == emoitconModel.codeIconString) || (emoticon.chs != nil && emoticon.chs == emoitconModel.chs){
                sameEmoticon = emoticon
                break
            }
        }
        // 若已存在则删除
        if let sameM = sameEmoticon{
            let index = pageEmoticon.indexOf(sameM)
            pageEmoticon.removeAtIndex(index!)
        }
        // 添加到数组的最前面
        pageEmoticon.insert(emoitconModel, atIndex: 0)
        // 判断是否超过20个。超过则移除最后一个
        if pageEmoticon.count > numberOfItemsAtPage{
            pageEmoticon.removeLast()
        }
        // 赋值
        packageModelArray[0].pageEmoticonArray[0] = pageEmoticon
//        STPrint(items: "writeToFilePath: \(writeToFilePath)")
        // 归档
        NSKeyedArchiver.archiveRootObject(pageEmoticon, toFile: writeToFilePath)
    }
    
    /// 加载最近表情：解档
    // 加载最近表情
    private func loadRecentEmoticons() -> [STEmoticonModel] {
        
        /// 归档的是 pageEmoticon = [STEmoticonModel]
        
        if let emoticons = NSKeyedUnarchiver.unarchiveObjectWithFile(writeToFilePath) as? [STEmoticonModel] {
            // 加载出表情数组
            return emoticons
        } else {
            // 没加载出来
            return [STEmoticonModel]()
        }
//        return [STEmoticonModel]()
    }
}
