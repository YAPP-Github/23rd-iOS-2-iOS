//
//  Onboarding.Email.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Onboarding.Email {
    @MainActor
    struct TextFieldView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            FCTextFieldView(
                textField: {
                    TextField("\("gildong@fullcar.com")", text: $viewModel.email)
                        .textFieldStyle(.fullCar(
                            type: .check($viewModel.isEmailValid),
                            state: $viewModel.emailTextFieldState)
                        )
                        .onChange(of: viewModel.email) {
                            viewModel.isEmailRequestSent = false
                            viewModel.isEmailAddressValid = false
                        }
                },
                state: $viewModel.emailTextFieldState,
                headerText: "회사 메일을 입력해 주세요.",
                headerFont: .pretendard22(.bold),
                headerPadding: 20
            )
        }
    }

    @MainActor
    struct NumberView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            Text("인증번호 뷰 올것임.")
        }
    }

    @MainActor
    struct SendButtonView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            VStack(spacing: 10) {
                if viewModel.isEmailRequestSent {
                    Text("메일이 오지 않나요? >")
                        .foregroundStyle(Color.fullCar_primary)
                        .font(.pretendard14(.semibold))
                }

                Button(action: {
                    Task {
                        await viewModel.sendEmail()
                    }
                }, label: {
                    Text("인증메일 발송")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.fullCar(style: .palette(.primary_white)))
                .disabled(!viewModel.isEmailValidation() == !viewModel.isEmailRequestSent)
            }
        }
    }

    @MainActor
    struct CertificationButtonView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            Button(action: {
                Task {
                    await viewModel.checkAuthenticationNumber()
                    // MARK: 닉네임 textField로 포커스 변경하고 싶은데,,
                }
            }, label: {
                Text("다음")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        Onboarding.Email.TextFieldView(viewModel: .init())

        Onboarding.Email.NumberView(viewModel: .init())

        Onboarding.Email.SendButtonView(viewModel: .init())
    }
}
#endif