//
//  EventFetcherTests.swift
//  EventFetcherTests
//
//  Created by Cezary Muniak on 21/05/2023.
//

import XCTest
import AVFoundation
@testable import EventFetcher

class EventFetcherTests: XCTestCase {
    
    var eventsViewModel: EventsViewModel!
    var scheduleViewModel: ScheduleViewModel!
    var playbackViewModel: PlaybackViewModel!
    var apiFetcher: APIFetcher!
    var videoURL: URL!

    
    override func setUp() {
        super.setUp()
        eventsViewModel = EventsViewModel()
        scheduleViewModel = ScheduleViewModel()
        playbackViewModel = PlaybackViewModel(videoURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/promo.mp4)"))
        videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/promo.mp4")
        apiFetcher = APIFetcher()
    }

    override func tearDown() {
        eventsViewModel = nil
        scheduleViewModel = nil
        playbackViewModel = nil
        apiFetcher = nil
        videoURL = nil
        super.tearDown()
    }
    
    func testURLPrefix() {
        let expectedPrefix = "https://firebasestorage.googleapis.com/v0/b/dazn-recruitment/o/"
        XCTAssertTrue(videoURL.absoluteString.hasPrefix(expectedPrefix), "Video URL does not start with expected prefix")
    }
    
    func testVideoURL() {
        XCTAssertEqual(playbackViewModel.videoURL, URL(string: "https://abc.com/video.mp4"))
    }
    
    func testDateFormatting() {
        let testDateString = "2023-05-22T06:32:03.574Z"
        let formattedDate = formatDate(testDateString)
        XCTAssertNotNil(formattedDate, "Date formatting failed.")
    }
    
    func testAPIFetcherFetchEvents() {
        let expectation = self.expectation(description: "Fetch events data")
        
        apiFetcher.fetchEvents { events, error in
            XCTAssertNil(error, "There was an error fetching events data: \(error?.localizedDescription ?? "")")
            XCTAssertNotNil(events, "No events were fetched.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAPIFetcherFetchSchedule() {
        let expectation = self.expectation(description: "Fetch schedule data")
        
        apiFetcher.fetchSchedule { schedule, error in
            XCTAssertNil(error, "There was an error fetching schedule data: \(error?.localizedDescription ?? "")")
            XCTAssertNotNil(schedule, "No schedule was fetched.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension EventFetcherTests {
    func formatDate(_ dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = formatter.date(from: dateString) {
            let calendar = Calendar.current
            let currentDate = calendar.startOfDay(for: Date())
            let targetDate = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: currentDate, to: targetDate)
            
            if let days = components.day {
                if days == 0 {
                    formatter.dateFormat = "'Today' HH:mm"
                } else if days == 1 {
                    formatter.dateFormat = "'Tomorrow' HH:mm"
                } else {
                    formatter.dateFormat = "'In \(days) days' HH:mm"
                }
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }

            return formatter.string(from: date)
        }

        return nil
    }
}
