
import Foundation
import UIKit
import CoreData

class CRUDSettingValue{
    
    static func GetUserSetting() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingTestEntity")
        var settingValueInt = ""
        var settingValue_DB =  [NSManagedObject]()
        do {
            let result = try managedContext.fetch(fetchRequest)
            settingValue_DB = result
            if ( settingValue_DB as? [NSManagedObject]) != nil {
                settingValueInt = (settingValue_DB.first?.value(forKey: "language") as? String ?? "")!
                if settingValueInt == "" {
                    CRUDSettingValue.SaveSettingDevice(lang: "T")
                }
            } else {
                print("Error null")
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if settingValueInt == "T" {
            return "T"
        }else {
            return "E"
        }
    }

    static func SaveSettingDevice(lang:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "SettingTestEntity", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(lang, forKey: "language")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func ClearSettingDevice(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingTestEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    static func UpdateSetting(lang:String){
        if self.GetUserSetting() != lang {
            self.ClearSettingDevice()
            self.SaveSettingDevice(lang: lang)
        }
    }
}
