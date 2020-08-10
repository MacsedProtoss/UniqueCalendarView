//
//  UCVCalendarUtil.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//

import Foundation

internal class UCVCalendarUtil {
    
    private let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    private let daysOfMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    func getMonthDayCount(ofYear year : Int,ofMonth month : Int) -> Int{
        
        var count = daysOfMonth[month - 1]
    
        if (year%4==0 && year%100 != 0) || year%400 == 0{
            if month == 2{
                count = 29
            }
        }
        
        return count
    }
    
    func getMonthIndex(ofYear year:Int,ofMonth month : Int) -> Int{
        let startYear = getStartYear()
        let startMonth = getStartMonth()
        
        return (year-startYear)*12 + (month-startMonth)
    }
    
    func getFirstDayOfMonth(ofYear year : Int,ofMonth month : Int) -> Int{
        if let date = formatter.date(from: "\(year)-\(month)-01"){
            let calendar = Calendar.current
            let components = calendar.dateComponents(in: .current, from: date)
            if let weekday = components.weekday{
                return weekday
            }else{
                fatalError("创建日历时无法计算weekday")
            }
            
        }else{
            fatalError("创建日历选项时遇见错误的日期")
        }
    }
    
    static let shared = UCVCalendarUtil()
    
    func getCellCount(ofYear year : Int,ofMonth month : Int) -> Int{
        
        return getFirstDayOfMonth(ofYear: year, ofMonth: month) + getMonthDayCount(ofYear: year, ofMonth: month) - 1

    }
    
    func isToday(ofYear year : Int,ofMonth month : Int,ofDay day : Int) -> Bool{
        
        let today = Date()
        
        let currentDate = formatter.string(from: today)
        
        var todayString = "\(year)-"
        
        if month < 10{
            todayString = todayString + "0" + "\(month)-"
        }else{
            todayString = todayString + "\(month)-"
        }
        
        if day < 10{
            todayString = todayString + "0" + "\(day)"
        }else{
            todayString = todayString + "\(day)"
        }
        
        return (currentDate == todayString)
        
    }
    
    func getStartYear() -> Int{
        let date = Date()
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return Int(f.string(from: date))! - 1
    }
    
    func getStartMonth() -> Int{
        let date = Date()
        let f = DateFormatter()
        f.dateFormat = "MM"
        return Int(f.string(from: date))!
    }
    
    func getDayCellIndex(date : Date) -> Int{
        
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        let year = Int(f.string(from: date))!
        f.dateFormat = "MM"
        let month = Int(f.string(from: date))!
        f.dateFormat = "dd"
        let day = Int(f.string(from: date))!
        
        let start = getFirstDayOfMonth(ofYear: year, ofMonth: month)
        
        return start + day - 2
    }
    
    func getMonthCellIndex(date selectDate : Date) -> Int{
        let currentDate = Date()
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        let currentYear = Int(f.string(from: currentDate))!
        let selectYear = Int(f.string(from: selectDate))!
        var output = 12 * (selectYear - currentYear + 1)
        
        f.dateFormat = "MM"
        let currentMonth = Int(f.string(from: currentDate))!
        let selectMonth = Int(f.string(from: selectDate))!
        
        output += (selectMonth - currentMonth)
        
        return output
    }
    
    func getDateByYMD(byYear year: Int,byMonth month : Int,byDay day : Int) -> Date{
        
        var todayString = "\(year)-"
        
        if month < 10{
            todayString = todayString + "0" + "\(month)-"
        }else{
            todayString = todayString + "\(month)-"
        }
        
        if day < 10{
            todayString = todayString + "0" + "\(day)"
        }else{
            todayString = todayString + "\(day)"
        }
        
        return formatter.date(from: todayString)!
        
    }
    
    func getDatesFromInterval(startDate start: Date,endDate end : Date) -> [Date]{
        
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        let startYear = Int(f.string(from: start))!
        f.dateFormat = "MM"
        let startMonth = Int(f.string(from: start))!
        f.dateFormat = "dd"
        let startDay = Int(f.string(from: start))!

        f.dateFormat = "yyyy"
        let endYear = Int(f.string(from: end))!
        f.dateFormat = "MM"
        let endMonth = Int(f.string(from: end))!
        f.dateFormat = "dd"
        let endDay = Int(f.string(from: end))!

        var tempYear = startYear
        var tempMonth = startMonth
        var tempDay = startDay
        
        var output : [Date] = []
        
        while !(tempYear == endYear && tempMonth == endMonth && tempDay == endDay) {
            
            let today = getDateByYMD(byYear: tempYear, byMonth: tempMonth, byDay: tempDay)
            output.append(today)
            
            let next = today.addingTimeInterval(24*60*60)
            
            f.dateFormat = "yyyy"
            tempYear = Int(f.string(from: next))!
            f.dateFormat = "MM"
            tempMonth = Int(f.string(from: next))!
            f.dateFormat = "dd"
            tempDay = Int(f.string(from: next))!
            
        }
        
        output.append(getDateByYMD(byYear: endYear, byMonth: endMonth, byDay: endDay))
        
        return output
    }
    
    
    func isAhead(from start:Date , date : Date) -> Bool{
        
        let f = DateFormatter()
        let ahead = start.addingTimeInterval(-24*60*60)
        f.dateFormat = "yyyy"
        let aheadYear = Int(f.string(from: ahead))!
        f.dateFormat = "MM"
        let aheadMonth = Int(f.string(from: ahead))!
        f.dateFormat = "dd"
        let aheadDay = Int(f.string(from: ahead))!
        
        f.dateFormat = "yyyy"
        let nowYear = Int(f.string(from: date))!
        f.dateFormat = "MM"
        let nowMonth = Int(f.string(from: date))!
        f.dateFormat = "dd"
        let nowDay = Int(f.string(from: date))!
        
        return (nowYear==aheadYear && nowMonth==aheadMonth && nowDay==aheadDay)
        
    }
    
    func isBehind(from end : Date , date : Date) -> Bool{
        let f = DateFormatter()
        let behind = end.addingTimeInterval(24*60*60)
        f.dateFormat = "yyyy"
        let behindYear = Int(f.string(from: behind))!
        f.dateFormat = "MM"
        let behindMonth = Int(f.string(from: behind))!
        f.dateFormat = "dd"
        let behindDay = Int(f.string(from: behind))!
        
        f.dateFormat = "yyyy"
        let nowYear = Int(f.string(from: date))!
        f.dateFormat = "MM"
        let nowMonth = Int(f.string(from: date))!
        f.dateFormat = "dd"
        let nowDay = Int(f.string(from: date))!
        
        return (nowYear==behindYear && nowMonth==behindMonth && nowDay==behindDay)
    }
    
    func getIntervalWithBorders(from start:Date,to end:Date,withBorders borders: [Int]) -> [(Date,Date)]{
        
        let leftBorder = convertRowToInterval(row: borders[0]).0
        let rightBorder = convertRowToInterval(row: borders[borders.count-1]).1
//        print(leftBorder.CNtoString)
//        print(rightBorder.CNtoString)
        
        if start.compare(leftBorder) == .orderedAscending{
            if end.compare(leftBorder) == .orderedAscending{
                return []
            }else if end.compare(leftBorder) == .orderedSame{
                return [(leftBorder,leftBorder)]
            }else if end.compare(leftBorder) == .orderedDescending{
                if end.compare(rightBorder) == . orderedDescending{
                    return [(leftBorder,rightBorder)]
                }else{
                    return [(leftBorder,end)]
                }
            }
        }else if start.compare(leftBorder) == .orderedDescending{
            
            if start.compare(rightBorder) == .orderedDescending{
                return []
            }else if start.compare(rightBorder) == .orderedSame{
                return [(rightBorder,rightBorder)]
            }else{
                if end.compare(rightBorder) == .orderedDescending{
                    return [(start,rightBorder)]
                }else{
                    return [(start,end)]
                }
            }
            
        }else{
            if end.compare(rightBorder) == .orderedDescending{
                return [(leftBorder,rightBorder)]
            }else{
                return [(leftBorder,end)]
            }
        }
        
        
        return[]
    }
    
    private func convertRowToInterval(row :Int) -> (Date,Date){
        
        let month = (getStartMonth() + row)%12==0 ? 12 : (getStartMonth() + row)%12
        let year = getStartYear() + ((getStartMonth() + row)%12 == 0 ? (getStartMonth() + row - 1)/12 : (getStartMonth() + row)/12)
        
        let startDay = getDateByYMD(byYear: year, byMonth: month, byDay: 1)
        let endDay = getDateByYMD(byYear: year, byMonth: month, byDay: getCellCount(ofYear: year, ofMonth: month) - getFirstDayOfMonth(ofYear: year, ofMonth: month) + 1)
        
        return (startDay,endDay)
        
    }
    
}

