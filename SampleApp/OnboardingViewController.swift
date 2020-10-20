//
//  OnboardingViewController.swift
//  SampleApp
//
//  Created by Kian on 2020-10-19.
//  Copyright © 2020 Henrique Faria. All rights reserved.
//

import UIKit

class Onboarding: UIViewController {

    private let permissions = Permissions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Onboarding"
        view.backgroundColor = .white
    }
    
    @IBAction func locationAuthTapped(_ sender: Any) {

    }

    @IBAction func activityAuthTapped(_ sender: Any) {

    }
    
}
