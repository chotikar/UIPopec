//
//  DepartmentEntity+CoreDataProperties.swift
//  
//
//  Created by Chotikar on 7/31/2560 BE.
//
//

import Foundation
import CoreData


extension DepartmentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartmentEntity> {
        return NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
    }

    @NSManaged public var facultyId: String?
    @NSManaged public var facultyName: String?
    @NSManaged public var programAbb: String?
    @NSManaged public var programeNameTh: String?
    @NSManaged public var programId: String?
    @NSManaged public var programNameEn: String?
    @NSManaged public var roomCode: String?
    @NSManaged public var message: NSSet?

}

// MARK: Generated accessors for message
extension DepartmentEntity {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: MessageEntity)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: MessageEntity)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
