//
//  SearchViewController.swift
//  SeSAC_WEEK5_CLASS
//
//  Created by 지성 on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {

    var movieData: [String] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchMovieData()
    }
    
    //** 수업에서 한 것 따라 만들어보기 **
    //** 네이버 api 등록했을때 네이버 검색을 영화로 이름 잘못지어서 시간 엄청 걸림...
    //네이버 영화 네트워크 통신
    func fetchMovieData() {
        
        //네이버 영화 API 호출해서 Debug 결과  찍기!!
        
        //인코딩작업을 위한 메서드. 여기서 상수에 담아둔 query의 타입은 옵셔널 스트링 타입으로 되어있기 때문에 해제 작업이 필요하고, if let이라는 옵셔널 바인딩 통해서 처리하거나, 가드 구문을 통해서 처리해야한다.
        if let query = "스파이더맨".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=15&start=16"
            
            
            let header: HTTPHeaders = [
                "X-Naver-Client-Id": "Qjuv3orpkNVFk9Bu4TeY",
                "X-Naver-Client-Secret": "R_tS3uD9li"
            ]
            
            AF.request(url, method: .get, headers: header).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
//                    let title = json["items"][0]["title"].stringValue.  <-이건 일반적인 경우
                 //하나씩 다 가져오는 것을 편하게 하려면 반복문을 사용하라고 알려주심.
                    
                    for item in json["items"].arrayValue {  //옵셔널을 처리하기 싫어서 arrayValue를 사용한거랑 in 뒤에 부분에서 숫자가 아닌데 반복문이 된 것이 이해가 안됨..
                        
                        let value = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                        self.movieData.append(value)    //위에서 문자열 배열이 담긴 변수를 하나를 축약형으로 선언했었음
                        
                        
                    }
                    
                    // ** 굉장히 중요한 부분이라고 알려주셨었음! **
                    self.tableView.reloadData()
                    print(self.movieData)
                    
                case .failure(let error):
                    print(error)
                }
        
        
            }
        }
    }


}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movieData.count, #function)
        return movieData.count //movieData 배열로 선언을 했기 때문에 하나의 섹션에 보이는 셀의 갯수를 movieData의 갯수로 처리
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.lbl1.text = movieData[indexPath.row] // 셀에 있는 레이블에 글씨 출력하기
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
}
