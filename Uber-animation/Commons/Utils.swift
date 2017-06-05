//
//  Utils.swift
//  Uber-animation
//
//  Created by SL on 04/06/2017.
//  Copyright © 2017 SL. All rights reserved.
//

import UIKit

class Utils: NSObject {

}

public extension UIColor {
    public class func fuberBlue()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 15/255, green: 78/255, blue: 101/255, alpha: 1)
        }
        return C.c
    }
    
    public class func fuberLightBlue()->UIColor {
        struct C {
            static var c : UIColor = UIColor(red: 77/255, green: 181/255, blue: 217/255, alpha: 1)
        }
        return C.c
    }
}

/*
 @escaping 逃逸闭包 闭包在函数执行后被调用，比如网络请求回调
 @noescaping 非逃逸闭包 闭包在函数结束前被调用，比如masonry、snapkit添加约束的方法
 */
public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
