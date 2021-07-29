//
//  ContentView.swift
//  xkcd Comics
//
//  Created by Xia He on 2021/7/30.
//

import SwiftUI
import URLImage

struct ContentView: View {
    @State private var comics = [Comic]()
    
    let apiFormat = "https://xkcd.com/%@/info.0.json"
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {}, label: {
                    Text("Jump to Random Comic")
                        .padding(8)
                })
                .background(Color.blue)
                .cornerRadius(5)
                .foregroundColor(.white)
                .padding()
                
                List(comics) { comic in
                    Text(comic.title)
                        .font(.headline)
                }
            }
            .navigationBarTitle("xkcd Comic Reader")
        }
    }
    
    func fetchComics(to: Int) {
        // Get last comic number
        let lastComicNumber = getComic(number: -1).id
        if to == -1 {  // Fetch all
            for number in 1...lastComicNumber {
                var newFetchedComic = getComic(number: number)
                comics.append(newFetchedComic)
            }
        }
    }
    
    func getComic(number: Int) -> Comic {
        // Syntax sugar of parseData
        if number == -1 {  // Get the last one
            let stringNumber = ""
        } else {
            let stringNumber = String(number)
        }
        return try! parseData(data: Data(contentsOf: URL(string: String(format: apiFormat, stringNumber))!))
    }
    
    func parseData(data: Data) -> Comic {
        let json = try! JSON(data: data)
        var parsedComic = Comic()
        parsedComic.id = json["num"].intValue
        parsedComic.title = json["title"].stringValue
        parsedComic.imageURL = json["img"].stringValue
        parsedComic.comments = json["alt"].stringValue
        return parsedComic
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct Comic: Identifiable {
        @State var imageURL = String()
        
        var id = 0
        var title = String()
        var comments = String()
        var image: some View {
            URLImage(URL(string: self.imageURL)!) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
