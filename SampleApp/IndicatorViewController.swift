//
//  ViewController+ActivityIndicator.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController {
    private var loadingIndicator: UIActivityIndicatorView?

    func showProgressIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator!.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator!.hidesWhenStopped = true
        loadingIndicator!.style = UIActivityIndicatorView.Style.gray
        loadingIndicator!.startAnimating()

        view.addSubview(loadingIndicator!)

        loadingIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func hideProgressIndicator() {
        loadingIndicator?.removeFromSuperview()
    }
}