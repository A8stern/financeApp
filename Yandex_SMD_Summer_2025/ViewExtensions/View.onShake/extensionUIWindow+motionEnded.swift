//
//  extensionUIWindow+motionEnded.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 25.06.2025.
//

import UIKit

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}
