//
//  NetworkService.swift
//  Yand
//
//  Created by Mac on 02.03.2021.
//

import Foundation


class NetworkClass {
    
    //MARK: - get list of quotes(name, price etc)
    func getQuotesInfo(completion: @escaping (Result<[QuoteInfo], Error>) -> Void) {
        
        let tickers = "AAPL,F,BAC,AMZN,YNDX,T,BABA,AAL,ADBE,BA,DIS,GE,NKE,SBUX,MLRYY,ATVI"
        
        let headers = [
            "X-Mboum-Secret": "8HuhXW2tVWSHw4a5bZ0NBFz7A3fnpWkUt3T9wr8iiiGd9ITj0hmJUMXT6s5R"
        ]

        let request = NSMutableURLRequest(
            url: NSURL(string: "https://mboum.com/api/v1/qu/quote/?symbol=\(tickers)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            do {
                let obj = try JSONDecoder().decode([QuoteInfo].self, from: jsonData) //!!!
                completion(.success(obj))
            } catch {
                print("error: ", error)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    //MARK: - get day/week/month prices
    func getQuoteHistory(compName: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        
        let headers = [
            "X-Mboum-Secret": "8HuhXW2tVWSHw4a5bZ0NBFz7A3fnpWkUt3T9wr8iiiGd9ITj0hmJUMXT6s5R"
        ]

        let request = NSMutableURLRequest(
            url: NSURL(string: "https://mboum.com/api/v1/hi/history/?symbol=\(compName)&interval=1h&diffandsplits=true")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            do {
                let obj = try JSONDecoder().decode(QuoteHistory.self, from: jsonData)
                var objBack = [Item]()
                for (_, value) in obj.items {
                    objBack.append(value)
                }
                completion(.success(objBack))
            } catch {
                print("error: ", error)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    //MARK: - get list of favorite(chosen) quotes
    func getFavoriteQuotesInfo(compNames: String, completion: @escaping (Result<[QuoteInfo], Error>) -> Void) {

        let headers = [
            "X-Mboum-Secret": "8HuhXW2tVWSHw4a5bZ0NBFz7A3fnpWkUt3T9wr8iiiGd9ITj0hmJUMXT6s5R"
        ]

        let request = NSMutableURLRequest(
            url: NSURL(string: "https://mboum.com/api/v1/qu/quote/?symbol=\(compNames)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            do {
                let obj = try JSONDecoder().decode([QuoteInfo].self, from: jsonData) //!!!
                completion(.success(obj))
            } catch {
                print("error: ", error)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    //MARK: - get more quote info
    func getMoreInfo(compName: String, completion: @escaping (Result<[MoreInfo], Error>) -> Void) {
        let headers = [
            "X-Mboum-Secret": "8HuhXW2tVWSHw4a5bZ0NBFz7A3fnpWkUt3T9wr8iiiGd9ITj0hmJUMXT6s5R"
        ]

        let request = NSMutableURLRequest(
            url: NSURL(string: "https://mboum.com/api/v1/qu/quote/profile/?symbol=\(compName)")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            do {
                let obj = try JSONDecoder().decode(MoreInfo.self, from: jsonData)//!!!
                var back = [MoreInfo]()
                back.append(obj)
                completion(.success(back))
            } catch {
                print("error: ", error)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
}
