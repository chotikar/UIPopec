

import UIKit
import CoreData
class TestCoreDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        FindDepartment(roomCode: "070115")
    }
//    func FindDepartment(roomCode: String) -> DepartmentEntity{
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
//        var department = DepartmentEntity(context: context)
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
//        fetchRequest.predicate = NSPredicate(format: "DepartmentEntity.roomCode == %@", roomCode)
//        fetchRequest.fetchLimit = 1
//        var result = NSManagedObject()
//        do {
//            let fetchDepartment = try context.fetch(fetchRequest) as? DepartmentEntity
//             department = fetchDepartment!!
//            print(department.value(forKey: ("roomCode")))
//        }catch let err {
//            print("Error: \(err), From CRUDDepartment/FindDepartment(roomCode)")
//        }
//        return department
//    }
//
}
