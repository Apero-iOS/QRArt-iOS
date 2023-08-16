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
    case scan_view
    case scan_zoom_click
    case scan_flash_click
    case qr_creation_click
    case qr_creation_view
    case qr_creation_next_style_click
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
    case result_save_as_4k_click
    case qr_creation_done_click
    case sub_view
    case sub_weekly_click
    case sub_monthly_click
    case sub_lifetime_click
    case sub_successfull
    case sub_successfull_3days_free_trial
    case history_all_click
    case setting_view
    case setting_language
    case setting_pricacy_policy
    case setting_term_of_service
    case setting_rate_app
    case setting_share_app
    case onboarding_view
    case onboarding_click
    case permission_camera_view
    case permission_camera_allow_click
    case permission_camera_not_allow_click
    case permission_photo_view
    case permission_photo_allow_click_view
    case permission_photo_not_allow_click_view
    case home_dialog_view
    case home_upload_qr_click
    case home_create_new_qr_click
    case my_qr_click
    case my_qr_view
    case my_qr_thumnail_click
    case qr_creation_change_style_click
    case result_share_click
}

enum FirebaseParamsKey: String {
    case style
    case category
    case qr_type
    case guidance_number
    case step_number
    case source
    case package_time
    case share_type
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
