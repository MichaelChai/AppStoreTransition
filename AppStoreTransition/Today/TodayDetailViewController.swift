//
//  TodayDetailViewController.swift
//  AppStoreTransition
//
//  Created by Michael.C on 2024/3/13.
//

import UIKit

class TodayDetailViewController: UIViewController {
    
    public var imageView: UIImageView { _scrollView.imageView }
    
    public var closeButton: UIButton { _closeBtn }
    
    private let _scrollView = _ScrollView()
    
    private let _closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close_button"), for: .normal)
        return btn
    }()
    
    override var prefersStatusBarHidden: Bool { true }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        
        _scrollView.delegate = self
        _scrollView.frame = view.bounds
        view.addSubview(_scrollView)
        if #available(iOS 11.0, *) {
            _scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        _closeBtn.addTarget(self, action: #selector(_closeBtnClick), for: .touchUpInside)
        _closeBtn.frame = CGRect(x: view.bounds.width - 50.0, y: 20.0, width: 30.0, height: 30.0)
        view.addSubview(_closeBtn)
    }
    
    var dismissCallback: (() -> Void)?
    @objc private func _closeBtnClick() {
        dismiss(animated: true)
        dismissCallback?()
    }
    
}

extension TodayDetailViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TodayAnimationTransition(animationType: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TodayAnimationTransition(animationType: .dismiss)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        TodayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension TodayDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

extension TodayDetailViewController {
    
    private class _ScrollView: UIScrollView {
        
        public var imageView: UIImageView { _imageView }
        
        private let _imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        private let _textView: UITextView = {
            let textView = UITextView()
            textView.text = "Thank you. I'm honored to be with you today for your commencement from one of the finest universities in the world. Truth be told, i never graduated from college and this is the closest I've ever gotten to a college gradution. \n\nToday i want to tell you three stories from my life. That's it. No big deal. Just three stories. The first story is about connecting the dots. \n\ndropped out of Reed College after the first 6 months, but then stayed around as a drop-in for another 18 months or so before I really quit. So why did I drop out? \n\nIt started before I was born. My biological mother was a young,unwed college graduate student, and she decided to put me up for adoption. She felt very strongly that I should be adopted by college graduates, so everything was all set for me to be adopted at birth by a lawyer and his wife. Except that when I popped out they decided at the last minute that they really wanted a girl. So my parents, who were on a waiting list, got a call in the middle of the night asking: 'We got an unexpected baby boy; do you want him?' They said: 'Of course.' My biological mother found out later that my mother had never graduated from college and  my father had never graduated from high school. She refused to sign the final adoption papers. She only relented a few months later when my parents promised that I would  go to college."
            textView.font = .boldSystemFont(ofSize: 15.0)
            textView.textColor = .gray
            textView.isEditable = false
            return textView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let windowWidth = UIScreen.main.bounds.width
            _imageView.frame = CGRect(x: 0.0, y: 0.0, width: windowWidth, height: 500.0)
            addSubview(_imageView)
            
            let width = windowWidth - 40.0
            _textView.frame = CGRect(x: 20.0, y: 540.0, width: width, height: _textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height + 50.0)
            addSubview(_textView)
            
            contentSize = CGSize(width: windowWidth, height: _imageView.bounds.height + 40.0 + _textView.bounds.height + 50.0)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
