//
//  MatchTargetType.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/09/25.
//

import Foundation
import Moya

//๐ ์ฐธ๊ณ : https://github.com/Moya/Moya/blob/master/docs/Targets.md

//ex) ๋ง์ผ 'ABC/DEF'์ token์ post๋ก ๋ณด๋ด์ผ ํ๋ค๊ณ  ๊ฐ์ 
// case signIn(path: String, token: String)
enum MatchTargetType {
    case matchUser(MatchModel)
    case myListener
    case mySpeaker
}


// TargetType Protocol Implementation
extension MatchTargetType: BaseTargetType {
    
    // ์๋ฒ์ base URL ๋ค์ ์ถ๊ฐ ๋  Path (์ผ๋ฐ์ ์ผ๋ก API)
    // case .signIn(path, _) return "/\(path)"
    public var path: String {
        switch self {
        case .matchUser(_):
            return "/match/user"
        case .myListener:
            return "/match/user/listener"
        case .mySpeaker:
            return "/match/user/speaker"
        }
    }
    
    // HTTP ๋ฉ์๋ (ex. .get / .post / .delete ๋ฑ๋ฑ)
    // case .signIn: return .post
    public var method: Moya.Method {
        switch self {
        case .matchUser(_):
            return .post
        case .myListener, .mySpeaker:
            return .get
        }

    }
    
    // task : request์ ์ฌ์ฉ๋๋ ํ๋ผ๋ฏธํฐ ์ค์ 
    // - plain request : ์ถ๊ฐ ๋ฐ์ดํฐ๊ฐ ์๋ request
    // - data request : ๋ฐ์ดํฐ๊ฐ ํฌํจ๋ requests body
    // - parameter request : ์ธ์ฝ๋ฉ๋ ๋งค๊ฐ ๋ณ์๊ฐ ์๋ requests body
    // - JSONEncodable request : ์ธ์ฝ๋ฉ ๊ฐ๋ฅํ ์ ํ์ requests body
    // - upload request
    
    // case let .signIn(_, token): return .requestJSONEncodable(["accesstoken": token])
    public var task: Task {
        switch self {
        case .matchUser(let model):
            return .requestJSONEncodable(model)
        case .myListener, .mySpeaker:
            return .requestPlain
        }
    }
}
