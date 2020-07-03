//
//  EntryTableViewController.swift
//  TestDemo
//
//  Created by CxDtreeg on 2020/5/27.
//  Copyright © 2020 CxDtreeg. All rights reserved.
//

import UIKit
//import Kingfisher

class EntryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 400)
        let url = Bundle.main.url(forResource: "test", withExtension: "webp")
        /*
        KingfisherManager.shared.defaultOptions += [
          .processor(WebPProcessor.default),
          .cacheSerializer(WebPSerializer.default)
        ]
        imageView.kf.setImage(with: LocalFileImageDataProvider(fileURL: url!))
        */
    }
    
    func testArray() -> Array<Dictionary<String, String>> {
        return [["name": "自定义布局-色块Demo(不使用Helper)", "entry": "ViewController"],["name": "JSON数据Demo(使用Helper)", "entry": "MockViewController"]]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TEST")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TEST")
        }
        let dic = testArray()[indexPath.row]
        cell?.textLabel?.text = dic["name"];
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController!
        switch indexPath.row {
        case 0:
            vc = ViewController()
        case 1:
            vc = MockViewController()
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
