//
//  SplitViewController.swift
//  UIRubik
//
//  Created by Михаил Фокин on 04.06.2021.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    @IBOutlet weak var settingVC: NSSplitViewItem!
    @IBOutlet weak var gameVC: NSSplitViewItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let left = settingVC.viewController as? SettingViewController {
            left.gameVC = gameVC.viewController as? GameViewController
        }
    }
    
}
