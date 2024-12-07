//
//  SearchBarView.swift
//  LearnUIKitMiniProject
//
//  Created by Joshua Wenata Sunarto on 07/12/24.
//

import UIKit

class SearchBarView: UIView {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    var onTextChanged: ((String) -> Void)? // Closure untuk menangkap perubahan teks
    
    init(margin: CGFloat = 16) {
        super.init(frame: .zero)
        setupView(margin: margin)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(margin: CGFloat) {
        addSubview(searchBar)
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension SearchBarView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onTextChanged?(searchText)
    }
}
