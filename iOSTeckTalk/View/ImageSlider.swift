//
//  ImageSlider.swift
//  iOSTeckTalk
//
//  Created by Farouk GNANDI on 20/10/2023.
//

import SwiftUI

struct ImageSlider: View {
    var images: [UIImage]
    
    var body: some View {
            TabView {
                ForEach(images, id: \.self) { item in
                    Image(uiImage: item)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    ImageSlider(images: [UIImage(named: "img1")!,
                         UIImage(named: "img2")!,
                         UIImage(named: "img3")!,
                         UIImage(named: "img4")!,
                         UIImage(named: "img5")!])
}
