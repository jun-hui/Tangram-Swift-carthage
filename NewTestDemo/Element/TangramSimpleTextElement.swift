//
//  TangramSimpleTextElement.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/27.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import UIKit

@objc class TangramSimpleTextElement: UIView, TMLazyItemViewProtocol, TangramElementHeightProtocol {
    @objc var text: String?
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
    }
    
    @objc required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc static func height(by itemModel: TangramDefaultItemModel!) -> CGFloat {
        return 30
    }
    
    @objc func mui_afterGetView() {
        self.label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.label.text = self.text
    }
}
