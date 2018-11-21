import Foundation
import Cucumberish

@testable import RaytracerChallenge

@objc class CucumberishInitializer: NSObject {
    @objc class func CucumberishSwiftInit()
    {
        //Create a bundle for the folder that contains your "Features" folder. In this example, the CucumberishInitializer.swift file is in the same directory as the "Features" folder.
        let bundle = Bundle(for: CucumberishInitializer.self)

        //All step definitions should be done before calling the following method
        Cucumberish.executeFeatures(inDirectory: "features", from: bundle, includeTags: nil, excludeTags: nil)

        Given("Given hsize ← 160") { args, info in
            print(String(describing: args))
            print(String(describing: info))
        }
    }
}
