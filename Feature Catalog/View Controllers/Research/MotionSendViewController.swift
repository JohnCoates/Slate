//
//  MotionSendViewController
//  Created on 4/14/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit
import CFNetwork
import CoreMotion

class MotionSendViewController: UIViewController, StreamDelegate,
NetServiceBrowserDelegate, NetServiceDelegate {
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpButton()
        setUpStackView()
        start()
    }
    
    // MARK: - View Events

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stop()
    }
    
    let button = UIButton(type: .custom)
    private func setUpButton() {
        
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.centerXY --> view
    }
    
    let pitchLabel = UILabel()
    let yawLabel = UILabel()
    let rollLabel = UILabel()
    let orientationLabel = UILabel()
    private func setUpStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            pitchLabel,
            yawLabel,
            rollLabel,
            orientationLabel
            ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10,
                                               bottom: 10, right: 10)
        
        view.addSubview(stackView)
        
        stackView.bottom.pin(to: button.top, add: -15)
    }
    
    // MARK: - Start, Stop
    
    var orientation: UIInterfaceOrientation = .unknown

    func start() {
        RotationManager.updateInterval = 0.01
        RotationManager.shared.attitudeUpdated = { attitude in
            var motionData = MotionData()
           
            DispatchQueue.main.async {
                self.updateLabels(with: attitude)
            }
            
            let quaternion = attitude.quaternion
            motionData.x = quaternion.x
            motionData.y = quaternion.y
            motionData.z = quaternion.z
            motionData.w = quaternion.w
            let encoder = JSONEncoder()
            do {
                let json = try encoder.encode(motionData)
                self.send(data: json)
            } catch let error {
                print("Couldn't send data, error: \(error)")
            }
        }
        
        if let host = hostAddress {
            setUpStreams(host: host)
        } else {
            searchForHost()
        }
        
        RotationManager.beginOrientationEvents()
    }
    
    func updateLabels(with attitude: CMAttitude) {
        let pitch = RotationManager.degrees(radians: attitude.pitch)
        let yaw = RotationManager.degrees(radians: attitude.yaw)
        let roll = RotationManager.degrees(radians: attitude.roll)
        pitchLabel.text = "pitch: \(pitch)"
        yawLabel.text = "yaw: \(yaw)"
        rollLabel.text = "roll: \(roll)"
        orientation = RotationManager.newOrientation(from: self.orientation,
                                                     pitch: pitch,
                                                     yaw: yaw,
                                                     roll: roll)
        orientationLabel.text = self.orientation.description
    }
    
    func stop() {
        RotationManager.endOrientationEvents()
        inputStream?.close()
        outputStream?.close()
        inputStream = nil
        outputStream = nil
    }
    
    // MARK: - Streams
    
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func setUpStreams(host: String) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           host as CFString, 9845,
                                           &readStream,
                                           &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        guard let inputStream = inputStream, let outputStream = outputStream else {
            print("Failed to create streams")
            return
        }
        inputStream.delegate = self
        outputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .commonModes)
        outputStream.schedule(in: .current, forMode: .commonModes)
        inputStream.open()
        outputStream.open()
    }
    
    func send(data: Data) {
        guard let outputStream = outputStream else {
            return
        }
        _ = data.withUnsafeBytes {
            outputStream.write($0, maxLength: data.count)
        }
    }
    
    let maxReadLength = 4096
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .errorOccurred {
            inputStream = nil
            outputStream = nil
            print("Error: Stream error")
        } else if eventCode == .endEncountered {
            inputStream = nil
            outputStream = nil
            print("Error: Encountered end of stream")
        }
    }
    
    // MARK: - User Interaction
    
    @objc func buttonTapped() {
        stop()
        start()
    }
    
    // MARK: - Bonjour
    
    private let browser = NetServiceBrowser()
    var searching = false
    func searchForHost() {
        guard searching == false else {
            return
        }
        searching = true
        print("searching for host")
        browser.delegate = self
        browser.searchForServices(ofType: "_companion-link._tcp", inDomain: "local.")
    }
    
    private var hostService: NetService?
    private var hostAddress: String?
    
    func netServiceBrowser(_ browser: NetServiceBrowser,
                           didFind service: NetService, moreComing: Bool) {
        print("found service: \(service)")
        service.delegate = self
        service.resolve(withTimeout: 20)
        hostService = service
        browser.stop()
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addresses = sender.addresses else {
            return
        }
        
        for addressData in addresses {
            let addressPointer = addressData.withUnsafeBytes { (pointer: UnsafePointer<sockaddr_in>) in
                return pointer
            }
            let rawAddress = addressPointer.pointee
            
            // IPv4 only
            guard rawAddress.sin_family == AF_INET else {
                continue
            }
            var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            let result = addressData.withUnsafeBytes { (sockAddress: UnsafePointer<sockaddr>) in
                getnameinfo(sockAddress, socklen_t(addressData.count), &host,
                            socklen_t(host.count), nil, 0, NI_NUMERICHOST)
                
            }
            guard result == 0 else {
                return
            }
            guard hostAddress == nil else {
                return
            }
            let address = String(cString: host)
            hostAddress = address
            print("found host address: \(address)")
            setUpStreams(host: address)
        }

    }

}

// MARK: - Models

private struct MotionData: Codable {
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    var w: Double = 0
}
