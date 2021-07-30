//
//  ComicDetailsView.swift
//  xkcd Comics
//
//  Created by Xia He on 2021/7/30.
//

import SwiftUI

struct ComicDetailsView: View {
    let comic: Comic
    
    var body: some View {
        ScrollView {
            VStack {
                comic.image
                
                Text(comic.comments)
            }
        }
        .navigationBarTitle(comic.title)
    }
}

struct ComicDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailsView(comic: Comic())
    }
}
