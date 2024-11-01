//
//  WorkerCell.swift
//  abzTestTask
//
//  Created by Vitya Mandryk on 31.10.2024.
//

import Foundation
import SwiftUI




struct WorkerCell: View {
    @ObservedObject var viewModel: WorkerCellViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: viewModel.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.name)
                        .font(AppFont.regular.font(size: 18))
                        .foregroundColor(.black)
                    Text(viewModel.position)
                        .font(AppFont.regular.font(size: 14))
                        .foregroundColor(AppColors.darkGray)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.email)
                        .font(AppFont.regular.font(size: 14))
                        .foregroundColor(.black)
                    Text(viewModel.phoneNumber)
                        .font(AppFont.regular.font(size: 14))
                        .foregroundColor(.black)
                }
                Divider()
                    .background(Color.gray)
                    .padding(.top, 23)
                    .padding(.trailing, 16)
            }
        }
        .padding()
    }
}







