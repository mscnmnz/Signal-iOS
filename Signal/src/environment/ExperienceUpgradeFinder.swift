//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeFinder: NSObject {
    public let TAG = "[ExperienceUpgradeFinder]"

    // Keep these ordered by increasing uniqueId.
    private var allExperienceUpgrades = [ExperienceUpgrade(uniqueId: "z001",
                                                           title: NSLocalizedString("UPGRADE_EXPERIENCE_VIDEO_TITLE", comment: "Header for upgrade experience"),
                                                           body: NSLocalizedString("UPGRADE_EXPERIENCE_VIDEO_DESCRIPTION", comment: "Description of video calling to upgrading (existing) users"),
                                                           image: #imageLiteral(resourceName: "introductory_splash_video_calling") ),
                                         ExperienceUpgrade(uniqueId: "z002",
                                                           title: NSLocalizedString("UPGRADE_EXPERIENCE_CALLKIT_TITLE", comment: "Header for upgrade experience"),
                                                           body: NSLocalizedString("UPGRADE_EXPERIENCE_CALLKIT_DESCRIPTION", comment: "Description of CallKit to upgrading (existing) users"),
                                                           image: #imageLiteral(resourceName: "introductory_splash_callkit") )]

    // MARK: - Dependencies

    private let storageManager: TSStorageManager

    // MARK: - Initializer

    init(storageManager: TSStorageManager) {
        self.storageManager = storageManager
    }

    // MARK: - Instance Methods

    public func allUnseen(transaction: YapDatabaseReadTransaction) -> [ExperienceUpgrade] {
        return allExperienceUpgrades.filter { ExperienceUpgrade.fetch(withUniqueID: $0.uniqueId, transaction: transaction) == nil }
    }

    public func markAllAsSeen(transaction: YapDatabaseReadWriteTransaction) {
        Logger.info("\(TAG) skipping experience upgrades for new user")
        allExperienceUpgrades.forEach { $0.save(with: transaction) }
    }
}
