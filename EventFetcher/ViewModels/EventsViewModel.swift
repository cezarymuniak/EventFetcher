//
//  EventsViewModel.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import Foundation

class EventsViewModel {
    var events: EventModel = []
    let apiFetcher = APIFetcher()
    
    func fetchEventsData(completion: @escaping (Error?) -> Void) {
        apiFetcher.fetchEvents { (events, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let events = events {
                self.events = events
                completion(nil)
            }
        }
    }
}
