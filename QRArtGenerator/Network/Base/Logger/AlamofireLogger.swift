//
//  AlamofireLogger.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Foundation
import Alamofire

final class AlamofireLogger: EventMonitor {

    func requestDidResume(_ request: Request) {

        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        let headers = """
        ⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️ Headers: \(allHeaders)
        """
        print("\(headers)")

        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️⚡️⚡️⚡️ Request Started: \(request)
        ⚡️⚡️⚡️⚡️ Body Data: \(body)
        """
        print("\(message)")
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        print("⚡️⚡️⚡️⚡️ Response Received: \(response.debugDescription)")
        print("⚡️⚡️⚡️⚡️ Response All Headers: \(String(describing: response.response?.allHeaderFields))")
    }
}
