//
//  MockViewController.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/27.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import UIKit

class MockViewController: UIViewController, TangramViewDatasource {
    func numberOfLayouts(in view: TangramView!) -> UInt {
        return UInt(layoutArray.count)
    }
    
    func numberOfItems(in view: TangramView!, forLayout layout: (UIView & TangramLayoutProtocol)!) -> UInt {
        return UInt(layout.itemModels.count)
    }
    
    func layout(in view: TangramView!, at index: UInt) -> (UIView & TangramLayoutProtocol)! {
        return layoutArray[Int(index)] as! UIView & TangramLayoutProtocol
    }
    
    func item(in view: TangramView!, withModel model: TangramItemModelProtocol!, forLayout layout: (UIView & TangramLayoutProtocol)!, at index: UInt) -> UIView! {
        var reuseableView = view.dequeueReusableItem(withIdentifier: model.reuseIdentifier())
        if reuseableView != nil {
            reuseableView = TangramDefaultDataSourceHelper.refreshElement(reuseableView!, byModel: model, layout: layout, tangramBus: tangramBus)
        }else {
            reuseableView = TangramDefaultDataSourceHelper.element(byModel: model, layout: layout, tangramBus: tangramBus)
        }
        return reuseableView ?? UIView()
    }
    
    func itemModel(in view: TangramView!, forLayout layout: (UIView & TangramLayoutProtocol)!, at index: UInt) -> TangramItemModelProtocol! {
        return layout.itemModels[Int(index)] as! TangramItemModelProtocol
    }
    
    var layoutModelArray: [Any] = []
    var modelArray: [Any] = []
    var tangramView: TangramView = {
        let v = TangramView()
        v.backgroundColor = .white
        return v
    }()
    var layoutArray: [Any] = []
    var tangramBus: TangramBus = {
        return TangramBus()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMockContent()
        registerEvent()
        tangramView.frame = self.view.bounds
        tangramView.setDataSource(self)
        view.addSubview(tangramView)
        tangramView.reloadData()
    }
    
    func loadMockContent() {
        let mockDataString = try! String(contentsOfFile: Bundle.main.path(forResource: "TangramMock", ofType: "json") ?? "")
        let data = mockDataString.data(using: .utf8)
        let dict = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        let datas = (dict as? [String:Any])?["data"]
        layoutModelArray = (datas as? [String:Any])?["cards"] as! [Any]
        TangramDefaultItemModelFactory.registElementType("image", className: NSStringFromClass(TangramSingleImageElement.self))
        TangramDefaultItemModelFactory.registElementType("text", className: NSStringFromClass(TangramSimpleTextElement.self))
        layoutArray = TangramDefaultDataSourceHelper.layouts(with: layoutModelArray as! [[AnyHashable : Any]], tangramBus: tangramBus)
    }
    
    func registerEvent() {
        tangramBus.registerAction(#selector(responseToClickEvent(context:)).description, ofExecuter: self, onEventTopic: "jumpAction")
    }
    
    @objc func responseToClickEvent(context: TangramContext) {
        let params = context.event.params()
        print("Click Action: \(params?["action"])")
    }
    
    
}
