//
//  UIViewControllerExtensions.swift
//  MemeMe
//
//  Created by Gregory White on 3/1/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - API
    
    func logViewDidAppear()           { log.verbose("\(type(of: self)) view did appear") }
    func logViewDidDisappear()        { log.verbose("\(type(of: self)) view did disappear") }
    func logViewDidLoad()             { log.verbose("\(type(of: self)) view did load") }
    func logDidReceiveMemoryWarning() { log.warning("\(type(of: self)) did receive memory warning") }
    func logViewWillLayoutSubviews()  { log.verbose("\(type(of: self)) view will layout subviews") }
    func logViewWillAppear()          { log.verbose("\(type(of: self)) view will appear") }
    func logViewWillDisappear()       { log.verbose("\(type(of: self)) view will disappear") }
    
}
