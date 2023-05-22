//
//  MainViewController.swift
//  EventFetcher
//
//  Created by Cezary Muniak on 21/05/2023.
//

import UIKit

class MainViewController: UITabBarController {
    
    let eventsVC = EventsViewController()
    let scheduleVC = ScheduleViewController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let eventsImage = resizeImage(image: UIImage(named: "events") ?? UIImage(), targetSize: CGSize(width: 25, height: 25))
        let scheduleImage = resizeImage(image: UIImage(named: "schedule") ?? UIImage(), targetSize: CGSize(width: 25, height: 25))
        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: eventsImage, tag: 0)
        scheduleVC.tabBarItem = UITabBarItem(title: "Schedule", image: scheduleImage, tag: 1)
        
        let tabBarList = [eventsVC, scheduleVC]
        
        viewControllers = tabBarList.map { UINavigationController(rootViewController: $0) }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
