//
//  AnswerViewController.swift
//  BeautyMaster
//
//  Created by Apple on 2019/3/22.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var displayMainView: UIView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    var titleText:String = ""
    var descriptionText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayMainView.layer.cornerRadius = 5
        displayMainView.clipsToBounds = true
        descriptionView.layer.cornerRadius = 5
        descriptionView.clipsToBounds = true
        closeBtn.layer.cornerRadius = 5
        closeBtn.clipsToBounds = true
        
        titleNameLabel.text = ""
        descriptionLabel.text = ""
        closeBtn.setTitle("关闭", for: UIControl.State.normal)
        
        closeBtn.addTargetClosure { (sender) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleNameLabel.text = titleText
        descriptionLabel.text = descriptionText
        
    }

}
