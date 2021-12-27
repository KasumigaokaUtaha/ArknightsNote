//
//  CharacterSearchViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 15.12.21.
//

import UIKit

class CharacterSearchViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
