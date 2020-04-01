//
//  ViewController+ActivityIndicator.swift
//  SampleApp
//
//  Created by Henrique Faria on 01.04.20.
//  Copyright © 2020 MotionTag GmbH. All rights reserved.
//

import UIKit

class IndicatorUIViewController: UIViewController {
    private var overlay: UIView?
    private var loadingIndicator: UIActivityIndicatorView?

    func showProgressIndicator() {
        overlay = UIView(frame: view.frame)
        overlay!.translatesAutoresizingMaskIntoConstraints = false
        overlay!.backgroundColor = .black
        overlay!.alpha = 0.2

        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator!.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator!.hidesWhenStopped = true
        loadingIndicator!.style = UIActivityIndicatorView.Style.gray
        loadingIndicator!.startAnimating()

        view.addSubview(overlay!)
        view.addSubview(loadingIndicator!)

        NSLayoutConstraint.activate([
            loadingIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func hideProgressIndicator() {
        loadingIndicator?.removeFromSuperview()
        overlay?.removeFromSuperview()
    }
}
