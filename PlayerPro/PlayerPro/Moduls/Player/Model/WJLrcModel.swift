//
//  WJLrcModel.swift
//  PlayerPro
//
//  Created by William on 2019/4/23.
//  Copyright © 2019 William. All rights reserved.
//

import ObjectMapper

struct WJLrcLinePartModel {
    /// 播放时长
    var duration: TimeInterval = 0.0
    /// 文字
    var text: String = ""
}

struct WJLrcLineModel {
    // 行开始时间
    var beginTime: TimeInterval = 0.0
    // 行显示时长
    var duration: TimeInterval = 0.0
    // 文字切割比分
    var parts: [WJLrcLinePartModel] = []
    // 歌词行
    var lrcString: String = ""
    
    init(_ content: String) {
        let pattern = #"\[\d+,\d+]"#
        let regular = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: content.count)
        let results = regular?.matches(in: content, options: .reportProgress, range: range)
        
        guard let subRange = results?.first?.range else {
            print("根据规则未能获取匹配字符")
            return
        }
        let start = content.index(after: content.firstIndex(of: "[")!)
        let end   = content.index(before: content.firstIndex(of: "]")!)
        let substring = content[start...end]
        let time = substring.components(separatedBy: ",")
        beginTime = TimeInterval(time[0]) ?? 0.0
        duration  = TimeInterval(time[1]) ?? 0.0

        /// 解析内容
        let lrcPattern = #"\(\d+,\d+\)\w+"#
        let lrcRegular = try? NSRegularExpression(pattern: lrcPattern, options: .caseInsensitive)
        guard let lrcResult = lrcRegular?.matches(in: content, options: .reportProgress, range: range) else {
            print("没有匹配到内容")
            return
        }
        for result in lrcResult {
            let start = content.index(content.startIndex, offsetBy: result.range.location)
            let end   = content.index(start, offsetBy: result.range.length - 1)
            let partString = content[start...end]
            let durationStart = partString.index(after: partString.firstIndex(of: ",")!)
            let durationEnd   = partString.index(before: partString.firstIndex(of: ")")!)
            let textStart     = partString.index(after: partString.firstIndex(of: ")")!)
            var part = WJLrcLinePartModel()
            part.duration = TimeInterval(partString[durationStart...durationEnd]) ?? 0.0
            part.text = String(partString[textStart...])
            parts.append(part)
            lrcString.append(part.text)
        }
    }
    
    private func beginTimeAndDuration() -> (TimeInterval, TimeInterval) {
        
        return (0,0)
    }
}

struct WJLrcModel {
    
    var lines: [WJLrcLineModel]?

    init(with lrcPath: String?) {
        guard let path = lrcPath else {
            print("歌词路径有问题")
            return
        }
        let fullPath = Bundle.main.path(forResource: path , ofType: nil)
        guard let contentPath = fullPath else {
            print("找不到歌词的路径")
            return
        }
        let content = try? String(contentsOfFile: contentPath, encoding: .utf8)
        let lines = content?.components(separatedBy: "\n") ?? []
        for line in lines {
            let lrcLine = WJLrcLineModel(line)
            if self.lines == nil {
                self.lines = []
            }
            self.lines?.append(lrcLine)
        }
    }
}


