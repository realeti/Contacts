//
//  ViewController.swift
//  Contacts
//
//  Created by Apple M1 on 16.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "contactCellIdentifier") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            cell = reuseCell
        }
        else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            cell = UITableViewCell(style: .value1, reuseIdentifier: "contactCellIdentifier")
        }
        
        configuration(cell: &cell, for: indexPath)
        return cell
    }
}

extension ViewController {
    private func configuration(cell: inout UITableViewCell, for indexPath: IndexPath) {
        if #available(iOS 14, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Строка #\(indexPath.row)"
            
            if indexPath.row == 0 {
                configuration.secondaryText = "secondaryText"
            }
            
            cell.contentConfiguration = configuration
        }
        else {
            cell.textLabel?.text = "Cтрока \(indexPath.row)"
            
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = "secondaryText"
            }
        }
    }
}
