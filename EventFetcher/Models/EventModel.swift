//
//  EventModel.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

// MARK: - EventsModelElement
struct EventModelElement: Codable {
    let id, title, subtitle, date: String
    let imageURL: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, date
        case imageURL = "imageUrl"
        case videoURL = "videoUrl"
    }
}

typealias EventModel = [EventModelElement]
