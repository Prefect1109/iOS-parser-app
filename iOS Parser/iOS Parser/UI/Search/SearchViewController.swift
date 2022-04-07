//
//  SearchViewController.swift
//  iOS Parser
//
//  Created by Prefect on 27.03.2022.
//

import RxSwift

class SearchViewController: UIViewController {
    
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
    private var showFilter: (() -> ())?
    private var viewModel: SearchViewModel?
    
    private let disposeBag = DisposeBag()
    private let fetchMore = PublishSubject<Void>()
    private let refreshControlAction = PublishSubject<Void>()
    private let inputString = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.backgroundGrey()
        configureUI()
        bind()
    }
    
    func configure(viewModel: SearchViewModel,
                   showArticle: @escaping (URL) -> (),
                   showFilter: @escaping () -> ()) {
        self.viewModel = viewModel
        self.showArticle = showArticle
        self.showFilter = showFilter
    }
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.clipsToBounds = true
        view.backgroundColor = R.color.backgroundGrey()
        view.bringSubviewToFront(headerView)
        
        view.bringSubviewToFront(safeAreaBackgroundView)
        
        tableView.register(R.nib.newsTableViewCell)
        tableView.register(R.nib.searchHistoryTableViewCell)
        tableView.backgroundColor = R.color.backgroundGrey()
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        tableViewHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewHeaderLabel.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 15).isActive = true
        tableViewHeaderLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        headerView.searchTextField.rx.text.orEmpty
            .filter { $0.count >= 4 }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                inputString.onNext(text)
            }).disposed(by: disposeBag)
        
        let output = viewModel.transform(.init(inputString: inputString.asObservable(),
                                               featchMore: fetchMore.asObserver().startWith(()),
                                               refreshControlEvent: refreshControlAction.asObserver()))
        
        headerView.filterButton.rx.tap.subscribe(onNext: { self.showFilter?() })
            .disposed(by: disposeBag)
        
        output.tableHeaderValue
            .bind(to: tableViewHeaderLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.items
            .drive(tableView.rx.items(dataSource: SearchDataSource.dataSource()))
            .disposed(by: disposeBag)
        
        output.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }.disposed(by: disposeBag)
        
        output.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchTableViewItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                case .searchHistory(let string):
                    self.inputString.onNext(string)
                    self.tableViewHeaderLabel.rx.text.onNext("News")
                case .news(let article):
                    self.openWebView(with: article.url)
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 150) {
                self.fetchMore.onNext(())
            }
        }.disposed(by: disposeBag)
        
        viewModel.loadHistoryItems()
    }
    
    @objc private func refreshControlTriggered() {
        refreshControlAction.onNext(())
    }
    
    private func openWebView(with string: String) {
        guard let url = URL(string: string) else { return }
        showArticle?(url)
    }
}
