//
//  HomePresenter.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import Foundation
import UIKit

protocol HomePresenterDelegate: AnyObject {}

final class HomePresenter {
    private var delegate: HomePresenterDelegate?
    private var sections: [HomeSection] = []

    init() {
        sections = buildSections()
    }

    func set(delegate: HomePresenterDelegate) {
        self.delegate = delegate
    }

    func numberOfSections() -> Int {
        sections.count
    }

    func numberOfRows(in section: Int) -> Int {
        switch sections[section] {
        case let .general(rows):
            return rows.count
        }
    }

    func title(for section: Int) -> String {
        switch sections[section] {
        case .general:
            return "General"
        }
    }

    func title(forCellAt indexPath: IndexPath) -> String {
        switch sections[indexPath.section] {
        case let .general(rows):
            return rows[indexPath.row].title
        }
    }

    func nextViewController(forCellAt indexPath: IndexPath) -> UIViewController {
        switch sections[indexPath.section] {
        case let .general(rows):
            switch rows[indexPath.row] {
            case .camera:
                return CameraViewController()
            }
        }
    }
}

private extension HomePresenter {
    func buildSections() -> [HomeSection] {
        var sections: [HomeSection] = []
        sections.append(.general([.camera]))
        return sections
    }
}
