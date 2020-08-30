import SpinRxSwift
import SpinCommon
import RxSwift

extension ListViewController {
    struct EmptyListConfiguration {
        let icon: UIImage?
        let title: String?
        let subtitle: String
        let actionDescription: String?
        let actionBlock: (() -> Void)?
    }
}

class ListViewController<TItem, TCell, TShimmerCell>: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UITableViewDataSourcePrefetching
where
    TItem: Codable,
    TCell: UITableViewCell, TCell: ClassIdentifiable & NibIdentifiable & BindableType,
    TShimmerCell: UITableViewCell, TShimmerCell: ClassIdentifiable & NibIdentifiable {

    typealias ViewModelFactoryType = (TItem) -> TCell.ViewModelType?

    // MARK: - State
    private lazy var itemsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(cellType: TCell.self)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .white
        table.estimatedRowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.allowsSelection = true
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.refreshControl = refreshControl
        return table
    }()
    private lazy var loadingTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(cellType: TShimmerCell.self)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.dataSource = shimmerDatasource
        return table
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private lazy var nextPageProgressIndicator: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        progress.color = R.color.primaryColor()
        progress.frame = .init(x: 0, y: 0, width: 44, height: 44)
        return progress
    }()

    private lazy var backgroundView: StatusBackgroundView = {
        var view = StatusBackgroundView()
        view.backgroundColor = R.color.tableViewBackground()
        view.isHidden = true
        return view
    }()
    private lazy var shimmerDatasource: UITableViewShimmerDatasource<TShimmerCell> = {
        return UITableViewShimmerDatasource<TShimmerCell>()
    }()

    private let emptyListConfiguration: ListViewController.EmptyListConfiguration
    private let viewModelFactory: ViewModelFactoryType
    private let didSelectItem: ((TItem) -> Void)?
    private var datasource = ListPage<TItem>.first(items: [], hasNext: false)
    private var feature: ListFeature<TItem>!

    init(_ configuration: ListViewController.EmptyListConfiguration,
         viewModelFactory: @escaping ViewModelFactoryType,
         selectedItem: ((TItem) -> Void)? = nil) {
        self.emptyListConfiguration = configuration
        self.viewModelFactory = viewModelFactory
        self.didSelectItem = selectedItem

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Impl
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingTableView
            .add(to: view)
            .pinToEdges()

        itemsTableView
            .add(to: view)
            .pinToEdges()

        backgroundView
            .add(to: view)
            .pinToEdges()
    }

    func bind(feature: ListFeature<TItem>) {
        self.feature = feature
        feature.spin.render(on: self, using: { $0.render(state:) })
        feature.spin.start()
        feature.spin.emit(.refresh(filter: "", initial: true))
    }

    @objc
    func refresh() {
        feature.spin.emit(.refresh(filter: "", initial: false))
    }

    private func presentError(_ error: Error) {
        backgroundView.update(
            topImage: R.image.caution()!,
            title: R.string.localizable.somethingWrong(),
            subtitle: error.localizedDescription,
            buttonDescription: R.string.localizable.tryAgain()
        )
        backgroundView.buttonAction = { [weak self] in self?.feature.spin.emit(.refresh(filter: "", initial: true)) }
        view.bringSubviewToFront(backgroundView)
    }

    private func presentEmpty() {
        backgroundView.update(
            topImage: emptyListConfiguration.icon ?? R.image.info()!,
            title: emptyListConfiguration.title ?? "",
            subtitle: emptyListConfiguration.subtitle, 
            buttonDescription: emptyListConfiguration.actionDescription ?? ""
        )
        backgroundView.buttonAction = emptyListConfiguration.actionBlock
        view.bringSubviewToFront(backgroundView)
    }

    // MARK: - Render
    func render(state: ListFeature<TItem>.State) {
        switch state {
        case .idle:
            return

        case let .refreshing(_, initial):
            itemsTableView.isHidden = initial
            backgroundView.isHidden = true
            loadingTableView.isHidden = !initial

        case .refreshed(let list):
            datasource = ListPage.first(items: list.items, hasNext: list.hasNext)
            itemsTableView.reloadData()

            backgroundView.isHidden = true
            itemsTableView.isHidden = false
            refreshControl.endRefreshing()
            loadingTableView.isHidden = true

        case .loadingPage:
            nextPageProgressIndicator.isHidden = false

        case let .loadedPage(page):
            let lastIndex = datasource.items.count
            let indexes = page.items.indices
                .map { $0.advanced(by: lastIndex) }
                .map { IndexPath(row: $0, section: 0) }

            datasource = datasource.with(nextPage: page)
            nextPageProgressIndicator.isHidden = true
            itemsTableView.insertRows(at: indexes, with: .fade)

        case let .error(error):
            datasource = .empty()
            itemsTableView.reloadData()
            presentError(error)
            refreshControl.endRefreshing()
            loadingTableView.isHidden = true
            itemsTableView.isHidden = true
            backgroundView.isHidden = false

        case .empty:
            datasource = .empty()
            itemsTableView.reloadData()

            presentEmpty()
            backgroundView.isHidden = false
            itemsTableView.isHidden = true
            refreshControl.endRefreshing()
            loadingTableView.isHidden = true

        }
    }

    // MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = datasource.items[indexPath.row]
        guard let feature = viewModelFactory(item) else { preconditionFailure("Could not build VM") }

        var cell = itemsTableView.dequeueReusableCell(withCellType: TCell.self)
        cell.bind(to: feature)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nextPageProgressIndicator
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let nRows = datasource.items.count - 1
        if datasource.hasNext && indexPaths.contains(where: { $0.row >= nRows }) {
            self.feature.spin.emit(.loadPage(page: datasource.currentPage + 1, filter: ""))
        }
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datasource.items[indexPath.row]
        didSelectItem?(item)
    }
}
