//
//  CompanySearchView.swift
//  FullCar
//
//  Created by Sunny on 1/20/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct CompanySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: OnboardingViewModel

    @State private var companySearchBarState: InputState = .default
    @State var company: String = ""

    var body: some View {
        bodyView
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .navigationBarStyle(
                leadingView: {
                    NavigationButton(icon: .back, action: { dismiss() })
                },
                centerView: {
                    Text("회사 입력")
                        .font(.pretendard18(.bold))
                },
                trailingView: { }
            )
    }

    private var bodyView: some View {
        VStack(spacing: .zero) {
            companySearchBar
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                companySearchBarState = .focus
            }
        }
    }

    private var companySearchBar: some View {
        FCTextFieldView(
            textField: {
                HStack {
                    TextField("회사, 주소 검색", text: $company)
                        .textFieldStyle(
                            .fullCar(
                                type: .none,
                                state: $companySearchBarState,
                                padding: 16,
                                backgroundColor: .gray5,
                                cornerRadius: 10
                            ))

                    Button(action: {
                        companySearchBarState = .default
                    }, label: {
                        Text("검색")
                    })
                    .buttonStyle(.fullCar(
                        font: .pretendard16(.semibold),
                        horizontalPadding: 14,
                        verticalPadding: 15,
                        style: .palette(.primary_secondary)
                    ))
                }
            },
            state: $companySearchBarState
        )
    }
}

#Preview {
    CompanySearchView(viewModel: .init())
}
