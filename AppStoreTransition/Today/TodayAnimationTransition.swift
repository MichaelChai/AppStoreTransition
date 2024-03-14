//
//  TodayAnimationTransition.swift
//  AppStoreTransition
//
//  Created by Michael.C on 2024/3/14.
//

import UIKit

class TodayAnimationTransition: NSObject {
    
    public enum AnimationType {
        case present
        case dismiss
    }
    
    private let _duration: TimeInterval = 1.0
    
    private let _animationType: AnimationType
    
    public init(animationType: AnimationType) {
        _animationType = animationType
        super.init()
    }
    
}

extension TodayAnimationTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        _duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch _animationType {
        case .present:
            animateTransitionPresent(using: transitionContext)
        case .dismiss:
            animateTransitionDismiss(using: transitionContext)
        }
    }
    
    func animateTransitionPresent(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取 fromVC 和 toVC
        guard let fromVC = transitionContext.viewController(forKey: .from) as? UITabBarController,
              let todayVC = fromVC.viewControllers?.first as? TodayViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? TodayDetailViewController,
              let selectedCell = todayVC.selectedCell else { return }
        // 转换坐标
        let frame = selectedCell.convert(selectedCell.bgView.frame, to: fromVC.view)
        // 设置 toVC 的起始大小
        toVC.view.frame = frame
        let windowBounds = UIScreen.main.bounds
        let windowWidth = windowBounds.width
        toVC.imageView.frame.size = CGSize(width: windowWidth - 40.0, height: 410.0)
        transitionContext.containerView.addSubview(toVC.view)
        // 开始动画恢复 toVC 大小并隐藏 tabbar
        UIView.animate(withDuration: _duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0) {
            toVC.view.frame = windowBounds
            toVC.imageView.frame.size = CGSize(width: windowWidth, height: 500.0)
            toVC.closeButton.alpha = 1.0
            
//            let tabbar = fromVC.tabBar
//            tabbar.alpha = 0.0
//            tabbar.frame.origin.y = windowBounds.height
        } completion: {
            transitionContext.completeTransition($0)
        }
    }
    
    func animateTransitionDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? TodayDetailViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController,
              let todayVC = toVC.viewControllers?.first as? TodayViewController,
              let selectedCell = todayVC.selectedCell else { return }
        let frame = selectedCell.convert(selectedCell.bgView.frame, to: toVC.view)
        let windowBounds = UIScreen.main.bounds
        let windowWidth = windowBounds.width
        UIView.animate(withDuration: _duration - 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0) {
            fromVC.view.frame = frame
            fromVC.view.layer.cornerRadius = 15.0
            fromVC.imageView.frame.size = CGSize(width: windowWidth - 40.0, height: 410.0)
            fromVC.closeButton.alpha = 0.0
            
//            let tabbar = toVC.tabBar
//            tabbar.alpha = 1.0
//            tabbar.frame.origin.y = windowBounds.height - tabbar.bounds.height
        } completion: {
            transitionContext.completeTransition($0)
//            toVC.view.addSubview(toVC.tabBar)
        }

    }
    
}
