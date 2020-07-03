//
//  DTKBridgeSwift.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/27.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    @objc func dtk_setImage(_ source: Any?, placeholder: UIImage? = nil, completion: ((UIImage?, Error?)->())? = nil) {
        var placeholder = placeholder
        var kfSource: Source?
        var options = [KingfisherOptionsInfoItem]()
        
//        options.append(.processor(WebpProcessor()))
        
        if let image = source as? UIImage {
            self.image = image
            return
        }else if let urlStr = source as? String, urlStr.count > 0 {
            
            var url: URL?
            if urlStr.hasPrefix("//") {
                url = URL(string: "http:" + urlStr)
            } else {
                url = URL(string: urlStr)
            }
//            if isKind(of: GoodsImageView.self) {
//                placeholder = productType == .linjiaxiaohui ? #imageLiteral(resourceName: "xiaohui_ph_goods") : #imageLiteral(resourceName: "ph_goods")
//            }
            if let _url = url {
                kfSource = .network(_url)
            }
        } else if let url = source as? URL {
            if url.isFileURL {
                let provider = LocalFileImageDataProvider(fileURL: url)
                kfSource = .provider(provider)
            } else {
                kfSource = .network(url)
            }
        } else {
            image = nil
            return
        }
        ImageCache.default.diskStorage.config.sizeLimit = 500 * 1000 * 1000
        ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1000 * 1000
        kf.indicatorType = .none
        kf.setImage(with: kfSource, placeholder: placeholder, options: options, completionHandler: { (result) in
            var image: UIImage?
            var outError: NSError?
            switch result {
            case .failure(let error):
                outError = error as NSError
            case .success(let r):
                image = r.image
            }
            completion?(image, outError)
        })
    }
}

extension NSObject {
    @objc func imageDownloader(url: String, completion: ((UIImage?, Data?, NSError?) -> ())?) {
        ImageDownloader.default.downloadImage(with: URL(string: url)!, options: KingfisherParsedOptionsInfo(nil)) { (result) in
            var outError: NSError?
            var data: Data?
            var image: UIImage?
            switch result {
            case .failure(let error):
                outError = error as NSError
            case .success(let r):
                data = r.originalData
                image = r.image
            }
            completion?(image, data, outError)
        }
    }
}
