# Rove AdService

A simple Ad Service for iOS to deliver custom ads to users on your application. 

## Getting Started

The Ad Service requires you to have an endpoint which returns a webpage containing the advertisment.


### Installing

Copy the project's classes to your own project.




For interstellar Ad create an AdService object and pass in the main view of the View Controller.

## For example
```
let service = AdService(type: .Banner,adCacheTime: 30 , screenName: "Example Class", view: self.view, delegate: self)
```

For Banner Ad
Create a UIView object and place it in your desired location. Create an AdService object passing in the ad banner view object.

## For example
```
let adBanner = UIView()
let service = AdService(type: .Banner, adCacheTime: 30 ,  screenName: "Example Class", view: adBanner, delegate: self)
```

Once the object is created simply call service.load() to load the advertisment from the server. 


To show the ad once its loaded simply call the following function 
```
  func adDidLoad(_ service: AdService) {
        service.showAd()
    }
```    

## Built With

* SWIFT


## Authors

* Hassan Abbasi


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Inspired by Google Ad Service. 
