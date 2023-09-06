//
//  QRType.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 27/06/2023.
//

import Foundation
import SwiftUI
import RealmSwift

enum QRType: Int, PersistableEnum {
    case website
    case contact
    case email
    case text
    case whatsapp
    case instagram
    case facebook
    case twitter
    case spotify
    case youtube
    case wifi
    case paypal
    
    var title: String {
        switch self {
        case .website:
            return "Website"
        case .contact:
            return "Contact"
        case .email:
            return "E-mail"
        case .text:
            return "Text"
        case .whatsapp:
            return "Whatsapp"
        case .instagram:
            return "Instagram"
        case .facebook:
            return "Facebook"
        case .twitter:
            return "Twitter"
        case .spotify:
            return "Spotify"
        case .youtube:
            return "Youtube"
        case .wifi:
            return "Wifi"
        case .paypal:
            return "Paypal"
        }
    }
    
    var baseUrl: String? {
        var baseUrl: String?
        switch self {
        case .facebook:
            baseUrl = "facebook.com"
        case .instagram:
            baseUrl = "instagram.com"
        case .twitter:
            baseUrl = "twitter.com"
        case .whatsapp:
            baseUrl = "whatsapp.com"
        case .spotify:
            baseUrl = "spotify.com"
        case .youtube:
            baseUrl = "youtu.be"
        default:
            break
        }
        return baseUrl
    }
    
    var image: Image {
        switch self {
        case .website:
            return R.image.ic_website.image
        case .contact:
            return R.image.ic_contact.image
        case .email:
            return R.image.ic_email.image
        case .text:
            return R.image.ic_text.image
        case .whatsapp:
            return R.image.ic_whatsapp.image
        case .instagram:
            return R.image.ic_instagram.image
        case .facebook:
            return R.image.ic_facebook.image
        case .twitter:
            return R.image.ic_twitter.image
        case .spotify:
            return R.image.ic_spotify.image
        case .youtube:
            return R.image.ic_youtube.image
        case .wifi:
            return R.image.ic_wifi.image
        case .paypal:
            return R.image.ic_paypal.image
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .website:
            return R.color.color_F17851_alpha20.color
        case .contact:
            return R.color.color_317939_alpha20.color
        case .email:
            return R.color.color_5161F1_alpha20.color
        case .text:
            return R.color.color_F1BB51_alpha20.color
        case .whatsapp:
            return R.color.color_60D669_alpha20.color
        case .instagram:
            return R.color.color_FFC150_alpha20.color
        case .facebook:
            return R.color.color_4A6FF3_alpha20.color
        case .twitter:
            return R.color.color_3BA8F7_alpha20.color
        case .spotify:
            return R.color.color_31CD82_alpha20.color
        case .youtube:
            return R.color.color_E72C2C_alpha20.color
        case .wifi:
            return R.color.color_F43664_alpha20.color
        case .paypal:
            return R.color.color_2F3BA5_alpha20.color
        }
    }
    
    var positionShadow: (x: CGFloat, y: CGFloat) {
        switch self {
        case .email, .text:
            return (0,12)
        default:
            return (0,4)
        }
    }
    
    var radiusShadow: CGFloat {
        return 12
    }
}

enum QRGroupType: Int, CaseIterable, PersistableEnum {
    case basic
    case social
    case other
    
    var items: [QRType] {
        switch self {
        case .basic:
            return [.website, .contact, .email, .text]
        case .social:
            return [.whatsapp, .instagram, .facebook, .twitter, .spotify, .youtube]
        case .other:
            return [.wifi, .paypal]
        }
    }
    
    var title: String {
        switch self {
        case .basic:
            return Rlocalizable.basic()
        case .social:
            return Rlocalizable.social_media()
        case .other:
            return Rlocalizable.other()
        }
    }
}

enum CreateQRType: String, PersistableEnum {
    case normal
    case custom
}
