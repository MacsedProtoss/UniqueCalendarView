//
//  UCVCache.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//

import Foundation
import UIKit

internal struct UCVCache {
    var data : [UCVMonthData]
}

internal struct UCVMonthData {
    var year : Int
    var month : Int
    var firstDay : Int
    var height : CGFloat
    var data : [UCVDayData]
}

internal struct UCVDayData{
    var isToday : Bool
    var year : Int
    var month : Int
    var day : Int
}

internal struct UCVDayCellConstant {
    var base : CGFloat
    var reSized40 : CGFloat
    var reSized20 : CGFloat
}

internal let UCVDayCellCache = UCVDayCellConstant(base: (380.0/7).reSized, reSized40: 40.reSized, reSized20: 20.reSized)

internal class UCVCacheBuilder{
    
    let lock = NSObject()
    
    var CalendarCache : UCVCache{
        get{
            objc_sync_enter(lock)
            let output = _CalendarCache
            objc_sync_exit(lock)
            return output
        }
        set{
            objc_sync_enter(lock)
            _CalendarCache = newValue
            objc_sync_exit(lock)
        }
    }
    
    private var _CalendarCache : UCVCache = UCVCache(data: [])
    
    func GetCache(completion:((Bool)->Void)?){
        DispatchQueue.global().async {
            var output = UCVCache(data: [])
            
            for row in 0..<36{
                let month = (UCVCalendarUtil.shared.getStartMonth() + row)%12==0 ? 12 : (UCVCalendarUtil.shared.getStartMonth() + row)%12
                let year = UCVCalendarUtil.shared.getStartYear() + ((UCVCalendarUtil.shared.getStartMonth() + row)%12 == 0 ? (UCVCalendarUtil.shared.getStartMonth() + row - 1)/12 : (UCVCalendarUtil.shared.getStartMonth() + row)/12)
                let count = UCVCalendarUtil.shared.getCellCount(ofYear: year, ofMonth: month)
                
                let height = 49.reSized + CGFloat(count/7 + 1)*40.reSized + CGFloat(count/7)*16.reSized + 31.reSized
                
                let firstDay = UCVCalendarUtil.shared.getFirstDayOfMonth(ofYear: year, ofMonth: month)
                
                var temp = UCVMonthData(year: year, month: month, firstDay: firstDay, height: height, data: [])
                
                for day in 1...count{
                    let isToday = UCVCalendarUtil.shared.isToday(ofYear: year, ofMonth: month, ofDay: day)
                    let dayData = UCVDayData(isToday: isToday, year: year, month: month, day: day)
                    temp.data.append(dayData)
                }
                
                output.data.append(temp)
                
            }
            
            self.CalendarCache = output
            if (completion != nil){
                completion!(true)
            }
        }
    }
    
}

