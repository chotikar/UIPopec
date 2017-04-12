//
//  calendarViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 4/12/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import UIKit
import SWRevealViewController
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    private weak var calendar: FSCalendar!
    fileprivate var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        
    }
    
    
    func Sidemenu() {
        if revealViewController() != nil {
            MenuButton.target = SWRevealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }

    
    override func loadView() { // call calendar view
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        let calendar = FSCalendar(frame: CGRect(x: 10, y: self.navigationController!.navigationBar.frame.maxY + 10, width: scWid - 20 , height: scHei * 0.87))
//        let startdate = calendar.formatter.date(from: "2017/01/14")
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.layer.cornerRadius = 5
        calendar.layer.borderColor = UIColor.white.cgColor
        calendar.pagingEnabled = false
//        calendar.scrollDirection = .vertical
        calendar.clipsToBounds = true
        self.view.addSubview(calendar)
        self.calendar = calendar
        self.calendar.appearance.eventDefaultColor = UIColor.green
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
    }
    
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    var datesWithEvent = ["2017/04/03", "2017/04/06", "2017/04/12", "2017/04/25"]
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return calendar.isUserInteractionEnabled == false
        
    }
    

    
}
