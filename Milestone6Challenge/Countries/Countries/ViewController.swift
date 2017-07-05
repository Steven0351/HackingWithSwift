//
//  ViewController.swift
//  Countries
//
//  Created by Steven Sherry on 7/5/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://api.worldbank.org/countries?per_page=500&format=json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                print(json)
                parse(JSONdata: json)
                return
            }
        }
        showApiError()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // format cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country["name"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // display detail VC
    }
    
    func showApiError() {
        let ac = UIAlertController(title: "Error", message: "There was a network error, please try again",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func parse(JSONdata json: JSON) {
        for countryData in json[1].arrayValue {
            if countryData["longitude"].stringValue == "" {
                continue
            }
            let id = countryData["id"].stringValue
            let name = countryData["name"].stringValue
            print(name)
            let region = countryData["region"]["value"].stringValue
            let capital = countryData["capitalCity"].stringValue
            let incomeLevel = countryData["incomeLevel"]["value"].stringValue
            let country = ["id": id, "name": name, "region": region, "capital": capital, "incomeLevel": incomeLevel]
            countries.append(country)
        }
        countries.sort(by: <#T##([String : String], [String : String]) -> Bool#>)
    }
}

