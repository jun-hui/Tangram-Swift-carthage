//
//  ViewController.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/25.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import UIKit
//import ZRouter
//import ZIKRouter
//import DTKBaseFramework

let TESTLAYOUT_NUMBER = 20
let TESTCOLUMN = 3
let TESTROW = 4

class DemoItemModel: NSObject, TangramItemModelProtocol {
    
    @objc var itemFrame: CGRect {
        set {
            itemModelFrame = newValue
        }
        get {
            return itemModelFrame ?? CGRect.zero
        }
    }
    
    override init() {
        super.init()
        self.itemFrame = CGRect.zero
    }
    
    func itemType() -> String! {
        return "demo"
    }
    
    func reuseIdentifier() -> String! {
        return "demo_model_reuse_identifier"
    }
    
    func marginTop() -> CGFloat {
        return 5
    }
    
    func marginRight() -> CGFloat {
        return 5
    }
    
    func marginBottom() -> CGFloat {
        return 5
    }
    
    func marginLeft() -> CGFloat {
        return 5
    }
    
    func display() -> String! {
        return "inline"
    }
    
    var itemModelFrame: CGRect?
    var isBlock: Bool?
    var indexInLayout: UInt?
}

class DemoItem: UIView {
    var itemModel: DemoItemModel?
    
    var model: TangramItemModelProtocol? {
        get {
            return itemModel
        }
    }
    
}

class DemoLayout: TangramFlowLayout {
    var index: UInt?
    
    override func layoutType() -> String {
        return "xxxxx_\(index ?? 0)"
    }
}

class DemoFixModel: NSObject, TangramItemModelProtocol {
    var index: UInt?
    var itemFrame: CGRect {
        set {
            itemModelFrame = newValue
        }
        get {
            return CGRect(x: 0, y:0, width: 100, height: 30)
        }
    }
    var itemModelFrame: CGRect?
    
    func itemType() -> String! {
        return "demo"
    }
    
    func reuseIdentifier() -> String! {
        return ""
    }
    
    func marginTop() -> CGFloat {
        return 0
    }
    
    func marginRight() -> CGFloat {
        return 0
    }
    
    func marginBottom() -> CGFloat {
        return 0
    }
    
    func marginLeft() -> CGFloat {
        return 0
    }
    
    func display() -> String! {
        return "inline"
    }
}


class ViewController: UIViewController, TangramViewDatasource, UIScrollViewDelegate {
    
    func randomColor() -> UIColor {
        let hue = ( Double(arc4random() % 256) / 256.0 );
        let saturation = ( Double(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness = ( Double(arc4random() % 128) / 256.0 ) + 0.5;
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1)
    }
    
    func numberOfLayouts(in view: TangramView!) -> UInt {
        return UInt(TESTLAYOUT_NUMBER)
    }
    
    func numberOfItems(in view: TangramView!, forLayout layout: (UIView & TangramLayoutProtocol)!) -> UInt {
        if layout.isKind(of: TangramFixLayout.self) {
            return 1
        }
        if layout.isKind(of: TangramSingleAndDoubleLayout.self) {
            return 4
        }
        if layout.isKind(of: TangramWaterFlowLayout.self) {
            return 10
        }
        if layout.isKind(of: TangramStickyLayout.self) {
            return 1
        }
        return 4
    }
    
    //Layout不做复用，复用的是Item
    func layout(in view: TangramView!, at index: UInt) -> (UIView & TangramLayoutProtocol)! {
        if index == 0 {
            //固定布局
            let fixLayout = TangramDragableLayout()
            fixLayout.alignType = FixAlignType.TopRight
            fixLayout.offsetX = 100
            fixLayout.offsetY = 100
            return fixLayout
        }
        
        if index == 1 {
            //一拖N布局
            let layout = TangramSingleAndDoubleLayout()
            layout.rows = [40, 60]
            return layout
        }
        
        if index == 3 {
            //吸顶布局
            let floatLayout = TangramStickyLayout()
            return floatLayout
        }
        
        if index == 6 {
            let waterFlowLayout = TangramWaterFlowLayout()
            return waterFlowLayout
        }
        
        //普通流式布局
        let layout = DemoLayout()
        layout.margin = [10, 20,20,20]
        layout.numberOfColumns = index % 5+1
        layout.hGap = 3
        layout.vGap = 5
        layout.index = index
        layout.backgroundColor = randomColor()
        return layout
    }
    
    func item(in view: TangramView!, withModel model: TangramItemModelProtocol!, forLayout layout: (UIView & TangramLayoutProtocol)!, at index: UInt) -> UIView! {
        //首先查找是否有可以复用的Item,是否可以复用是根据它的reuseIdentifier决定的
        //layout不复用，复用的是item
        var item = view.dequeueReusableItem(withIdentifier: model.reuseIdentifier())
        if item == nil {
            item = DemoItem(frame: CGRect.zero, reuseIdentifier: model.reuseIdentifier())
        }
        item?.backgroundColor = randomColor()
        var testLabel = item?.viewWithTag(1001) as? UILabel
        if testLabel == nil {
            testLabel = UILabel()
            testLabel?.frame = CGRect(origin: CGPoint(x: 2, y: 2), size: CGSize(width: 30, height: 30))
            testLabel?.textColor = .white
            testLabel?.tag = 1001
            item?.addSubview(testLabel!)
        }
        testLabel?.text = "\(index)"
        item?.clipsToBounds = true
        return item
    }
    
    func itemModel(in view: TangramView!, forLayout layout: (UIView & TangramLayoutProtocol)!, at index: UInt) -> TangramItemModelProtocol! {
        if layout.isKind(of: TangramDragableLayout.self) || layout.isKind(of: TangramStickyLayout.self) {
            let fixModel = DemoFixModel()
            return fixModel
        }
        let model = DemoItemModel()
        model.indexInLayout = index
        model.itemFrame = CGRect(x: model.itemFrame.origin.x, y: model.itemFrame.origin.y, width: model.itemFrame.size.width, height: 150)
        if layout.isKind(of: TangramWaterFlowLayout.self) {
            model.itemFrame = CGRect(x: model.itemFrame.origin.x, y: model.itemFrame.origin.y, width: model.itemFrame.size.width, height: CGFloat((arc4random() % 120) + 30))
        }
        return model
    }
    
    var totalIndex: UInt = 0
//    var twoVCRouter: DestinationViewRouter<TwoVCInput>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tangramView = TangramView(frame: self.view.bounds)
        tangramView.setDataSource(self)
        tangramView.backgroundColor = .lightGray
        view.addSubview(tangramView)
        tangramView.fixExtraOffset = 64
        tangramView.delegate = self
        tangramView.reloadData()
        
//        let btn = UIButton(type: .custom)
//        btn.backgroundColor = .red
//        btn.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
//        view.addSubview(btn)
//        btn.addTarget(self, action: #selector(jumpTwoVC), for: .touchUpInside)
//        ZIKRouter<AnyObject, ZIKPerformRouteConfiguration, ZIKRemoveRouteConfiguration>.enableDefaultURLRouteRule()
    }
    
    @objc func jumpTwoVC() {
//        let vc = DTKTestViewController()
//        vc.ttt = "我是基础测试哈哈哈"
//        present(vc, animated: true, completion: nil)
        
//        ZIKAnyViewRouter.router(forURL: "app://twovc")?.perform(.presentModally(from: self), configuring: { (config) in
//        })
//        twoVCRouter = Router.perform(to: RoutableView<TwoVCInput>(), path: .presentModally(from: self), configuring: {[weak self] (config, _)  in
//            config.prepareDestination = { destination in
//                destination.closePage = {
//                    self?.twoVCRouter?.removeRoute()
//                }
//            }
//        })
    }

}

