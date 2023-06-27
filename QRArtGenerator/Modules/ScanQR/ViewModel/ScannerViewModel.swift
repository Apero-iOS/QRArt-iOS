//
//  ScannerViewModel.swift
//  QRArtGenerator
//
//  Created by khac tao on 27/06/2023.
//

import Foundation
import AVKit
import NetworkExtension

class ScannerViewModel: ObservableObject {
    
    var connectionStatus: String = ""
    func handleScan(result: Result<String, Error>) {
        switch result {
        case .success(let code):
            let data_code = code.data(using: .utf8)
            do {
                let dict_code = try JSONSerialization.jsonObject(with: data_code!, options: .allowFragments) as! [String : Any]
                let wifi_ssid = dict_code["S"] as! String
                let wifi_pwd = dict_code["P"] as! String
                let wifi_type = dict_code["T"] as! String
                
                let configuration = NEHotspotConfiguration.init(ssid: wifi_ssid, passphrase: wifi_pwd, isWEP: self.checkWifiType(type: wifi_type))
                configuration.joinOnce = true
                NEHotspotConfigurationManager.shared.apply(configuration) {
                    (error) in
                    if error != nil {
                        if let errorStr = error?.localizedDescription {
                            print("Error Information:\(errorStr)")
                        }
                        if (error?.localizedDescription == "already associated.") {
                            print("Connected!")
                        } else {
                            print("No Connected!")
                        }
                    } else {
                        print("Connected!")
                    }
                }
                
                print("Dict_Code:\(dict_code)")
            } catch (let error) {
                print("JSONSerial... Convert Error:\(error.localizedDescription)")
            }
            
        case .failure(_):
            self.connectionStatus = "Scanning failed!"
        }
    }
    
    func checkWifiType(type: String) -> Bool {
        return true
    }
    
}
