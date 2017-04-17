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
        
        //http://www.supanattoy.com:89/AppliedStudent/ApplyNewStudent?year=2017&semester=2&isThai=true&IDnumber=110090&profile=mr;pop;pop;Thai;14/06/1995;0231;pop@au.edu;ac&degree=3&facultyID=11&programID=2&scorelist=0;0;0;0;0
        
        
        //2017;1,Ms.;Kornkamol;Kiatopas;true;1100900463331;"Thai;26/06/1995;0962059390;kornkamol33@gmail.com;ASC
        
        
        var y = ""
        var year = String(2017)
        var semester = String(1)
        var faculty = String(11)
        var program = String(2)
        
        y = year + ";" + semester + ";"
        y = titleName.text! + ";"
        y = Fname.text! + ";"
        y = Lname.text! + ";"
        if citizenNumber.text! != "" || passportNumber.text! != ""{
            if citizenNumber.text! != "" {
                y = y+"true;"
            }else if passportNumber.text! != "" {
                y = y+"false;"
            }
        }
        y = citizenNumber.text! + ";"
        y = nationality.text! + ";"
        y = Birthdate.text! + ";"
        y = mobile.text! + ";"
        y = email.text! + ";"
        y = highschool.text! + ";"
        y = faculty + ";" + program + ";"
        y = 
        
        
                                    if acc {
                                        let alert = UIAlertController(title: "Do you want to apply?", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                        let cofirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                            self.loadJSON(information: y)
                                            let alertt = UIAlertController(title: "Application success", message: "", preferredStyle: UIAlertControllerStyle.alert)
                                            let cofirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "facultyLAYOUT") as! FacultyTableViewController
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            
                                            alertt.addAction(cofirmAction)
                                            self.present(alertt, animated: true, completion: nil)
                                            
                                        }
                                    }
                                    
                                    
                                    //        print ("Press")
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        func iosToast(noti:String){
//            let alert = UIAlertController(title: "Invalid Input", message: noti, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            
//        }
        
        func loadJSON(information:String) -> Bool{
            var  sta  = false
            var ws = "http://www.supanattoy.com:89/AppliedStudent/ApplyNewStudent?\(information)"
            print (ws)
            ws = ws.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
            
            let requestURL: NSURL = NSURL(string: ws)!
            let request = URLRequest(url: requestURL as URL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) {
                (data, response, error) -> Void in
                
                if error == nil {
                    //                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    let stringData = String(data: data!, encoding: .utf8)
                    
                    //                let validJson = json as? String
                    print ("**********************\(String(describing: stringData))**********************************************")
                    sta =  Bool(stringData!.contains("true"))
                }
            }
            
            task.resume()
            print(sta)
            return sta
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




