//
//  WJSongListManager.swift
//  PlayerPro
//
//  Created by William on 2019/4/25.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import ObjectMapper

class WJSongListManager: NSObject, Mappable {
    
    /// 播放列表
    private var _songLists: [WJSongListModel]?
    
    /// 只读计算属性
    open var songLists: [WJSongListModel]? {
        return _songLists
    }
    
    /// 添加播放列表
    open func addSongList(_ songList: WJSongListModel?) -> Bool {
        if let songList = songList {
            if _songLists == nil {
                _songLists = []
            }
            _songLists?.append(songList)
            return true
        }
        return false
    }
    
    open func removeSongList(_ index: Int) -> Bool? {
        if index >= 0 && index < _songLists?.count ?? 0 {
            _songLists?.remove(at: index)
            return true
        }
        return false
    }
    
    /// TODO: Mappable protocol method
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    /// 单例
    static let sharedInstance = WJSongListManager()
    
    /// TODO: init data
    private override init() {
        super.init()
        /// 模拟加载列表数据
        let sourcePath = Bundle.main.path(forResource: "music/playlists.json", ofType: nil)
        guard let path = sourcePath else {
            print("playlists.json 文件加载不成功")
            return
        }
        let content = try? String(contentsOfFile: path, encoding: .utf8)
        guard let jsonString = content else {
            print("playlists.json 内容加载不成功")
            return
        }
        let songLists = Mapper<WJSongListModel>().mapArray(JSONString: jsonString)
        guard let list = songLists else {
            print("playlists.json 内容模型化出错")
            return
        }
        self._songLists = list
    }
}
