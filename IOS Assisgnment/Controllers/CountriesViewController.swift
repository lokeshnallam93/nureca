//
//  CountriesViewController.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import UIKit
import SwiftyJSON
class CountriesViewController: UIViewController {

    @IBOutlet weak var countryListTableview: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var mainCountriesList = [CountryModel]()
    var countriesList = [CountryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Countries"
        self.countryListTableview.delegate = self
        self.countryListTableview.dataSource = self
        searchBar.delegate = self

        self.countryListTableview.register(cellTypes: [CountryTableViewCell.self])
        loadCountriesList()
        setLeftBackButton()
        // Do any additional setup after loading the view.
    }
    func setLeftBackButton() {
       self.navigationItem.setHidesBackButton(true, animated:false);
      let leftBarBackButtonItem =   UIBarButtonItem(image: UIImage(named: "lefArrowBlack"), style: .plain, target: self, action: #selector(leftBarbuttonAction))
        leftBarBackButtonItem.tintColor = .white
       self.navigationItem.setLeftBarButton(leftBarBackButtonItem, animated: true)
   }
    @objc func leftBarbuttonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func loadCountriesList(){
        CountryListWorker().getCountriesList(urlString: "https://api.covid19api.com/countries") { (tempCountrieslist, error) in
            self.mainCountriesList.removeAll()
            self.countriesList.removeAll()
            for item in tempCountrieslist{
                self.mainCountriesList.append(item)
                self.countriesList.append(item)
            }
            self.countryListTableview.reloadData()
        }
    }
    

}

extension CountriesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(with: CountryTableViewCell.self, for: indexPath)
        let countryModel = countriesList[indexPath.row]
        cell.country_label.text = countryModel.Country
        cell.flag_imageView.image = UIImage(named: countryModel.Country)
        cell.selectionStyle = .none
        cell.background_view.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryModel = countriesList[indexPath.row]
        let countryDetailVc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        countryDetailVc.countryModel = countryModel
        CountryListWorker().parseAndSaveCountry(counrtyModel: countryModel)

        self.navigationController?.pushViewController(countryDetailVc, animated: true)
    }


}

extension CountriesViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        countriesList.removeAll()
        if searchText.count > 0{
            for index in 0 ... mainCountriesList.count-1{
                let tempCountryObject = mainCountriesList[index]
                if tempCountryObject.Country.lowercased().contains(searchText.lowercased()){
                    countriesList.append(tempCountryObject);
                }

            }
        }else{
            countriesList.append(contentsOf: mainCountriesList)

        }


        self.countryListTableview.reloadData()

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
