//
//  ScheduleViewController.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import UIKit

class ScheduleViewController: UITableViewController {
    
    var viewModel: ScheduleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")

        // Initialize viewModel
        viewModel = ScheduleViewModel()

        // Fetch schedule data
        fetchScheduleData()
        
        // Set up timer to refresh data every 30 seconds
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] timer in
            self?.fetchScheduleData()
        }
    }
    
    func fetchScheduleData() {
        viewModel.fetchScheduleData { [weak self] error in
            if let error = error {
                print("Error fetching schedule: \(error)")
                return
            }
            
            print("Fetched schedule data: \(self?.viewModel.schedule)") // Add this line
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(viewModel.schedule.count)") // Add this line
        return viewModel.schedule.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
        
        let scheduleItem = viewModel.schedule[indexPath.row]
        
        cell?.titleLabel.text = scheduleItem.title
        cell?.subtitleLabel.text = scheduleItem.subtitle

        if let formattedDate = formatDate(scheduleItem.date) {
            cell?.dateLabel.text = formattedDate
        } else {
            cell?.dateLabel.text = "Date unknown"
        }
         
         // Fetch the image from the imageURL and set it as the cell's imageView's image
         if let imageUrl = URL(string: scheduleItem.imageURL) {
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

        let rowNumber = indexPath.row + 1
        let message = "Row \(rowNumber) tapped!"
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
