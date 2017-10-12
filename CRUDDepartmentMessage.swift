import Foundation
import UIKit
import CoreData

class CRUDDepartmentMessage{
    
    static func fetchDepartmentMessage() -> [DepartmentEntity]? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        do{
            return try context.execute(request) as? [DepartmentEntity]
        }catch let err {
            print(err)
        }
        return nil
    }
    
    static func SaveMessage(log: String, sendBy: Int16, department: DepartmentEntity) -> MessageEntity{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let message = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as! MessageEntity
        message.department = department
        message.text = log
        message.date = NSDate()
        message.sendBy = sendBy
        do{
            try(context.save())
        }catch let err {
            print(err)
        }
        return message
    }
    
    static func SaveDepartment(department: DepartmentEntity) -> DepartmentEntity{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        request.predicate = NSPredicate(format: "DepartmentEntity.roomcode", department.roomCode!)
        if request.fetchLimit == 0 {
            var departmentEntity = NSEntityDescription.insertNewObject(forEntityName: "DepartmentEntity", into: context) as! DepartmentEntity
            departmentEntity = department
            do{
                try(context.save())
                return department
            }catch let err {
                print(err)
            }
        }
        let error = DepartmentEntity()
        error.facultyName = "error"
        return error
    }
    
    static func SaveDepartment(facName: String, facId: Int, depNameEn: String, depId: Int, depAbb: String, depNameTh: String, roomCode: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context =  appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "DepartmentEntity", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(facName, forKey: "facultyName")
        transc.setValue(facId, forKey: "facultyId")
        transc.setValue(depNameEn, forKey: "programeNameEn")
        transc.setValue(depNameTh, forKey: "programeNameTh")
        transc.setValue(depId, forKey: "programId")
        transc.setValue(depAbb, forKey: "programAbb")
        transc.setValue(roomCode, forKey: "roomCode")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    static func FindDepartment(roomCode: String) -> DepartmentEntity{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var department = DepartmentEntity(context: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        fetchRequest.predicate = NSPredicate(format: "DepartmentEntity.roomCode == %@", roomCode)
        fetchRequest.fetchLimit = 1
        var result = NSManagedObject()
        do {
            let fetchDepartment = try context.fetch(fetchRequest)
            if let records = fetchDepartment as? DepartmentEntity {
                department = records
            }
            print(department.value(forKey: ("roomCode")))
        }catch let err {
            print("Error: \(err), From CRUDDepartment/FindDepartment(roomCode)")
        }
        return department
    }
    
    static func CreateMessageWithText(textInfo: AnyObject, department: DepartmentEntity) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.A"
        let chatLog = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as! MessageEntity
        chatLog.department = department
        chatLog.date = NSDate()
        chatLog.sendBy = textInfo["Sendby"] as! Int16
        chatLog.text = String(textInfo["Message"] as! String)
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func ClearMessageAndDepartment() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entityNames = ["DepartmentEntity","MessageEntity"]
        do {
            for entityName in entityNames {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let entity = try(context.fetch(request))
                print(entity)
                    for reccord in entity {
                        context.delete(reccord as! NSManagedObject)
                    }
                }
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    static func ResetUnreadCount(department: DepartmentEntity){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        department.unread = 0
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func CreateMessageWithTextUnread(textInfo: AnyObject, department: DepartmentEntity){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.A"
        let chatLog = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: context) as! MessageEntity
        chatLog.department = department
        chatLog.date = NSDate()
        chatLog.sendBy = textInfo["Sendby"] as! Int16
        chatLog.text = String(textInfo["Message"] as! String)
        department.unread += 1
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
