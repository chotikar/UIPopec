
import Foundation
import UIKit
import CoreData

class CRUDProfileDevice {
    
    static func GetUserProfile() -> UserLogInDetail {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInfor")
        
        var userProfile = UserLogInDetail()
        var profileValue_DB =  [NSManagedObject]()
        do {
            let result = try managedContext.fetch(fetchRequest)
            profileValue_DB = result
            if ( profileValue_DB as? [NSManagedObject]) != nil {
                userProfile = UserLogInDetail(obj: profileValue_DB)
                //userProfile = UserLogInDetail(dic) ( profileValue_DB.first? ?? UserLogInDetail())!
                
            } else {
                print("Error null")
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return userProfile
    }
    
    ///Save Profile device to mobile database
    static func SaveProfileDevice(loginInfor:UserLogInDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context =  appDelegate.persistentContainer.viewContext
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "ProfileInfor", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        print(loginInfor.userId)
        transc.setValue(loginInfor.email, forKey: "email")
        transc.setValue(loginInfor.facebookId, forKey: "facebook_id")
        transc.setValue(loginInfor.facebookName, forKey: "facebook_name")
        transc.setValue(loginInfor.facebookAccessToken, forKey: "facebook_access_token")
        transc.setValue(loginInfor.udid, forKey: "udid_device")
        transc.setValue(loginInfor.username, forKey: "username")
        transc.setValue(loginInfor.password, forKey: "password")
        transc.setValue(loginInfor.userId, forKey: "userId")
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let managedContext = appDelegate.persistentContainer.viewContext
//                let entity = NSEntityDescription.entity(forEntityName: "ProfileInfor", in: managedContext)!
//        
//                let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
//                managedObject.setValue(loginInfor.email, forKey: "email")
//                managedObject.setValue(loginInfor.facebookId, forKey: "facebook_id")
//                managedObject.setValue(loginInfor.facebookName, forKey: "facebook_name")
//                managedObject.setValue(loginInfor.facebookAccessToken, forKey: "facebook_access_token")
//                managedObject.setValue(loginInfor.udid, forKey: "udid_device")
//                managedObject.setValue(loginInfor.username, forKey: "username")
//                managedObject.setValue(loginInfor.password, forKey: "password")
//                managedObject.setValue(loginInfor.userId, forKey: "userId")
//        
//        
//                do {
//                    try managedContext.save()
//                    print("save the new profile device record sucessfully")
//                } catch let error as NSError {
//                    print("Could not insert the new record. \(error)")
//                }
    }
    
    /// Clear device information
    static func ClearProfileDevice(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileInfor")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

























//    static func ClearProfileDevice(){
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do
//        {
//            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.delete(managedObjectData)
//            }
//        } catch let error as NSError {
//            print("Detele all data in Major error : \(error) \(error.userInfo)")
//        }
//
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        let managedContext = appDelegate.persistentContainer.viewContext
////        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
////        fetchRequest.returnsObjectsAsFaults = false
////
////        do
////        {
////            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
////            let managedObjectData:NSManagedObject = results as! NSManagedObject
////            managedContext.delete(managedObjectData)
////
////        } catch let error as NSError {
////            print("Detele all data in Profile Device error : \(error) \(error.userInfo)")
////        }
//
//    }
//    //  Update Building
//    static func UpdateBuilding(building:BuildingObject){
//        var buildingList_DB = [NSManagedObject]()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Building")
//        fetchRequest.predicate = NSPredicate(format: "buildingCode = %@", building.BuildingCode)
//        do {
//
//            let result = try managedContext.fetch(fetchRequest)
//            buildingList_DB = result as! [NSManagedObject]
//            if let object = buildingList_DB as? [NSManagedObject] {
//                if (buildingList_DB.count != 0){
//                    var managedObject = buildingList_DB[0]
//                    managedObject.setValue(building.BuildingCode, forKey: "buildingCode")
//                    managedObject.setValue(building.BuildingAbb, forKey: "buildingAbb")
//                    managedObject.setValue(building.BuildingName, forKey: "buildingName")
//                    managedObject.setValue(building.Latitude, forKey: "latitude")
//                    managedObject.setValue(building.Longtitude, forKey: "longtitude")
//
//                    do {
//                        try managedContext.save()
//                        print("update the building record sucessfully")
//                    } catch let error as NSError {
//                        print("Could not insert the new building record. \(error)")
//                    }
//                }
//            } else {
//                print("Error null")
//            }
//        }
//        catch let error as NSError {
//            print("Could not fetch from Building. \(error)")
//        }
//    }
//}
