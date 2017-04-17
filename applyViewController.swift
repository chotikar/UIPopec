//
//  applyViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 3/27/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import SWRevealViewController

class applyViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate    {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var citizenNumber: UITextField!
    @IBOutlet weak var passportNumber: UITextField!
    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var nationality: UITextField!
    @IBOutlet weak var Birthdate: UITextField!
    @IBOutlet weak var highschool: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var ielts: UITextField!
    @IBOutlet weak var toefl: UITextField!
    @IBOutlet weak var appltBtn: UIButton!
    @IBOutlet weak var satwriting: UITextField!
    @IBOutlet weak var satmath: UITextField!
    
    
    let datePicker = UIDatePicker()
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    var Title_Name  = ["MR.", "MS.", "MRS."]
    var Gender = ["Male" , "Female"]
    let ws = WebService.self
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Sidemenu()
        CustomNavbar()
        picker1.delegate = self
        picker1.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        titleName.inputView = picker1
        genderTextField.inputView = picker2
        createDatePicker()
        customlayout()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapview(gesture:)))
//        view.addGestureRecognizer(tapGesture)
        
    }
    
//    func didTapview(gesture: UITapGestureRecognizer) {
//        view.endEditing(true)
//    
//    }
//    
//    func addObserver() {
//        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
//            Notification in self.keyboardWillShow(notification: notification)
//        }
//        
//        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) {
//            Notification in self.keyboardWillShow(notification: notification)
//        }
//        
//    }
//    
//    func keyboardWillShow(notification: Notification) {
//        guard let userInfo  = notification.userInfo,
//            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgReactValue else: {
//                return
//        }
//        let contentInsert = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
//    }
//    
    
    
    /// add condition passportnumber and citizennumber
    
    func pressbtn(_ sender : AnyObject) {
        
        if citizenNumber.text! == "" {
            iosToast(noti: "Please Input Citizen Number")
        }else if Fname.text! == "" {
            iosToast(noti: "Please Input First Name")
        }else if Lname.text! == "" {
            iosToast(noti: "Please Input Last Name")
        }else if nationality.text! == "" {
            iosToast(noti: "Please Input Nationality")
        }else if Birthdate.text! == "" {
            iosToast(noti: "Please Select Birthdate")
        }else if mobile.text! == "" {
            iosToast(noti: "Please Input Mobile Number")
        }else if email.text! == "" {
            iosToast(noti: "Please Input Email")
        }else if highschool.text! == "" {
            iosToast(noti: "Please Input HighSchool")
        }else {
            let alert = UIAlertController(title: "Do you want to apply?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let cofirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                self.ws.ApplyWS(Semester: 2, Year: 2017, isThai: true, Citizen: self.citizenNumber.text!, titlename: self.titleName.text!, fname: self.Fname.text!, lname: self.Lname.text!, national: self.nationality.text!, birthdate: self.Birthdate.text!, mobile: self.mobile.text!, email: self.email.text!, highsch: self.highschool.text!, degree: 3, facultyID: 11, programID: 2, ielts: Int(self.ielts.text!)!, toefl_ibt: Int(self.toefl.text!)!, toefl_p: 30, sat_math: Int(self.satmath.text!)!, sat_writing: Int(self.satwriting.text!)!)
                
                //            self.ws.ApplyWS(Semester: 2, Year: 2017, isThai: true, Citizen: "1710500278484", titlename: "xxxxxx", fname: "xxxxx", lname: "xxxxxxxx", national: "xxxxxxxx", birthdate: "14/06/1995", mobile: "000000", email: "xxxxxxxx", highsch: "xxxxxxxx", degree: 3, facultyID: 11, programID: 2, ielts: 10, toefl_ibt: 20, toefl_p: 30, sat_math: 30, sat_writing: 30)
                //
                let alertt = UIAlertController(title: "Application success", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let cofirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                
                alertt.addAction(cofirmAction)
                self.present(alertt, animated: true, completion: nil)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            
            alert.addAction(cofirmAction)
            alert.addAction(cancelAction )
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func iosToast(noti:String){
        let alert = UIAlertController(title: "Invalid Input", message: noti, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count: Int = Title_Name.count
        if pickerView == picker2 {
            count = self.Gender.count
        }
        return count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker1 {
            let title = Title_Name[row]
            return title
        }else if pickerView == picker2 {
            let title = Gender[row]
            return title
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker1 {
            self.titleName.text = self.Title_Name[row]
            //            self.picker1.isHidden = true
            
        }else if pickerView == picker2 {
            self.genderTextField.text = self.Gender[row]
            //            self.picker2.isHidden = true
        }
        self.view.endEditing(false)
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar  = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolbar.setItems([doneButton], animated: false)
        
        Birthdate.inputAccessoryView = toolbar
        Birthdate.inputView = datePicker
    }
    
    func donePress () {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        
        Birthdate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    func customlayout() {
        appltBtn.layer.cornerRadius = 5
        appltBtn.layer.borderWidth = 1
        appltBtn.layer.borderColor = UIColor.red.cgColor
        appltBtn.layer.backgroundColor = UIColor.red.cgColor
        
    }
    
    
    //------------function to check user input citizen or passport number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let userEnteredString = citizenNumber.text
        let inputstr = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if inputstr != "" {
            passportNumber.isEnabled = false
        }else {
            passportNumber.isEnabled = true
        }
        
        return true
        
    }
    
    
    //------------ Move keyboard up when input textfield (out of screen)
    
    /*
     func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
     let moveDuration = 0.3
     let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
     
     UIView.beginAnimations("animateTextField", context: nil)
     UIView.setAnimationBeginsFromCurrentState(true)
     UIView.setAnimationDuration(moveDuration)
     self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
     UIView.commitAnimations()
     }
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
     moveTextField(textField, moveDistance: -250, up: true)
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     moveTextField(textField, moveDistance: -250, up: false)
     }
     */
    
    // hide keyboard with return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}




