//
//  externalAPI.swift
//  yandex.radio-demo
//
//  Created by dattk on 03/08/2019.
//  Copyright © 2019 dattk. All rights reserved.
//

import Foundation

enum apiError: Error {
    case noPropertyData(dic: [String : Any?], property: String? )
}

// MARK: FLOW CONTROL COMMANDS

let apiFlowNavigateTo = "externalAPI.navigate('{to}'); true"
let apiFlowTogglePlayPause = "externalAPI.togglePause()"
let apiFlowNext = "externalAPI.next(); true" // true потому что next() возвращает Promise
let apiFlowToggleLike = "externalAPI.toggleLike(); true"
let apiFlowToggleDislike = "externalAPI.toggleDislike(); true"


// MARK: GET INFORMATION COMMANDS & STRUCTS

let apiFlowIsPlaying = "externalAPI.isPlaying()" // -> Bool

let apiGetCurrentTrack = "externalAPI.getCurrentTrack()" // -> Track
let apiGetNextTrack = "externalAPI.getNextTrack()" // -> Track
let apiGetTracksList = "externalAPI.getTracksList()" // -> [Track] = массив треков,
let apiGetTrackIndex = "externalAPI.getTrackIndex()" // -> Int = индекс в массиве треков

struct apiArtist {
    let title: String
    let cover: Cover
    let link: String?
}

struct apiAlbum {
    let title: String
    let year: Int
    let cover: Cover
    let link: String?
    let artists: [apiArtist]
}

//album: {title: "Бонни&Клайд", year: 2007, cover: "avatars.yandex.net/get-music-content/63210/a19f4e7f.a.954128-1/%%", link: "/album/954128", artists: [{title: "Ночные Снайперы", cover: "avatars.yandex.net/get-music-content/149669/1062efcb.p.218071/%%", link: "/artist/218071"}]}
//artists: [{title: "Ночные Снайперы", cover: "avatars.yandex.net/get-music-content/149669/1062efcb.p.218071/%%", link: "/artist/218071"}] (1)
//cover: "avatars.yandex.net/get-music-content/63210/a19f4e7f.a.954128-1/%%", disliked: undefined, duration: 213.97, liked: false, link: "/album/954128/track/26219049", title: "морячок", version: undefined

struct apiTrack : Equatable {
    static func == (lhs: apiTrack, rhs: apiTrack) -> Bool {
        return lhs.description == rhs.description
    }
    
    let album: apiAlbum
    let artists: [apiArtist]
    let cover: Cover
    let disliked: Bool?
    let duration: Double
    let liked: Bool
    let link: String?
    let title: String
    let version: String?
}

let apiGetPlaylist = "{index: \(apiGetTrackIndex), list: \(apiGetTracksList)}" // -> apiPlaylist
struct apiPlaylist {
    let index: Int
    let list: [apiTrack]
}

//В ссылке cover присутствует подстрока "%%", которую требуется заменить на необходимое разрешение.
//Доступны разрешения 30x30, 50x50, 80x80, 100x100, 200x200, 300x300, 400x400

typealias Cover = String
extension Cover {
    static let defaultIconUrl = "avatars.yandex.net/get-music-misc/34161/rotor-genre-rusrock-icon/%%"
    static let defaultCoverUrl = "avatars.yandex.net/get-music-misc/49997/rotor-genre-folkrock-image-vszHT/%%"
    func urlString(with resolution: apiCoverResolution = .r100x100) -> String {
        return "https://" + self.replacingOccurrences(of: "%%", with: resolution.rawValue)
        //return URL(string: urlString)
    }
}
let apiCoverDefaultUrl = "" //TODO найти картинку по умолчанию
enum apiCoverResolution: String {
    case r30x30   = "30x30"
    case r50x50   = "50x50"
    case r80x80   = "80x80"
    case r100x100 = "100x100"
    case r200x200 = "200x200"
    case r300x300 = "300x300"
    case r400x400 = "400x400"
}


let apiGetTrackProgress  = "externalAPI.getProgress()" // -> apiTrackProgress
//{position: 146.837301919, duration: 154.48816326530613, loaded: 154.48816326530613}
struct apiTrackProgress {
    let position: Double
    var duration: Double
    let loaded: Double
}
extension apiTrackProgress {
    var value : Double {
        get {
            return  (self.duration == 0 || self.position > self.duration) ? 0 : 100 * self.position / self.duration
        }
    }
}

let apiGetControlsAvailability = "externalAPI.getControls()" // -> apiControlsAvailability
//dislike: true, index: null, like: true, next: true, prev: null, repeat: null, shuffle: null
struct apiControlsAvailability: Equatable {
    let dislike: Bool
    let index: Bool
    let like: Bool
    let next: Bool
    let prev: Bool
    let `repeat`: Bool
    let shuffle: Bool
}

let apiGetSourceInfo = "externalAPI.getSourceInfo()" // -> apiSource
//{title: undefined, link: "/genre/rusrock/", type: "radio", cover: "avatars.yandex.net/get-music-misc/34161/rotor-genre-rusrock-icon/%%"} = $RADIO
// {title: "Зае...вшие рожи", year: 2018, cover: "avatars.yandex.net/get-music-content/98892/b5153f22.a.5064369-1/%%", link: "/album/5064369", artists: [{title: "Григорий Лепс", cover: "avatars.yandex.net/get-music-content/32236/b68aaa94.p.165131/%%", link: "/artist/165131"}], …} = $MUSIC
// {title: "Рок", link: "/genre/%D1%80%D0%BE%D0%BA", type: "common"}
struct apiSource {
    let artists: [apiArtist]?
    let title: String?
    let link: String
    let type: String // "radio", "album", "common"
    let cover: String?
    let year: Int?
}

// вот такой чухню возвращает callback рекламный при начале рекламы
//{image = "https://awaps.yandex.net/0/c1/tVK-Oiz0m0j1k6YASgcYXr1aVpVRK-fQoRZlIAnMz8VTg+ck33uo3HJJr9ltC_t1zdTS5PKleZBLqGsz+7w3Bbym7Jaa+66r-9THAGbTFK9WDHM0g2HaMcfgeNp_tSQ2k6GaTx87ZKMbwyAYMD49aXJJVN5cxi53nAD2KEz7FysWVPBwI1n-V8fzP_tdCyxHk4g5SfBB0N-tihWf9auCBwQqkjSyhHG0WTqI6GBeeRCrdJosllEfVnJ_tQTgGTfk0wGHA1LkDL-ihfqgsR5rVe37UTJQmlwrqscUUVEh3PmzVfNz7GgIc_tPMM-FEf+4SL3J1kMoKYkuQZ8fk4vJU2MJyW1lBchaLkfx3YgCG8rwlDQoaw+_Kq0kMDKX6Ga2iUAAA_A_.jpg";
//    link = "https://awaps.yandex.net/1/c1/tFJnooS++cRN1gBXi-hQ7U59Mf1zDpRnQEzOrLVQcYD4d685TJsm36j+AQ9DE_tIFMSNgd7INgEtuAtfiZy48foZcp-ih+oM-cDI-AjY1N-SKAKwszS5eZAQHQr_ty1cEPKcAAQg4LiTpiiH34MATasGSaCqQNX4wgJxCFix4Dps9zUJnhLMN7XRp_tlvl8UJZpmpzVggVGLStJoVb4AgLSQOGKjVIsNSceJf9ZTlhGM3-irNvkU0iM_twMc0JfTh5q879uqayJmBrxxFSivZytlk0CaySXTlR7sfHsecPj7dseNg1yXw_tWFCrV6yKvpY2oeGWKFrsgLzbew-+T6fJekZrWrnzSZ+p3FTUeRkYhPYZoXC+_il7Pe0473sw9bxaYdMNBkZZUH3-O2thRYU9UU9IR0ulMcwAAA_A_.htm";
//    title = "\U041c\U0422\U0421 Music \U2013 \U044d\U0442\U043e \U0431\U043e\U043b\U0435\U0435 50 \U043c\U043b\U043d. \U0442\U0440\U0435\U043a\U043e\U0432 \U0432\U0441\U0435\U0433\U043e \U0437\U0430 60 \U0440\U0443\U0431./\U043c\U0435\U0441\U044f\U0446"; }
struct apiAdvert {
    let image: String
    let link: String
    let title: String
}


// MARK: STRUCTS fromDictionaryInitiatable, CustomStringConvertible

protocol fromDictionaryInitiatable {
    init(from dic: [String: Any?]) throws
}

extension apiTrackProgress : fromDictionaryInitiatable, CustomStringConvertible {
    init(from dic: [String: Any?]) {
        position = dic["position"] as? Double ?? 0.0
        duration = dic["duration"] as? Double ?? 0.0
        loaded = dic["loaded"] as? Double ?? 0.0
    }
    var description: String {
        return "position:\(position.rounded())sec, duration:\(duration.rounded())sec, loaded:\(loaded.rounded())sec"
    }
}

extension apiArtist: fromDictionaryInitiatable {
    init(from dic: [String: Any?]) throws {
        if let title = dic["title"] as? String {
            self.title = title
        } else { throw apiError.noPropertyData(dic: dic, property: "title") }
        cover = dic["cover"] as? Cover ?? apiCoverDefaultUrl
        link = dic["link"] as? String
    }
}

extension apiAlbum: fromDictionaryInitiatable {
    init(from dic: [String: Any?]) throws {
        if let title = dic["title"] as? String,
            let year = dic["year"] as? Int {
            self.title = title
            self.year = year
        } else { throw apiError.noPropertyData(dic: dic, property: "title, year") }
        
        cover = dic["cover"] as? Cover ?? apiCoverDefaultUrl
        link = dic["link"] as? String
        artists = try (dic["artists"] as? NSArray ?? []).map { (it) -> apiArtist in
            return try apiArtist(from: it as? [String : Any?] ?? [:])
        }
    }
}

extension apiTrack: fromDictionaryInitiatable, CustomStringConvertible {
    init(from dic: [String: Any?]) throws {
        if let duration = dic["duration"] as? Double,
            let title = dic["title"] as? String,
            let liked = dic["liked"] as? Bool {
            self.duration = duration
            self.title = title
            self.liked = liked
        } else { throw apiError.noPropertyData(dic: dic, property: "duration, title, liked") }
        
        cover = dic["cover"] as? Cover ?? apiCoverDefaultUrl
        disliked = dic["disliked"] as? Bool
        link = dic["link"] as? String
        version = dic["version"] as? String
        album = try apiAlbum(from: dic["album"] as? [String : Any?] ?? [:])
        artists = try (dic["artists"] as? NSArray ?? []).map { (it) -> apiArtist in
            return try apiArtist(from: it as? [String : Any?] ?? [:])
        }
    }
    var description: String {
        return "title:\(title), duration:\(duration.rounded())sec, liked:\(liked)"
    }
}

extension apiPlaylist: fromDictionaryInitiatable, CustomStringConvertible {
    init(from dic: [String : Any?]) throws {
        if let index = dic["index"] as? Int {
            self.index = index
        } else { throw apiError.noPropertyData(dic: dic, property: "index") }
        list = try (dic["list"] as? NSArray ?? []).map { (it) -> apiTrack in
            return try apiTrack(from: it as? [String : Any?] ?? [:])
        }
    }
    var description: String {
        return "index:\(index), list.count:\(list.count)"
    }
}

extension apiControlsAvailability: fromDictionaryInitiatable, CustomStringConvertible {
    init(from dic: [String: Any?]) {
        dislike = dic["dislike"] as? Bool ?? false
        index = dic["index"] as? Bool ?? false
        like = dic["like"] as? Bool ?? false
        next = dic["next"] as? Bool ?? false
        prev = dic["prev"] as? Bool ?? false
        `repeat` = dic["`repeat`"] as? Bool ?? false
        shuffle = dic["shuffle"] as? Bool ?? false
    }
    var description: String {
        return "index:\(index), shuffle:\(shuffle), repeat:\(`repeat`) prev:\(prev), next:\(next), like:\(like), dislike:\(dislike)"
    }
}

extension apiSource: fromDictionaryInitiatable, CustomStringConvertible  {
    init(from dic: [String: Any?]) throws {
        if let link = dic["link"] as? String,
            let type = dic["type"] as? String { // "radio", "album", "common"
            self.link = link
            self.type = type
        } else { throw apiError.noPropertyData(dic: dic, property: "link, type") }
        artists = (dic["artists"] as? NSArray ?? []).map { (it) -> apiArtist? in
            return try? apiArtist(from: it as? [String : Any?] ?? [:])
            }.filter{ $0 != nil } as? [apiArtist]
        title = dic["title"] as? String
        cover = dic["cover"] as? String
        year = dic["year"] as? Int
    }
    var description: String {
        return "type:\(type), link:\(link), title:\(String(describing: title))"
    }
}

extension apiAdvert: fromDictionaryInitiatable, CustomStringConvertible{
    init(from dic: [String: Any?]) {
        image = dic["image"] as? String ?? ""
        link = dic["link"] as? String ?? ""
        title = dic["title"] as? String ?? "advert"
    }
    var description: String {
        return "ADVERT with title:\(title), image:\(image)"
    }
}
