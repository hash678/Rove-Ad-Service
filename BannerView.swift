//
//  BannerView.swift
//  MyPastPapers
//
//  Created by Hassan Abbasi on 30/11/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class BannerView:AdView{

    
  override func setupViews(){
      
         
         self.addSubview(webView)
         webView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
         webView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
         webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
         webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
     }
    
    
}
