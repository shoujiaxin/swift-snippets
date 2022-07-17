//
//  ContentView.swift
//  CustomLineGraph
//
//  Created by Jiaxin Shou on 2022/7/17.
//

import SwiftUI

private let samplePlot: [Double] = [
    989, 1200, 750, 790, 650, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200,
]

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.title2)
                }

                Spacer()

                Button {} label: {
                    Image("User")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
            }
            .padding()
            .foregroundStyle(.black)

            VStack(spacing: 10) {
                Text("Total Balance")
                    .fontWeight(.bold)

                Text("$ 51 200")
                    .font(.system(size: 38, weight: .bold))
            }
            .padding(.top, 20)

            Button {} label: {
                HStack(spacing: 5) {
                    Text("Income")

                    Image(systemName: "chevron.down")
                }
                .font(.caption.bold())
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.white, in: Capsule())
                .foregroundColor(.black)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
            }

            LineGraph(data: samplePlot)
                .frame(height: 220)
                .padding(.top, 25)

            Text("Shortcuts")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    cardView(title: "YouTube", imageName: "video", price: "$ 26", color: Color("Gradient1"))

                    cardView(title: "Apple", imageName: "applelogo", price: "$ 2600", color: Color("Gradient2"))

                    cardView(title: "Xbox", imageName: "logo.xbox", price: "$ 120", color: .green)
                }
                .padding()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color("Background"))
    }

    @ViewBuilder
    private func cardView(title: String, imageName: String, price: String, color: Color) -> some View {
        VStack(spacing: 15) {
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .padding()
                .background(color, in: Circle())

            Text(title)
                .font(.title3.bold())

            Text(price)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
        .padding(.vertical)
        .padding(.horizontal, 25)
        .background(.white, in: RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: .black.opacity(0.03), radius: 5, x: -5, y: -5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
