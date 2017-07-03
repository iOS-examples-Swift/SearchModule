//
//  ChildViewController.swift
//  SearchModule
//
//  Created by Steve on 2017/6/27.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {
    var tableView: UITableView!


    var searchController: UISearchController!

    let data = ["fullScreen", "pageSheet", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    var filteredData: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = view.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        filteredData = data
        view.addSubview(tableView)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.keyboardType = .numberPad

        //        searchController.searchBar.scopeBarBackgroundImage
//        searchController.searchBar.showsScopeBar = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsScopeBar = false
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
//        searchController.searchBar.scopeButtonTitles = ["美团", "百度"]
//        searchController.searchBar.becomeFirstResponder()
//        definesPresentationContext = true
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        searchController.isActive = true
//        searchController.searchBar.becomeFirstResponder()
        delay(0.1) { self.searchController.searchBar.becomeFirstResponder() }

    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}


extension ChildViewController: UISearchResultsUpdating, UISearchControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.uppercased().range(of: searchText.uppercased(), options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension ChildViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter({
            return $0.contains(searchText)
        })
        tableView.reloadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if #available(iOS 9.0, *) {} else {
            delay(0.1, execute: { [weak self] in
                if let cancelButton = self?.searchController.searchBar.subviews.last?.subviews.filter({$0.description.contains("UINavigationButton")}).last as? UIButton {
                    cancelButton.setTitle("取消", for: .normal)
                }
            })
        }
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChildViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

func delay(_ interval: TimeInterval, execute: @escaping () -> Void)  {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: execute)
}


