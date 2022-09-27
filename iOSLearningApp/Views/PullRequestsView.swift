//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Nveen Bandlamudi on 09/06/22.
//

import UIKit
import SnapKit

class PullRequestsView: UIViewController {
    
    private let screenHeadingLabel = UILabel()
    private let pullRequestTableView = UITableView()
    private let loadingContainerView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private var pullRequestsList: [PullRequestItem] = []
    private let pullRequestViewModel = PullRequestsViewModel()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        //temp
        let userDetailsView = UserDetailsView(username: "al45tair")
        self.navigationController?.pushViewController(userDetailsView,animated:true)
        //temp
        
        pullRequestViewModel.pullRequestsDelegate = self
        pullRequestViewModel.viewDidLoad()
        
        // MARK: old task - load data from file
        //self.pullRequestsList = FileManager.loadJson(filename: StringConstants.sampleJsonFileName.rawValue)
        
        setupHeadingLabel()
    }
    
    func setupHeadingLabel(){
        screenHeadingLabel.text  = StringConstants.pullRequestsLabelValue.rawValue
        screenHeadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        view.addSubview(screenHeadingLabel)
        screenHeadingLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(10)
            
        }
    }
    
    
    func showLoadingIndicator(){
        view.addSubview(loadingContainerView)
        loadingContainerView.backgroundColor = .white
        loadingContainerView.snp.makeConstraints{
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        loadingContainerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints{
            make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
    }
    
    func stopLoadindIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
}



extension PullRequestsView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequestsList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.pullRequestsCellIdentifier.rawValue) as! PullRequestsTableViewCell
        
        if(indexPath.row + 1 == pullRequestsList.count){
            return tableView.dequeueReusableCell(withIdentifier: StringConstants.loadingCellIdentifier.rawValue) as! LoadingTableViewCell
        } else{
            let item = pullRequestsList[indexPath.row]
            cell.setPullRequestTableCellData(item: item)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsView = UserDetailsView(username: pullRequestsList[indexPath.row].user.login)
        self.navigationController?.pushViewController(userDetailsView,animated:true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row + 2 == pullRequestsList.count){
            pullRequestViewModel.loadNextPage()
        }
    }
    
}

class LoadingTableViewCell: UITableViewCell {
    let loadingFooterContainerView = UIView()
    let paginationIndicatorView = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(loadingFooterContainerView)
        loadingFooterContainerView.snp.makeConstraints({
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        })
        loadingFooterContainerView.addSubview(paginationIndicatorView)
        paginationIndicatorView.snp.makeConstraints{
            make in
            make.centerY.centerX.equalToSuperview()
        }
        paginationIndicatorView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class PullRequestsTableViewCell : UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let favoriteToggleButton = UIButton(type: UIButton.ButtonType.custom)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViewsInCell(){
        setupContainerView()
        setupAvatarImageView()
        setupTitleLabelView()
        setupSubTitleLabelView()
        setupFavoriteToggleButton()
        setupBodyLabelView()
    }
    
    private func setupContainerView(){
        self.contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.snp.makeConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupAvatarImageView(){
        containerView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints{
            make in
            make.leading.top.equalToSuperview().offset(10)
            make.height.width.equalTo(70)
            make.bottom.lessThanOrEqualToSuperview().offset(-12).priority(.required)
            // make.centerY.equalToSuperview()
        }
    }
    
    
    private func setupTitleLabelView(){
        containerView.addSubview(titleLabel)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
        }
    }
    
    private func setupSubTitleLabelView(){
        containerView.addSubview(subTitleLabel)
        subTitleLabel.textColor = .black
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = subTitleLabel.font.withSize(14)
        subTitleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func setupFavoriteToggleButton(){
        containerView.addSubview(favoriteToggleButton)
        favoriteToggleButton.setImage(UIImage(named: StringConstants.favoriteAssetName.rawValue), for: .normal)
        favoriteToggleButton.snp.makeConstraints{
            make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        favoriteToggleButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupBodyLabelView(){
        containerView.addSubview(bodyLabel)
        bodyLabel.textColor = .darkGray
        bodyLabel.numberOfLines = 0
        bodyLabel.font = bodyLabel.font.withSize(14)
        bodyLabel.snp.makeConstraints{
            make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteToggleButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
            
        }
        
    }
    
    
    func setPullRequestTableCellData(item: PullRequestItem){
        titleLabel.text = item.user.login
        subTitleLabel.text = item.title
        bodyLabel.text = item.body
        avatarImageView.image = UIImage(named: item.user.login)
        URLSession.shared.dataTask(with: NSURL(string: item.user.avatar_url )! as URL, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.avatarImageView.image = image
            })
        }).resume()
    }
}

extension PullRequestsView : PullRequestsViewModelDelegate {
    func showLoader(_ show: Bool) {
        if(show){
            showLoadingIndicator()
        }
        else{
            stopLoadindIndicator()
            self.view.addSubview(self.pullRequestTableView)
            self.pullRequestTableView.separatorColor = UIColor.clear
            self.pullRequestTableView.dataSource = self
            self.pullRequestTableView.delegate = self
            self.pullRequestTableView.register(PullRequestsTableViewCell.self, forCellReuseIdentifier: StringConstants.pullRequestsCellIdentifier.rawValue)
            self.pullRequestTableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: StringConstants.loadingCellIdentifier.rawValue)
            self.pullRequestTableView.snp.makeConstraints{
                make in
                make.top.equalTo(self.screenHeadingLabel.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    func loadData(_ response: [PullRequestItem]) {
        self.pullRequestsList.append(contentsOf: response)
        pullRequestTableView.reloadData()
    }
    
    func showError(_ errorMessage: String) {
        stopLoadindIndicator()
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(
            UIAlertAction(title: "Dismiss",
                          style: UIAlertAction.Style.default) {
                              (result: UIAlertAction) -> Void in
                          })
        self.present(alert, animated: true, completion: nil)
        
    }
}
