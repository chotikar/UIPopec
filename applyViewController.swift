//
//  applyViewController.swift
//  UIPSOPEC
//
//  Created by Popp on 3/27/17.
//  Copyright © 2017 Senior Project. All rights reserved.
//

import Foundation
import SWRevealViewController
import SkyFloatingLabelTextField

class applyViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate    {
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    @IBOutlet weak var genderTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var citizenNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var passportNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var Fname: SkyFloatingLabelTextField!
    @IBOutlet weak var Lname: SkyFloatingLabelTextField!
    @IBOutlet weak var titleName: SkyFloatingLabelTextField!
    @IBOutlet weak var nationality: SkyFloatingLabelTextField!
    @IBOutlet weak var Birthdate: SkyFloatingLabelTextField!
    @IBOutlet weak var highschool: SkyFloatingLabelTextField!
    @IBOutlet weak var mobile: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var ielts: SkyFloatingLabelTextField!
    @IBOutlet weak var toefl: SkyFloatingLabelTextField!
    @IBOutlet weak var appltBtn: UIButton!
    @IBOutlet weak var satwriting: SkyFloatingLabelTextField!
    @IBOutlet weak var satmath: SkyFloatingLabelTextField!
    
    let datePicker = UIDatePicker()
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    var Title_Name  = ["MR.", "MS.", "MRS."]
    var Gender = ["Male" , "Female"]
    let ws = WebService.self
    var check = true
    
    //    var textFields: [SkyFloatingLabelTextField]
    //    var isSubmitButtonPressed = false
    //    var showingTitleInProgress = false
    //
    @IBOutlet weak var Scroll: NSLayoutConstraint!
    
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
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    //check invalid text not complete *****************
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == citizenNumber {
            let userEnteredString = citizenNumber.text
            let inputstr = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            if inputstr != "" {
                check = true
                passportNumber.isEnabled = false
                print("-------\(check)")
            }else {
                check = false
                passportNumber.isEnabled = true
            }
            if let text = textField.text {
                //                passportNumber.isEnabled = false
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count != 12) {
                        print(text.characters.count)
                        floatingLabelTextField.errorMessage = ""
                        
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = "TestCheck"
                        
                    }
                }
            }
        } else if textField == email {   //reverse not complete!!!!1
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if (!text.contains("@")) {
                        print (text.characters.count)
                        floatingLabelTextField.errorMessage = ""
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = "TestCheck"
                    }
                }
            }
        }else if textField == passportNumber {
            let userEnteredString = passportNumber.text
            let inputstr = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
            if inputstr != "" {
                check = false
                citizenNumber.isEnabled = false
                print("-------\(check)")
            }else {
                check = true
                citizenNumber.isEnabled = true
            }
            
        }
        return true
    }
    
    @IBAction func pressbtn(_ sender : AnyObject) {
        
        var cutwordGender = ""
        if genderTextField.text! == "Male" {
            cutwordGender = "M"
        } else if genderTextField.text! == "Female" {
            cutwordGender = "F"
        }
        
        //        if citizenNumber.text! == "" {
        //            iosToast(noti: "Please Input Citizen Number")
        //        }else if Fname.text! == "" {
        //            iosToast(noti: "Please Input First Name")
        //        }else if Lname.text! == "" {
        //            iosToast(noti: "Please Input Last Name")
        //        }else if nationality.text! == "" {
        //            iosToast(noti: "Please Input Nationality")
        //        }else if Birthdate.text! == "" {
        //            iosToast(noti: "Please Select Birthdate")
        //        }else if mobile.text! == "" {
        //            iosToast(noti: "Please Input Mobile Number")
        //        }else if email.text! == "" {
        //            iosToast(noti: "Please Input Email")
        //        }else if highschool.text! == "" {
        //            iosToast(noti: "Please Input HighSchool")
        //        }else {
        let alert = UIAlertController(title: "Do you want to apply?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let cofirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.ws.ApplyWS(Semester: 2, Year: 2017, isThai: self.check, Citizen: self.citizenNumber.text!, titlename: self.titleName.text!, fname: self.Fname.text!, lname: self.Lname.text!, gender: cutwordGender, national: self.nationality.text!, birthdate: self.Birthdate.text!, mobile: self.mobile.text!, email: self.email.text!, highsch: self.highschool.text!, degree: 3, facultyID: 11, programID: 2, ielts: Int(self.ielts.text!)!, toefl_ibt: Int(self.toefl.text!)!, toefl_p: 30, sat_math: Int(self.satmath.text!)!, sat_writing: Int(self.satwriting.text!)!)
            
            
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
        //        }
        
    }
    
    func iosToast(noti:String){
        let alert = UIAlertController(title: "Invalid Input", message: noti, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
    
    //------------ Move keyboard up when input textfield (out of screen)
    
    //        func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
    //            let moveDuration = 0.1
    //            let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
    //
    //            UIView.beginAnimations("animateTextField", context: nil)
    //            UIView.setAnimationBeginsFromCurrentState(true)
    //            UIView.setAnimationDuration(moveDuration)
    //            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    //            UIView.commitAnimations()
    //        }
    //
    //        func textFieldDidBeginEditing(_ textField: UITextField) {
    //            if (textField == self.email || textField == self.ielts || textField == self.toefl) {
    //                moveTextField(textField, moveDistance: -210, up: true)
    //            }
    //        }
    //
    //        func textFieldDidEndEditing(_ textField: UITextField) {
    //            if (textField == self.email || textField == self.ielts || textField == self.toefl) {
    //                moveTextField(textField, moveDistance: -210, up: false)
    //            }
    //        }
    
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    //    }
    //
    //    func adjustingHeight(show:Bool, notification:NSNotification) {
    //        // 1
    //        var userInfo = notification.userInfo!
    //        // 2
    //        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    //        // 3
    //        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
    //        // 4
    //        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
    //        //5
    //        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
    //            self.bottomConstraint.constant += changeInHeight
    //        })
    //    }
    
    //    func handleKeyboardWillShow(notification: NSNotification) {
    //        adjustingHeight(show: true, notification: notification)    }
    //
    //    func handleKeyboardWillHide(notification: NSNotification){
    //         adjustingHeight(show: false, notification: notification)    }
    //
    
    
    // hide keyboard with return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}




