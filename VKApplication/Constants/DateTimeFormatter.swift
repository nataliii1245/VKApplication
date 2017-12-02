//
//  DateTimeFormatter.swift
//  VKApplication
//
//  Created by Natalia Volkova on 02.12.2017.
//  Copyright © 2017 Nataliia Volkova. All rights reserved.
//

import Foundation

enum DateTimeFormatter {
    
    /// Часы и минуты (21:47)
    static let hoursAndMinutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    /// Полная дата (18.03.2017)
    static let completeDateShortMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter
    }()
    
}
