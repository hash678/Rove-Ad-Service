//
//  AdService.swift
//  MyPastPapers
//
//  Created by Hassan Abbasi on 26/10/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit

class AdService{
    
    //fileprivate let adCache = NSCache<NSString, CustomAdCacheObject>()
    fileprivate let screenName:String!
    fileprivate var mainView:UIView!
    fileprivate let adType:ADType!
    fileprivate let adExpiryTimes = 1
    fileprivate var currentAd:AdView?
    fileprivate var adCacheTime:Int?
    var delegate:AdServiceProtocol?
    var data:Data?
    
    
    var type:ADType{
        return adType
    }
    
    init(){
        self.screenName = ""
        self.adCacheTime = 30
        self.mainView = UIView()
        self.adType = .Interstellar
    }
    
    
    
    init(type:ADType,screenName:String,adCacheTime:Int?,view:UIView,delegate:AdServiceProtocol){
        self.screenName = screenName
        self.adCacheTime = adCacheTime
        self.mainView = view
        self.adType = type
        self.delegate = delegate
        
        
    }
    
    
    func loadAd(){
           if let data = loadAdFromCache(forced: false) {
               adLoaded(data)
            return
           }
           
        
        
        if adType == .Banner{
        if let data = loadAdFromCache(forced: true) {
            adLoaded(data)
        }
        }
           
           loadAdFromServer { (data, error) in
               guard let data = data else{
                   if let data = self.loadAdFromCache(forced: true) {
                       self.adLoaded(data)
                             
                   }else{
                       self.delegate?.adFailedToLoad(error!)
                   }
                   return
               }
               
               self.adLoaded(data)
               
               
           }
           
           
           
       }
    
    
    func showAd(){
        
        
        if let ad  = currentAd {
            ad.loadAd(data: data!);

        }
        
        guard let data = data else{
            print("Ad object Data empty")
            return
        }

        if adType == .Interstellar {
             let currentWindow:UIWindow? = UIApplication.shared.keyWindow
            self.mainView = currentWindow == nil ? self.mainView : currentWindow
            
            
            
        let adView = InterstellarAdView()
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.loadAd(data: data)
        self.mainView.addSubview(adView)
        
        adView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        adView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        adView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        adView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
       
        adView.setupViews()
            
        }else{
            
            let adView = BannerView()
            adView.translatesAutoresizingMaskIntoConstraints = false
            adView.loadAd(data: data)
            self.mainView.addSubview(adView)
            adView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
            adView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
            adView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            adView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
            
        }
        
        print("Showing ad")
        
        
    }
    
    fileprivate func adLoaded(_ data:Data){
        
        if data != self.data {
        self.data = data
        self.delegate?.adDidLoad(self)
 
        }
        
    }
    
    fileprivate func saveAd(data:Data){
        //self.data = data
        let adObj = CustomAdObject(date: Date(), data: data)
        
        do {
        let saveData = try NSKeyedArchiver.archivedData(withRootObject: adObj, requiringSecureCoding: false)
        
        try DiskCacheService.shared.saveData(key:self.adCacheKey(type: self.adType),data:saveData)
        }catch {
            print("Ad Couldn't be saved")
        }
        //self.adCache.setObject(adObjCache, forKey: self.adCacheKey(type: self.adType) as NSString)
        print("AdSaved")
    }
    
    
    
   
    
    
    
    fileprivate func loadAdFromServer(completion:@escaping (Data?,Error?) -> Void){
    //TODO: Implement function to fetch ad from server.
    /**
    If the ad is loaded 
    completion(data,nil)
    if it fails
    completion(nil,yourError)
    **/
    }
    
    
    fileprivate func loadAdFromCache(forced:Bool) -> Data?{
       
        
        
        do{
        guard let adData = try DiskCacheService.shared.getData(key: self.adCacheKey(type: self.adType)) else {return nil}
        
        guard let adObj =  NSKeyedUnarchiver.unarchiveObject(with: adData) as? CustomAdObject else{return nil}
        
//        guard let adCacheObj = adCache.object(forKey: adCacheKey(type: adType) as NSString) else{return nil}
    
        
        print("Got saved ad")

        if forced{return adObj.data}
        
        
        
        if diffBetweenTimes(d1: adObj.date, d2: Date()) <= adCacheTime{
            return adObj.data}
            
            return nil
        }catch {
            print("Couldn't load ad from Memory")
        }
        return nil
    }
    
    
    fileprivate func diffBetweenTimes(d1:Date, d2:Date) -> Int{
        let cal = Calendar.current
        
        let components = cal.dateComponents([.minute], from: d2, to: d1)
        let diff = components.minute!
        return abs(diff)
    }
    
    fileprivate func adCacheKey(type:ADType) -> String{
        if type == .Interstellar{
            return "\(screenName ?? "")-Inter"
        }else{
            return "\(screenName ?? "")-Banner"
            
        }
    }
    
    
    fileprivate func saveToDisk(){
    }
}


extension AdService:InterstellarProtocol{
    func didCloseAd() {
        delegate?.interstellarAdClosed()
    }
    
    
}


protocol AdServiceProtocol{
    func adDidLoad(_ service:AdService)
    func adFailedToLoad(_ error:Error)
    func interstellarAdClosed()
    
}


extension AdServiceProtocol {

    func interstellarAdClosed() {
        print("Intersetllar Ad Closed")
    }
}

enum ADType:String{
    case Interstellar
    case Banner
}




class CustomAdObject: NSObject, NSCoding{
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: "data")
        coder.encode(date, forKey: "date")
    }
    
    required init?(coder: NSCoder) {
        self.data = coder.decodeObject(forKey: "data") as! Data
        self.date = coder.decodeObject(forKey: "date") as! Date
    }
    
    
    convenience init(data: Data, date: Date) {
          self.init(date:date,data:data)
          self.data = data
          self.date = date
      }
    
    var data:Data
    var date:Date
    
    
    init(date:Date,data:Data){
        self.date = date
        self.data = data
    }
}
