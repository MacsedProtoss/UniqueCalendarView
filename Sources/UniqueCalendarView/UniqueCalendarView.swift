//
//  UniqueCalendarView.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//
import Foundation
import UIKit

///UniqueCalendarView入口
///
///同时只能最多存在一个UniqueCalendarView
public class UCV{
    ///使用默认配置生成一个UniqueCalendarView Manager
    /// - parameter type:UniqueCalendar模式 支持单选/多选
    /// - parameter delegate:UniqueCalendar回调代理，用于响应相关操作
    /// - returns:返回一个UniqueCalendarView Manager
    static func manager(withType type:UCVCalendarType,withDelegate delegate:UCVDelegate?) -> UniqueCalendarViewManager{
        return UniqueCalendarViewManager(withType: type, withDelegate: delegate)
    }
    ///使用自定义配置生成一个UniqueCalendarView Manager
    /// - parameter type:UniqueCalendar模式 支持单选/多选
    /// - parameter config:UniqueCalendar配置文件，用于配置部分自定义内容
    /// - parameter delegate:UniqueCalendar回调代理，用于响应相关操作
    /// - returns:返回一个UniqueCalendarView Manager
    static func manager(withType type:UCVCalendarType, withConfig config:UCVConfig,withDelegate delegate:UCVDelegate?) -> UniqueCalendarViewManager{
        return UniqueCalendarViewManager(withType: type, withConfig: config, withDelegate: delegate)
    }
    
}

public class UniqueCalendarViewManager{
    
    private var _controller : UCVController!
    private var type : UCVCalendarType!
    private var config : UCVConfig!
    
    private var cacheBuilder : UCVCacheBuilder!
    
    var delegate : UCVDelegate? {
        set{
            
            if (_controller != nil){
                _controller.delegate = newValue
            }
        }
        get {
            return _controller==nil ? nil : _controller.delegate
        }
    }
    
    
    func controller(getCompletion:@escaping((UIViewController) -> Void)){
        DispatchQueue.global().async {
            if (self._controller != nil){
                DispatchQueue.main.async {
                    getCompletion(self._controller)
                }
                return
            }else{
                self.controller(getCompletion: getCompletion)
                return
            }
        }
    }
    
    internal init(withType type:UCVCalendarType,withDelegate delegate:UCVDelegate?){
        self.type = type
        self.delegate = delegate
        prepareIfNeeded()
    }
    
    internal init(withType type:UCVCalendarType, withConfig config:UCVConfig,withDelegate delegate:UCVDelegate?){
        self.type = type
        self.delegate = delegate
        self.config = config
        prepareIfNeeded()
    }
    
    private func buildController(withType type:UCVCalendarType,withDelegate delegate:UCVDelegate?) {
        
        let controller = UCVController(type: type)
        controller.delegate = delegate
        self._controller = controller
    }
    
    private func buildController(withType type:UCVCalendarType, withConfig config:UCVConfig,withDelegate delegate:UCVDelegate?){
        
        let controller = UCVController(type: type, config: config)
        controller.delegate = delegate
        self._controller = controller
    }
    
    func prepareIfNeeded(){
        if (self.cacheBuilder == nil){
            self.cacheBuilder = UCVCacheBuilder()
            loadCache()
        }else if (self.cacheBuilder.CalendarCache.data.count == 0){
            loadCache()
        }
    }
    
    func loadCache(){
        cacheBuilder.GetCache(completion:{ (finished) in
            if (finished){
                if (self.config != nil){
                    self.buildController(withType: self.type, withConfig: self.config, withDelegate: self.delegate)
                }else{
                    self.buildController(withType: self.type, withDelegate: self.delegate)
                }
                self._controller.cache = self.cacheBuilder.CalendarCache
            }
        })
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
