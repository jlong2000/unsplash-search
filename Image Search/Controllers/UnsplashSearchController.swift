//
//  UnsplashSearchController.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

class UnsplashSearchController: UISearchController {
    lazy var customSearchBar = CustomSearchBar(frame: CGRect.zero)

    override var searchBar: UISearchBar {
        customSearchBar.showsCancelButton = false
        return customSearchBar
    }
}

class CustomSearchBar: UISearchBar {
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }
}
