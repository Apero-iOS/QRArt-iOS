//
//  TargetType.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Param {
    case plainParams(path : String)
    case requestParms(path: String, params: [String: Any])
}

enum Body {
    case requestPlainBody
    case requestBody(body: [String: Any])
}

protocol TargetType {
    var baseURL: BaseURLType { get }
    var headers: [String: String]? { get }
    var params: Param { get }
    var body: Body { get }
    var method: HTTPMethod { get }
}

