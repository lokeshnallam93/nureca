//
//  CountryDetailModel.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 30/08/21.
//

import Foundation

class CountryDetailModel : Decodable {
    
    var Country: String?
    var CountryCode: String?
    var Lat : String?
    var Lon : String?
    var Cases : Int?
    var CityCode : String?
    var Status : String?
    var Date : String?
    var ID : String?
    var Province : String?
    init(country: String, CountryCode: String, Lat: String, lon: String, Cases: Int, CityCode: String,Status : String, Date: String, LocationID: String, Province: String) {
        self.Country = country
        self.CountryCode = CountryCode
        self.Lat = Lat
        self.Lon = lon
        self.Cases = Cases
        self.CityCode = CityCode
        self.Status = Status
        self.Date = Date
        self.ID = LocationID
        self.Province = Province
    }
}

