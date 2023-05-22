//
//  ScheduleModel.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import Foundation

// MARK: - ScheduleModelElement
struct ScheduleModelElement: Codable {
    let id, title, subtitle, date: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, date
        case imageURL = "imageUrl"
    }
}

typealias ScheduleModel = [ScheduleModelElement]
