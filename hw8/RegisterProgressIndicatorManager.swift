//
//  RegisterProgressIndicatorManager.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/11.
//

import Foundation


// adopt the ProgressSpinnerDelegate protocol and define the show and hide methods
extension RegisterViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        // add the indicator as a child view of the current view
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        // attach and display the indicator on top of the current view.
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        // detach the indicator
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        // remove the indicator views from their parent
        childProgressView.removeFromParent()
    }
}
