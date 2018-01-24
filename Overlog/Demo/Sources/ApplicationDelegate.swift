//
//  ApplicationDelegate.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import Overlog

/// Entry point for the application.
@UIApplicationMain fileprivate final class ApplicationDelegate: UIResponder, UIApplicationDelegate {

	// MARK: Properties

	/// - SeeAlso: UIApplicationDelegate.window
	@objc(window) fileprivate lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

	// MARK: UIApplicationDelegate

	/// - SeeAlso: UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)
	fileprivate func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		window!.rootViewController = UINavigationController(rootViewController: ViewController())
		window!.makeKeyAndVisible()

		Overlog.shared.configuration.features = FeatureType.all
		Overlog.shared.configuration.keychainIdentifier = "com.name.overlog.keychain"
		Overlog.shared.show(in: window!)

		return true

	}

}
