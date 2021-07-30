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
                List(comics) { comic in
                    NavigationLink(
                        destination: ComicDetailsView(comic: comic),
                        label: {
                            Text(comic.title)
                        })
                }
                .listStyle(InsetListStyle())
                
                Button("Fetch More") {
                    let lastComicNo = comics[comics.count-1].id
                    fetchComics(from: lastComicNo, to: lastComicNo+10)
                }
            }
            .onAppear() {
                if comics.isEmpty {
                    fetchComics(to: 10)
                }
            }
            .navigationBarTitle("xkcd Comic Reader")
        }
    }
    
    func fetchComics(from: Int = 1, to: Int) {
        // Get last comic number
        let lastComicNumber = getComic(number: -1).id
        let startIndex = from
        var stopIndex: Int
        
        if (to == -1) || (to > lastComicNumber) {  // Fetch all
            stopIndex = lastComicNumber
        } else {  // Fetch up to No."to"
            stopIndex = to
        }
        
        // Actually do the fetching
        for number in startIndex...stopIndex {
            let newFetchedComic = getComic(number: number)
            comics.append(newFetchedComic)
        }
    }
    
    func getComic(number: Int) -> Comic {
        // Syntax sugar of parseData
        var stringNumber = String(number)
        if number == -1 {  // Get the last one
            stringNumber = ""
        }
        return try! parseData(data: Data(contentsOf: URL(string: String(format: apiFormat, stringNumber))!))
    }
    
    func parseData(data: Data) -> Comic {
        if let json = try? JSON(data: data) {
            var parsedComic = Comic()
            parsedComic.id = json["num"].intValue
            parsedComic.title = json["title"].stringValue
            parsedComic.imageURL = json["img"].stringValue
            parsedComic.comments = json["alt"].stringValue
            return parsedComic
        }
        return Comic()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Comic: Identifiable {
    var imageURL = String()
    var id = 0
    var title = String()
    var comments = String()
    var image: some View {
        URLImage(URL(string: self.imageURL)!) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
