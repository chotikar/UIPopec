
import Foundation
import UIKit
import CoreData

class CRUDChatDetails {
    
    static func GetLastRoomId() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ChatDetailEntity> = ChatDetailEntity.fetchRequest()
        var lastRoomId = "0"
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            lastRoomId = array_users[0].value(forKey: "lastRoomID") as! String ?? "0"
            print("func get last room id : \(array_users[0].value(forKey: "lastRoomID") as! String)")
        }catch{
            print("Error with request: \(error)")
        }
        return lastRoomId
    }

    static func GetLastLogId() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ChatDetailEntity> = ChatDetailEntity.fetchRequest()
        var lastLogId = "0"
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            lastLogId = array_users[0].value(forKey: "lastLogID") as! String ?? "0"
            print("func get last log id : \(array_users[0].value(forKey: "lastLogID") as! String)")
        }catch{
            print("Error with request: \(error)")
        }
        return lastLogId
    }

    static func UpdateLastLogId(msgId :String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ChatDetailEntity> = ChatDetailEntity.fetchRequest()
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            array_users[0].setValue(msgId, forKey: "lastLogID")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }catch{
            print("Error with request: \(error)")
        }
    }
    static func UpdateLastRoomId(roomId :String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ChatDetailEntity> = ChatDetailEntity.fetchRequest()
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            array_users[0].setValue(roomId, forKey: "lastRoomID")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }catch{
            print("Error with request: \(error)")
        }
    }

    static func UpdateLogRoomId(roomId :String, logId :String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<ChatDetailEntity> = ChatDetailEntity.fetchRequest()
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            array_users[0].setValue(logId, forKey: "lastLogID")
            array_users[0].setValue(roomId, forKey: "lastRoomID")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }catch{
            print("Error with request: \(error)")
        }
    }
    
    static func StoreLogRoomId(roomId :String, logId :String){
        print("\(roomId),logid::\(logId)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "ChatDetailEntity", in: managedContext)
        let chatDe = NSManagedObject(entity: entity!, insertInto: managedContext)
        chatDe.setValue(logId, forKey: "lastLogID")
        chatDe.setValue(logId, forKey: "lastRoomID")
        do {
            try managedContext.save()
            print("Store sefault Value")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    static func ClearLogRoomDevice(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatDetailEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}

