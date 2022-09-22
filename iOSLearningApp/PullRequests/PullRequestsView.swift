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
    private let  pullRequestTableView = UITableView()
    
    private let loadingContainerView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private var pullRequestsList: PullRequestsModel!
    
    private let pullRequestViewModel = PullRequestsViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.pullRequestsList = FileManager.loadJson(filename: StringConstants.sampleJsonFileName.rawValue)
        
         
        setupHeadingLabel()
        showLoadingIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.stopLoadindIndicator()
        }
        
        
//        view.addSubview(pullRequestTableView)
//
//        pullRequestTableView.dataSource = self
//        pullRequestTableView.delegate = self
//        pullRequestTableView.register(PullRequestsTableViewCell.self, forCellReuseIdentifier: StringConstants.pullRequestsCellIdentifier.rawValue)
//
//
//
//        pullRequestTableView.snp.makeConstraints{ make in
//            make.top.equalTo(screenHeadingLabel.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
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
            make.height.width.equalToSuperview()
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
        loadingContainerView.removeFromSuperview()
    }

}



extension PullRequestsView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequestsList.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.pullRequestsCellIdentifier.rawValue) as! PullRequestsTableViewCell
        let item = pullRequestsList.items[indexPath.row]
        cell.setPullRequestTableCellData(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = pullRequestsList.items[indexPath.row]
        print("clicked \(indexPath.row)")
        let alertController = UIAlertController(title: "\(item.user.login)"
            , message: "Item clicked", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}

class PullRequestsTableViewCell : UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    
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
    
    private func setupBodyLabelView(){
        containerView.addSubview(bodyLabel)
        bodyLabel.textColor = .darkGray
        bodyLabel.numberOfLines = 0
        bodyLabel.font = bodyLabel.font.withSize(14)
        bodyLabel.snp.makeConstraints{
            make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
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
        showLoadingIndicator()
    }
    
    func loadData(_ response: PullRequestsModel) {
        self.pullRequestsList = response
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
