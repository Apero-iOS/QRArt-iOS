//
//  AFNetworking.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 30/06/2023.
//

import Alamofire

final class AFNetworking {
    let session: Session
    
    required init() {
        session = Session(eventMonitors: [AlamofireLogger()])
    }
}

