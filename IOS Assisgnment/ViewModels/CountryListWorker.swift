//
//  CountryListWorker.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 29/08/21.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON
class CountryListWorker{
    
    
     func getCountriesList(urlString:String, callback: @escaping (_ list: [CountryModel], _ error:AFError?)->()){
        let header : HTTPHeaders =  [ "Content-Type" : "application/json"];
        CommonWorker().callRequest(url: URL(string: urlString)!, method: .get, parameter: nil, encoding: JSONEncoding.default, headers: header) { (response, error) in
            do{
                let countriesList = try JSON(data: response.data!).rawData()
                let tempCountriesList = try! JSONDecoder().decode([CountryModel].self, from: countriesList)
                callback(tempCountriesList,nil)
            }catch{
                
            }
        
        }
    }
    
    
    func getCountryDetails(urlString:String, callback: @escaping (_ list: [CountryDetailModel], _ error:AFError?)->()){
       let header : HTTPHeaders =  [ "Content-Type" : "application/json"];
       CommonWorker().callRequest(url: URL(string: urlString)!, method: .get, parameter: nil, encoding: JSONEncoding.default, headers: header) { (response, error) in
           do{
               let countriesList = try JSON(data: response.data!).rawData()
        
               let tempCountriesList = try! JSONDecoder().decode([CountryDetailModel].self, from: countriesList)
               callback(tempCountriesList,nil)
           }catch{
               
           }
       
       }
   }
    
    func parseAndSaveCountry(counrtyModel:CountryModel){
       
        let countryObj = CountryDetail()
        countryObj.Country = counrtyModel.Country
        countryObj.Slug = counrtyModel.Slug
        countryObj.ISO2 = counrtyModel.ISO2
        countryObj.UId = counrtyModel.Country
            RealmDBManager().addOrUpdateObject(object: countryObj)
        }


    

}
