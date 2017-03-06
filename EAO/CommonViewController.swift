//
//  CommonViewController.swift
//  EAO
//
//  Created by Work on 2017-02-21.
//  Copyright © 2017 FreshWorks. All rights reserved.
//

import UIKit

enum BarButtonType {
    case none, menu, back, search
}
enum BarButtonPosition {
    case left, right
}

enum ViewControllerType {
    case map, inspections, projects, favourites, settings
    var navigationTitle: String {
        switch self {
        case .map:
            return "Map"
        case .inspections:
            return "Inspections"
        case .projects:
            return "Projects"
        case .favourites:
            return "Favourites"
        case .settings:
            return "Settings"
        }
    }
}

class CommonViewController: UIViewController {
    fileprivate let titleAttributes = [NSForegroundColorAttributeName: UIColor.navigationBarTintColor] //change to appropriate colour
    var showStatusIndicator: Bool = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showStatusIndicator
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Navigation
extension CommonViewController {
    func setNavigationBar(withTitle title: String, leftButtonType: BarButtonType, rightButtonType: BarButtonType) {
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.barTintColor = .navigationBarColor
        navigationController?.navigationBar.tintColor = .navigationBarTintColor
        navigationItem.title = title
        setBarButton(at: .left, type: leftButtonType)
        setBarButton(at: .right, type: rightButtonType)
    }

    func setNavigationBar(with type: ViewControllerType, leftButtonType: BarButtonType, rightButtonType: BarButtonType) {
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.barTintColor = .navigationBarColor
        navigationController?.navigationBar.tintColor = .navigationBarTintColor
        navigationItem.title = type.navigationTitle
        setBarButton(at: .left, type: leftButtonType)
        setBarButton(at: .right, type: rightButtonType)
    }

    private func setBarButton(at position: BarButtonPosition, type: BarButtonType) {
        var barButton0: UIBarButtonItem?
        var barButton1: UIBarButtonItem?
        switch type {
        case .none:
            barButton0 = UIBarButtonItem(customView: makeButton(withImage: nil, action: #selector(noneAction)))
            barButton1 = nil
            break
        case .menu:
            barButton0 = UIBarButtonItem(customView: makeButton(withTitle: "Menu", action: #selector(menuAction)))
            barButton1 = nil
            break
        case .back:
            break
        case .search:
            break
            
            
        }

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        switch position {
        case .left:
            guard barButton1 != nil else {
                navigationItem.setLeftBarButton(barButton0, animated: false)
                return
            }
            navigationItem.setLeftBarButtonItems([barButton0!, space, barButton1!], animated: false)

        case .right:
            guard barButton1 != nil else {
                navigationItem.setRightBarButton(barButton0, animated: false)
                return
            }
            navigationItem.setRightBarButtonItems([barButton0!, space, barButton1!], animated: false)
        }
    }

    private func makeButton(withImage image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }
    private func makeButton(withTitle title: String?, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.navigationBarTintColor, for: .normal)
        button.setImage(nil, for: .normal)
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }
}

//MARK: - IBActions
extension CommonViewController {
    @IBAction func noneAction(_ sender: UIButton) {}
    @IBAction func menuAction(_ sender: UIButton) {}
    @IBAction func backAction(_ sender: UIButton) {}
}
