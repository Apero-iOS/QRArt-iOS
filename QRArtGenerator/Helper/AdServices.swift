//
//  AdServices.swift
//  PDFEditor
//
//  Created by ANH VU on 17/07/2023.
//

import Foundation
import UIKit
import iAd
import AdServices
import FirebaseAnalytics

//Search Ads attribution info: ["countryOrRegion": US, "orgId": 1234567890, "campaignId": 1234567890, "clickDate": 2023-05-05T09:57Z, "conversionType": Download, "adGroupId": 1234567890, "attribution": 1, "keywordId": 12323222, "adId": 1234567890]

class AdServices {
    static let shared = AdServices()

    private struct AttributionResult: Codable {
        let campaignId: Int
        let adGroupId: Int?
        let clickDate: String?
        let keywordId: Int?
        let adId: Int?
    }

    func fetchAttributionData() {
        guard !UserDefaults.standard.isTrackingSearchAd else { return }
        
        if #available(iOS 14.3, *) {
            fetchAttributionTokeniOS14()
        } else {
            fetchAttributionDetailsiOSEarlier()
        }
    }

    @available(iOS 14.3, *)
    private func fetchAttributionTokeniOS14() {
        do {
            let attributionToken = try AAAttribution.attributionToken()
            sendAttributionRequest(token: attributionToken)
        } catch {
            print("Error fetching attribution token:", error)
        }
    }

    private func fetchAttributionDetailsiOSEarlier() {
        ADClient.shared().requestAttributionDetails { attributionDetails, error in
            guard let attributionDetails = attributionDetails else {
                print("Search Ads error: \(error?.localizedDescription ?? "")")
                return
            }
            self.parseAttributionDetails(attributionDetails)
        }
    }

    private func parseAttributionDetails(_ attributionDetails: [String: Any]) {
        for (version, adDictionary) in attributionDetails {
            print("Search Ads version:", version)
            if let attributionInfo = adDictionary as? [String: Any],
               let campaignIdString = attributionInfo["iad-campaign-id"] as? String,
               let campaignId = Int(campaignIdString) {
                if campaignId != 1234567890 {
                    let iadAdgroupId = attributionInfo["iad-adgroup-id"] as? Int
                    let iadClickDate = attributionInfo["iad-click-date"] as? String
                    let iadKeyword = attributionInfo["iad-keyword"] as? String
                    let adId = attributionInfo["iad-creative-id"] as? Int
                    
                    let params = [
                        "SA_Campaign_ID" : "\(campaignId)",
                        "SA_Adgroup_ID" : "\(iadAdgroupId ?? 0)",
                        "SA_Creative_ID" : "\(adId ?? 0)",
                        "SA_Keyword_ID" : "\(iadKeyword ?? "")"
                    ]
                    Analytics.logEvent("open_app_from_apple_search_ad", parameters: params)
                    UserDefaults.standard.isTrackingSearchAd = true
                }
            }
        }
    }

    @available(iOS 14.3, *)
    private func sendAttributionRequest(token attributionToken: String) {
        let urlString = "https://api-adservices.apple.com/api/v1/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(attributionToken.utf8)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error sending attribution request:", error)
                return
            }
            guard let data = data else {
                print("No data received in response")
                return
            }

            do {
                let result = try JSONDecoder().decode(AttributionResult.self, from: data)
                if result.campaignId != 1234567890 {
                    let params = [
                        "SA_Campaign_ID" : "\(result.campaignId)",
                        "SA_Adgroup_ID" : "\(result.adGroupId ?? 0)",
                        "SA_Creative_ID" : "\(result.adId ?? 0)",
                        "SA_Keyword_ID" : "\(result.keywordId ?? 0)"
                    ]
                    Analytics.logEvent("open_app_from_apple_search_ad", parameters: params)
                    UserDefaults.standard.isTrackingSearchAd = true
                }
            } catch {
                print("Error parsing attribution response:", error)
            }
        }

        task.resume()
    }
}

extension UserDefaults {
    var isTrackingSearchAd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "key_tracking_search_ad")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "key_tracking_search_ad")
        }
    }
}
