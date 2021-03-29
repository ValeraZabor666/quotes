//
//  ChartViewController.swift
//  Yand
//
//  Created by Mac on 11.03.2021.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {

    var quoteChart = [Item]()
    var quoteName = String()
    let quotesRequest = NetworkClass()
    
    lazy var lineChart : LineChartView = {
        let chartView = LineChartView()
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        
        return chartView
    }()
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var moreQuoteInfo: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = quoteName
        lineChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height / 1.5)
        lineChart.center = view.center
        view.addSubview(lineChart)
    
        setData()
    }
    
    //MARK: - set month chart(default)
    func setData() {
        var entries  = [ChartDataEntry]()
        var checkDate = ""
        for i in 0..<quoteChart.count {
            if quoteChart[i].date != checkDate {
                entries.append(ChartDataEntry(x: Double(i),
                                              y: quoteChart[i].high))
                checkDate = quoteChart[i].date
            }
        }
        let set = LineChartDataSet(entries: entries, label: "Price(month changing)")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.setColor(.systemBlue)
        set.fill = Fill(color: .systemBlue)
        set.fillAlpha = 0.5
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChart.data = data
    }
    
    //MARK: - set(button) month chart(default)
    @IBAction func monthChart(_ sender: Any) {
        var entries  = [ChartDataEntry]()
        var checkDate = ""
        for i in 0..<quoteChart.count {
            if quoteChart[i].date != checkDate {
                entries.append(ChartDataEntry(x: Double(i),
                                              y: quoteChart[i].high))
                checkDate = quoteChart[i].date
            }
        }
        let set = LineChartDataSet(entries: entries, label: "Price(month changing)")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.setColor(.systemBlue)
        set.fill = Fill(color: .systemBlue)
        set.fillAlpha = 0.5
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChart.data = data
    }
    
    //MARK: - set day chart
    @IBAction func dayChart(_ sender: Any) {
        var entries  = [ChartDataEntry]()
        var counter = 0
        for i in quoteChart.count - 20..<quoteChart.count {
            entries.append(ChartDataEntry(x: Double(counter),
                                              y: quoteChart[i].high))
            counter += 1
        }
        let set = LineChartDataSet(entries: entries, label: "Price(day changing)")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.setColor(.systemBlue)
        set.fill = Fill(color: .systemBlue)
        set.fillAlpha = 0.5
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChart.data = data
    }
    
    //MARK: - get more info button
    @IBAction func getMoreInfo(_ sender: Any) {
        quotesRequest.getMoreInfo(compName: quoteName) { [weak self] result in
        switch result {
        case .failure(let error) : do {
            print(error)
            DispatchQueue.main.async {
                self!.alert(style: .alert)
            }
        }
        case .success(let qInfo) : do {
            DispatchQueue.main.async {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TextInfoViewController") as? TextInfoViewController {
                    vc.moreInfo = qInfo
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        }
    }
    }
    
    //MARK: - alert
    func alert(style: UIAlertController.Style) {
        let alertController = UIAlertController(title: "Error", message: "Can't load data (check connection)", preferredStyle: style)
        
        let action = UIAlertAction(title: "Got it!", style: .default) { (action) in

        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
