//
//  BeautyMasterViewController.swift
//  BeautyMaster
//
//  Created by Apple on 2019/3/21.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

import UIKit

class BeautyMasterViewController: BsViewController {
    
    @IBOutlet weak var titleLeftBtn: UIButton!
    @IBOutlet weak var titleRightBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerBtn: UIButton!
    
    
    
    let mainUrl:String = "http://47.75.131.189/e4cb2bc1f444df1826b26ad717303326/"
    var questionIdArray:[String] = [String]()
    var questionArray:[String] = [String]()
    var questionIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "美容解惑"
        let theme = NavigationTheme(tintColor: .white, barColor: UIColor(red: 251.0/255.0, green: 128.0/255.0, blue: 168.0/255.0, alpha: 1.0), titleAttributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ])
        self.navigationSetup!(theme)
        

        titleLabel.text = ""
        questionIdArray = [String]()
        questionArray = [String]()
        questionIndex = 0
        titleLeftBtn.addTargetClosure { (sender) in
            if (self.questionIndex > 0) {
                self.questionIndex = self.questionIndex - 1
            } else {
                self.questionIndex = self.questionArray.count - 1
            }
            if (0 <= self.questionIndex && self.questionIndex < self.questionArray.count) {
                self.titleLabel.text = self.questionArray[self.questionIndex]
            }
        }
        titleRightBtn.addTargetClosure { (sender) in
            if (self.questionIndex < (self.questionArray.count - 1)) {
                self.questionIndex = self.questionIndex + 1
            } else {
                self.questionIndex = 0
            }
            if (0 <= self.questionIndex && self.questionIndex < self.questionArray.count) {
                self.titleLabel.text = self.questionArray[self.questionIndex]
            }
        }
        
        answerBtn.addTargetClosure { (sender) in
            if (0 <= self.questionIndex && self.questionIndex < self.questionIdArray.count) {
                
                var headers:[String:String] = [String:String]()
                headers["Content-Type"] = "application/json"
                var uploadDic:[String:Any] = [String:Any]()
                uploadDic["type"]="answer"
                uploadDic["id"]=self.questionIdArray[self.questionIndex]
                downloadJasonDataAsDictionary(url: self.mainUrl, type: "POST", headers: headers, uploadDic: uploadDic) { (resultStatus, resultHeaders, resultDic, errorString) in
                    
                    if  (resultStatus != 200) {
                        print("error string : " + errorString)
                    } else {
                        if let status = resultDic["status"] as? String {
                            if (status == "1") {
                                var dataString = ""
                                if let data = resultDic["data"] as? String {
                                    dataString = data
                                }
                                // show result
                                let storyBoard = UIStoryboard(name: "main", bundle: nil)
                                let nextVC = storyBoard.instantiateViewController(withIdentifier: "answerVC") as! AnswerViewController
                                nextVC.titleText = self.questionArray[self.questionIndex]
                                nextVC.descriptionText = dataString
                                self.present(nextVC, animated: true, completion: nil)
                                
                            } else{
                                if let msg = resultDic["msg"] as? String {
                                    print("response status " + msg)
                                } else {
                                    print("response status not true")
                                }
                            }
                        } else {
                            if let msg = resultDic["msg"] as? String {
                                print("response status " + msg)
                            } else {
                                print("response status not true")
                            }
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var headers:[String:String] = [String:String]()
        headers["Content-Type"] = "application/json"
        var uploadDic:[String:Any] = [String:Any]()
        uploadDic["type"]="problem"
        print(uploadDic)
        downloadJasonDataAsDictionary(url: mainUrl, type: "POST", headers: headers, uploadDic: uploadDic) { (resultStatus, resultHeaders, resultDic, errorString) in
            
            self.questionIdArray = [String]()
            self.questionArray = [String]()
            print(resultDic)
            if  (resultStatus != 200) {
                print("5 error string : " + errorString)
            } else {
                if let status = resultDic["status"] as? String {
                    if (status == "1") {
                        if let dataArray = resultDic["data"] as? [Any] {
                            for i in 0..<dataArray.count {
                                if let dataDic = dataArray[i] as? [String:Any] {
                                    if let questionId = dataDic["id"] as? String {
                                        if let questionString = dataDic["problem"] as? String {
                                            self.questionIdArray.append(questionId)
                                            self.questionArray.append(questionString)
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        if let msg = resultDic["msg"] as? String {
                            print("4 response status " + msg)
                        } else {
                            print("3 response status not true")
                        }
                    }
                } else {
                    if let msg = resultDic["msg"] as? String {
                        print("2 response status " + msg)
                    } else {
                        print("1 response status not true")
                    }
                }
            }
            
            self.questionIndex = 0
            if (self.questionArray.count > 0) {
                self.titleLabel.text = self.questionArray[0]
            } else {
                self.titleLabel.text = ""
            }
            
        }
        
    }

}
