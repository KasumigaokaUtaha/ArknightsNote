//
//  CharacterViewController.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 29.11.21.
//

import UIKit

class CharacterViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CharacterCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }
}

// MARK: - Table View Data Source
extension CharacterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        cell.characterImageView.image = UIImage(named: "假日威龙陈")
        return cell
    }
}

// MARK: - Table View Delegate
extension CharacterViewController: UITableViewDelegate {
    
}
