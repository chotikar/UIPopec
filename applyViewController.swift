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
        
        appltBtn.addTarget(self, action: #selector(applyViewController.pressbtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func pressbtn(_ sender : AnyObject) {
        
        print ("Press")
        
        
        
        
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
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
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




