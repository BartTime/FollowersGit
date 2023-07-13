//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Alex on 26.02.2022.
//

import UIKit

protocol FollowerListVCDelgate: class{
    func didRequestFollowers(for username: String)
}

class FollowerListVC: UIViewController {
    
    enum Section{
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title         = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
        
    }
    
    func getFollowers(username: String, page: Int){
        showLoadinView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            switch result{
            case .success(let followers):
                if followers.count < 100{ self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty{
                    let message = "This user doesnt have any followers. Go to followem them"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad stuff Happend", message: error.rawValue, buttonTitle: "Ok")
                
            }
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
        
    }
    
    @objc func addButtonTapped(){
        showLoadinView()
        
        NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result{
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) {[weak self] error in
                    
                    guard let self = self else { return }
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "You have succesfully add user to favorite list", buttonTitle: "Ok")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")

                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            
            }
        }
    }
    
}

extension FollowerListVC: UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY        = scrollView.contentOffset.y
        let contentHeight  = scrollView.contentSize.height
        let height         = scrollView.frame.size.height
        
        if offsetY > contentHeight - height{
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activateArray  = isSearching ? filteredFollowers : followers
        let follower       = activateArray[indexPath.item]
        
        let destVC         = UserInfoVC()
        destVC.username    = follower.login
        destVC.delegate    = self
        let navController  = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching        = true
        filteredFollowers  = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching  = false
        updateData(on: followers)
    }
}


extension FollowerListVC: FollowerListVCDelgate{
    
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
    
    
}
