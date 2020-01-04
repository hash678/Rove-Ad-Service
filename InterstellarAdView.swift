//
//  InterstellarAdView.swift
//  MyPastPapers
//
//  Created by Hassan Abbasi on 30/11/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class InterstellarAdView:AdView{
    
    var delegate:InterstellarProtocol?
    
    
    fileprivate var background:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0.9
        return v
    }()
    
  
    fileprivate var mainBox:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        
        return v
    }()
    
    fileprivate lazy var closeButton:UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "closeAdButton")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
  
   override func setupViews(){
        
        
        
        self.addSubview(background)
        background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        background.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
        
        self.addSubview(mainBox)
        mainBox.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.96).isActive = true
        mainBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        mainBox.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        self.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.topAnchor.constraint(equalTo: mainBox.topAnchor,constant: 15).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAd)))
        
        
        mainBox.addSubview(webView)
        webView.leftAnchor.constraint(equalTo: mainBox.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: mainBox.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor ,constant: 15).isActive = true
        webView.bottomAnchor.constraint(equalTo: mainBox.bottomAnchor).isActive = true
        
        
        
    
    }
    
    @objc fileprivate func closeAd(){
        print("close ad")
        delegate?.didCloseAd()
        self.removeFromSuperview()
    }
  
    func adAdtoView(mainView:UIView){
        mainView.addSubview(self)
        self.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
    
}



protocol InterstellarProtocol{
    func didCloseAd()
}

