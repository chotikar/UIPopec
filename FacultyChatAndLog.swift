//
//  UserProfile.swift
//  UIPS_SignalR_05.02.17
//
//  Created by Chotikar on 2/13/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import Foundation

class  FacultyChatAndLog {
    var facName : String!
    var facId : String!
    var chatLogList = [ChatLog]()
    
    init (){
        self.facName = ""
        self.facId = ""
        self.chatLogList = [ChatLog]()
    }

    init(dic: AnyObject) {
        self.facName = dic["FacultyName"] as? String
        self.facId = dic["FacultyId"] as? String
        
        let arrayOfChatLog = dic["ChatLog"] as? [[String:AnyObject]]
        for dictionary in arrayOfChatLog! {
            chatLogList.append(ChatLog(dic: dictionary as AnyObject))
        }
    }
    
}
