
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
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "SettingTestEntity", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(lang, forKey: "language")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
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


    //  Update Building

//func UpdateSetting(lang:String){
//        if self.GetUserSetting() != lang {
//            self.ClearProfileDevice()
//            self.SaveSettingDevice(lang: lang)
//    }
//}
//



//import Foundation
//import UIKit
//import CoreData
//
//class CRUDSettingValue{
//    
//    
//    static func GetUserSetting() -> String {
//        
////        let fetchRequest: NSFetchRequest<SettingTest> = SettingTest.fetchRequest()
////        
////        do {
////            //go get the results
////            let appDelegate = UIApplication.shared.delegate as! AppDelegate
////            
////            let context =  appDelegate.persistentContainer.viewContext
////            let searchResults = try context.fetch(fetchRequest)
////            
////            //I like to check the size of the returned results!
////            print ("num of results = \(searchResults.count)")
////            
////            //You need to convert to NSManagedObject to use 'for' loops
////            for trans in searchResults as [NSManagedObject] {
////                //get the Key Value pairs (although there may be a better way to do that...
////                print("\(trans.value(forKey: "audioFileUrlString"))")
////            }
////        } catch {
////            print("Error with request: \(error)")
////        }
////    }
////        
////        guard let appDelegate =
////            UIApplication.shared.delegate as? AppDelegate else {
////                return "NULL"
////        }
////        
////        let managedContext =
////            appDelegate.persistentContainer.viewContext
////        
////        //2
////        let fetchRequest =
////            NSFetchRequest<NSManagedObject>(entityName: "SettingTest")
////        
////        //3
////        do {
////            let k = try managedContext.fetch(fetchRequest)
////          
////        } catch let error as NSError {
////            print("Could not fetch. \(error), \(error.userInfo)")
////        }
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingTest")
// 
//        var settingValueInt = ""
//        var settingValue_DB =  [NSManagedObject]()
//                do {
//            let result = try managedContext.fetch(fetchRequest)
//            settingValue_DB = result
//            if ( settingValue_DB as? [NSManagedObject]) != nil {
//                settingValueInt = (settingValue_DB.first?.value(forKey: "language") as? String ?? "")!
//                if settingValueInt == nil {
//                    CRUDSettingValue.SaveSettingDevice(lang: "TH")
//                }
//               
//            } else {
//                print("Error null")
//            }
//            
//        }catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        
//        if settingValueInt == "TH" {
//          return "TH"
//        }else if settingValueInt == "EN"{
//            return "EN"
//        }else{
//            return "NULL"
//        }
//
//    }
//    
//   
//    
//    static func SaveSettingDevice(lang:String){
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        let context =  appDelegate.persistentContainer.viewContext
//        //retrieve the entity that we just created
//        let entity =  NSEntityDescription.entity(forEntityName: "SettingTest", in: context)
//        
//        let transc = NSManagedObject(entity: entity!, insertInto: context)
//        
//        //set the entity values
//        transc.setValue(lang, forKey: "language")
//        
//        //save the object
//        do {
//            try context.save()
//            print("saved!")
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        } catch {
//            
//        }//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        let managedContext = appDelegate.persistentContainer.viewContext
////        let entity = NSEntityDescription.entity(forEntityName: "SettingTest", in: managedContext)!
////        
////        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
////        managedObject.setValue(lang, forKey: "language")
////                
////        do {
////            try managedContext.save()
////            print("save the new profile device record sucessfully")
////        } catch let error as NSError {
////            print("Could not insert the new record. \(error)")
////        }
//    }
//    
//
//
//    static func ClearProfileDevice(){
//        
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
//        
//        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SettingTest")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//        
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//        } catch {
//            print ("There was an error")
//        }
//        
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        let managedContext = appDelegate.persistentContainer.viewContext
////        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingTest")
////        fetchRequest.returnsObjectsAsFaults = false
////        
////        do
////        {
////            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
////            for managedObject in results
////            {
////                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
////                managedContext.delete(managedObjectData)
////            }
////        } catch let error as NSError {
////            print("Detele all data in language error : \(error) \(error.userInfo)")
////        }
//        
//    }
//    
//
//    
//        //  Update Building
//        static func UpdateSetting(lang:String){
//            var buildingList_DB = [NSManagedObject]()
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SettingTest")
//            fetchRequest.predicate = NSPredicate(format: "language = %@", lang)
//            do {
//    
//                let result = try managedContext.fetch(fetchRequest)
//                buildingList_DB = result as! [NSManagedObject]
//                if let object = buildingList_DB as? [NSManagedObject] {
//                   
//                        NSManagedObject.setValue(lang, forKey: "language")
//    
//                        do {
//                            try managedContext.save()
//                            print("update the building record sucessfully")
//                        } catch let error as NSError {
//                            print("Could not insert the new building record. \(error)")
//                        }
//                    
//                } else {
//                    print("Error null")
//                }
//            }
//            catch let error as NSError {
//                print("Could not fetch from Building. \(error)")
//            }
//        }
////
//
//}
