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
        title = "Countries"
        
        let urlString = "https://restcountries.eu/rest/v2/all"
        
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
        cell.textLabel?.text = country["Name"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // display detail VC
        let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailVC
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showApiError() {
        let ac = UIAlertController(title: "Error", message: "There was a network error, please try again",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func parse(JSONdata json: JSON) {
        for countryData in json.arrayValue {
            var currency: String
            let id = countryData["alpha3Code"].stringValue
            let name = countryData["name"].stringValue
            print(name)
            let region = countryData["subregion"].stringValue
            let capital = countryData["capital"].stringValue
            let rawCurrency = countryData["currencies"][0]["name"].stringValue
            if let stringIndex = rawCurrency.characters.index(of: " ") {
                currency = rawCurrency.substring(from: stringIndex).capitalized
            } else {
                currency = rawCurrency
            }
            let population = "\(countryData["population"].intValue)"
            let size = "\(countryData["area"].doubleValue) KM^2"
            let country = ["Name": name, "Region": region, "Capital": capital, "Size": size,
                           "Population": population, "Currency": currency, "ID": id]
            countries.append(country)
        }
        countries.sort { $0["Name"]! < $1["Name"]! }
    }
}

