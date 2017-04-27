

import Foundation
import UIKit
import SWRevealViewController
import FSCalendar

class CalenderViewController_2 : UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var Menubutton: UIBarButtonItem!
    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var eventTable: UITableView!
//    @IBOutlet weak var dateTopic: UITextView!
//    @IBOutlet weak var Topic: UITextView!
   
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyy"
        return formatter
    }()
    let ws = WebService.self
    var eventList : [CalendarModel] = []
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    var datesWithEvent = ["03/04/2017", "06/04/2017", "12/04/2017", "25/04/2017"]
    var dateWithMultiEvent = ["05/04/2017", "16/04/2017" , "01/05/2017"]
//    var dateEvent:[String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sidemenu()
        CustomNavbar()
        customCalendar()
//        customTable()
//        reloadWS()
    }
    
//    func reloadWS() {
//        ws.GetCalendarWS() { (responseData : [CalendarModel], nil) in DispatchQueue.main.async ( execute: {
//            self.eventList = responseData
//            self.eventTable.reloadData()
//            self.calendar.reloadData()
//
//        })
//        }
//    }

    // SideMenu
    func Sidemenu() {
        
            Menubutton.target = SWRevealViewController()
            Menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }
    // SideMenu
    func CustomNavbar() {
        navigationController?.navigationBar.barTintColor = abacRed
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func customCalendar() {
        calendar.layer.borderWidth = 0.5
        calendar.backgroundColor = UIColor.white
        calendar.layer.cornerRadius = 5
        calendar.layer.borderColor = UIColor.gray.cgColor
        calendar.clipsToBounds = true
        calendar.appearance.eventDefaultColor = UIColor.green
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
    var selectedDates = [String]()
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        
//        if eventTable.isHidden {
//            eventTable.isHidden = false
//            self.calendar.frame.size = CGSize(width: self.calendar.frame.size.width, height: self.calendar.frame.size.height * 0.55)
//        } else {
//            eventTable.isHidden = true
//            self.calendar.frame.size = CGSize(width: scWid - 20, height: scHei * 0.87)
//        }
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dateString = self.dateFormatter.string(from: date)
        if !self.datesWithEvent.contains(dateString) && !self.dateWithMultiEvent.contains(dateString) {
            return calendar.isUserInteractionEnabled == false
        }else {
            
            return calendar.isUserInteractionEnabled  == true
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.dateWithMultiEvent.contains(dateString) {
            return 2
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter.string(from: date)
        if self.dateWithMultiEvent.contains(key) {
            return [appearance.eventDefaultColor,UIColor.blue]
        }
        return nil
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        //        return self.dateFormatter.date(from: "2017/01/01")!
        return self.calendar.currentPage
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.dateFormatter.date(from: "31/12/2017")!
    }
    
    //------------TableView----------------------
    /*
    
    func customTable(){
        eventTable.frame = CGRect(x: 10, y: self.view.frame.size.height * 0.61, width: self.view.frame.size.width - 20, height: self.view.frame.size.height * 0.375)
        eventTable.layer.borderWidth = 0.5
        eventTable.layer.borderColor = UIColor.gray.cgColor
        eventTable.layer.cornerRadius = 5
//        eventTable.isHidden = true
        eventTable.separatorColor = UIColor.gray
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = self.eventList[indexPath.row]
        cell.textLabel?.text = ("\(event.Date!) : \(event.Topic!)")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.isUserInteractionEnabled = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 */
    
}






