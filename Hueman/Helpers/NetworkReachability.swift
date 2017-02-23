//
//  NetworkReachability.swift
//  Hueman
//
//  Created by Efthemios Prime on 2/22/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import SystemConfiguration

struct NetworkNotification {
    static let flagsChanged = "FlagsChanged"
}

class NetworkReachability {
    var hostname: String?
    var isRunning: Bool = false
    var isReachableOnWWAN: Bool  = false
    var networkReachability: SCNetworkReachability?
    var networkReachabilityFlags = SCNetworkReachabilityFlags()
    let reachabilitySerialQueue = dispatch_queue_create("reachabilitySerialQueue", DISPATCH_QUEUE_SERIAL)
    init(networkReachability: SCNetworkReachability) {
        self.networkReachability = networkReachability
        isReachableOnWWAN = true
    }
    init?(hostname: String) throws {
        guard let networkReachability = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            throw ReachabilityError.failedToCreateWith(hostname)
        }
        self.networkReachability = networkReachability
        self.hostname = hostname
        isReachableOnWWAN = true
    }
    init?() throws {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let networkReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { throw ReachabilityError.failedToInitializeWith(zeroAddress) }
        self.networkReachability = networkReachability
        isReachableOnWWAN = true
    }
    var networkStatus: NetworkStatus {
        return  !isConnectedToNetwork ? .unreachable :
            isReachableViaWiFi    ? .wifi :
            isRunningOnDevice     ? .wwan : .unreachable
    }
    var isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }()
    deinit { stop() }
}

extension NetworkReachability {
    func start() throws {
        guard let networkReachability = networkReachability  where !isRunning else { return }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutablePointer(Unmanaged.passUnretained(self).toOpaque())
        guard SCNetworkReachabilitySetCallback(networkReachability, callout, &context) else {
            stop()
            throw ReachabilityError.failedToSetCallout
        }
        guard SCNetworkReachabilitySetDispatchQueue(networkReachability, reachabilitySerialQueue) else {
            stop()
            throw ReachabilityError.failedToSetDispatchQueue
        }
        dispatch_async(reachabilitySerialQueue) { self.flagsChanged() }
        isRunning = true
    }
    func stop() {
        defer { isRunning = false }
        guard let networkReachability = networkReachability else { return }
        SCNetworkReachabilitySetCallback(networkReachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(networkReachability, nil)
        self.networkReachability = nil
    }
    var isConnectedToNetwork: Bool {
        return  isReachable &&
            !isConnectionRequiredAndTransientConnection &&
            !(isRunningOnDevice && isWWAN && !isReachableOnWWAN)
    }
    var isReachableViaWiFi: Bool {
        return  isReachable && isRunningOnDevice && !isWWAN
    }
    var flags: SCNetworkReachabilityFlags? {
        guard let networkReachability = networkReachability else { return nil }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(&flags) { SCNetworkReachabilityGetFlags(networkReachability, UnsafeMutablePointer($0)) } ? flags : nil
    }
    func flagsChanged() {
        guard let flags = flags where networkReachabilityFlags != flags else { return }
        networkReachabilityFlags = flags
        NSNotificationCenter.defaultCenter().postNotificationName(NetworkNotification.flagsChanged, object: self)
    }
    var transientConnection:    Bool { return flags?.contains(.TransientConnection) == true }
    var connectionRequired:     Bool { return flags?.contains(.ConnectionRequired) == true }
    var connectionOnTraffic:    Bool { return flags?.contains(.ConnectionOnTraffic) == true }
    var interventionRequired:   Bool { return flags?.contains(.InterventionRequired) == true }
    var connectionOnDemand:     Bool { return flags?.contains(.ConnectionOnDemand) == true }
    var isLocalAddress:         Bool { return flags?.contains(.IsLocalAddress) == true }
    var isDirect:               Bool { return flags?.contains(.IsDirect) == true }
    var isWWAN:                 Bool { return flags?.contains(.IsWWAN) == true }
    var isReachable:            Bool { return flags?.contains(.Reachable) == true }
    
    var isConnectionRequiredAndTransientConnection: Bool {
        return flags?.intersect([.ConnectionRequired, .TransientConnection]) == [.ConnectionRequired, .TransientConnection]
    }
}
func callout(reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutablePointer<Void>) {
    dispatch_async(dispatch_get_main_queue()) {
        Unmanaged<NetworkReachability>.fromOpaque(COpaquePointer(info)).takeUnretainedValue().flagsChanged()
    }
}
enum ReachabilityError: ErrorType {
    case failedToSetCallout
    case failedToSetDispatchQueue
    case failedToCreateWith(String)
    case failedToInitializeWith(sockaddr_in)
}
enum NetworkStatus: String {
    case unreachable, wifi, wwan
}
extension NetworkStatus: CustomStringConvertible {
    var description: String { return rawValue }
}
