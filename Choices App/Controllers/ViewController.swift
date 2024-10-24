//
//  ViewController.swift
//  Choices
//
//  Created by Muhamad Septian Nugraha on 23/10/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var randomLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    let realm = try! Realm()
    var wordsArray: Results<WordsModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingImageView.isHidden = true
    }
    
    // MARK: - Menghilangkan nav bar pada satu halaman tertentu
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = .black
    }


    @IBAction func tapShuffle(_ sender: UIButton) {
        
        wordsArray = realm.objects(WordsModel.self)
        
        if let words = wordsArray?.randomElement() {
            
            randomLabel.isHidden = true
            loadingImageView.isHidden = false
                    
            // Tambahkan jeda 1 detik menggunakan DispatchQueue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                // Sembunyikan gambar loading setelah jeda
                self.loadingImageView.isHidden = true
                self.randomLabel.isHidden = false
                
                // Lakukan shuffle
                print("Words: \(words.name)")
                self.randomLabel.text = words.name
            }

        } else {
            
            // Tampilkan alert jika tidak ada data
            let alert = UIAlertController(
                title: "No Data", message: "There are no words data available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Tampilkan alert di view controller saat ini
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func openWords(_ sender: UIButton) {
        
        // Pindah halaman
        performSegue(withIdentifier: "goToWords", sender: self)
    }
    
}

