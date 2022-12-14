//
//  LoginAPI.swift
//  GoodListener
//
//  Created by Jiyoung Park on 2022/07/31.


import Foundation
import Moya

//๐ ์ฐธ๊ณ : https://github.com/Moya/Moya/blob/master/docs/Targets.md

//ex) ๋ง์ผ 'ABC/DEF'์ token์ post๋ก ๋ณด๋ด์ผ ํ๋ค๊ณ  ๊ฐ์ 
// case signIn(path: String, token: String)
enum UserTargetType {
    case signIn(SignInModel)        // ํ์๊ฐ์
    case nicknameCheck(String)      // ๋๋ค์ ์ค๋ณต ํ์ธ
    case getUserInfo                // ์ ์ ์ ๋ณด ์ป์ด์ค๊ธฐ
    case deleteAccount                    // ํ์ ํํด
    case userModify((String, String, String))   // ํธ์งํ์ด์ง ํ์ ์ ๋ณด ์์  -> ๋๋ค์, ํ๋์ผ, ์๊ฐ๊ธ
    case profileImgModify(Int)   // ํ๋กํ ์ด๋ฏธ์ง ์์ 
    case updateUserDeviceToken(String) // FCM ํ ํฐ ์์ 
}


// TargetType Protocol Implementation
extension UserTargetType: BaseTargetType {
    
    // ์๋ฒ์ base URL ๋ค์ ์ถ๊ฐ ๋  Path (์ผ๋ฐ์ ์ผ๋ก API)
    // case .signIn(path, _) return "/\(path)"
    public var path: String {
        switch self {
        case .signIn(_):
            return "/user/sign"
            
        case .nicknameCheck(_):
            return "/user/valid"
            
        case .getUserInfo, .deleteAccount, .userModify(_), .profileImgModify(_), .updateUserDeviceToken(_):
            return "/user"
        }
    }
    
    // HTTP ๋ฉ์๋ (ex. .get / .post / .delete ๋ฑ๋ฑ)
    // case .signIn: return .post
    public var method: Moya.Method {
        switch self {
        case .signIn(_):
            return .post
        
        case .nicknameCheck(_), .getUserInfo:
            return .get
            
        case .deleteAccount:
            return .delete
            
        case .userModify(_), .profileImgModify(_), .updateUserDeviceToken(_):
            return .patch
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
        case .signIn(let model):
            return .requestJSONEncodable(model)
            
        case .nicknameCheck(let nickname):
            let params: [String: Any] = [
                "nickName": nickname
            ]
//
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .getUserInfo, .deleteAccount:
            return .requestPlain
            
        case .userModify((let nickname, let job, let description)):
            let params: [String: String] = [
                "nickname" : nickname,
                "job" : job,
                "description" : description
            ]
            
            return .requestJSONEncodable(params)
//            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .profileImgModify(let image):
            let params: [String: Int] = [
                "profileImg": image
            ]
            
            return .requestJSONEncodable(params)
            
        case .updateUserDeviceToken(let token):
            let params: [String: String] = [
                "fcmHash": token
            ]
            
            return .requestJSONEncodable(params)
        }
    }
}
