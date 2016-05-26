//
//  NSObject+Extension.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/24.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// 利用runtime打印属性
    class func printIvarList(){
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self, &count)
        for var i=0;i<Int(count);i++ {
            let myIvar = ivars[i]
            let ivarName = ivar_getName(myIvar)
            let name = NSString(UTF8String: ivarName)
            STPrint(items: "name:\(name)")
        }
//        var outCount: UInt32 = 0
//        let ivars = class_copyIvarList(UIPageControl.self, &outCount)
//        for var i:UInt32  = 0; i<outCount; i++ {
//        
//            let ivar = ivars[Int(i)]
//            let cName = ivar_getName(ivar)
//            let name = String(CString: cName, encoding: NSUTF8StringEncoding)
//            print("name: \(name)")
//            
//            let cType = ivar_getTypeEncoding(ivar)
//            let type = String(CString: cType, encoding: NSUTF8StringEncoding)
//            print("type: \(type)")
    }
}


