//
//  flow.swift
//  yandex.radio-demo
//
//  Created by dattk on 03/08/2019.
//  Copyright © 2019 dattk. All rights reserved.
//

import Foundation

protocol FlowControl {
    func toggle()
//    func next()
//    func like()
//    func dislike()
//    func navigate(to: String)
}

enum FlowSource {
    case radio
    case music
}

protocol FlowSourceDelegate {
    func onReady(controls: apiControlsAvailability)
    func onChange(controls: apiControlsAvailability) // при изменнии доступности функций
    func onChange(source: apiSource) // при изменении радиостанции
    func onChange(state isPlaying: Bool) // при изменении состояния плейера
    func onChange(track: apiTrack) // при изменении текущего трека
    func onChange(playlist: apiPlaylist) // при изменении в наборе треков
    //    func onChangeFeedback() // при лайках/дизлайках
    //    func onChangeVolume() // при изменении уровня громкости
    func onChange(advert: Bool, info: apiAdvert?)
    func onChange(liked: Bool, info: apiTrack?)
    func onChange(trackProgress: apiTrackProgress) // при изменении позиции в треке
}

protocol RadioSourceDelegate: FlowSourceDelegate {
//    func onChange(station list: [apiStation])
}

protocol MusicSourceDelegate: FlowSourceDelegate {
}
