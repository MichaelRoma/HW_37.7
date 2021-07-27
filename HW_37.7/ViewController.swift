//
//  ViewController.swift
//  HW_37.7
//
//  Created by Mykhailo Romanovskyi on 15.06.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var articals = [NewsModel.Artical]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController {
    private func viewSetup() {
        tableView.rowHeight = 65
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = articals[indexPath.row].title
        content.textProperties.numberOfLines = 3
        
        if articals[indexPath.row].imageData == nil {
            getImage(imageUrl: articals[indexPath.row].urlToImage) { result in
                switch result {
                case .success(let data):
                    self.articals[indexPath.row].imageData = data
                    DispatchQueue.main.async {
                        content.image = UIImage(data: data)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            content.image = UIImage(data: articals[indexPath.row].imageData ?? Data())
        }
        cell.contentConfiguration = content
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
}

//MARK: Network
extension ViewController {
    private func getImage(imageUrl: String?, completion: @escaping (Result<Data, Error>)->Void) {
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    private func getData(completion: @escaping GetComplete) {
        let session = URLSession.shared
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                do {
                    let news = try JSONDecoder().decode(NewsModel.self, from: data)
                    guard let articals = news.articles else { return }
                    self.articals = articals
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            completion()
        }.resume()
    }
}
