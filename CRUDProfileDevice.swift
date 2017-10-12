
import Foundation
import UIKit
import CoreData

class CRUDProfileDevice {
    
    static func GetUserProfile() -> UserLogInDetail {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileInforEntity")
        var userProfile = UserLogInDetail()
        var profileValue_DB =  [NSManagedObject]()
        do {
            let result = try managedContext.fetch(fetchRequest)
            profileValue_DB = result
            if ( profileValue_DB as? [NSManagedObject]) != nil {
                if profileValue_DB.first?.value(forKey: "byFacebook") as? Int16 != nil {
                userProfile = UserLogInDetail(obj: profileValue_DB)
                //userProfile = UserLogInDetail(dic) ( profileValue_DB.first? ?? UserLogInDetail())!
                }else{
                    CRUDProfileDevice.SaveProfileDevice(loginInfor: UserLogInDetail())
                    userProfile = UserLogInDetail()
                }
            } else {
                print("Error null")
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return userProfile
    }
    
    ///Save Profile device to mobile database
    static func SaveProfileDevice(loginInfor: UserLogInDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ProfileInforEntity", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(loginInfor.byFacebook, forKey: "byFacebook")
        transc.setValue(loginInfor.email, forKey: "email")
        transc.setValue(loginInfor.facebookId, forKey: "facebook_id")
        transc.setValue(loginInfor.facebookName, forKey: "facebook_name")
        transc.setValue(loginInfor.accessToken, forKey: "access_token")
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
        }
    }
    
    /// Clear device information
    static func ClearProfileDevice(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileInforEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            SaveProfileDevice(loginInfor: UserLogInDetail())
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
