//
//  APIError.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire

enum APIError: Error {
    case Internal_Server
    case Invalid_Input
    case User_Blocked
    case Not_Found
    case Conversation_Hit_The_Limit
    case Device_Already_Exist
    case Message_Hit_The_Limit
    case Invalid_Signature
    case Invalid_Timestamp
    case Invalid_Nonce
    case Upload_File_Hit_The_Limit
    case Unauthorize
    case Cant_Get_Summarize
    case Cant_Cancel_Subscription
    case Max_File_Per_Day_Free
    case Max_File_Per_Day_Premium
    case Max_Question_Per_Day_Premium
    case Max_Question_Per_Day_Free
    case Not_Support_File_Type_Free
    case Not_Support_File_Type_Premium
    case Exceed_File_Size_Free
    case Exceed_File_Size_Premium
    case General
    case Time_Out
    case No_Network
    case Decode_Failed
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .Internal_Server
        case 1: self = .Invalid_Input
        case 2: self = .User_Blocked
        case 3: self = .Not_Found
        case 4: self = .Conversation_Hit_The_Limit
        case 5: self = .Device_Already_Exist
        case 6: self = .Message_Hit_The_Limit
        case 7: self = .Invalid_Signature
        case 8: self = .Invalid_Timestamp
        case 9: self = .Invalid_Nonce
        case 10: self = .Upload_File_Hit_The_Limit
        case 11: self = .Unauthorize
        case 12: self = .Cant_Get_Summarize
        case 13: self = .Cant_Cancel_Subscription
        case 14: self = .Max_File_Per_Day_Free
        case 15: self = .Max_File_Per_Day_Premium
        case 16: self = .Max_Question_Per_Day_Premium
        case 17: self = .Max_Question_Per_Day_Free
        case 18: self = .Not_Support_File_Type_Free
        case 19: self = .Not_Support_File_Type_Premium
        case 20: self = .Exceed_File_Size_Free
        case 21: self = .Exceed_File_Size_Premium
        default: self = .General
        }
    }
}
