//
//  ViewController.swift
//  clock
//
//  Created by Tuan LE on 9/16/17.
//  Copyright © 2017 Leo LE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clockContainer: UIView?
    fileprivate var clockView: ClockView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initClockView()
        clockView?.start()
    }

    fileprivate func initClockView() {
        if clockView == nil {
            let view = ClockView.createFromNib()
            view.frame = clockContainer?.bounds ?? .zero            
            view.translatesAutoresizingMaskIntoConstraints = true
            clockContainer?.addSubview(view)
            clockView = view
            clockView?.scale = 0.7
        }
    }
    
    
}

