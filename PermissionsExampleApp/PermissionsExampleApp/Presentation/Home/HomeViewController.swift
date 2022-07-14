//
//  HomeViewController.swift
//  PermissionsExampleApp
//
//  Created by Manu on 14/07/2022.
//

import UIKit
import UIKitHelpers

final class HomeViewController: UITableViewController {
    private let presenter = HomePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

extension HomeViewController: ViewSetUpping {
    func setUpView() {
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
    }
}

// MARK: - Table
extension HomeViewController {
    func setUpTableView() {
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in _: UITableView) -> Int {
        presenter.numberOfSections()
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = presenter.title(forCellAt: indexPath)
        cell.contentConfiguration = contentConfig
        return cell
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.title(for: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController!.pushViewController(presenter.nextViewController(forCellAt: indexPath), animated: true)
    }
}
