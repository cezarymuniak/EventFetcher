//
//  EventsViewController.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import UIKit

class EventsViewController: UITableViewController {
    
    var viewModel: EventsViewModel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        viewModel = EventsViewModel()
        
        // Initialize activity indicator
         activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = tableView.center
         activityIndicator.hidesWhenStopped = true
         view.addSubview(activityIndicator)
         activityIndicator.startAnimating()

         // Fetch schedule data
         fetchEventsData()
         
         // Set up timer to refresh data every 30 seconds
         Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] timer in
             self?.fetchEventsData()
         }


    }
    
    
    func fetchEventsData() {
        // Fetch events data
        viewModel.fetchEventsData { [weak self] error in
            if let error = error {
                print("Error fetching schedule: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()

            }
        }
    }
    





    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
         
         let event = viewModel.events[indexPath.row]
         
        cell?.titleLabel.text = event.title
        cell?.subtitleLabel.text = event.subtitle
        print("Eevent.dates: \(event.date)")

        if let formattedDate = formatDate(event.date) {
            cell?.dateLabel.text = formattedDate
        } else {
            cell?.dateLabel.text = "Date unknown"
        }
         
         // Fetch the image from the imageURL and set it as the cell's imageView's image
         if let imageUrl = URL(string: event.imageURL) {
             URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                 if let data = data {
                     DispatchQueue.main.async {
                         cell?.eventImageView.image = UIImage(data: data)
                     }
                 }
             }.resume()
         }
         
        return cell ?? UITableViewCell()
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.events[indexPath.row]
        
        if let videoURL = URL(string: event.videoURL) {
            let playbackViewModel = PlaybackViewModel(videoURL: videoURL)
            let playbackVC = PlaybackViewController()
            playbackVC.viewModel = playbackViewModel
            playbackVC.modalPresentationStyle = .fullScreen
            present(playbackVC, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension UIViewController {
    
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
