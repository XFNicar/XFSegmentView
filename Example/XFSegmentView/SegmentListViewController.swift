//
//  SegmentListViewController.swift
//  XFSegmentView_Example
//
//  Created by 言乙 on 2022/2/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import XFSegmentView

class SegmentListViewController: UIViewController,SegmentViewDelegate,SegmentViewDataSource {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var segmentView: SegmentView!
    var titles: [String] = ["红色页面", "黄色页面", "蓝色页面","紫色页面"]
    var colors: [UIColor] = [.red, .yellow, .blue, .purple]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
    }
    
    func configUI()  {
//        segmentView = SegmentView.init(frame: CGRect(x: 0, y: safeTopHeight(), width: view.frame.width, height: view.frame.height - safeTopHeight()))
        segmentView = SegmentView.init(frame: view.frame)
        segmentView.dataSource = self
        segmentView.segmentBar.backgroundColor = .white
        segmentView.segmentBar.selectedTitleColor = .black
        segmentView.segmentBar.deSelectedTitleColor = .gray
        segmentView.segmentBar.lineView.backgroundColor = .black
        segmentView.segmentBar.itemWidth = view.frame.width / 4
        segmentView.segmentBar.lineWidth = 25
        segmentView.isPagingEnabled = false
        segmentView.enablePageAnimation = false
        view.addSubview(segmentView)
        segmentView.reloadData()
        segmentView.segmentBar.titleFont = UIFont.systemFont(ofSize: 16)
        
    }
    
    public func segmentView(segmentView: SegmentView, subViewWith index: Int) -> UIView {
        let  recordView = UIView.init(frame: view.bounds)
//        view.addSubview(recordView)
        recordView.backgroundColor = colors[index]
        return recordView
    }
    
    public func subTitleWithPages(segmentView: SegmentView) -> [String] {
        return titles
    }
    public func numberOfPages(segmentView: SegmentView) -> Int {
        return titles.count
    }
    
    func segmentView(segmentView: SegmentView, didEndScroll atIndex: Int) {
        
    }
    
    func segmentView(segmentView: SegmentView, barWidthForIndex: Int) -> CGFloat {
        return view.frame.width / 4
    }
    
    
    func safeTopHeight() -> CGFloat {
        var safeTop: CGFloat = 0
        if let appWindow = UIApplication.shared.delegate?.window {
            if #available(iOS 11.0, *) {
                safeTop = appWindow?.safeAreaInsets.top ?? 0
            } else {
                safeTop = 0
            }
        }
        return safeTop
    }
    
    func safeBottomHeight() -> CGFloat {
        var safeBottom: CGFloat = 0
        if let appWindow = UIApplication.shared.delegate?.window {
            if #available(iOS 11.0, *) {
                safeBottom = appWindow?.safeAreaInsets.bottom ?? 0
            } else {
                safeBottom = 0
            }
        }
        return safeBottom
    }

}
