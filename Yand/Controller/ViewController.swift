//
//  ViewController.swift
//  Yand
//
//  Created by Mac on 01.03.2021.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate, FavoriteButton {
    
    //MARK: - inits
    let quotesRequest = NetworkClass()
    var filteredData = [QuoteInfo]()
    var favoriteQuotes = [QuoteInfo]()
    var listOfQuotes = [QuoteInfo]() {
        didSet {
            filteredData = listOfQuotes
            getItems()
            for i in 0..<self.savedQuotes.count {
                for j in 0..<listOfQuotes.count {
                    if listOfQuotes[j].symbol == self.savedQuotes[i].symbol {
                        favoriteQuotes.append(listOfQuotes[j])
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var savedQuotes = [DataModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControll: UIRefreshControl = {
        let rC = UIRefreshControl()
        rC.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return rC
    }()
    @IBOutlet weak var starButtonOutlet: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.refreshControl = refreshControll
        
        //MARK: - get quotes data (name, price etc)
        quotesRequest.getQuotesInfo { [weak self] result in
            switch result {
            case .failure(let error) : do {
                print(error)
                DispatchQueue.main.async {
                    self!.alert(style: .alert)
                }
            }
            case .success(let quotesData) : self?.listOfQuotes = quotesData
            }
        }
    }
    
    
    //MARK: - configure cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let item = filteredData[indexPath.row]
        cell.symbolLabel?.text = item.symbol
        cell.longNameLabel?.text = item.shortName
        var cut = String(format: "%.1f", item.regularMarketPrice)
        cell.priceName?.text = "\(cut)$"
        cut = String(format: "%.1f", item.regularMarketChange)
        if item.regularMarketChange >= 0 {
            cell.changeLabel.text = "↑\(cut)$"
        } else {
            cell.changeLabel.text = "↓\(cut)$"
        }
        cell.cellDelegate = self
        cell.symbol = item.symbol
        cell.likeButton.isSelected = false
        for i in 0..<self.savedQuotes.count {
            if cell.symbol == self.savedQuotes[i].symbol {
                cell.likeButton.isSelected = true
            }
        }
        
        return cell
    }
    
    //MARK: - add to favorite cell button
    func clickCell(sender: UIButton, symbol: String) {
        if sender.isSelected {
            for i in 0..<self.savedQuotes.count {
                if symbol == self.savedQuotes[i].symbol {
                    deleteItem(item: self.savedQuotes[i])
                    getItems()
                    break
                }
            }
            sender.isSelected = false
        } else {
            createItem(name: symbol)
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    //MARK: - search bar filter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? listOfQuotes : listOfQuotes.filter { (item: QuoteInfo) -> Bool in
            if (item.shortName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                || item.symbol.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) {
                return true
            }
            else {
                return false
            }
        }
        
        tableView.reloadData()
    }
    
    //MARK: - cell accessory (segue to chart-view)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        quotesRequest.getQuoteHistory(compName: filteredData[indexPath.row].symbol) { [weak self] result in
            switch result {
            case .failure(let error) : do {
                print(error)
                DispatchQueue.main.async {
                    self!.alert(style: .alert)
                }
            }
            case .success(let qChart) : do {
                DispatchQueue.main.async {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ChartViewController") as? ChartViewController {
                        vc.quoteChart = qChart
                        vc.quoteName = self!.filteredData[indexPath.row].symbol
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            }
        }
    }
    
    //MARK: - refresh control
    @objc private func refresh(sender: UIRefreshControl) {
        quotesRequest.getQuotesInfo { [weak self] result in
            switch result {
            case .failure(let error) : do {
                print(error)
                DispatchQueue.main.async {
                    self!.alert(style: .alert)
                }
            }
            case .success(let quotesData) : self?.listOfQuotes = quotesData
            }
        }
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    //MARK: - core data module
    func getItems() {
        do {
            savedQuotes = try context.fetch(DataModel.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func createItem(name: String) {
        let newItem = DataModel(context: context)
        newItem.symbol = name
        do {
            try context.save()
            getItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: DataModel) {
        context.delete(item)
        do {
            try context.save()
            getItems()
        } catch {
            
        }
    }

    //MARK: - segue to favorite
    @IBAction func goToFavorite(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FavoriteViewController") as? FavoriteViewController {
            favoriteQuotes.removeAll()
            getItems()
            for i in 0..<self.savedQuotes.count {
                for j in 0..<listOfQuotes.count {
                    if listOfQuotes[j].symbol == self.savedQuotes[i].symbol {
                        favoriteQuotes.append(listOfQuotes[j])
                    }
                }
            }
            vc.listOfQuotes = favoriteQuotes
            self.navigationController?.pushViewController(vc, animated: true)
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
