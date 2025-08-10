//
//  CardImage.swift
//  My Contacts
//
//  Created by Cosme Stakemann on 9/8/25.
//
import SwiftUI
import Kingfisher

struct CardImage: View {
    let imageUrl: String?
    
    var body: some View {
        showImage()
    }
    
    @ViewBuilder
    func showImage() -> some View {
        if let urlString = imageUrl, let url = URL(string: urlString) {
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.gray)
        }
    }
    
}
