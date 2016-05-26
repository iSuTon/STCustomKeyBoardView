//
//  STEmoticonModel.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/23.
//  Copyright © 2016年 SuTon. All rights reserved.
//
// MARK: - ====================================
// MARK: STEmoticonModel 获取数据模型
// MARK: ====================================
import UIKit
/// 获取数据模型
class STEmoticonModel: NSObject,NSCoding {
    /// 模型所在文件夹名称
    var id: String
    
    // chs, 网络传输使用
    var chs: String?
    // png, 客户端显示的图片
    var png: String?{
        didSet{
            //拼成全路径
            fullPngPath = emoticonFilePath+"/"+id+"/"+png!
        }
    }
    /// 图片全路径
    var fullPngPath: String?{
        didSet{
//            STPrint(items: "fullPngPath:\(fullPngPath)")
        }
    }
    
    // code, emoji的16进制字符串
    var code: String?{
        didSet{
            let scanner = NSScanner(string: code!)
            var result:UInt32 = 0
            /// 扫描16进制字符串，转换为 整型
            scanner.scanHexInt(&result)
            codeIconString = String(Character(UnicodeScalar(result)))
        }
    }
    
    var codeIconString:String?
    // 字典转模型
    init(dict: [String: String], id:String) {
        self.id = id
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 字典中的key在模型中没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    // 打印方法
    override var description: String {
        get {
            return "\n\t\t 表情模型: chs: \(chs), png: \(png), code: \(code)"
        }
    }
    
    // MARK: - STEmoticonModel 解档+归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(chs, forKey: "chs")
        aCoder.encodeObject(png, forKey: "png")
        //aCoder.encodeObject(fullPngPath, forKey: "fullPngPath")
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(codeIconString, forKey: "codeIconString")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObjectForKey("id") as? String ?? ""
        chs = aDecoder.decodeObjectForKey("chs") as? String
        png = aDecoder.decodeObjectForKey("png") as? String
        //        fullPngPath = aDecoder.decodeObjectForKey("fullPngPath") as? String
        code = aDecoder.decodeObjectForKey("code") as? String
        codeIconString = aDecoder.decodeObjectForKey("codeIconString") as? String
        
        // 在init构造函数里面给属性赋值,不会触发 didSet
        // 重新拼接fullPngPath
        if let p = png {
            fullPngPath = emoticonFilePath + "/" + id + "/" + p
        }
    }
}
// MARK: - ====================================
// MARK:
// MARK: ====================================
//extension STEmoticonModel:NSCoding{
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeObjectForKey("id") as? String ?? ""
//        chs = aDecoder.decodeObjectForKey("chs") as? String
//        png = aDecoder.decodeObjectForKey("png") as? String
//        //        fullPngPath = aDecoder.decodeObjectForKey("fullPngPath") as? String
//        code = aDecoder.decodeObjectForKey("code") as? String
//        codeIconString = aDecoder.decodeObjectForKey("emoji") as? String
//        
//        // 在init构造函数里面给属性赋值,不会触发 didSet
//        // 重新拼接fullPngPath
//        if let p = png {
//            fullPngPath = emoticonFilePath + "/" + id + "/" + p
//        }
//    }
//    
//    
//}
// MARK: - ====================================
// MARK: STEmoticonPackageModel 获取表情包数据模型
// MARK: ====================================
/// 获取表情包数据模型
class STEmoticonPackageModel:NSObject{
    /// 表情包文件夹名称
    var id: String
    /// 表情包中文名称
    var group_name_cn: String
    /// 所有表情模型（该数组中包含有字典）
    var emoticons: [STEmoticonModel]
    
    /// 分页，每页放20个，注意数组越界问题
    //  外层为表情数据包，内层为每个表情数据包有多少模型，一个模型为一页
    var pageEmoticonArray:[[STEmoticonModel]] = [[STEmoticonModel]]()
    
    
    init(id: String, group_name_cn: String, emoticons: [STEmoticonModel]) {
        self.id = id
        self.group_name_cn = group_name_cn
        self.emoticons = emoticons
        super.init()
        // 将所有表情模型分成多页,到一个cell要显示的时候,直接将这页数据给cell就好了
        spliteEmoticons()
    }
    /// 将每个表情包中的 emoticon 个数按 20个为一组分开，一组即一页即一模型
    // 注意不够20个时的数组越界问题
    private func spliteEmoticons(){
        // 计算有多少行 = (总数 + 总列数 - 1) / 总列数
        // 计算有多少页 = (总数 + 一页的个数 - 1) / 一页个数
        /// 总页数
        let pageCount = (emoticons.count + numberOfItemsAtPage - 1)/numberOfItemsAtPage
        if pageCount == 0{
            pageEmoticonArray.append([STEmoticonModel]())
            return
        }
        
        /// 分组
        for i in 0..<pageCount{
            
            //每组的第一个起始位置
            let location = i * numberOfItemsAtPage
            var lenght = numberOfItemsAtPage
            if emoticons.count-location<numberOfItemsAtPage{
                lenght = emoticons.count-location
            }
            /// 截取数组, 重一个数组里面根据范围截取需要的数组
            let pageModelArray = (emoticons as NSArray).subarrayWithRange(NSRange(location: location, length: lenght)) as! [STEmoticonModel]
//            STPrint(items: "\(pageModelArray)")//打印每页数据
            pageEmoticonArray.append(pageModelArray)
        }
    }
    
    // 对象打印方法
    override var description: String {
        get {
            return "\n \t 表情包模型: id: \(id), group_name_cn: \(group_name_cn), emoticons: \(emoticons)"
        }
    }
}











