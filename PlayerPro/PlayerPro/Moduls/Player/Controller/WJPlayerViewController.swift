//
//  WJPlayerViewController.swift
//  PlayerPro
//
//  Created by William on 2019/4/22.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import ObjectMapper

class WJPlayerViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerSongDidChangedNotification(_:)), name: NSNotification.Name("WJMusicPlayerSongDidChangedNotification"), object: viewModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerPlayStatusDidChangedNotification(_:)), name: NSNotification.Name("WJMusicPlayerPlayStatusDidChangedNotification"), object: viewModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(musicPlayerCurrentTimeDidChangedNotification(_:)), name: NSNotification.Name("WJMusicPlayerCurrentTimeDidChangedNotification"), object: viewModel)
        
        loadInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func musicPlayerSongDidChangedNotification(_ notification: NSNotification) {
        refreshSongInfo(viewModel.playingSong)
        refreshDurationLabel(viewModel.duration)
    }
    
    @objc private func musicPlayerPlayStatusDidChangedNotification(_ notification: NSNotification) {
        refreshPlayOrPauseStatus(viewModel.status)
    }
    
    @objc private func musicPlayerCurrentTimeDidChangedNotification(_ notification: NSNotification) {
        refreshCurrentTimeLabel(viewModel.currentTime)
        /// 毫秒
        lrcView.setCurrentTime(viewModel.currentTime * 1000)
    }
    
    /// 添加视图
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundEffectView)
        view.addSubview(contentView)
        contentView.addSubview(coverImageView)
        contentView.addSubview(landscapeScrollView)
        landscapeScrollView.addSubview(lrcView)
        view.addSubview(controlAreaView)
        controlAreaView.addSubview(currentTimeLabel)
        controlAreaView.addSubview(progressSlider)
        controlAreaView.addSubview(durationLabel)
        controlAreaView.addSubview(forwardButton)
        controlAreaView.addSubview(playOrPauseButton)
        controlAreaView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        backgroundEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(backgroundImageView)
        }
        
        controlAreaView.snp.makeConstraints { (make) in
            make.trailing.leading.equalTo(view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.bottom.equalTo(view)
            }
            make.height.equalTo(130)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(controlAreaView.snp_top);
            make.top.equalTo(navigationHeight())
        }
        
        /// 内容约束
        coverImageView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.edges.equalTo(UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5))
        }
        
        landscapeScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        lrcView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalTo(landscapeScrollView)
            make.leading.equalTo(landscapeScrollView).offset(SCREEN_WIDTH)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(landscapeScrollView)
        }
        
        /// 控制区域约束
        currentTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(controlAreaView).offset(5)
            make.centerY.equalTo(progressSlider)
        }
        
        progressSlider.snp.makeConstraints { (make) in
            make.top.equalTo(controlAreaView).offset(10)
            make.leading.equalTo(currentTimeLabel.snp_trailing).offset(5)
            make.trailing.equalTo(durationLabel.snp_leading).offset(-5)
            make.height.equalTo(30)
        }
        
        durationLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(controlAreaView).offset(-5)
            make.centerY.equalTo(progressSlider)
        }
        
        playOrPauseButton.snp.makeConstraints { (make) in
            make.size.equalTo(playOrPauseButton.currentImage!.size)
            make.centerX.equalTo(controlAreaView)
            make.bottom.equalTo(-10)
        }
        
        forwardButton.snp.makeConstraints { (make) in
            make.size.equalTo(forwardButton.currentImage!.size)
            make.centerY.equalTo(playOrPauseButton);
            make.trailing.equalTo(playOrPauseButton.snp_leading).offset(-15)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.size.equalTo(nextButton.currentImage!.size)
            make.centerY.equalTo(playOrPauseButton);
            make.leading.equalTo(playOrPauseButton.snp_trailing).offset(15)
        }
    }
    
    /// TODO: navigation
    private func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        /// 导航底部线条
//        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = barButtonItem
        
        title = "测试文字"
    }
    
    private lazy var barButtonItem: UIBarButtonItem = {
        let backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(actionBack))
        backBarButtonItem.tintColor = kTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),
                                                            NSAttributedString.Key.foregroundColor: kTintColor]
        return backBarButtonItem
    }()
    
    @objc private func actionBack() {
        dismiss(animated: true, completion: nil)
    }

    /// TODO: lazy view
    /// 设置背景
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// 制作背景模糊
    private lazy var backgroundEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return effectView
    }()
    
    /// 制作正文内容视图
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.clear
        return contentView
    }()
    
    /// 添加封面视图
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// 添加滚动视图
    private lazy var landscapeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    /// 添加歌词视图
    private lazy var lrcView: WJLrcView = {
        let lrcView = WJLrcView()
        lrcView.backgroundColor = UIColor.clear
        return lrcView
    }()
    
    /// 创建控制区域
    private lazy var controlAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let timeLabel = UILabel("00:00")
        return timeLabel
    }()
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider("image_player/player_slider_block_normal", self, #selector(actionSliderDidChanged(_:)))
        return slider
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel("00:00")
        return durationLabel
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(UIImage.tintImage("image_player/player_btn_forward_normal"),
                              self, #selector(actionForward(_:)))
        return button
    }()
    
    private lazy var playOrPauseButton: UIButton = {
        let button = UIButton(UIImage.tintImage("image_player/player_btn_play_normal"),
                              UIImage.tintImage("image_player/player_btn_pause_normal"),
                              self, #selector(actionPlayOrPause(_:)))
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(UIImage.tintImage("image_player/player_btn_next_normal"),
                              self, #selector(actionNext(_:)))
        return button
    }()
    
    
    private let viewModel = WJMusicPlayerViewModel.sharedInstance
    
    /// SUDO: target mothod
    
    @objc private func actionSliderDidChanged(_ slider: UISlider) {
        viewModel.currentTime = Double(slider.value) * viewModel.duration
    }
    
    @objc private func actionForward(_ button: UIButton) {
        viewModel.forward()
    }
    
    @objc private func actionPlayOrPause(_ button: UIButton) {
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
    
    @objc private func actionNext(_ button: UIButton) {
        viewModel.next()
    }
    
    /// SUDO:
    /// load display infomation for the first time
    private func loadInfo() {
        refreshSongInfo(viewModel.playingSong)
        refreshPlayOrPauseStatus(viewModel.status)
    }
    
    private func refreshSongInfo(_ info: WJSongModel?) {
        let coverPath = Bundle.main.path(forResource: info?.coverPath, ofType: nil) ?? ""
        let coverImage = UIImage(contentsOfFile: coverPath)
        title = info?.name
        backgroundImageView.image = coverImage
        coverImageView.image = coverImage;
        /// load lrc and set lrc view
        /// 加载歌词
        DispatchQueue.global().async {
            let lrc = WJLrcModel(with: self.viewModel.playingSong?.lrcPath)
            DispatchQueue.main.async {
                self.lrcView.setLrc(lrc);
            }
        }
    }
    
    private func refreshPlayOrPauseStatus(_ status: WJMusicPlayStatus) {
        switch status {
        case .Paused:
            playOrPauseButton.isSelected = false
            break
        case .Playing:
            playOrPauseButton.isSelected = true
            break
        }
    }
    
    private func refreshDurationLabel(_ duration: TimeInterval) {
        let fmt = DateFormatter()
        fmt.dateFormat = "mm:ss"
        durationLabel.text = fmt.string(from: Date(timeIntervalSince1970: duration))
    }
    
    private func refreshCurrentTimeLabel(_ currentTime: TimeInterval) {
        let fmt = DateFormatter()
        fmt.dateFormat = "mm:ss"
        currentTimeLabel.text = fmt.string(from: Date(timeIntervalSince1970: currentTime))
        progressSlider.value = Float(currentTime / viewModel.duration)
    }
    
    
    /// TODO: scroll view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let rate = scrollView.contentOffset.x / SCREEN_WIDTH
        coverImageView.alpha = 1 - rate
    }
}



