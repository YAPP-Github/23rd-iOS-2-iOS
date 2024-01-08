//
//  BadgeConfigurable.swift
//  FullCarUI
//
//  Created by Sunny on 1/6/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

/// Badge의 구성 가능한 특성을 나타낸 타입입니다.
public struct BadgeConfigurable {
    var font: Pretendard.Style
    var spacing: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat

    init(
        font: Pretendard.Style,
        spacing: CGFloat = 0,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 5,
        cornerRadius: CGFloat = 3
    ) {
        self.font = font
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
    }

    public static var standard: Self = BadgeConfigurable(
        font: .bold12,
        spacing: 0,
        horizontalPadding: 8,
        verticalPadding: 5,
        cornerRadius: 3
    )
}
