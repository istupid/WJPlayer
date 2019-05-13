//
//  WJSongModel.swift
//  PlayerPro
//
//  Created by William on 2019/4/23.
//  Copyright © 2019 William. All rights reserved.
//

import ObjectMapper

class WJSongModel: NSObject, Mappable {
    // 歌曲路径
    var path: String?
    // 歌曲名字
    var name: String?
    // 歌曲作者
    var author: String?
    // 图片路径
    var coverPath: String?
    // 歌词路径
    var lrcPath: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        author <- map["singer"]
        coverPath <- map["cover"]
        path <- map["mp3"]
        lrcPath <- map["lrc"]
    }
    
}
