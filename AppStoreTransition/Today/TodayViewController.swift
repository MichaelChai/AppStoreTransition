//
//  TodayViewController.swift
//  AppStoreTransition
//
//  Created by Michael.C on 2024/3/13.
//

import UIKit

class TodayViewController: UITableViewController {
    
    public var selectedCell: Cell?
    
    private let _imageNameArray = ["cover_4", "cover_5"]
    
    private let _headerView = _HeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96))
    
    private var _statusBarIsHidden = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool { _statusBarIsHidden }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.Iden)
        tableView.rowHeight = 440.0
        _headerView.didClickHeaderCallback = {
            
        }
        tableView.tableHeaderView = _headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _imageNameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.Iden, for: indexPath) as! Cell
        cell.image = UIImage(named: _imageNameArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { return }
        UIView.animate(withDuration: 0.1) {
            cell.bgView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { return }
        UIView.animate(withDuration: 0.3) {
            cell.bgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { return }
        selectedCell = cell

        let detailVC = TodayDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.imageView.image = cell.image
        detailVC.dismissCallback = { [weak self] in
            self?._statusBarIsHidden = false
        }
        _statusBarIsHidden = true
        present(detailVC, animated: true)
    }

}

extension TodayViewController {
    
    private class _HeaderView: UIView {
        
        private let _dateLabel: UILabel = {
            let label = UILabel()
            label.text = "3月13号 星期三"
            label.textColor = .gray
            label.font = .boldSystemFont(ofSize: 13)
            return label
        }()
        
        private let _titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Today"
            label.font = .boldSystemFont(ofSize: 34)
            return label
        }()
        
        private let _headImageButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: ""), for: .normal)
            let layer = button.layer
            layer.cornerRadius = 17.5
            layer.borderColor = UIColor(red: 239/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1).cgColor
            layer.borderWidth = 0.8
            return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(_dateLabel)
            addSubview(_titleLabel)
            _headImageButton.addTarget(self, action: #selector(_buttonClick), for: .touchUpInside)
            addSubview(_headImageButton)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            _dateLabel.frame = CGRect(x: 20, y: 33, width: 200, height: 15)
            _titleLabel.frame = CGRect(x: 20, y: 48, width: 200, height: 40)
            _headImageButton.frame = CGRect(x: bounds.width - 20 - 40, y: 46, width: 35, height: 35)
        }
        
        var didClickHeaderCallback: (() -> Void)?
        @objc private func _buttonClick() {
            didClickHeaderCallback?()
        }
    }
    
    public class Cell: UITableViewCell {
        
        public static let Iden = "TodayViewController._Cell"
        
        public var image: UIImage? {
            set { _imageView.image = newValue }
            get { _imageView.image }
        }
        
        public var bgView: UIView { _bgView }
        
        private let _bgView: UIView = {
            let view = UIView()
            let layer = view.layer
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.4
            layer.shadowOffset = CGSize(width: 0, height: 1)
            return view
        }()
        
        private let _imageView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFill
            let layer = view.layer
            layer.cornerRadius = 15.0
            layer.masksToBounds = true
            return view
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            _bgView.frame = CGRect(x: 20.0, y: 0.0, width: UIScreen.main.bounds.width - 40.0, height: 410)
            contentView.addSubview(_bgView)
            _imageView.frame = _bgView.bounds
            _bgView.addSubview(_imageView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
