//
//  FullCarTextField.swift
//  FullCarUI
//
//  Created by Sunny on 1/1/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

/// Header, TextField, Footer로 구성되어있는 View입니다. Footer는 Message 타입으로 error, information 등의 정보를 나타냅니다.
public struct FullCarTextField: View {
    @FocusState private var isFocused: Bool

    @Binding private var value: String
    @Binding private var state: InputState
    @Binding private var isChecked: Bool

    private let placeholder: String
    /// header 관련 속성
    private let headerText: String?
    private let isHeaderRequired: Bool
    private let headerFont: Pretendard.Style
    private let headerBottomPadding: CGFloat
    /// footer 관련 속성
    private let footerMessage: Message?

    public var body: some View {
        SectionView(
            content: {
                textFieldView
            },
            header: {
                if let headerText = headerText {
                    HeaderLabel(
                        title: headerText,
                        isRequired: isHeaderRequired,
                        font: headerFont
                    )
                }
            },
            footer: {
                /// 에러 상태일 때, 에러 메세지 띄우는 경우
                if case .error(let errorMessage) = state {
                    MessageLabel(.error(errorMessage))
                }

                /// 안내 문구 띄우는 경우
                if case .information(let description, _) = footerMessage {
                    MessageLabel(.information(description))
                }
            },
            headerBottomPadding: headerBottomPadding,
            footerTopPadding: footerTopPadding
        )
    }

    private var textFieldView: some View {
        HStack {
            textField

            if isChecked {
                icon
            }
        }
        .padding(Constants.textFieldViewPadding)
        .background(Colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.textFieldViewRadius)
                .stroke(state.borderColor, lineWidth: 1)
        )
    }

    private var textField: some View {
        TextField(
            placeholder,
            text: $value
        )
        .font(pretendard: .body4)
        .focused($isFocused)
        // 에러 상태일 땐, focus상태여도 error상태 그대로 유지
        .onChange(of: isFocused) { oldValue, newValue in
            if case .error = state { return }
            state = newValue ? .focus : .default
        }
    }

    private var icon: some View {
        Icon.image(type: .check)?
            .frame(width: Constants.iconSize)
            .foregroundStyle(Colors.icon)
    }
}

extension FullCarTextField {
    public init(
        value: Binding<String>,
        state: Binding<InputState>,
        isChecked: Binding<Bool>,
        placeholder: String,
        headerText: String? = nil,
        isHeaderRequired: Bool = false,
        headerFont: Pretendard.Style = .body4,
        headerPadding: CGFloat = 12,
        footerMessage: Message? = nil
    ) {
        self._value = value
        self._state = state
        self._isChecked = isChecked
        self.placeholder = placeholder
        self.headerText = headerText
        self.footerMessage = footerMessage
        self.isHeaderRequired = isHeaderRequired
        self.headerFont = headerFont
        self.headerBottomPadding = headerPadding
    }
}

extension FullCarTextField {
    enum Constants {
        static let textFieldViewRadius: CGFloat = 10
        static let footerPadding: CGFloat = 8
        static let textFieldViewPadding: CGFloat = 16
        static let iconSize: CGFloat = 24
    }

    enum Colors {
        static let background: Color = .gray5
        static let icon: Color = .green100
    }

    private var footerTopPadding: CGFloat {
        switch state {
        case .default, .focus: return 10
        case .error: return 8
        }
    }
}

struct FullCarTextFieldPreviews: PreviewProvider {
    @State static var text: String = ""
    @State static var inputState: InputState = .default

    @State static var isChecked: Bool = false

    @State static var inputState_error: InputState = .error("일치하는 메일 정보가 없습니다.\n회사 메일이 없는 경우 명함으로 인증하기를 이용해 주세요!")

    static var previews: some View {
        VStack(spacing: 30) {
            FullCarTextField(
                value: $text,
                state: $inputState, 
                isChecked: $isChecked,
                placeholder: "회사, 주소 검색",
                headerText: "회사 입력",
                isHeaderRequired: true,
                headerPadding: 5
            )

            FullCarTextField(
                value: $text,
                state: $inputState_error,
                isChecked: $isChecked,
                placeholder: "Placeholder"
            )

            FullCarTextField(
                value: $text,
                state: $inputState,
                isChecked: $isChecked,
                placeholder: "Placeholder",
                footerMessage: .information("이건 정보성 메세지에요.")
            )
        }
        .padding()
    }
}
