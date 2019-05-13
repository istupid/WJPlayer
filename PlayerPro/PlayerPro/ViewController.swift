//
//  ViewController.swift
//  PlayerPro
//
//  Created by William on 2019/4/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.addSubview(playButton);
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(showPlayerButton)

        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        
        WJMusicPlayerViewModel.sharedInstance.songs = WJSongListManager.sharedInstance.songLists?[0].songs ?? []
        _ = WJMusicPlayerViewModel.sharedInstance.playingSong
    }

    // TODO: 懒加载子控件
    private lazy var backgroundView: UIView = {
       let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        return backgroundView
    }()
    
    override func updateViewConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
//            make.leading.trailing.equalTo(view)
//            if #available(iOS 11.0, *) {
//                make.top.bottom.equalTo(view.safeAreaLayoutGuide)
//            } else {
//                make.top.equalTo(topLayoutGuide.snp.bottom)
//                make.bottom.equalTo(bottomLayoutGuide.snp.top)
//            }
        }
        
        playButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(view).offset(-300)
            make.centerX.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(60);
        }
        
        previousButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(playButton)
            make.centerY.equalTo(playButton).offset(100)
            make.height.width.equalTo(playButton)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(previousButton)
            make.centerY.equalTo(previousButton).offset(100)
            make.height.width.equalTo(playButton)
        }
        
        showPlayerButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(nextButton)
            make.centerY.equalTo(nextButton).offset(100)
            make.height.equalTo(playButton)
            make.width.equalTo(200)
        }
        
        super.updateViewConstraints()
    }
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(text: "Play", textColor: UIColor.yellow, fontSize: 14, target: self, action: #selector(play))
        return playButton
    }()
    
    private lazy var previousButton: UIButton = {
        let previousButton = UIButton(text: "Prev", textColor: UIColor.green, fontSize: 16, target: self, action: #selector(previous))
        return previousButton
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton(text: "Next", textColor: UIColor.cyan, fontSize: 16, target: self, action: #selector(nextSong))
        return nextButton
    }()
    
    private lazy var showPlayerButton: UIButton = {
        let showPlayer = UIButton(text: "显示播放详情", textColor: UIColor.lightText, fontSize: 18, target: self, action: #selector(showPalyerDetail))
        return showPlayer
    }()
    
    private let viewModel = WJMusicPlayerViewModel.sharedInstance
    
    @objc func play() {
        let status = viewModel.status
        switch status {
        case .Playing:
            viewModel.pause()
            break
        case .Paused:
            viewModel.play()
            break
        }
    }
    
    @objc func previous() {
        viewModel.forward()
    }
    /// MARK:
    @objc func nextSong() {
        viewModel.next();
    }
    
    // FIXME:
    @objc func showPalyerDetail() {
        print("跳转播放详情")
        let playerViewController = WJPlayerViewController()
        playerViewController.view.backgroundColor = UIColor.white
        let naviagetionController = UINavigationController(rootViewController: playerViewController)
        present(naviagetionController, animated: true) {
            print("已经跳转了哟")
        }
    }
    
}


