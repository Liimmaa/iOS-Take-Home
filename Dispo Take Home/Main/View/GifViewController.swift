import UIKit
import SnapKit
import Kingfisher

final class GifViewController: UIViewController {
    private var viewModel: GifViewModel?
    private var gifList: [GifObject]?
    
    private var collectionView: UICollectionView!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = GifViewModel(delegate: self)
        viewModel?.getTrendingGif()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.identifier)
    }
    
    private func setupUI(){
        setupCollectionView()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.backgroundColor = .systemPurple
        view.backgroundColor = .systemBackground
    }
}

extension GifViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)))
        
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)),
            subitem: verticalStackItem,
            count: 2)
        
        let doubleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)))
        doubleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let doubleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.4)),
            subitem: doubleItem,
            count: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.6)),
            subitems: [
                item,
                verticalStackGroup
            ])
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)),
            subitems: [
                horizontalGroup,
                doubleHorizontalGroup
            ])
        
        // Sections
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        // Return
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: UISearchBarDelegate

extension GifViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: implement
        if searchText.isEmpty {
            viewModel?.getTrendingGif()
        } else {
            gifList = nil
            self.collectionView.reloadData()
            
            viewModel?.getGifbySearch(completion: { result in
                DispatchQueue.main.async {
                    self.gifList = result
                    self.collectionView.reloadData()
                }
            }, searchword: searchText)
        }
    }
}

extension GifViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifList?.count ?? Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.identifier, for: indexPath) as? PhotoLibraryCollectionViewCell
        if let url = gifList?[indexPath.row].images.fixed_height.url {
            cell?.backgroundColor = ColorProvider().getColorByIndex(indexPath: indexPath)
            cell?.imageView.kf.setImage(with: url)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = gifList?[indexPath.row].id {
            DetailViewController.launch(self, id: id)
        }
    }
}

extension GifViewController: GetGifEvent {
    func getGifs(_ data: [GifObject]) {
        DispatchQueue.main.async {
            self.gifList = data
            self.collectionView.reloadData()
        }
    }
}
