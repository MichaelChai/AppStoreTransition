//
//  TodayPresentationController.swift
//  AppStoreTransition
//
//  Created by Michael.C on 2024/3/14.
//

import UIKit

class TodayPresentationController: UIPresentationController {
    
    private let _blurView = UIVisualEffectView(effect: nil)
    
    override var shouldRemovePresentersView: Bool { false }
    
    override func presentationTransitionWillBegin() {
        guard let view = containerView else { return }
        _blurView.translatesAutoresizingMaskIntoConstraints = false
        _blurView.frame = view.bounds
        view.addSubview(_blurView)
//        NSLayoutConstraint.activate([
//            _blurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
//            _blurView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
//            _blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            _blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//        ])
        _blurView.alpha = 0.0
        
        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self._blurView.effect = UIBlurEffect(style: .light)
            self._blurView.alpha = 1.0
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self._blurView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            _blurView.removeFromSuperview()
        }
    }
    
}
