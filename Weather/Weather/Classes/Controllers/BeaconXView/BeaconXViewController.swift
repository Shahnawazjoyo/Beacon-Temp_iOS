//
//  BeaconXViewController.swift
//  WeatherBeacon
//
//  Created by Shah Nawaz on 10/10/2020.
//  Copyright © 2020 Shah Nawaz. All rights reserved.
//

import UIKit
import CoreLocation
import MKBeaconXProSDK
import CoreFoundation

class BeaconXViewController: AbstractController ,MKBXPScanDelegate{
    
    
    var scanTimer : DispatchSourceTimer?
    var dataList:[MKScanBeaconModel] = []

    @IBOutlet weak var acStatusLbl: UILabel!
    @IBOutlet weak var acTempLbl: UILabel!
    @IBOutlet weak var roomTempLbl: UILabel!
    @IBOutlet weak var cityTempLbl: UILabel!
    
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var getLocationBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    var viewModel = BeaconxViewModel()
    var needScan = false
    var leftButton = UIButton()
    var acTempString = ""
    var outSideTemp:Int?
    private let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refreshData = true
        getLocationBtn.isHidden = true
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        let uiview = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        uiview.addSubview(leftButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: uiview)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.setCentralScanDelegate), name: Notification.Name("MKCentralDeallocNotification"), object: nil)
        setCentralScanDelegate()

    }
    
    @objc func leftClick() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if CLLocationManager.authorizationStatus() == .denied {
            getLocationBtn.isHidden = false
    
        }else {
            getLocationBtn.isHidden = true
        }
        
        if (self.needScan && MKBXPCentralManager.shared().managerState == .enable) {
            self.needScan = false
            self.leftButton.isSelected = false
            leftButtonMethod()
        }
    }
    
    func scanTimerRun() {
        if let timer  = scanTimer {
            timer.cancel()
            
        }
        MKBXPCentralManager.shared().startScanPeripheral()
        self.scanTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .default))
        //scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DispatchQueue.global(qos: .default))
        
        //Starting time
        let start = DispatchTime.now() + Double(60 * Double(NSEC_PER_SEC))
        //Intervals
        //let interval = UInt64(60 * Double(NSEC_PER_SEC))
        self.scanTimer?.schedule(deadline: start, repeating: .seconds(1))
        
        self.scanTimer?.setEventHandler(handler: {
            MKBXPCentralManager.shared().stopScanPeripheral()
        })

        scanTimer?.resume()
    }
    
    @objc
    func showCentralStatus()  { //MKBXPCentralManagerStateEnable
        if(UIDevice.current.systemVersion >= "11.0" && MKBXPCentralManager.shared().managerState != .enable){
            let alert = UIAlertController(title: "Dismiss", message: "The current system of bluetooth is not available!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "oK", style: .default) { (action) in
                
            }
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
        leftButtonMethod()
    }
    
    func leftButtonMethod() {
        if MKBXPCentralManager.shared().managerState != .enable {
            //view.showCentralToast("The current system of bluetooth is not available!")
            return
        }
        leftButton.isSelected = !leftButton.isSelected
        if !leftButton.isSelected {
            //Stop scanning
            MKBXPCentralManager.shared().stopScanPeripheral()
            if let timer =  self.scanTimer {
                timer.cancel()
        
            }
            return
        }
        dataList.removeAll()
        resetDevicesNum()
        scanTimerRun()
    }
    
    func rightButtonMethod() {
        
    }

    func resetDevicesNum()  {
        
    }
   
    
    @objc
    func setCentralScanDelegate()  {

        MKBXPCentralManager.shared().scanDelegate = self
        
    }
    

    override func customizeView() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }

   
    // fetch Weather  from network
    func fetchWeatherBeacons(cityNames: String) {
        viewModel.getWeatherBy(cityNames: cityNames) { (success, error) in
            if success {
                if self.viewModel.weathersList.count > 0 {
                    self.outSideTemp = Int(self.viewModel.weathersList[0].mainViewModel.temp)
                    self.cityTempLbl.text = "\(self.viewModel.weathersList[0].cityName) : \(Int(self.viewModel.weathersList[0].mainViewModel.temp))°C"
                }
                self.getLocationBtn.isHidden = true
            
            }else {
                self.getLocationBtn.isHidden = false
               
            }
        }
    }
    // Fetch current location
    func fetchMyLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled()
            {
                    locationManager.startUpdatingLocation()
                    locationManager.requestLocation()
            }
        }
    }
        
// Show alert, if user denied location permission.
    private func showLocationPermission() {
        let alert = UIAlertController(title:"ERROR_LOCATION_PERMISSION".localized, message: "ERROR_LOCATION_PERMISSION_MSG".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: {action in
        switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                break
            }}))
        alert.addAction(UIAlertAction(title: "SETTINGS".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
                
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
            })
            self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectDeviceClick(_ sender: Any) {
       

        if acTempString == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter Ac Temprature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")
                    
                  default:
                  break

            }}))
            self.present(alert, animated: true, completion: nil)
        }else{
          
            let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                self.showCentralStatus()
            }
        }
        
    }
    
    @IBAction func enterAcTempClick(_ sender: Any) {
        Presenter.shared.showAlert(style: .acTempInput, delegate: self)
    }
    
    @IBAction func getLocationClicked(_ sender: Any) {
        
        if CLLocationManager.authorizationStatus() == .denied {
            showLocationPermission()
        }else {
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    func bxp_didReceiveBeacon(_ beaconList: [MKBXPBaseBeacon]!) {
        
        for beacon in beaconList{
            updateDataWithBeacon(beacon: beacon)
        }
        
        
    }

    func updateDataWithBeacon(beacon: MKBXPBaseBeacon)  {
        
        if beacon.frameType == MKBXPDataFrameType.MKBXPDeviceInfoFrameType {
            return
        }
    
        self.processBeacon(beacon)
    }

    func processBeacon(_ beacon: MKBXPBaseBeacon?) {
        //Check whether the relevant equipment already exists in the data source
        let identy = beacon?.peripheral.identifier.uuidString
        deviceNameLbl.text =  beacon?.deviceName
     
        let lockQueue = DispatchQueue(label: "dataList")
        lockQueue.sync {
            //let predicate = NSPredicate(format: "identifier == %@", identy ?? "")
            let array = dataList.filter{$0.identifier == identy}
            if array.count > 0{
                let exsitModel = array[0]
                self.beaconExistDataSource(exsitModel: exsitModel, beacon: beacon!)
                return
            }
            self.beaconNoExistDataSource(beacon: beacon!)
        }
    }
    
    func beaconExistDataSource(exsitModel:MKScanBeaconModel,beacon:MKBXPBaseBeacon)  {
        
        if beacon.deviceName != "" {
            exsitModel.deviceName = beacon.deviceName
        }
        
        if exsitModel.lastScanDate != nil{
            //exsitModel.displayTime = String(format: "%@%ld%@", "<->", (kSystemTimeStamp.intValue - exsitModel.lastScanDate.intValue) * 1000, "ms")
            exsitModel.lastScanDate = Date().description
        }
        //MKBXPDeviceInfoFrameType
        if beacon.frameType == MKBXPDataFrameType.MKBXPDeviceInfoFrameType {
            //Device information frame
            exsitModel.infoBeacon = beacon as? MKBXPDeviceInfoBeacon
            
//            UIView.performWithoutAnimation({ [self] in
//                tableView.reloadSection(exsitModel.index, with: UITableView.RowAnimation.none)
//            })
            return
        }
        
        //If it is one of URL, TLM, UID, iBeacon，
        //If the eddStone frame array already contains this type of data, judge whether it is TLM, if it is TLM, directly replace the data in the array, if not, judge whether the broadcast content is the same, if it is the same, do not process it, if it is not the same, add it directly To frame array

        if let dataarray = exsitModel.dataArray {
            for model in dataarray{
                
                if model.advertiseData == beacon.advertiseData {
                    //If the broadcast content is the same, discard the data directly
                    return
                }
                if model.frameType == beacon.frameType && (beacon.frameType == MKBXPDataFrameType.MKBXPTLMFrameType || beacon.frameType == MKBXPDataFrameType.MKBXPTHSensorFrameType || beacon.frameType == MKBXPDataFrameType.MKBXPThreeASensorFrameType) {
                    //TLM information frame needs to be replaced
                    beacon.index(ofAccessibilityElement: model.index)
                    exsitModel.dataArray?.append(beacon)
                    //let temp = beacon.peripheral.temperatureHumidity.description
                    //self.checkAcStatus(acTemp: Int(acTempLbl.text), outSideTemp: outSideTemp, currentRoomTemp: temp, prevRoomTemp: UserDefaults.standard.integer(forKey: "TEMP"))
                    //exsitModel.dataArray[model.index] = beacon
                    return
                }
            }
        }
        
        //If the eddStone frame array does not contain the data, add it directly
        exsitModel.dataArray?.append(beacon)
        beacon.index(ofAccessibilityElement: exsitModel.dataArray!.count - 1)
        let tempArray = exsitModel.dataArray
//        let sortedArray = (tempArray as NSArray?)?.sortedArray(comparator: { p1, p2 in
//            if p1?.frameType > p2?.frameType {
//                return .orderedDescending
//            } else {
//                return .orderedAscending
//            }
//        })
        exsitModel.dataArray?.removeAll()
        
        for i in 1...tempArray!.count {
            let tempModel = tempArray?[i] as? MKBXPBaseBeacon
            tempModel?.index(ofAccessibilityElement: i)
            if let tempModel = tempModel {
                exsitModel.dataArray!.append(tempModel)
            }
        }
       // let set = NSIndexSet(index: exsitModel.getIndex())
//        UIView.performWithoutAnimation({ [self] in
//
//        })
    }

    func checkAcStatus(acTemp:Int,outSideTemp:Int,currentRoomTemp:Int, prevRoomTemp:Int)  {
        
        UserDefaults.standard.set(currentRoomTemp, forKey: "TEMP")
        if(currentRoomTemp < outSideTemp){
            
            if(currentRoomTemp > prevRoomTemp){
                acStatusLbl.text = "AC Not Working"
            }else if(currentRoomTemp < prevRoomTemp){
                acStatusLbl.text = "AC is Working"
            }else{
                if(currentRoomTemp == acTemp){
                    acStatusLbl.text = "AC is Working"
                }else{
                    acStatusLbl.text = "Maintained value of Temp"
                }
            }
        }else{
            acStatusLbl.text = "AC Not Working"
        }
    }
    func beaconNoExistDataSource(beacon: MKBXPBaseBeacon)  {
        
        let newModel =  MKScanBeaconModel()
        self.dataList.append(newModel)
        newModel.index = self.dataList.count - 1
        
        newModel.identifier = beacon.peripheral.identifier.uuidString
        newModel.rssi = beacon.rssi
        newModel.deviceName = beacon.deviceName
        newModel.displayTime = "N/A"
        newModel.lastScanDate = Date().description
        
        if beacon.frameType ==  MKBXPDataFrameType.MKBXPDeviceInfoFrameType {
            
            newModel.infoBeacon =  beacon as? MKBXPDeviceInfoBeacon
            //let set = NSIndexSet(index: self.dataList.count - 1)
           
        }else{
            newModel.dataArray?.append(beacon)
            //[newModel.dataArray addObject:beacon];
            //beacon.index(ofAccessibilityElement: 0)
            //beacon.index = 0;
            //let set = NSIndexSet(index: self.dataList.count - 1)
            
        }
        resetDevicesNum()
    }

}

extension BeaconXViewController: CustomAlertViewDelegate {
    func customAlertSecondButtonAction() {
        acTempString = Presenter.shared.acTemp
        self.acTempLbl.text = "\(Presenter.shared.acTemp)°C"
        
    }
}
// MARK: -
// MARK: CLLocationManagerDelegate
extension BeaconXViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
     
                    // new address, get by coords.
        viewModel.geocode(latitude: location.latitude, longitude: location.longitude) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            if let cityName = placemark.administrativeArea {
                self.fetchWeatherBeacons(cityNames: cityName)
            }
        }
        //stop updating location.
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            
            fetchMyLocation()
            break
        case .notDetermined, .denied:
            
            break
        default:
            break
        }
    }
    
    
}
