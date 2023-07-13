//
//  BaseAPI+.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire
import SwCrypt

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
    
    func encrypted(str: String) -> String? {
        do {
            let bundle = Bundle.main
            let pub = bundle.object(forInfoDictionaryKey: "productPubPEM") as! String
            let string = str.replaceString(withRegex: "\n", by: "").replaceString(withRegex: " ", by: "")
            let pubKey = try? SwKeyConvert.PublicKey.pemToPKCS1DER(pub)
            let encrypt = try CC.RSA.encrypt(string.data(using: String.Encoding.utf8)!, derKey: pubKey!, tag: Data(), padding: .pkcs1, digest: .sha256)
            return encrypt.base64EncodedString()
        } catch {
            return nil
        }
    }
}
