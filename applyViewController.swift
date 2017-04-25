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
    @IBOutlet weak var faculty: SkyFloatingLabelTextField!
    @IBOutlet weak var program: SkyFloatingLabelTextField!
    @IBOutlet weak var toefl_p: SkyFloatingLabelTextField!
    
    let datePicker = UIDatePicker()
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    let picker4 = UIPickerView()
    var Title_Name  = ["MR.", "MS.", "MRS."]
    var Gender = ["Male" , "Female"]
    var faclist : [FacultyModel] = []
    var factCode: Int!
    var programCode: Int!
    var facultyMajorInformation = FacultyMajorModel()
    let ws = WebService.self
    var check = true
    
    //    var textFields: [SkyFloatingLabelTextField]
    //    var isSubmitButtonPressed = false
    //    var showingTitleInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Sidemenu()
        CustomNavbar()
        picker1.delegate = self
        picker1.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        picker3.delegate = self
        picker3.dataSource = self
        picker4.delegate = self
        picker4.dataSource = self
        titleName.inputView = picker1
        genderTextField.inputView = picker2
        faculty.inputView = picker3
        program.inputView = picker4
        createDatePicker()
        customlayout()
        genderTextField.text = "Male"
        titleName.text = "MR."
        Birthdate.text = "01/01/1997"
        ielts.text = "0"
        toefl.text = "0"
        toefl_p.text = "0"
        satmath.text = "0"
        satwriting.text = "0"
        reloadTableViewInFac(lang: CRUDSettingValue.GetUserSetting())
        
        
        
        
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
    
    func reloadTableViewInFac(lang:String){
        ws.GetFacultyWS(language: lang) { (responseData: [FacultyModel], nil) in
            DispatchQueue.main.async( execute: {
                self.faclist = responseData
            })
        }
    }
    
    func reloadTableViewInFacMajor(facId : Int,lang:String) {
        WebService.GetMajorWS(facultyId: facId,language: lang){ (responseData: FacultyMajorModel, nil) in
            DispatchQueue.main.async( execute: {
                self.facultyMajorInformation = responseData
            })
        }
    }
    
    //check invalid text
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
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count == 1) {
                        floatingLabelTextField.errorMessage = ""
                    }else if (text.characters.count != 12){
                        floatingLabelTextField.errorMessage = "Invalid Thai Citizen Number"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                        
                    }
                }
            }
        } else if textField == email {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if (!text.contains("@")) {
                        print (text.characters.count)
                        floatingLabelTextField.errorMessage = "Invalid Email Format"
                    }
                        //                    else if (text.characters.count == 1){
                        //                        // The error message will only disappear when we reset it to nil or empty string
                        //                        floatingLabelTextField.errorMessage = ""
                        //                    }
                    else {
                        floatingLabelTextField.errorMessage = ""
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
        
        var numberInput = ""
        if check == true {
            numberInput = citizenNumber.text!
            print("----\(numberInput)")
        }else if check == false {
            numberInput = passportNumber.text!
            print("----\(numberInput)")
        }
        
        //        if citizenNumber.text! == "" {
        //            iosToast(noti: "Please Input Citizen or Passport Number")
        //        }else
        
        if faculty.text! == ""{
            iosToast(noti: "Please Select Faculty")
        }else if program.text! == "" {
             iosToast(noti: "Please Select Program")
        }else if Fname.text! == "" {
            iosToast(noti: "Please Input First Name")
        }else if Lname.text! == "" {
            iosToast(noti: "Please Input Last Name")
        }else if nationality.text! == "" {
            iosToast(noti: "Please Input Nationality")
        }else if Birthdate.text! == "" {
            iosToast(noti: "Please Select Birthdate")
        }else if highschool.text! == "" {
            iosToast(noti: "Please Input HighSchool")
        }else if mobile.text! == "" {
            iosToast(noti: "Please Input Mobile Number")
        }else if email.text! == "" {
            iosToast(noti: "Please Input Email")
        }else {
            let alert = UIAlertController(title: "Do you want to apply?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let cofirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                self.ws.ApplyWS(Semester: 2, Year: 2017, isThai: self.check, Citizen: numberInput, titlename: self.titleName.text!, fname: self.Fname.text!, lname: self.Lname.text!, gender: cutwordGender, national: self.nationality.text!, birthdate: self.Birthdate.text!, mobile: self.mobile.text!, email: self.email.text!, highsch: self.highschool.text!, degree: 3, facultyID: self.factCode, programID: self.programCode, ielts: Int(self.ielts.text!)!, toefl_ibt: Int(self.toefl.text!)!, toefl_p: Int(self.toefl_p.text!)!, sat_math: Int(self.satmath.text!)!, sat_writing: Int(self.satwriting.text!)!)
                
                
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count: Int = Title_Name.count
        if pickerView == picker2 {
            count = self.Gender.count
        }else if pickerView == picker3 {
            count = faclist.count
        }else if pickerView == picker4 {
            count = facultyMajorInformation.marjorList.count
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
        }else if pickerView == picker3 {
            let title = faclist[row].facultyName
            return title
        }else if pickerView == picker4 {
            let title = facultyMajorInformation.marjorList[row].departmentName
            return title
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker1 {
            self.titleName.text = self.Title_Name[row]
        }else if pickerView == picker2 {
            self.genderTextField.text = self.Gender[row]
        }else if pickerView == picker3 {
            self.faculty.text = self.faclist[row].facultyName
            factCode = self.faclist[row].faculyId
            reloadTableViewInFacMajor(facId: factCode, lang: CRUDSettingValue.GetUserSetting())
        }else if pickerView == picker4 {
            self.program.text = self.facultyMajorInformation.marjorList[row].departmentName
            programCode = self.facultyMajorInformation.marjorList[row].departmentId
        }
        self.view.endEditing(false)
    }
    
    let dateFormatter = DateFormatter()
    func createDatePicker() {
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePicker.datePickerMode = .date
        datePicker.date = dateFormatter.date(from: "01/01/1997")!
        
        let toolbar  = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolbar.setItems([doneButton], animated: false)
        
        Birthdate.inputAccessoryView = toolbar
        Birthdate.inputView = datePicker
    }
    
    func donePress () {
        dateFormatter.dateFormat = "dd/MM/yyyy"
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
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.1
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.email || textField == self.ielts || textField == self.toefl || textField == self.toefl_p || textField == self.satmath || textField == self.satwriting) {
            moveTextField(textField, moveDistance: -210, up: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.email || textField == self.ielts || textField == self.toefl || textField == self.toefl_p || textField == self.satmath || textField == self.satwriting) {
            moveTextField(textField, moveDistance: -210, up: false)
        }
    }
    // hide keyboard with return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}




