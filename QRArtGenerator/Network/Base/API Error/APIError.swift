//
//  APIError.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire

enum APIError: Error {
    case Internal_Error
    case Invalid_Input
    case General
    case Time_Out
    case No_Network
    case Decode_Failed
    case Service_Unavailable
    
    init?(rawValue: Int) {
        switch rawValue {
        case 400: self = .Invalid_Input
        case 408: self = .Time_Out
        case 500: self = .Internal_Error
        case 503: self = .Service_Unavailable
        default: self = .General
        }
    }
    
    var message: String {
        switch self {
        case .No_Network:
            return Rlocalizable.no_internet()
        default:
            return Rlocalizable.could_not_load_data()
        }
    }
}
