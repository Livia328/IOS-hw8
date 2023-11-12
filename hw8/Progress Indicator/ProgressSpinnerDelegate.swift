//
//  ProgressSpinnerDelegate.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/11.
//

import Foundation

// define a protocol to control the indicator from other screens

protocol ProgressSpinnerDelegate{
    func showActivityIndicator()
    func hideActivityIndicator()
}
