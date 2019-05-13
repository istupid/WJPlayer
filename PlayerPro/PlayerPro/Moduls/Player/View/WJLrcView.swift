//
//  WJLrcView.swift
//  PlayerPro
//
//  Created by William on 2019/4/24.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit
import SnapKit

class WJLrcView: UIView {
    /// TODO:
    /// set lrc
    open func setLrc(_ lrc: WJLrcModel?) {
        
        /// remove lrc label
        scrollView.wj_removeAllSubviews()
        
        guard let lines = lrc?.lines else {
            print("load lrc fail !")
            return
        }
        
        var subviews: [WJLrcLabel] = []
        for line in lines {
            let label = WJLrcLabel(line.lrcString, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), kFont, 16, .center)
            label.line = line
            scrollView.addSubview(label)
            subviews.append(label)
        }
        
        let labelHight = 32.0
        let topMargin = 0
        let bottomMargin = 0
        let space = 0
        for index in 0...subviews.count - 1 {
            let currentLabel = subviews[index]
            var previousLabel: WJLrcLabel? = nil
            var nextLabel: WJLrcLabel? = nil
            
            if index > 0 {
                previousLabel = subviews[index - 1]
            }
            if index < subviews.count - 1 {
                nextLabel = subviews[index + 1]
            }
            
            /// 第一个元素
            if index == 0 {
                currentLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(scrollView).offset(topMargin)
                    make.centerX.equalTo(scrollView)
                    make.height.equalTo(labelHight)
                    if nextLabel == nil {
                        make.bottom.equalTo(scrollView).offset(-bottomMargin)
                    } else {
                        make.bottom.equalTo(nextLabel!.snp_top).offset(-space)
                    }
                }
            } else if index == subviews.count - 1 {
                currentLabel.snp.makeConstraints { (make) in
                    make.centerX.equalTo(scrollView)
                    make.height.equalTo(labelHight)
                    make.bottom.equalTo(scrollView).offset(-bottomMargin)
                    if(previousLabel == nil) {
                        make.top.equalTo(scrollView);
                    } else {
                        make.top.equalTo(previousLabel!.snp_bottom).offset(space);
                    }
                }
            } else {
                currentLabel.snp.makeConstraints { (make) in
                    make.centerX.equalTo(scrollView)
                    make.height.equalTo(labelHight)
                    make.top.equalTo(previousLabel!.snp_bottom).offset(space)
                    make.bottom.equalTo(nextLabel!.snp_top).offset(-space)
                }
            }
        }
        /// 重新计算
        layoutIfNeeded()
        let height = scrollView.frame.size.height / 2 - CGFloat(labelHight / 2)
        scrollView.contentInset = UIEdgeInsets(top: height, left: 0, bottom: height, right: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
    }
    
    /// 通过时间寻找已经创建好的label
    private func searchLrcLabel(_ currentTime: TimeInterval) -> WJLrcLabel? {
        let lineLabels = scrollView.subviews
        for label in lineLabels {
            if !label.isKind(of: WJLrcLabel.self) {
                continue
            }
            let lrcLine = (label as! WJLrcLabel).line!
            if currentTime >= lrcLine.beginTime && currentTime <= lrcLine.beginTime + lrcLine.duration {
                return label as? WJLrcLabel
            }
        }
        return nil
    }
    
    /// 高亮标签
    private var highlightLabel: WJLrcLabel?
    
    /// 设置播放时间
    open func setCurrentTime(_ currentTime: TimeInterval) {
        
        guard let lrcLabel = searchLrcLabel(currentTime) else {
            return
        }

        if highlightLabel != nil && lrcLabel != highlightLabel {
            highlightLabel?.font = UIFont(name: kFont, size: 16)
            highlightLabel?.isHighlight = false
            scrollView.setContentOffset(CGPoint(x: 0, y: lrcLabel.frame.origin.y - scrollView.contentInset.top), animated: true)
        }
        highlightLabel = lrcLabel
        highlightLabel?.font = UIFont(name: kFont, size: 20)
        highlightLabel?.isHighlight = true
        
        /// 解决高亮部分
        guard let lineModel = lrcLabel.line else {
            print("没有获取标签显示数据")
            return
        }
        /// 已过时间
        var lapsedTime = currentTime - lineModel.beginTime
        var highlightPartWidth: CGFloat = 0.0
        var highlightString = ""
        /// 高亮宽度
        for part in lineModel.parts {
            if lapsedTime - part.duration < 0 {
                /// 当前唱的部分高亮
                let percent: CGFloat = CGFloat(lapsedTime / part.duration)
                /// 当前唱的部分字符串所占的总体宽度
                let size = part.text.size(withAttributes: [.font:highlightLabel?.font! as Any])
                
                /// 部分高亮宽度
                highlightPartWidth = CGFloat(size.width * percent)
                break
            } else {
                highlightString.append(part.text)
                /// 剩余时间
                lapsedTime -= part.duration
            }
        }
        /// 之前文字高亮宽度
        let highlightSize = highlightString.size(withAttributes: [.font:highlightLabel?.font! as Any])
        highlightLabel?.highlightWidth = highlightSize.width + highlightPartWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        // 内容会自动滚动，导致循环获取内容控件
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
}
