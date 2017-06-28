//
//  ViewController.swift
//  SearchModule
//
//  Created by Steve on 2017/6/27.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

//    @IBOutlet weak var searchBar: UISearchBar!

    var searchController: UISearchController!

    let data = ["fullScreen", "pageSheet", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
//    var styles: [UIModalPresentationStyle] = [.fullScreen, .pageSheet, .formSheet, .currentContext, .custom, .overFullScreen, .overCurrentContext, .popover, .none]
//    var styles: [UIModalTransitionStyle] = [.coverVertical, .flipHorizontal, .crossDissolve, .partialCurl]
    var pushStyles: [CAAnimationType] = [
                                            .rippleEffect, //波纹效果
                                            .cube,//立体翻转效果
                                            .suckEffect,//像被吸入瓶子的效果
                                            .oglflip,//翻转
                                            .pageCurl,//翻页效果
                                            .pageUnCurl,//反翻页效果
                                            .cameraIrisHollowOpen,//开镜头效果
                                            .cameraIrisHollowClose,//关镜头效果
                                            .fade,//淡入淡出
                                            .push,//推进效果
                                            .reveal,//揭开效果
                                            .moveIn,//慢慢进入并覆盖效果
                                            .fromBottom,//下翻页效果
                                            .fromTop,//上翻页效果
                                            .fromLeft,//左翻转效果
                                            .fromRight//右翻转效果
                                        ]
    var styles: [CAAnimationType] = []
    var filteredData: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        styles = pushStyles
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        filteredData = data

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "搜索"
//        searchController.searchBar.scopeButtonTitles = ["美团", "百度"]
//        searchController.searchBar.scopeBarBackgroundImage
//        searchController.searchBar.showsScopeBar = true
//        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

    }

}


extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.uppercased().range(of: searchText.uppercased(), options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
    }

    func presentSearchController(_ searchController: UISearchController) {
        func delay(interval: TimeInterval, execute: @escaping () -> Void)  {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: execute)
        }
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        } else {
            delay(interval: 0.0, execute: { [weak self] in
                if let cancelButton = self?.searchController.searchBar.subviews.last?.subviews.filter({$0.description.contains("UINavigationButton")}).last as? UIButton {
                    cancelButton.setTitle("取消", for: .normal)
                }
            })
        }
    }

}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter({
            return $0.contains(searchText)
        })
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredData.count
        if section == 0 {
            return pushStyles.count
        }
        return styles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = pushStyles[indexPath.row].rawValue
        } else {
            cell.textLabel?.text = styles[indexPath.row].rawValue.description
        }
//        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let child = ChildViewController()
        if indexPath.section == 0 {
            push(to: child, animation: pushStyles[indexPath.row], interval: 0.5)
        } else {
//            child.modalTransitionStyle = styles[indexPath.row]
            let root = UINavigationController(rootViewController: child)
            present(to: root, animation: styles[indexPath.row], interval: 1)
        }
    }
}

