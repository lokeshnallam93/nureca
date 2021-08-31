//
//  DetailViewController.swift
//  IOS Assisgnment
//
//  Created by Lokesh on 30/08/21.
//

import UIKit
import Charts
class DetailViewController: UIViewController, ChartViewDelegate {

    var countryModel : CountryModel!
    
    var months: [Int]!
    var dates = [String]()
    var timeIntervels =  [Int]()
    var datesString = [String]()
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var confirmedCasesLabel: UILabel!
    var datePicker : UIDatePicker!
    var fromDate = String()
    var toDate = String()
    var confirmedCases = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBackButton()
        let to_date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        toDate = dateformatterDateTime(date: to_date!)
        let from_date = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        fromDate = dateformatterDateTime(date: from_date!)
        getCountryDetails()
        self.barChartView.delegate = self
        self.navigationItem.titleView = setNavgationBarTitleView(countryModel.Country, displayName: countryModel.Country)

    }
    func setNavgationBarTitleView(_ imageStr: String, displayName: String) -> UITextField{
        let titleTextField = UITextField()
        let imageView = UIImageView();
        imageView.frame = CGRect(x: 0, y: 9, width: 25, height: 25)
        imageView.image = UIImage(named: imageStr)
        titleTextField.leftViewMode = .always
        titleTextField.text = "  \(displayName)"
        titleTextField.textColor = UIColor.white
        titleTextField.leftView = imageView;
        titleTextField.isUserInteractionEnabled = false
        titleTextField.addSubview(imageView)
        return titleTextField
    }
    func getCountryDetails(){

        CountryListWorker().getCountryDetails(urlString: "https://api.covid19api.com/country/\(countryModel.Slug)/status/confirmed?from=\(fromDate)Z&to=\(toDate)Z") { (tempCountryDetail, error) in
            
            self.confirmedCases.removeAll()
            self.dates.removeAll()
            self.timeIntervels.removeAll()
            self.datesString.removeAll()
            if tempCountryDetail.count < 1 {
                self.dateLabel.isHidden = true
                self.confirmedCasesLabel.isHidden = true
                return
            }
            
            for details in tempCountryDetail{
                self.dates.append(details.Date ?? "")
                self.confirmedCases.append(details.Cases ?? 0)
            }
            
            for (_, string) in self.dates.enumerated(){
                let isoDate = string
                let timestamp = self.displayFormatDateString(dateStr: isoDate, dateFormat: "MMM d").1
                self.datesString.append(self.displayFormatDateString(dateStr: isoDate, dateFormat: "MMM d").0)
                self.timeIntervels.append(Int(timestamp ?? 0.0))
            }
           
            self.setChart(dataPoints: self.timeIntervels, values: self.confirmedCases)
            self.barChartView.xAxis.labelPosition = .bottom
            self.dateLabel.text = "Date: \(self.displayFormatDateString(dateStr: self.dates[0], dateFormat: "MMM d, yyyy").0)"
            self.confirmedCasesLabel.text = "ConfirmedCases: \(self.confirmedCases[0])"
        }

    }
    
    func displayFormatDateString(dateStr: String, dateFormat: String) -> (String, Double?){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:dateStr)!
        dateFormatter.dateFormat = dateFormat
        let timestamp = date.timeIntervalSince1970
        return (dateFormatter.string(from: date), timestamp)
    }
    
    func setLeftBackButton() {
       self.navigationItem.setHidesBackButton(true, animated:false);
      let leftBarBackButtonItem =   UIBarButtonItem(image: UIImage(named: "lefArrowBlack"), style: .plain, target: self, action: #selector(leftBarbuttonAction))
        leftBarBackButtonItem.tintColor = .white
       self.navigationItem.setLeftBarButton(leftBarBackButtonItem, animated: true)
   }
    func setChart(dataPoints: [Int], values: [Int]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
    
        for i in 0..<dataPoints.count {
            let val = Double(values[i])
            let dataEntry = BarChartDataEntry(x: Double(i), y: val)
        
            dataEntries.append(dataEntry)
        }
      
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.drawValuesEnabled = false //For hiding the x and y values on bars
        
        chartDataSet.colors = [UIColor(red: 0.0/255.0, green: 141.0/255.0, blue: 201.0/255.0, alpha: 1.0)]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.backgroundColor = .white
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:datesString)
        
    }
    @objc func leftBarbuttonAction() {
        self.navigationController?.popViewController(animated: true)
    }
   
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let dateStr = displayFormatDateString(dateStr: dates[Int(entry.x)], dateFormat: "MMM d, yyyy").0
        dateLabel.text = "Date: \(dateStr)"
        confirmedCasesLabel.text = "ConfirmedCases: \(confirmedCases[Int(entry.x)])"
        
    }
    
    
    @IBAction func toButtonAction(_ sender: UIButton) {
        sender.tag = 2
        showDatePicker(button: sender)
    }
    
    @IBAction func fromButtonAction(_ sender: UIButton) {
        sender.tag = 1
        showDatePicker(button: sender)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        getCountryDetails()
    }
    
    
    func showDatePicker(button: UIButton) {
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        viewDatePicker.backgroundColor = UIColor.clear
        if datePicker == nil{
            self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        }
        self.datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        viewDatePicker.addSubview(self.datePicker)
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)

        alertController.view.addSubview(viewDatePicker)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
           self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "Done", style: .default)
        { (action) in
            
            if button.tag == 1{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let date = dateFormatter.date(from:self.dateformatterDateTime(date: self.datePicker.date))!
                dateFormatter.dateFormat = "MMM d, yyyy"
                let dateStr = dateFormatter.string(from: date)
                self.fromDateButton.setTitle(dateStr, for: .normal)
                self.fromDate = self.dateformatterDateTime(date: self.datePicker.date)
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let date = dateFormatter.date(from:self.dateformatterDateTime(date: self.datePicker.date))!
                dateFormatter.dateFormat = "MMM d, yyyy"
                let dateStr = dateFormatter.string(from: date)
                self.toDateButton.setTitle(dateStr, for: .normal)
                self.toDate = self.dateformatterDateTime(date: self.datePicker.date)
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
        {
           
        }
    }
    func dateformatterDateTime(date: Date) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

