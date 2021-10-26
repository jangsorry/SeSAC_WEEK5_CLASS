//
//  TranslateViewController.swift
//  SeSAC_WEEK5_CLASS
//
//  Created by 지성 on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {

    
    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var targetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let header: HTTPHeaders = [                                   //HTTPHeaders는 타입을 맞춰주기 위해서 작성함.. 근데 String으로 해야하는 것 아니야..?
            "X-Naver-Client-Id": "TXr85OOlArkQUexAEIHX",
            "X-Naver-Client-Secret": "7Benzm87TZ"
        ]
        
        //번역할 내용이 들어가야하는데 이게 바디 -> prameters 내용. 인섬니아의 form에 있는 내용들 입력
        let parameters = [
            "source": "ko",
            "target": "en",
            "text": sourceTextView.text! //옵셔널은 일단은 강제해제
        ]
        
        //헤더가 옵셔널 타입인 이유는 헤더가 존재하지 않는 경우도 있기 때문에 매개변수가 생략되서 사용되는 것.
        /*
         인코드 같은 내용을 작성하지 않았는데, 디버그 영역에서 잘 나오는 이유는 보내는 과정에서 바디같은 경우는 url 인코디드가 된 상태로 넘겨지기 때문. 그래서 굳이 명시하지 않았는데도 작성이 되는 것.
         물론 url의 queryString으로 날릴때는 인코딩 작업을 직접해주어야 함.
         
         */
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in    //prameters가 headers보다 앞에 있어야 하나봄..?
            
            
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print("JSON: \(json)")
              
              //translatedText를 textView에 출력 - 시뮬레이터에서 마침표가 왜 나오지..?
                let translatorText = json["message"]["result"]["translatedText"].stringValue
                print(translatorText)
                self.targetTextView.text = "\(String(translatorText))"
            
            case .failure(let error):
                print(error)
            }
        }
    }
    


}
