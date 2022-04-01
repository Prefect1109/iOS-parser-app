//
//  SearchDataSource.swift
//  iOS Parser
//
//  Created by Prefect on 01.04.2022.
//

import RxDataSources

enum SearchTableViewItem {
    case searchHistory(title: String)
    case news(article: Article)
}

enum SearchTableViewSection {
    case searchHistory(items: [SearchTableViewItem])
    case news(items: [SearchTableViewItem])
}

extension SearchTableViewSection: SectionModelType {
    typealias Item = SearchTableViewItem
    
    var header: String {
        ""
    }
    
    var items: [SearchTableViewItem] {
        switch self {
        case .searchHistory(items: let items):
            return items
        case .news(items: let items):
            return items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}

struct SearchDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<SearchTableViewSection> {
        return .init(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            switch dataSource[indexPath] {
            case let .searchHistory(title):
                tableView.separatorStyle = .singleLine
                tableView.separatorColor = .white
                tableView.refreshControl?.isHidden = true
                tableView.rowHeight = 49
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.searchHistoryCell,
                                                         for: indexPath)!
                cell.itemLabel.text = title
                return cell
            case let .news(article):
                tableView.separatorStyle = .none
                tableView.rowHeight = 118
                tableView.refreshControl?.isHidden = false
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell,
                                                         for: indexPath)!
                cell.newsImageView.load(url: URL(string: article.image)!)
                cell.titleLabel.text = article.title
                cell.bodyLabel.text = article.description
                return cell
            }})
    }
}
