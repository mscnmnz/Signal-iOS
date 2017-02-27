//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeFinder: NSObject {
    public let TAG = "[ExperienceUpgradeFinder]"

    // Keep these ordered by increasing uniqueId.
    private var allExperienceUpgrades = [ExperienceUpgrade(uniqueId: "001",
                                                           title: NSLocalizedString("UPGRADE_EXPERIENCE_VIDEO_TITLE", comment: "Header for upgrade experience"),
                                                           body: NSLocalizedString("UPGRADE_EXPERIENCE_VIDEO_DESCRIPTION", comment: "Description of video calling experience to upgrading (existing) users"))]
    // MARK: - Dependencies

    private let storageManager: TSStorageManager

    // MARK: - Initializer

    init(storageManager: TSStorageManager) {
        self.storageManager = storageManager
    }

    // MARK: - Instance Methods

    public func firstUnseen() -> ExperienceUpgrade? {
        for experienceUpgrade in allExperienceUpgrades {
            let previouslySeen = ExperienceUpgrade.fetch(withUniqueID: experienceUpgrade.uniqueId)
            if previouslySeen == nil {
                Logger.info("\(TAG) Found unseen experience upgrade: \(experienceUpgrade)")
                return experienceUpgrade
            }
        }
        Logger.debug("\(TAG) No unseen experience upgrades.")
        return nil
    }

    public func markAllAsSeen(transaction: YapDatabaseReadWriteTransaction) {
        Logger.info("\(TAG) skipping experience upgrades for new user")
        for experienceUpgrade in allExperienceUpgrades {
            experienceUpgrade.save(with: transaction)
        }
    }
}
