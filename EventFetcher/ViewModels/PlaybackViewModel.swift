//
//  PlaybackViewModel.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import AVFoundation

class PlaybackViewModel {
    var videoURL: URL?
    var player: AVPlayer?
    
    init(videoURL: URL?) {
        self.videoURL = videoURL
        if let videoURL = videoURL {
            player = AVPlayer(url: videoURL)
        }
    }
    
    func playPause() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }
}
