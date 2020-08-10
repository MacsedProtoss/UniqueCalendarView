//
//  UniqueCalendarView.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//
import Foundation
import UIKit

///UniqueCalendarView构造器
///
///同时只能最多存在一个UniqueCalendarView
public class UniqueCalendarViewBuilder{
    ///使用默认配置生成一个UniqueCalendarView
    /// - parameter type:UniqueCalendar模式 支持单选/多选
    /// - parameter delegate:UniqueCalendar回调代理，用于响应相关操作
    /// - returns:返回一个UIViewController，请手动管理其View位置和reference
    static func buildController(withType type:UCVCalendarType,withDelegate delegate:UCVDelegate?) -> UIViewController{
        memoryClean()
        let controller = UCVController(type: type)
        controller.delegate = delegate
        self.controller = controller
        return controller
    }
    ///使用自定义配置生成一个UniqueCalendarView
    /// - parameter type:UniqueCalendar模式 支持单选/多选
    /// - parameter config:UniqueCalendar配置文件，用于配置部分自定义内容
    /// - parameter delegate:UniqueCalendar回调代理，用于响应相关操作
    /// - returns:返回一个UIViewController，请手动管理其View位置和reference
    static func buildController(withType type:UCVCalendarType, withConfig config:UCVConfig,withDelegate delegate:UCVDelegate?) -> UIViewController{
        memoryClean()
        let controller = UCVController(type: type, config: config)
        controller.delegate = delegate
        self.controller = controller
        return controller
    }
    private static weak var controller : UCVController?
    private static func memoryClean(){
        if self.controller != nil {
            self.controller?.view.removeFromSuperview()
            self.controller?.removeFromParent()
        }
    }
}

///UniqueCalendar模式
public enum UCVCalendarType{
    ///单选模式
    case single
    ///多选模式
    case comble
}

///UniqueCalendar回调代理
public protocol UCVDelegate {
    ///View消失回调
    ///
    ///主动点击左上角返回按钮退出而非点击确定
    func calendarViewDismiss()
    ///点击确认回调
    ///
    ///单选模式
    func changeDateTo(date : Date)
    ///点击确认回调
    ///
    ///多选模式
    func changeDatesTo(dates : [Date])
}

///UniqueCalendar配置文件
///
///暂时只开放颜色和部分文字内容的配置，其他能力，诸如大小等暂时只提供自动自适应
public struct UCVConfig{
    ///背景颜色
    var backgroundColor : UIColor = UIColor.white
    ///顶部日期字体颜色
    var headerColor : UIColor = getColor(hexValue: 0x696F83, alpha: 1.0)
    ///星期标识（日～六）字体颜色
    var weekdayColor : UIColor = getColor(hexValue: 0x75798B, alpha: 0.8)
    ///月份标识（xx月）字体颜色
    var monthLabelColor : UIColor = getColor(hexValue: 0x49506C, alpha: 0.8)
    ///日期选项正常字体颜色
    var dayLabelColor : UIColor = getColor(hexValue: 0x49506C, alpha: 0.8)
    ///日期选项选中字体颜色
    var daySelectedLabelColor : UIColor = getColor(hexValue: 0x49506C, alpha: 0.8)
    ///日期选项多选选中背景颜色
    var dayMultiSelectedBgColor : UIColor = getColor(hexValue: 0x92A0F8, alpha: 1.0)
    ///日期选项单选选中背景颜色
    var daySingleSelectedBgColor : UIColor = getColor(hexValue: 0x6E748A, alpha: 0.35)
    ///确认按钮背景颜色
    var confirmButtonBgColor : UIColor = getColor(hexValue: 0x92A0F8, alpha: 1.0)
    ///确认按钮字体颜色
    var confirmButtonLabelColor : UIColor = UIColor.white
    ///确认按钮内容
    var confirmButtonLabelString : String = "确 认"
}
