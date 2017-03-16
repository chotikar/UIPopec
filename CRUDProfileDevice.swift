
import Foundation
import UIKit
import CoreData

class CRUDProfileDevice {
    
    static func GetUserProfile() -> UserLogInDetail {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
        
        var userProfile:UserLogInDetail = UserLogInDetail()
        var userProfile_DB = [NSManagedObject]()
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            userProfile_DB = result 
            
            if (userProfile_DB as? [NSManagedObject]) != nil {
                userProfile = (UserLogInDetail(obj: userProfile_DB.first!))
                //completion(userProfile, nil)
                
            } else {
                print("Error null")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return userProfile
    }
    
    ///Save Profile device to mobile database
    static func SaveProfileDevice(loginInfor:UserLogInDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ProfileInformation", in: managedContext)!
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(loginInfor.email, forKey: "email")
        managedObject.setValue(loginInfor.facebookId, forKey: "facebook_id")
        managedObject.setValue(loginInfor.facebookName, forKey: "facebook_name")
        managedObject.setValue(loginInfor.facebookAccessToken, forKey: "facebook_access_token")
        managedObject.setValue(loginInfor.udid, forKey: "udid_device")
        
        print("\(loginInfor.email) = \(managedObject.value(forKey: "email"))")
        print("\(loginInfor.facebookId) = \(managedObject.value(forKey: "facebook_id"))")
        print("\(loginInfor.facebookName) = \(managedObject.value(forKey: "facebook_name"))")
        print("\(loginInfor.facebookAccessToken) = \(managedObject.value(forKey: "facebook_access_token"))")
        print("\(loginInfor.udid) = \(managedObject.value(forKey: "udid_device"))")
        
        do {
            try managedContext.save()
            print("save the new profile device record sucessfully")
        } catch let error as NSError {
            print("Could not insert the new record. \(error)")
        }
    }

    /// Clear device information
    static func ClearProfileDevice(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Major error : \(error) \(error.userInfo)")
        }
        

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInformation")
//        fetchRequest.returnsObjectsAsFaults = false
//        
//        do
//        {
//            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//            let managedObjectData:NSManagedObject = results as! NSManagedObject
//            managedContext.delete(managedObjectData)
//            
//        } catch let error as NSError {
//            print("Detele all data in Profile Device error : \(error) \(error.userInfo)")
//        }
        
    }

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

}
