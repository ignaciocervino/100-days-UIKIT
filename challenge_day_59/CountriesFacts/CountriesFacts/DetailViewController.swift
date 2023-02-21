//
//  DetailViewController.swift
//  CountriesFacts
//
//  Created by Ignacio Cervino on 21/02/2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var populationLbl: UILabel!
    @IBOutlet weak var capitalLbl: UILabel!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!

    var country: Country?
    var flag: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    private func loadData() {
        guard let country = country, let flagImage = flag else { fatalError("country is nil") }

        title = country.name
        countryFlag.image = flagImage
        countryNameLbl.text = "Name: \(country.name)"
        capitalLbl.text = "Capital: \(country.capital)"
        populationLbl.text = "Population: \(country.population)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
