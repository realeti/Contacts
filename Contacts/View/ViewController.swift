//
//  ViewController.swift
//  Contacts
//
//  Created by Apple M1 on 16.02.2023.
//

import UIKit

class ViewController: UIViewController{

    private var contacts = [ContactProtocol]() {
        didSet {
            contacts.sort { $0.title < $1.title }
            // сохранение контактов в хранилище
            storage.save(contacts: contacts)
        }
    }
    
    var storage: ContactStorageProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func showNewContactAlert() {
        // создание Alert Controller
        let alertController = UIAlertController(title: "Создание нового контакта", message: "Введите имя и телефон", preferredStyle: .alert)
        
        // добавляем первое текстовое поле в Alert Controller
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        // добавляем второе текстовое поле в Alert Controller
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        
        // создаем кнопки
        // кнопки создания контакта
        let createButton = UIAlertAction(title: "Cоздать", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text, let contactPhone = alertController.textFields?[1].text else {
                return
            }
            // создаем новый контакт
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
            
        // кнопка отмены
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        // добавляем кнопки в Alert Controller
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        
        // отображаем Alert Controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func loadContacts() {
        contacts = storage.load()
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
            if configuration.text == "al!na" {
                configuration.image = UIImage(systemName: "star")
            }
            else {
                configuration.image = UIImage(systemName: "moon")
            }
            
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
            self.showEditContactAlert(self.contacts[indexPath.row].title, self.contacts[indexPath.row].phone, indexPath.row)
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        return actions
    }
    
    func showEditContactAlert(_ contactTitle: String, _ contactPhone: String, _ contactIndex: Int) {
        let alertController = UIAlertController(title: "Редактировать контакт", message: "Внесите изменения", preferredStyle: .alert)
        
        alertController.addTextField() { textFied in
            textFied.text = self.contacts[contactIndex].title
        }
        
        alertController.addTextField { textField in
            textField.text = self.contacts[contactIndex].phone
        }
        
        let changeButton = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text else {
                return
            }
            
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts[contactIndex] = contact
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(changeButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
