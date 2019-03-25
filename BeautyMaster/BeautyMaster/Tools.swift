//
//  Tools.swift
//  Doufu
//
//  Created by 鑫翼資訊 on 2019/3/10.
//  Copyright © 2019 SinyiTech. All rights reserved.
//

import Foundation
import UIKit

func getOutermostView(sourceView:UIView) -> UIView {
    var superView:UIView? = sourceView
    while (superView!.superview != nil) {
        superView = superView!.superview
    }
    return superView!
}

func getViewOfAbsoluteFame(sourceView:UIView) -> CGRect {
    
    var originX:CGFloat = 0
    var originY:CGFloat = 0
    originX = originX + sourceView.frame.origin.x
    originY = originY + sourceView.frame.origin.y
    var superView = sourceView.superview
    while (superView != nil) {
        if superView is UIScrollView {
            originY = originY - (superView as! UIScrollView).contentOffset.y
        }
        originX = originX + superView!.frame.origin.x
        originY = originY + superView!.frame.origin.y
        superView = superView!.superview
    }
    return CGRect(x: originX, y: originY, width: sourceView.frame.size.width, height: sourceView.frame.size.height)
    
}

func startIndicator(vc:UIViewController, contentView:UIView, callback: @escaping (UIView) -> Void) {
    DispatchQueue.main.async {
        
        let indicatorContentView:UIView? = UIView()
        indicatorContentView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        indicatorContentView!.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(indicatorContentView!)
        let topCons = NSLayoutConstraint(item: indicatorContentView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomCons = NSLayoutConstraint(item: indicatorContentView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadCons = NSLayoutConstraint(item: indicatorContentView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailCons = NSLayoutConstraint(item: indicatorContentView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0)
        contentView.addConstraints([topCons,bottomCons,leadCons,trailCons])
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorContentView!.addSubview(indicatorView)
        let centerXCons = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: indicatorContentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerYCons = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: indicatorContentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        indicatorContentView!.addConstraints([centerXCons,centerYCons])
        
        let cancelBtn = UIButton()
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.backgroundColor = UIColor.clear
        indicatorView.addSubview(cancelBtn)
        let topCons1 = NSLayoutConstraint(item: cancelBtn, attribute: .top, relatedBy: .equal, toItem: indicatorContentView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomCons1 = NSLayoutConstraint(item: cancelBtn, attribute: .bottom, relatedBy: .equal, toItem: indicatorContentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadCons1 = NSLayoutConstraint(item: cancelBtn, attribute: .leading, relatedBy: .equal, toItem: indicatorContentView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailCons1 = NSLayoutConstraint(item: cancelBtn, attribute: .trailing, relatedBy: .equal, toItem: indicatorContentView, attribute: .trailing, multiplier: 1.0, constant: 0)
        indicatorContentView!.addConstraints([topCons1,bottomCons1,leadCons1,trailCons1])
        cancelBtn.addTargetClosure(closure: { (sender) in
            DispatchQueue.main.async {
                if (indicatorContentView != nil) {
                    indicatorContentView!.removeFromSuperview()
                }
            }
        })
        indicatorView.startAnimating()
        
        callback(indicatorContentView!)
    }
}

func stopIndicator(indicatorView:UIView?, callback: @escaping () -> Void) {
    DispatchQueue.main.async {
        if (indicatorView != nil) {
            indicatorView!.removeFromSuperview()
        }
        callback()
    }
}

func matchPattern(input: String, pattern:String) -> Bool {
    
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
        return regex.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)).count > 0
    } else {
        return false
    }
    
}

func resizeImageLimited(image: UIImage, limitedSize: CGFloat) -> UIImage {
    
    let size = image.size
    if (size.width < limitedSize && size.height < limitedSize) {
        return image
    } else {
        var targetWidth:CGFloat = 0
        var targetHeight:CGFloat = 0
        if (size.width > size.height) {
            targetWidth = limitedSize
            targetHeight = limitedSize * size.height / size.width
        } else {
            targetHeight = limitedSize
            targetWidth = limitedSize * size.width / size.height
        }
        
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let rect = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        var newImage = UIImage()
        if let newImageTemp = UIGraphicsGetImageFromCurrentImageContext() {
            newImage = newImageTemp
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

func httpConnect(url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ runStatus:Int, _ headers:[String:String], _ data:Data, _ error:String) -> Void) {
    
    var request = URLRequest(url: URL(string: url)!)

    do {
        if type == "GET" {
            
        } else if type == "POST"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        } else if type == "PUT"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        } else if type == "DELETE"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        }
    } catch let error{
        print("http type \(error)")
    }
    
    request.httpMethod = type
    
    for i in 0..<Array(headers.keys).count {
        request.setValue(Array(headers.values)[i], forHTTPHeaderField: Array(headers.keys)[i])
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest){
        (data, response, error) -> Void in
        
        if error != nil {
            callback(999, [String:String](), Data(), error!.localizedDescription)
        } else {
            
            let httpResponse = response as! HTTPURLResponse
            let resultStatus = httpResponse.statusCode
            let responseHeaders = httpResponse.allHeaderFields
            var resultHeaders = [String:String]()
            for i in 0..<Array(responseHeaders.keys).count {
                if let headerKey = Array(responseHeaders.keys)[i] as? String {
                    if let headerValue = Array(responseHeaders.values)[i] as? String {
                        resultHeaders[headerKey] = headerValue
                    }
                }
            }
            var resultData:Data = Data()
            if (data != nil) {
                resultData = data!
            }
            
            callback(resultStatus, resultHeaders, resultData, "")
            
        }
    }
    
    task.resume()
}

func downloadImage(url: String, callback: @escaping (UIImage?) -> Void) {
    httpConnect(url: url, type: "GET", headers: [String:String](), uploadDic: nil) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            if (resultStatus == 200) {
                callback(UIImage(data: resultData))
            } else {
                callback(nil)
            }
        }
    }
}

func downloadJasonDataAsDictionary(url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ runStatus:Int, _ headers:[String:String], _ dataDic:[String:Any], _ error:String) -> Void) {
    httpConnect(url: url, type: type, headers: [String:String](), uploadDic: uploadDic) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            do {
                if let resultDic = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, resultDic, errorString)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, [String:Any](), errorString)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    callback(resultStatus, resultHeaders, [String:Any](), errorString)
                }
            }
        }
    }
}

func downloadJasonDataAsArray(url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ runStatus:Int, _ headers:[String:String], _ dataArray:[Any], _ error:String) -> Void) {
    httpConnect(url: url, type: type, headers: [String:String](), uploadDic: uploadDic) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            do {
                if let resultArray = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any] {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, resultArray, errorString)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, [Any](), errorString)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    callback(resultStatus, resultHeaders, [Any](), errorString)
                }
            }
        }
    }
}

func backToViewController(currentVC:UIViewController, backToVC:String) {
    var pvc:UIViewController = currentVC
    while (pvc.presentingViewController != nil) {
        pvc = pvc.presentingViewController!
        if (String(describing: pvc) == backToVC) {
            break
        }
    }
    pvc.dismiss(animated: false, completion: nil)
}
