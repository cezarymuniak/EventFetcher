//
//  APIFetcher.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import Foundation

class APIFetcher {
    let eventsURL = URL(string: "https://us-central1-dazn-sandbox.cloudfunctions.net/getEvents")!
    let scheduleURL = URL(string: "https://us-central1-dazn-sandbox.cloudfunctions.net/getSchedule")!


    func fetchEvents(completion: @escaping (EventModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: eventsURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let events = try decoder.decode(EventModel.self, from: data)
                completion(events, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
    
    
    func fetchSchedule(completion: @escaping (ScheduleModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: scheduleURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let events = try decoder.decode(ScheduleModel.self, from: data)
                completion(events, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
    
    
}
