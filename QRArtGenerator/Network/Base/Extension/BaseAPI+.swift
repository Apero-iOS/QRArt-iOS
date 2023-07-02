//
//  BaseAPI+.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire

extension BaseAPI {
    func buildPath(param: Param) -> String {
        switch param {
        case .plainParams(let path):
            return path
        case .requestParms(let path, let params):
            var newPath = "\(path)?"
            params.forEach { key, value in
                newPath += "\(key)=\(value)&"
            }
            newPath = String(newPath.dropLast())
            return newPath
        }
    }
    
    func buildBody(body: Body) -> [String: Any] {
        switch body {
        case .requestPlainBody:
            return [:]
        case .requestBody(let body):
            return body
        }
    }
    
    func convertToData<T>(_ value: T) -> Data {
        var value = value
        return withUnsafeBytes(of: &value) { Data($0) }
    }
}
