    //
//  NewsApi.swift
//  News
//
//  Created by Nikita Evdokimov on 05.02.2022.
//

import Foundation

//let urlString = "https://newsapi.org/v2/everything?q=" + searchLabel + "&from=2022-02-05&to=2022-02-05&sortBy=popularity&apiKey=d30c0c50f9ef48d5b0638565adceca4f"

//final class URLString {
//    let String = ""
//    init(string: String) {
//        self.String = string
//    }
//}

func lableToUrl(searchLabel: String?) -> String {
    let urlString = "https://newsapi.org/v2/everything?q=" + searchLabel! + "&from=2022-02-05&to=2022-02-05&sortBy=popularity&apiKey=d30c0c50f9ef48d5b0638565adceca4f"
    
    return urlString
}

final class NewsAPI {
    
    static let shared = NewsAPI()
    
    func fetchNewsList(searchLabel: String, onCompletion: @escaping ([Article]) -> ()) {

        guard let url = URL(string: lableToUrl(searchLabel: searchLabel)) else {
            print("URL's with non English symbols are not working yet")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            
            if error != nil {
                print("error")
                return
            }
            
            guard let newsList = try? JSONDecoder().decode(NewsList.self, from: data) else {
                    print("couldn't decode JSON")
                return
            }

            onCompletion(newsList.articles)

        }
        
        task.resume()
    }
    
}

struct NewsList: Codable {
//    let status: String?
    let totalResults : Int?
    let articles: [Article]
}


struct Article : Codable {
//    let source: Source
//    let author: String?
    let title: String?
    let description: String?
    let url: URL?
//    let urlToImage: String?
//    let publishedAt: String?
//    let content: String?
    
}

struct Source : Codable{
//    let id: String?
    let name: String?
//    let description: String?
//    let country: String?
//    let category: String?
//    let url: String?
}
