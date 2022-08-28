//
//  Filemanager.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 28.08.2022.
//

import Foundation

extension FileManager {
    static let documentDirectoryURL = try! `default`.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false)
}
