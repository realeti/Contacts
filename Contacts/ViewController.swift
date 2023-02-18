//
//  ViewController.swift
//  Contacts
//
//  Created by Apple M1 on 16.02.2023.
//

import UIKit

class ViewController: UIViewController {

    private var contacts = [ContactProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    private func loadContacts() {
        contacts.append(Contact(title: "Барак Обама", phone: "88005553535"))
        contacts.append(Contact(title: "Миссис Смит", phone: "83321928301"))
        contacts.append(Contact(title: "Юлий Цезарь", phone: "77755577700"))
        contacts.append(Contact(title: "Александр Сабитов", phone: "hidden"))
        
        contacts.sort { $0.title < $1.title}
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
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
    
    private func configuration(cell: inout UITableViewCell, for indexPath: IndexPath) {
        if #available(iOS 14, *) {
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = contacts[indexPath.row].title
            configuration.secondaryText = contacts[indexPath.row].phone
            configuration.image = UIImage(systemName: "moon")
            
            cell.contentConfiguration = configuration
        }
        else {
            cell.textLabel?.text = contacts[indexPath.row].title
            cell.detailTextLabel?.text = contacts[indexPath.row].phone
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            // удаляем контакт
            self.contacts.remove(at: indexPath.row)
            // заново формируем табличное представление
            tableView.reloadData()
        }
        let actionEdit = UIContextualAction(style: .normal, title: "Изменить") { _,_,_ in
            //...
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        return actions
    }
}
