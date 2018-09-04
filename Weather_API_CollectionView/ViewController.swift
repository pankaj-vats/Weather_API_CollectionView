//
//  ViewController.swift
//  Weather_API_CollectionView
//
//  Created by pankaj vats on 19/07/18.
//  Copyright © 2018 pankaj vats. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , apiManagerDelegate {
    
    @IBOutlet weak var collectionView: Weather_CV!
    
    var tempArray = [Double]()
    var humidityArray = [Int]()
    var cloudsArray = [Int]()
    var rainArray = [String]()
    var weatherArray = [String]()
    var dateArray = [String]()
    
    var apiManager : ApiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        
        apiManager = ApiManager()
        apiManager.delegate = self
        
        WeatherCall()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Weather_CVC", for: indexPath) as! Weather_CVC
        
        cell.TempLbl.text = String(tempArray[indexPath.row])
        cell.humidityLbl.text = String(humidityArray[indexPath.row])
        cell.cloudsLbl.text = String(cloudsArray[indexPath.row])
        cell.RainLbl.text = String(rainArray[indexPath.row])
        cell.WetherLbl.text = String(weatherArray[indexPath.row])
        
        
//     TO REMOVE TIME
        
        let date = dateArray[indexPath.row]
        print(date)
        if let index = date.range(of: " ")?.lowerBound
        {
            let substring = date[..<index]
            let string = String(substring)
       
            cell.dateLbl.text  = string
      
        }
//         = dateArray[indexPath.row]
        
        return cell
    }
    
    func WeatherCall()
    {
        apiManager.Weather_ApiCall()
    }
    
    func apiSuccessResponse(_ response : NSDictionary)
    {
        
        if let room = response as? NSDictionary
        {
            
            let States : NSArray = room.value(forKey: "list") as! NSArray
            for states in States
            {
                
                if let state = states as? NSDictionary
                {
                    
                    if let track = state.value(forKey: "dt_txt")
                    {
                        self.dateArray.append(track as! String)
                    }
                    if let main : NSDictionary = state.value(forKey: "main") as! NSDictionary
                    {
                        if  let humidity = main.value(forKey: "humidity")
                        {
                            self.humidityArray.append(humidity as! Int)
                            
                        }
                        if let temp = main.value(forKey: "temp")
                        {
                            self.tempArray.append(temp as! Double)
                        }
                        
                    }
                    
                    if let main : NSDictionary = state.value(forKey: "clouds") as! NSDictionary
                    {
                        if  let all = main.value(forKey: "all")
                        {
                            self.cloudsArray.append(all as! Int)
                            
                        }
                    }
                    
                    let weathers : NSArray = state.value(forKey: "weather") as! NSArray
                    for weather in weathers
                    {
                        if let Weather = weather as? NSDictionary
                        {
                            
                            if  let Rain = Weather.value(forKey: "description")
                            {
                                self.rainArray.append(Rain as! String)
                            }
                            
                            if  let Main = Weather.value(forKey: "main")
                            {
                                self.weatherArray.append(Main as! String)
                            }
                        }
                    }
                }
                
            }
            
            //        TO RELOAD DATA IN TABLEVIEW
            
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
            
        }
    }
    
}


