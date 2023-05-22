//
//  ScheduleViewModel.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import Foundation

class ScheduleViewModel {
    var schedule: ScheduleModel = []
    let apiFetcher = APIFetcher()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func fetchScheduleData(completion: @escaping (Error?) -> Void) {
        apiFetcher.fetchSchedule { [self] (schedule, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if var schedule = schedule {
               //  Filter the schedule for tomorrow only
//                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//                schedule = schedule.filter {
//                    guard let date = dateFormatter.date(from: $0.date) else { return false }
//                    return date.startOfDay == tomorrow?.startOfDay
//                }
                
                schedule.sort {
                    guard let date1 = dateFormatter.date(from: $0.date),
                          let date2 = dateFormatter.date(from: $1.date) else { return false }
                    return date1 < date2
                }
                
                self.schedule = schedule
                completion(nil)
            }

        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
