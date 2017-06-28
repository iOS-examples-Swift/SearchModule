//
//  PushAnimation.swift
//  SearchModule
//
//  Created by Steve on 2017/6/28.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

extension UIViewController {

    func push(to: UIViewController, animation: CAAnimationType, interval: TimeInterval = 0.3 ) {
        self.navigationController?.view.layer.add(anim(with: animation, interval: interval), forKey: nil)
        self.navigationController?.pushViewController(to, animated: false)
    }

    func present(to: UIViewController, animation: CAAnimationType, interval: TimeInterval = 0.3 ) {
        self.view.layer.add(anim(with: animation, interval: interval), forKey: nil)
        present(to, animated: false, completion: nil)
    }

    func anim(with: CAAnimationType, interval: TimeInterval) -> CATransition {
        let transition = CATransition()
        transition.duration = interval
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = with.rawValue
        transition.subtype = kCATransitionMoveIn
        transition.delegate = self as? CAAnimationDelegate
        return transition
    }
}

enum CAAnimationType: String {
    case rippleEffect //波纹效果
    case cube//立体翻转效果
    case suckEffect//像被吸入瓶子的效果
    case oglflip//翻转
    case pageCurl//翻页效果
    case pageUnCurl//反翻页效果
    case cameraIrisHollowOpen//开镜头效果
    case cameraIrisHollowClose//关镜头效果
    case fade//淡入淡出
    case push//推进效果
    case reveal//揭开效果
    case moveIn//慢慢进入并覆盖效果
    case fromBottom//下翻页效果
    case fromTop//上翻页效果
    case fromLeft//左翻转效果
    case fromRight//右翻转效果
}
