
import Foundation

enum ActiveElement {
    case hashtagFac(String)
    case hashtagPro(String)
    case url(original: String, trimmed: String)
    
    static func create(with activeType: ActiveType, text: String) -> ActiveElement {
        switch activeType {
        case .hashtagFac: return hashtagFac(text)
        case .hashtagPro: return hashtagPro(text)
        case .url: return url(original: text, trimmed: text)
        }
    }
}

public enum ActiveType {
    case hashtagFac
    case hashtagPro
    case url
    
    var pattern: String {
        switch self {
        case .hashtagFac: return RegexParser.hashtagFacPattern
        case .hashtagPro: return RegexParser.hashtagProPattern
        case .url: return RegexParser.urlPattern
        }
    }
}

extension ActiveType: Hashable, Equatable {
    public var hashValue: Int {
        switch self {
        case .hashtagFac: return -1
        case .hashtagPro: return -2
        case .url: return -3
        }
    }
}

public func ==(lhs: ActiveType, rhs: ActiveType) -> Bool {
    switch (lhs, rhs) {
    case (.hashtagFac, .hashtagFac): return true
    case (.hashtagPro, .hashtagPro): return true
    case (.url, .url): return true
    default: return false
    }
}











//import Foundation
//
//enum ActiveElement {
//    case mention(String)
//    case hashtag(String)
//    case url(original: String, trimmed: String)
//    case custom(String)
//
//    static func create(with activeType: ActiveType, text: String) -> ActiveElement {
//        switch activeType {
//        case .mention: return mention(text)
//        case .hashtag: return hashtag(text)
//        case .url: return url(original: text, trimmed: text)
//        case .custom: return custom(text)
//        }
//    }
//}
//
//public enum ActiveType {
//    case mention
//    case hashtag
//    case url
//    case custom(pattern: String)
//
//    var pattern: String {
//        switch self {
//        case .mention: return RegexParser.mentionPattern
//        case .hashtag: return RegexParser.hashtagPattern
//        case .url: return RegexParser.urlPattern
//        case .custom(let regex): return regex
//        }
//    }
//}
//
//extension ActiveType: Hashable, Equatable {
//    public var hashValue: Int {
//        switch self {
//        case .mention: return -1
//        case .hashtag: return -2
//        case .url: return -3
//        case .custom(let regex): return regex.hashValue
//        }
//    }
//}
//
//public func ==(lhs: ActiveType, rhs: ActiveType) -> Bool {
//    switch (lhs, rhs) {
//    case (.mention, .mention): return true
//    case (.hashtag, .hashtag): return true
//    case (.url, .url): return true
//    case (.custom(let pattern1), .custom(let pattern2)): return pattern1 == pattern2
//    default: return false
//    }
//}

