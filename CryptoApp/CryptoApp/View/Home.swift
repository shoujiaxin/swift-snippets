//
//  Home.swift
//  CryptoApp
//
//  Created by Jiaxin Shou on 2022/7/17.
//

import SwiftUI

struct Home: View {
    @State private var currentCoin: String = "BTC"

    @Namespace private var animation

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Circle()
                    .fill(.red)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Bitcoin")
                        .font(.callout)

                    Text("BTC")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            segmentedControl

            graphView

            controls
        }
        .padding()
    }

    private var segmentedControl: some View {
        let coins = ["BTC", "ETH", "BNB"]
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins, id: \.self) { coin in
                    Text(coin)
                        .foregroundColor(currentCoin == coin ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.5))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                currentCoin = coin
                            }
                        }
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.vertical)
    }

    private var graphView: some View {
        GeometryReader { _ in
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }

    private var controls: some View {
        HStack(spacing: 20) {
            Button {} label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
            }

            Button {} label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
