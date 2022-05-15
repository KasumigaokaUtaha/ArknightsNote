//
//  ANPageViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.05.22.
//

import UIKit

class ANPageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
    }
}
