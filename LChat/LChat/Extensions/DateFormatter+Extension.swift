//
//  DateFormatter+Extension.swift
//  LingoChat
//
//  Created by Егор on 28.02.2021.
//

import Foundation

extension DateFormatter {
    
     func isYesterday(date: String, format: String) -> Bool {
        
        var isYesterday = false
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let datefromStr = formatter.date(from: date), let yesterday = yesterday {
            
            formatter.dateFormat = "yyyy-MM-dd"
            let day = formatter.string(from: datefromStr)
            let yesterdayStr = formatter.string(from: yesterday)
            
            if day == yesterdayStr {
                            
                isYesterday = true
                
            } else {
                isYesterday = false
            }
        }
        return isYesterday
    }
    
    
    
    func isToday(date: String, withFormat format: String) -> Bool {
        
        var isToday = false
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let dateFromStr = formatter.date(from: date) {
          
            formatter.dateFormat = "yyyy MM dd"
            
            let nowToStr = formatter.string(from: now)
            let dateToStr = formatter.string(from: dateFromStr)
            
            if nowToStr == dateToStr {
                
                isToday = true
            }
        }
        
        return isToday
    }


    
    
    
    func convertDate(string: String, fromFormat: String, toFormat: String) -> String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        
        if let date = formatter.date(from: string) {
            
            formatter.dateFormat = toFormat
            let convertedDate = formatter.string(from: date)
            
            return convertedDate
            
        } else {
            
            return nil
        }
    }
}
