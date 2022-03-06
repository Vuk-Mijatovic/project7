//
//  ViewController.swift
//  Project7
//
//  Created by mobileteam on 22.2.22..
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(removeFilters))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(filterPetitions))

        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        filteredPetitions = petitions
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitons = try?decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitons.results
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "We are the people API", preferredStyle: .alert)
        let dissmissCredits = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        ac.addAction(dissmissCredits)
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        var searchTermField: UITextField?
        
        let ac = UIAlertController(title: "Filter", message: "Enter your search term", preferredStyle: .alert)
        
        let filterAction = UIAlertAction(title: "Search", style: .default) { (action) in
            if let searchTerm = searchTermField?.text?.lowercased() {
                self.filteredPetitions.removeAll()
                for petition in self.petitions {
                    if petition.title.lowercased().contains(searchTerm) {
                        self.filteredPetitions.append(petition)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
            ac.addAction(filterAction)
            
        ac.addTextField { (textField) -> Void in
            searchTermField = textField
        }
        present(ac, animated: true)
    }
    
    @objc func removeFilters() {
        self.filteredPetitions = petitions
        self.tableView.reloadData()
    }
    
    
}

