//
//  SettingsViewModel.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import Foundation

final class SettingsViewModel {
    @AppStorage(key: "sorting")
    var shouldSortAlphabetically = true
        
    func toggleSortingOn(_ isOn: Bool) {
        shouldSortAlphabetically = isOn
    }
}
