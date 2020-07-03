//
//  TangramSingleImageElement.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/27.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import UIKit
//import Kingfisher

@objc class TangramSingleImageElement: UIControl, TangramElementHeightProtocol,TMLazyItemViewProtocol, TangramEasyElementProtocol {
    
    @objc var imgUrl: String = "" {
        didSet {
            if !imgUrl.isEmpty {
//                imageView.dtk_setImage(imgUrl)
            }
        }
    }
    @objc var _atLayout: (UIView & TangramLayoutProtocol)!
    @objc var _tangramBus: TangramBus!
    
    @objc var number: NSNumber?
    @objc var _tangramItemModel: TangramDefaultItemModel!
    
    @objc func setAtLayout(_ layout: (UIView & TangramLayoutProtocol)!) {
        _atLayout = layout
    }
    
    @objc func atLayout() -> (UIView & TangramLayoutProtocol)! {
        return _atLayout
    }
    
    @objc func setTangramBus(_ tangramBus: TangramBus!) {
        _tangramBus = tangramBus
    }
    
    @objc var action: String = ""
    override var frame: CGRect {
        didSet {
            if frame.size.width > 0 && frame.size.height > 0 {
                mui_afterGetView()
            }
        }
    }
    
    var imageView: UIImageView = {
       let v = UIImageView()
        v.isUserInteractionEnabled = false
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
    }()
    var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .red
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialInterface()
    }
    
    func initialInterface() {
        addSubview(imageView)
        addSubview(titleLabel)
        addTarget(self, action: #selector(clickedOnElement), for: .touchUpInside)
        clipsToBounds = true
        self.backgroundColor = randomColor()
    }
    
    static func height(by itemModel: TangramDefaultItemModel!) -> CGFloat {
        let h = arc4random()%100
        return CGFloat(100 + h)
    }
    
    func randomColor() -> UIColor {
        let hue = ( Double(arc4random() % 256) / 256.0 );
        let saturation = ( Double(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness = ( Double(arc4random() % 128) / 256.0 ) + 0.5;
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1)
    }
    
    func tangramItemModel() -> TangramDefaultItemModel! {
        return _tangramItemModel
    }
    
    func setTangramItemModel(_ tangramItemModel: TangramDefaultItemModel!) {
        _tangramItemModel = tangramItemModel
    }
    
    @objc func clickedOnElement() {
        let event = TangramEvent(topic: "jumpAction", with: inTangramView(), posterIdentifier: "singleImage", andPoster: self)
        event.setParam(action, forKey: "action")
        _tangramBus.post(event)
    }
    
    func mui_afterGetView() {
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width-1, height: frame.height-1)
        titleLabel.text = "\(number?.uint64Value ?? 0)"
        titleLabel.sizeToFit()
    }
    
}
