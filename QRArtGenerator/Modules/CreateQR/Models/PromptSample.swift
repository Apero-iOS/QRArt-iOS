//
//  PromptSample.swift
//  QRArtGenerator
//
//  Created by Le Tuan on 26/07/2023.
//

import Foundation

enum PromptSuggessType: CaseIterable {
    case cyberpunk
    case landscapes
    case anime
    case portraits
    case flying_dog
    case young
    case city
    case concepts
    case caslte
    case super_hero
    case elegant

    var title: String {
        switch self {
            case .cyberpunk:
                return Rlocalizable.cyberpunk()
            case .landscapes:
                return Rlocalizable.landscapes()
            case .anime:
                return Rlocalizable.anime()
            case .portraits:
                return Rlocalizable.portraits()
            case .flying_dog:
                return Rlocalizable.flying_dog()
            case .young:
                return Rlocalizable.young()
            case .city:
                return Rlocalizable.city()
            case .concepts:
                return Rlocalizable.concepts()
            case .caslte:
                return Rlocalizable.caslte()
            case .super_hero:
                return Rlocalizable.super_hero()
            case .elegant:
                return Rlocalizable.elegant()
        }
    }
    
    var content: String {
        switch self {
            case .cyberpunk:
                return Rlocalizable.content_prompt_suggess_1()
            case .landscapes:
                return Rlocalizable.content_prompt_suggess_2()
            case .anime:
                return Rlocalizable.content_prompt_suggess_3()
            case .portraits:
                return Rlocalizable.content_prompt_suggess_4()
            case .flying_dog:
                return Rlocalizable.content_prompt_suggess_5()
            case .young:
                return Rlocalizable.content_prompt_suggess_6()
            case .city:
                return Rlocalizable.content_prompt_suggess_7()
            case .concepts:
                return Rlocalizable.content_prompt_suggess_8()
            case .caslte:
                return Rlocalizable.content_prompt_suggess_9()
            case .super_hero:
                return Rlocalizable.content_prompt_suggess_10()
            case .elegant:
                return Rlocalizable.content_prompt_suggess_11()
        }
    }
}

struct PromptSample {
    let prompt: [String] = ["a home built in a huge Soap bubble, windows, doors, porches, awnings, middle of SPACE, cyberpunk lights, Hyper Detail, 8K, HD, Octane Rendering, Unreal Engine, V-Ray, full hd",
                            "ossuary cemetary segmented shelves overgrown, graveyard, vertical shelves, zdzisław beksiński, hr giger, mystical occult symbol in real life, high detail, green fog",
                            "Rubber Duck Aliens visiting the Earth for the first time, hyper-realistic, cinematic, detailed",
                            "Reunion of man, team, squad, cyberpunk, abstract, full hd render + 3d octane render +4k UHD + immense detail + dramatic lighting + well lit + black, purple, blue, pink, cerulean, teal, metallic colours",
                            "surreal blueish monk, dodecahedron for his head, amazing details, hyperrealistic photograph, octane made of billions of intricate small houses, GODLIKE, bokeh, photography on mars, cinematic lighting",
                            "full body character + beautiful female neopunk wizard opening a portal to the sidereal multiverse",
                            "Samhain figure, creature, wicca, occult, harvest, fall, hyper-realistic, ultra resolution, creepy, dark, witchcore",
                            "Dog shopping with a stroller, Hollywood"]
    let negativePrompt: [String] = ["amputee, autograph, bad anatomy,bad illustration",
                                    "bad proportions, beyond the borders, blank background",
                                    "blurry, body out of frame, boring background",
                                    "extra fingers, extra hands ,extra legs, extra limbs",
                                    "bad_pictures, (bad_prompt_version2:0.8 ), EasyNegative, 3d, cartoon, anime, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)),",
                                    "missing arms, missing fingers, missing hands, missing legs, mistake",
                                    "unfocused, unattractive, unnatural pose, unreal engine",
                                    "ugly, disfigured, low quality, blurry, nsfw"]
    
    func randomPrompt() -> String {
        prompt.randomElement() ?? ""
    }
    
    func randomNegativePrompt() -> String {
        negativePrompt.randomElement() ?? ""
    }
}
