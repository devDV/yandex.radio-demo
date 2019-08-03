//
//  externalAPI_EVENTS.swift
//  yandex.radio-demo
//
//  Created by dattk on 03/08/2019.
//  Copyright © 2019 dattk. All rights reserved.
//

import Foundation

// MARK: CALLBACK EVENTS

enum apiCallbackEvent: String  {
    case ready = "ready"    // EVENT_READY - готовность данного интерфейса
    case state = "state"    // EVENT_STATE - изменение состояния плеера
    case track = "track"    // EVENT_TRACK - смена трека
    case advert = "advert"  // EVENT_ADVERT - воспроизведение рекламы
    case controls = "controls" // EVENT_CONTROLS - изменение состояния элементов управления (в т.ч. смены состояния шаффла и повтора треков)
    case source = "info"    // EVENT_SOURCE_INFO - смена источника воспроизведения
    case tracks = "tracks"  // EVENT_TRACKS_LIST - изменения списка треков
    //case volume = "volume"  // EVENT_VOLUME - изменение громкости
    //case speed = "speed"    // EVENT_SPEED - изменение скорости
    case progress = "progress" // EVENT_PROGRESS - изменение временных метрик трека
}

extension apiCallbackEvent : CaseIterable {
    
    func scriptForInject() -> String {
        
        // при каких событиях какую js функцию мы вставляем в callback
        let dicJSforEvent: [apiCallbackEvent : String] = [
            .ready : apiGetControlsAvailability,
            .state : apiFlowIsPlaying,
            .track : apiGetCurrentTrack,
            .advert : "event_parameter", // параметр callback функции
            .controls : apiGetControlsAvailability,
            .source : apiGetSourceInfo,
            .tracks: apiGetPlaylist,
            //.volume: apiGetVolume,
            //.speed: apiGetSpeed,
            .progress : apiGetTrackProgress
        ]
        
        // для использования необходимо заменить в шаблоне
        // {EVENT} - имя события, {JSFUNCTION} -  функция возвращающая то, что хотим получить в ответ
        // event_parameter - параметр события, есть только для .advert (EVENT_ADVERT)
        let injectScriptTemplate = """
if (!("{EVENT}" in externalAPI.__eventCallbacks__)) externalAPI.__eventCallbacks__.{EVENT} = [];
externalAPI.__eventCallbacks__.{EVENT}.push( function (event_parameter) {
    try {
        webkit.messageHandlers.{EVENT}.postMessage({JSFUNCTION})
    } catch(err) {
        console.log('The native context does not exist yet')
} } );

"""
        let script = injectScriptTemplate.replacingOccurrences(of: "{EVENT}", with: self.rawValue)
            .replacingOccurrences(of: "{JSFUNCTION}", with: dicJSforEvent[self] ?? "event_parameter")
        return script
    }
    
    static func allScriptsCombined() -> String {
        
        let allInjectScriptsCombined = apiCallbackEvent.allCases.reduce("") { (result, event) -> String in
            let script = event.scriptForInject()
            return result + "\n" + script
        }
        return allInjectScriptsCombined
    }
    
}
