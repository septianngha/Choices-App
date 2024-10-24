//
//  ListTableViewController.swift
//  Choices
//
//  Created by Muhamad Septian Nugraha on 23/10/24.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var wordsArray: Results<WordsModel>?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadWords()
    }

    
    // MARK: - Add New Words
    @IBAction func addWords(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Menambahkan keterangan pada alert
        let alert = UIAlertController(title: "Add New Words", message: "this word will be added to your list for shuffle", preferredStyle: .alert)
        
        // Action ketika user klik button Add
        let action = UIAlertAction(title: "Add words", style: .default) {
            (action) in

            let newWords = WordsModel()
            if let nameOfWords = textField.text, !nameOfWords.isEmpty {
                newWords.name = nameOfWords
                self.save(words: newWords)
                print("Added words success!")
            } else {
                print("Text field is empty, nothing will be saved.")
            }

            
        }
        
        // Menambahkan placeholder pada kolom UITextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a words"
            textField = alertTextField
        }
        
        // Tambahkan action ke alert
        alert.addAction(action)
        
        // Panggil alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Manipulation Methods (Save and Load Data)
    func save(words: WordsModel) {
        do {
            try realm.write {
                realm.add(words)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadWords() {
        
        wordsArray = realm.objects(WordsModel.self)
        tableView.reloadData()
    }
    
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let wordsValue = wordsArray?[indexPath.row]
        
        cell.textLabel?.text = wordsValue?.name ?? "No words added yet"
        
        // Mengganti warna background dan text list tabel
        let colour = UIColor(hexString: "#FFFFFF")?.darken(byPercentage: CGFloat(
            indexPath.row) / CGFloat(wordsArray!.count))
        cell.backgroundColor = colour
        cell.textLabel?.textColor = ContrastColorOf(colour!, returnFlat: true)
        
        return cell
    }
    
    
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let data = self.wordsArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(data)
                }
            } catch {
                print("Error delete data, \(error)")
            }
        }
        
    }
    
    
    // MARK: - TableView Delegate Methods
    
    // Delegate digunakan untuk triger ketika cell di klik
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        // Mengatur agar hover bisa dianimasikan
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
