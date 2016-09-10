//
//  ShowList.swift
//  freezerinventoryscanner
//
//  Created by Sam Kheirandish on 2016-08-18.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ShowList: UIStoryboardSegue {

    override func perform() {
        let sourceViewController: UIViewController = (self.sourceViewController )
        let destinationController: UIViewController = (self.destinationViewController )
        let transition: CATransition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        //kCATransitionMoveIn; //, kCATransitionPush,   kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        sourceViewController.navigationController!.view.layer.addAnimation(transition, forKey: nil)
        sourceViewController.navigationController!.pushViewController(destinationController, animated: true)
    }
}
