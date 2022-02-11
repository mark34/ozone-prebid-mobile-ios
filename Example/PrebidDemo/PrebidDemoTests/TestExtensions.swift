/*   Copyright 2018-2021 Prebid.org, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit
@testable import PrebidMobile

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\", "\\\'", "\\\""]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
}

extension CacheManager {
    func testSave(content: String) -> String? {
        if content.isEmpty {
            return nil
        } else {
            let cacheId = "Prebid_" + UUID().uuidString
            self.savedValuesDict[cacheId] = content
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.savedValuesDict.removeValue(forKey: cacheId)
                self.delegate?.cacheExpired()
            })
            return cacheId
        }
    }
}

@objcMembers class MPNativeAdRequest: NSObject {
    var name: String!
    private(set) var p_customTargeting: MPNativeAdRequestTargeting

    var targeting: MPNativeAdRequestTargeting {
        get {
            return p_customTargeting
        }

        set {
            self.p_customTargeting = newValue
        }

    }

    override init() {
        self.p_customTargeting = MPNativeAdRequestTargeting()
    }
}

@objcMembers class MPNativeAdRequestTargeting: NSObject {
    var name: String!
    private(set) var p_customKeywords: String = ""

    var keywords: String {

        get {
            return p_customKeywords
        }

        set {
            self.p_customKeywords = newValue
        }
    }
}

@objcMembers class DFPNRequest: NSObject {
    var name: String!
    private(set) var p_customKeywords: [String: AnyObject]

    var customTargeting: [String: AnyObject] {

        get {
            return p_customKeywords
        }

        set {
            self.p_customKeywords = newValue
        }

    }

    override init() {
        self.p_customKeywords = [String: AnyObject]()
    }
}

@objcMembers class MPNativeAd: NSObject {
    
    var name: String!
    var p_customProperties: [String:AnyObject]

    var properties:  [String:AnyObject] {

        get {
            return p_customProperties
        }

        set {
            self.p_customProperties = newValue
        }

    }

    override init() {
        self.p_customProperties = [String:AnyObject]()
        self.p_customProperties["isPrebid"] = 1 as AnyObject
    }
}

class GADNativeCustomTemplateAd: UserDefaults {}
