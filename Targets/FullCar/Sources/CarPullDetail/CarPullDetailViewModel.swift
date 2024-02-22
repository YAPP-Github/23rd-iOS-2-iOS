//
//  CarPullDetailViewModel.swift
//  FullCar
//
//  Created by 한상진 on 1/8/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation
import Observation
import Dependencies
import XCTestDynamicOverlay



@MainActor
@Observable
final class CarPullDetailViewModel {
    @ObservationIgnored @Dependency(\.callListAPI) private var callListAPI
    
    enum CarPullDetailOpenType {
        case MyPage
        case Home
    }
    
    enum AlertType {
    case alreadyRegister
    case deleteDone
    case apply
    }
    
    enum RequestStatus {
        case beforeBegin
        case inProcess
        case applyAlready
    }
    
    var openType: CarPullDetailOpenType
    var requestStatus: RequestStatus
    let carPull: CarPull.Model.Information
    var information: Car.Information?
    var onBackButtonTapped: () -> Void = unimplemented("onBackButtonTapped")
    
    var actionSheetOpen: Bool = false
    var alertOpen: Bool = false
    var deleteDoneAlertOpen: Bool = false
    var isFinishedAlertOpen: Bool = false
    var acceptAlertOpen: Bool = false
    var alreadyRegisterAlertOpen: Bool = false
    
    var alertType: AlertType = .alreadyRegister
    
    init(
        openType: CarPullDetailOpenType = .Home,
        requestStatus: RequestStatus = .beforeBegin,
        carPull: CarPull.Model.Information
    ) {
        self.openType = openType
        self.requestStatus = requestStatus
        self.carPull = carPull
    }
    
    func onFirstTask() async {
        // TODO: API call
    }
    
    func beginRequestButtonTapped() async {
        await applyFullCar()
    }
    
    func applyFullCar() async {
        do {
            try await callListAPI.applyCarpull(formId: carPull.id,
                                               pickupLocation: carPull.pickupLocation,
                                               peroidType: carPull.periodType.rawValue,
                                               money: carPull.money,
                                               content: carPull.content ?? "")
            
            await MainActor.run {
                requestStatus = .applyAlready
                alertType = .apply
                alreadyRegisterAlertOpen = true
            }
        } catch {
            
            alertType = .alreadyRegister
            alreadyRegisterAlertOpen = true
            
            print("error", error.localizedDescription)
        }
    }
    
    func patchAction(id: Int64) async {
        do {
            let _ = try await callListAPI.patchCarpull(formId: id)
            onBackButtonTapped()
        } catch {
            print("error", error.localizedDescription)
        }
    }
    
    func deleteAction(id: Int64) async {
        do {
            let _ = try await callListAPI.deleteCarpull(formId: id)
            
            alertType = .deleteDone
            alreadyRegisterAlertOpen = true
        } catch {
            print("에러", error.localizedDescription)
        }
    }
}

extension CarPullDetailViewModel: Hashable {
    nonisolated static func == (lhs: CarPullDetailViewModel, rhs: CarPullDetailViewModel) -> Bool {
        return lhs === rhs
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
