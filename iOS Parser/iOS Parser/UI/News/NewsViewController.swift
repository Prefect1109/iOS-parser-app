//
//  NewsViewController.swift
//  iOS Parser
//
//  Created by Prefect on 23.03.2022.
//

import UIKit
import RxSwift

class NewsViewController: UIViewController {
    
    @IBOutlet weak var safeAreaBackgroundView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableViewHeaderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    private var showArticle: ((URL) -> ())?
    private var viewModel: NewsViewModel?
    
    private let disposeBag = DisposeBag()
    private let fetchMore = PublishSubject<Void>()
    private let refreshControlAction = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    func configure(viewModel: NewsViewModel,
                   showArticle: @escaping (URL) -> ()) {
        self.viewModel = viewModel
        self.showArticle = showArticle
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        
        view.clipsToBounds = true
        view.backgroundColor = R.color.backgroundGrey()
        view.bringSubviewToFront(headerView)
        
        view.bringSubviewToFront(safeAreaBackgroundView)
        
        tableView.register(R.nib.newsTableViewCell)
        tableView.backgroundColor = R.color.backgroundGrey()
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        tableViewHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewHeaderLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 15).isActive = true
        tableViewHeaderLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(.init(featchMore: fetchMore.asObserver(),
                                               refreshControlEvent: refreshControlAction.asObserver()))
        
        output.items
            .drive(tableView.rx.items(dataSource: SearchDataSource.dataSource()))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchTableViewItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                if case .news(let article) = item {
                    self.openWebView(with: article.url)
                }
            }).disposed(by: disposeBag)
        
        output.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }.disposed(by: disposeBag)
        
        output.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 150) {
                self.fetchMore.onNext(())
            }
        }.disposed(by: disposeBag)
    }
    
    @objc private func refreshControlTriggered() {
        refreshControlAction.onNext(())
    }
    
    private func openWebView(with string: String) {
        guard let url = URL(string: string) else { return }
        showArticle?(url)
    }
}
