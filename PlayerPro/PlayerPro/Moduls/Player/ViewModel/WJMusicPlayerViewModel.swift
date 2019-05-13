//
//  WJMusicPlayerViewModel.swift
//  PlayerPro
//
//  Created by William on 2019/4/22.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

public enum WJMusicPlayStatus: Int {
    case Paused
    case Playing
}

class WJMusicPlayerViewModel: NSObject, AVAudioPlayerDelegate {
    /// TODO: 单例
    static let sharedInstance = WJMusicPlayerViewModel()
    
    private override init() {
        super.init()
        status = .Paused
        
        /// 设置类型
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        /// 设置支持后台播放
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    private func updateLockedScreenInfo() {
        /// 重新通过歌词生成图片 -> 设置到
        guard let song = playingSong else {
            return
        }
        let image = UIImage(contentsOfFile: song.coverPath ?? "")
        let center = MPNowPlayingInfoCenter.default()
        center.nowPlayingInfo = [MPNowPlayingInfoPropertyElapsedPlaybackTime:currentTime,
                                 MPMediaItemPropertyTitle:song.name ?? "",
                                 MPMediaItemPropertyArtist:song.author ?? "",
                                 MPMediaItemPropertyPlaybackDuration:duration,
                                 MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: image ?? UIImage())]
    }
    
    private var _player: AVAudioPlayer? = nil
    
    // 正在播放歌曲
    private dynamic var _playingSong: WJSongModel? {
        willSet {
            // 需要判断当前是否在播放
            guard let song = newValue else {
                print("当前没有要播放的歌曲")
                return
            }
            let mp3Path = Bundle.main.path(forResource: song.path, ofType: nil)
            guard let path = mp3Path else {
                print("播放文件获取失败")
                return
            }
            _player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            _player?.delegate = self
        }
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WJMusicPlayerSongDidChangedNotification"), object: self, userInfo: ["kPlayingSong":playingSong as Any])
        }
    }
    open var playingSong: WJSongModel? {
        get {
            if nil == _playingSong && nil != songs && songs?.count ?? 0 > 0 {
                _playingSong = songs?[0]
            }
            return _playingSong
        }
        set {
            _playingSong = newValue
        }
    }
    
    // 播放状态
    var status: WJMusicPlayStatus = .Paused {
        willSet {
            
        }
        didSet {
            NotificationCenter.default.post(name: .init("WJMusicPlayerPlayStatusDidChangedNotification"), object: self, userInfo: ["kPlayingSong":status])
            switch status {
            case .Paused:
                if let timer = _currentTimeObserver {
                    timer.invalidate()
//                    _currentTimeObserver = nil
                }
                break
            case .Playing:
                _currentTimeObserver = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(doObserverCurrentTime(_:)), userInfo: nil, repeats: true)
                break
            }
        }
    }
    private var _currentTimeObserver: Timer?
    
    @objc private func doObserverCurrentTime(_ timer: Timer) {
        print("\(timer)")
        NotificationCenter.default.post(name: .init("WJMusicPlayerCurrentTimeDidChangedNotification"), object: self, userInfo: ["kCurrentTime":currentTime, "kDuration":duration])
        /// 通知系统
        updateLockedScreenInfo()
    }
    
    // 单前播放时间 计算属性不存储
    var currentTime: TimeInterval {
        get {
            if let player = _player {
                return player.currentTime
            }
            return 0.0
        }
        set {
            if let player = _player {
                player.currentTime = newValue
            }
        }
    }
    // 播放时长
    var duration: TimeInterval {
        get {
            if let player = _player {
                return player.duration
            }
            return 0.0
        }
    }
    
    // 播放列表
    private var _songs: [WJSongModel]?
    
    open var songs: [WJSongModel]? {
        get {
            return _songs
        }
        set {
            _songs = newValue
        }
    }
    
    /// SUDO: 播放事件
    open func play() {
        _player?.play()
        status = .Playing;
    }
    
    open func pause() {
        _player?.pause()
        status = .Paused
    }
    
    open func forward() {
        forwardAndBackward(-1)
    }
    
    open func next() {
        forwardAndBackward(1)
    }
    
    private func forwardAndBackward(_ num: Int) {
        guard let song = playingSong, let songs = _songs else {
            print("failed to get the song !")
            return
        }
        let selectedIndex = songs.firstIndex(of:song)
        guard var index = selectedIndex else {
            print("怎么可能不包含该歌曲呢")
            return
        }
        index = index + num
        if index < 0 {
            index = songs.count - 1
        }
        if index >= songs.count {
            index = 0
        }
        playingSong = songs[index]
        
        if status == .Playing {
            _player?.play()
        }
    }
    
    /// TODO: audio player delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
    
}
