//
//  FirebaseAnalyticsEnum.swift
//  Docutalk-App
//
//  Created by Le Tuan on 02/06/2023.
//

import Foundation

enum FirebaseAnalyticsEnum: String {
    case permission_view
    case allow_access_click
    case not_allow_click
    case home_view
    case home_style_click
    case home_view_more_click
    case scan_view
    case scan_zoom_click
    case scan_flash_click
    case qr_creation_click
    case qr_creation_view
    case qr_creation_style_click
    case qr_creation_select_type_click
    case qr_creation_generate_click
    case advanced_setting_view
    case advanced_suggest_prompt_click
    case advanced_suggest_negative_prompt_click
    case advanced_setting_guidance_click
    case advanced_setting_step_click
    case qr_creation_result_view
    case qr_creation_regenerate_click
    case qr_creation_save_share_click
    case qr_creation_download_4k_click
    case qr_creation_done_click
}

enum FirebaseParamsKey: String {
    case style
    case category
    case qr_type
    case guidance_number
    case step_number
    case source
    case package_time
}

enum FirebaseParamsValue: String {
    case start_enhance
    case open_photo
    case open_app
    case home
    case result_enhance
    case start_generate
    case save_ai_generate
    case features
    case weekly
    case monthly
}
