//
//  NotificationNames.swift
//  MemeMe
//
//  Created by Gregory White on 12/1/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct NotificationName {
    static let MemeWasAdded   =  Notification.Name(rawValue: "MemesManagerMemeWasAddedNotification")
    static let MemeWasDeleted =  Notification.Name(rawValue: "MemesManagerMemeWasDeletedNotification")
    static let MemeWasMoved   =  Notification.Name(rawValue: "MemesManagerMemeWasMovedNotification")
}
