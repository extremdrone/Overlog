//
//  OverlayViewController.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

internal protocol OverlayViewControllerFlowDelegate: class {
    
    /// Tells the flow delegate that floating button has been tapped.
    ///
    /// - Parameters:
    ///   - sender: a button responsible for sending the action
    func didTapFloatingButton(with sender: UIButton)
}

internal final class OverlayViewController: UIViewController {
    
    /// A delegate responsible for sending flow controller callbacks
    internal weak var flowDelegate: OverlayViewControllerFlowDelegate?
    
    /// Handler of `.motionShake` motion event
    internal var didPerformShakeEvent: ((UIEvent?) -> Void)? = nil

    /// The initial center value of `OverlayView.floatingButton` during a drag gesture
    fileprivate var initialFloatingButtonCenter: CGPoint = .zero

    /// The initial delta between `OverlayView.floatingButton` center and its touch point during a drag gesture
    fileprivate var initialFloatingButtonCenterToTouchPointDelta: CGPoint = .zero
    
    /// The user defaults key for boolean value determining if it's a first launch of the app
    fileprivate let firstLaunchDefaultsKey = "OVLHasLaunchedOnce"
    
    /// Overlay view
    internal let overlayView = OverlayView()
    
    internal override func loadView() {
        view = overlayView
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.floatingButton.addTarget(
            self,
            action: #selector(didTapFloatingButton(button:)),
            for: .touchUpInside
        )
        
        let hasLaunchedOnce = UserDefaults.standard.bool(forKey: firstLaunchDefaultsKey)
        if !hasLaunchedOnce {
//            let availableFeatures = FeaturesDataSource().allItems.map { (value: Feature) -> FeatureType in
//                return value.type
//            }
//            for feature in availableFeatures {
//                UserDefaults.standard.set(true, forKey: feature.defaultsKey)
//            }
//            UserDefaults.standard.set(true, forKey: firstLaunchDefaultsKey)
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragFloatingButton(with:)))
        panGesture.maximumNumberOfTouches = 1
        overlayView.floatingButton.addGestureRecognizer(panGesture)
    }
        
    /// Overrides super method and calls `didPerformShakeEvent` closure when `.motionShake` was recevied. 
    /// Please refer to super method documentation for further information.
    ///
    /// - Parameters:
    ///   - motion: `UIEventSubtype`
    ///   - event: `UIEvent`
    internal override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            didPerformShakeEvent?(event)
        }
    }
    
}

// MARK: - Target actions

fileprivate extension OverlayViewController {

    /// Handle action on touch up inside on `floatingButton`
    ///
    /// - Parameter button: floating button instance
    @objc fileprivate func didTapFloatingButton(button: UIButton) {
        flowDelegate?.didTapFloatingButton(with: button)
    }

    /// Handle the pan gesture on `floatingButton`
    ///
    /// - Parameter recognizer: pan gesture recognizer instance
    @objc fileprivate func didDragFloatingButton(with recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			/// Calculate the initial button center value during the gesture
			initialFloatingButtonCenter = overlayView.floatingButton.center

			/// Calculate delta between the touch point and floating button center to eliminate button jumping and provide smoother experience
			let floatingButtonCenter = CGPoint(x: overlayView.floatingButton.frame.width / 2, y: overlayView.floatingButton.frame.height / 2)
			let touchPoint = recognizer.location(in: overlayView.floatingButton)
			initialFloatingButtonCenterToTouchPointDelta = CGPoint(x: floatingButtonCenter.x - touchPoint.x, y: floatingButtonCenter.y - touchPoint.y)
		case .ended, .changed:
			/// Update the `overlayView.floatingButton` center value with current finger position, include the delta
			let overlayTouchPoint = recognizer.location(in: overlayView)
			overlayView.floatingButton.center = CGPoint(x: overlayTouchPoint.x + initialFloatingButtonCenterToTouchPointDelta.x, y: overlayTouchPoint.y + initialFloatingButtonCenterToTouchPointDelta.y)
		case .cancelled, .failed:
			/// Bring back the initial button center if the gesture gets interrupted
			overlayView.floatingButton.center = initialFloatingButtonCenter
		default:
			break
		}
    }
    
}
