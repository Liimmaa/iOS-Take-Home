import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModel?
    var gifList: GifObject?
    var id: String
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = DetailViewModel(delegate: self)
        viewModel?.getDetailsById(id: id)
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(vStack)
        return view
    }()
    
    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ratingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(photoView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(ratingsLabel)
        
        stackView.setCustomSpacing(20, after: photoView)
        return stackView
    }()
    
    private func configureUI(url: URL, title: String, source: String, ratings: String) {
        self.photoView.kf.setImage(with: url)
        self.titleLabel.text = "Title: \(title)"
        self.sourceLabel.text = "Source: \(source)"
        self.ratingsLabel.text = "Ratings: \(ratings)"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(vStack)
        
        vStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }    
}

extension DetailViewController: GetGifDetailsEvent {
    func getGif(_ data: GifIDResponse) {
        self.gifList = data.data
        guard let url = self.gifList?.images.fixed_height.url,
              let title = self.gifList?.title,
              let source = self.gifList?.source_tld,
              let ratings = self.gifList?.rating else  {return}
        
        DispatchQueue.main.async {
            self.configureUI(url: url,
                             title: title,
                             source: source,
                             ratings: ratings)
        }
    }
}

extension DetailViewController {
    static func launch(_ caller: UIViewController, id: String) {
        let vc = DetailViewController(id:id)
        caller.navigationController?.pushViewController(vc, animated: true)
    }
}
