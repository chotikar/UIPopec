

import Foundation
class KeyWordModel {
    var keywordID: Int!
    var keyword:String!
    var choose : Bool!
    var chooseImg : String!
    
    init() {
        self.keywordID = 99999
        self.keyword = "N/A"
        self.choose = false
        self.chooseImg = "not choose"
    }
    
    init(dic: AnyObject) {
        self.keywordID  = dic["keywordID"] as? Int
        self.keyword =  dic["keyword"] as? String
        self.choose = false
        self.chooseImg = "not choose"
    }
    

}
