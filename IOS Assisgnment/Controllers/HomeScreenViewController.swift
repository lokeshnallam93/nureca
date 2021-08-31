//
//  HomeScreenViewController.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 31/08/21.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var savedListTableView: UITableView!
    var dbCountriesList = [CountryDetail]()
    var mainList = [CountryDetail]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var error_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        self.savedListTableView.delegate = self
        self.savedListTableView.dataSource = self
        self.savedListTableView.register(cellTypes: [CountryTableViewCell.self])
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getLastOpenedCountries()
    }
    func getLastOpenedCountries()
    {
        let list = RealmDBManager().fetchObjects(object: CountryDetail.self)
        dbCountriesList.removeAll()
        mainList.removeAll()
        if list.count < 1{
            error_label.isHidden = false
        }else{
            error_label.isHidden = true
        }
        for countryData in list{
            dbCountriesList.append(countryData as? CountryDetail ?? CountryDetail.init())
            mainList.append(countryData as? CountryDetail ?? CountryDetail.init())
        }
        
        savedListTableView.reloadData()
   
    }
    
    @IBAction func allCountriesButtonAction(_ sender: UIButton) {
        let countriesList = CountriesViewController(nibName: "CountriesViewController", bundle: nil)
        self.navigationController?.pushViewController(countriesList, animated: true)
    }
   

}
extension HomeScreenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbCountriesList.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        let title = UILabel(frame: CGRect(x: 0, y: 12, width: tableView.frame.width, height: 20))
        title.textColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.text = "  Saved Items"
        headerView.addSubview(title)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(with: CountryTableViewCell.self, for: indexPath)
        let countryModel = dbCountriesList[indexPath.row]
        cell.country_label.text = countryModel.Country
        cell.flag_imageView.image = UIImage(named: countryModel.Country ?? "")
        cell.selectionStyle = .none
        cell.background_view.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dbCountryModel = dbCountriesList[indexPath.row]
        let countryDetailVc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        let countryModel = CountryModel(country: dbCountryModel.Country ?? "", slug: dbCountryModel.Slug ?? "", iSO2: dbCountryModel.ISO2 ?? "")
        countryDetailVc.countryModel = countryModel
        self.navigationController?.pushViewController(countryDetailVc, animated: true)
    }


}
extension HomeScreenViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dbCountriesList.removeAll()
        if searchText.count > 0{
            if mainList.count < 1{
                return
            }
            for index in 0 ... mainList.count-1{
                let tempCountryObject = mainList[index]
                if tempCountryObject.Country!.lowercased().contains(searchText.lowercased()){
                    dbCountriesList.append(tempCountryObject);
                }

            }
        }else{
            dbCountriesList.append(contentsOf: mainList)
        }


        self.savedListTableView.reloadData()

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
