//
//  NetflixHomeViewController.swift
//  NetflixChatGPT
//
//  Created by Lawson Falomo on 10/9/23.
//

import UIKit

private enum Constants {
    static let reuseIdentifier: String = "MovieCell"
    static let headerIdentifier: String = "Header"
    static let imageName: String = "us_poster"
    static let getOutPoster: String = "getout"
    static let oppenheimerPoster: String = "opp"
    static let batmanPoster: String = "batman"
    static let topBoyPoster: String = "topboy"
    static let snowfallPoster: String = "snowfall"
    static let menacePoster: String = "menace"
    static let woodPoster: String = "wood"
}

class NetflixHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var gradientLayer: CAGradientLayer!
    
    var movieCategories: [MovieCategory] = [
        MovieCategory(title: "Critically Acclaimed Movies", movies: [
            Movie(title: "Get Out", posterImage: Constants.getOutPoster),
            Movie(title: "Oppenheimer", posterImage: Constants.oppenheimerPoster),
            Movie(title: "Batman Dark Knight", posterImage: Constants.batmanPoster)
        ]),
        MovieCategory(title: "Continue Watching for Moyo", movies: [
            Movie(title: "Top Boy", posterImage: Constants.topBoyPoster),
            Movie(title: "Snowfall", posterImage: Constants.snowfallPoster),
            Movie(title: "Menace To Society", posterImage: Constants.menacePoster),
        //    Movie(title: "The Wood", posterImage: Constants.woodPoster)
        ]),
        MovieCategory(title: "Trending Now", movies: [])
    ]
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "For Moyo"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let buttons = ["TV Shows", "Movies", "Categories"].map { title -> UIButton in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            return button
        }
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let featuredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: Constants.imageName)
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let myListButton: UIButton = {
        let button = UIButton()
        button.setTitle("My List", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 20, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupLayout()
        
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.headerIdentifier
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Helpers
    
    private func setupLayout() {
        collectionView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(buttonsStackView)
        scrollView.addSubview(featuredImageView)
        scrollView.addSubview(collectionView)
        
        setupGradientLayer()
        
        // Constraints for the scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        featuredImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        featuredImageView.layer.cornerRadius = 15
        featuredImageView.clipsToBounds = true
        
        featuredImageView.addSubview(playButton)
        featuredImageView.addSubview(myListButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        myListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Play Button
            playButton.bottomAnchor.constraint(equalTo: featuredImageView.bottomAnchor, constant: -15),
            playButton.leadingAnchor.constraint(equalTo: featuredImageView.leadingAnchor, constant: 15),
            playButton.trailingAnchor.constraint(equalTo: myListButton.leadingAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalTo: myListButton.widthAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 40),

            // My List Button
            myListButton.bottomAnchor.constraint(equalTo: featuredImageView.bottomAnchor, constant: -15),
            myListButton.trailingAnchor.constraint(equalTo: featuredImageView.trailingAnchor, constant: -15),
            myListButton.widthAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 1),
            myListButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            // Header Label
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            // Buttons Stack View
            buttonsStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Featured Image View
            featuredImageView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            featuredImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            featuredImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            featuredImageView.heightAnchor.constraint(equalToConstant: 450),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: featuredImageView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 0.6]  // Adjust as needed to get the desired effect
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension NetflixHomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movieCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCategories[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movieCategories[indexPath.section].movies[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = UIImage(named: movie.posterImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust this size to your desired cell size. For the large movie poster, you might want to use a bigger height.
        return CGSize(width: collectionView.bounds.width/3 - 10, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension NetflixHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SectionHeader
            headerView.titleLabel.text = movieCategories[indexPath.section].title
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 30)
    }
}
