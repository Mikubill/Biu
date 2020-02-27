//
//  SearchBar.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var onSearchButtonClicked: (() -> Void)?
    var onCancelButtonClicked: (() -> Void)?

    class Coordinator: NSObject, UISearchBarDelegate {

        let control: SearchBar

        var finalString: String = ""

        init(_ control: SearchBar) {
            self.control = control
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            finalString = searchText
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            control.onCancelButtonClicked?()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            control.text = finalString
            control.onSearchButtonClicked?()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.setBackgroundImage(colorScheme == .light ? UIColor.white.image() : UIColor.black.image(), for: .any, barMetrics: .default)
        searchBar.delegate = context.coordinator
        searchBar.showsCancelButton = true
        return searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        //        uiView.text = text
    }

}
