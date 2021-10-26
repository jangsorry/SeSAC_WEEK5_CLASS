//
//  ViewController.swift
//  SeSAC_WEEK5_CLASS
//
//  Created by 지성 on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ViewController: UIViewController {

    
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentWeather()
    }
    
    func getCurrentWeather() {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6a1679c59d6730f2b8b929b2cbff32a"
        
        //json같은 경우는 보통 딕셔너리로 구성되어있다 -> [{key: Value}] 형태
        AF.request(url, method: .get).validate().responseJSON { response in // Alamofire가 AF로 버전업이 되면서 바뀜. 코드는 swiftyjason에서 가져옴
            switch response.result {
            case .success(let value):                  //let value <- 연관값
                
                let json = JSON(value)
                print("JSON: \(json)")
                
                let currentTemp = json["main"]["temp"].doubleValue - 273.5 //성공경우에 안 올 가능성은 거의 없기 때문에 옵셔널 타입이 아닌 doublevalue로 선택한 것 / - 273.5는 kelvin 온도라서 빼줌
                let humidity = json["main"]["humidity"].doubleValue
                let speed = json["wind"]["speed"].doubleValue
                
                print(currentTemp)
                self.currentTempLabel.text = "현재 온도 : \(Int(currentTemp))℃"
                self.windSpeedLabel.text = "현재 습도 : \(Int(humidity))"
                self.humidityLabel.text = "현재 풍속 : \(Int(speed))"
                
                //이미지뷰 영역. 왜 안나오지..?
                let weathericon = json["weather"]["icon"].stringValue
                let url = URL(string: "http://openweathermap.org/img/wn/\(weathericon)@2x.png")
                self.weatherImageView.kf.setImage(with: url)
                
                
                
                
            case .failure(let error):                   // 실패했을때
                print(error)
            }
        }
    }
    
    
   
       
        
       
    }



