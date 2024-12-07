//
//  ViewController.swift
//  LearnUIKitMiniProject
//
//  Created by Joshua Wenata Sunarto on 07/12/24.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBarView = SearchBarView()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.onTextChanged = { text in
            print("Search text: \(text)")
        }
        
        view.addSubview(searchBarView)
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
