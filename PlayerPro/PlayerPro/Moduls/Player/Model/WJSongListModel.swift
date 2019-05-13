//
//  WJSongListModel.swift
//  PlayerPro
//
//  Created by William on 2019/4/25.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import ObjectMapper

class WJSongListModel: NSObject, Mappable {
    /// 列表名称
    private var _listName: NSString?
    
    open var listName: NSString? {
        return _listName
    }
    
    /// 歌曲列表
    private var _songs: [WJSongModel]?
    
    open var songs: [WJSongModel]? {
        return _songs
    }
    
    /// 添加歌曲
    open func addSong(_ song: WJSongModel?) -> Bool {
        if let song = song {
            if _songs == nil {
                _songs = []
            }
            _songs?.append(song)
            return true;
        }
        return false
    }
    
    /// 移除歌曲
    open func removeSong(_ index: Int) -> Bool {
        if index >= 0 && index < _songs?.count ?? 0 {
            _songs?.remove(at: index)
            return true
        }
        return false
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _listName <- map["name"]
        _songs    <- map["songs"]
    }
}
