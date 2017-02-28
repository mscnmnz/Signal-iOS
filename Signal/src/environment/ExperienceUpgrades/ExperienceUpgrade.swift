//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgrade: TSYapDatabaseObject {
    let title: String
    let body: String
    let image: UIImage
    var seenAt: Date?

    required init(uniqueId: String, title: String, body: String, image: UIImage) {
        // TODO don't persist image, (or title and body?)
        self.title = title
        self.body = body
        self.image  = image
        super.init(uniqueId: uniqueId)
    }

    override required init(uniqueId: String) {
        self.title = "New Feature"
        self.body = "Bug fixes and performance improvements."
        self.image = #imageLiteral(resourceName: "video_calling_splash1")
        super.init(uniqueId: uniqueId)
    }
    
    required init!(coder: NSCoder!) {
        self.title = "New Feature"
        self.body = "Bug fixes and performance improvements."
        self.image = #imageLiteral(resourceName: "video_calling_splash1")
        super.init(coder: coder)
    }
    
    required init(dictionary dictionaryValue: [AnyHashable : Any]!) throws {
        self.title = "New Feature"
        self.body = "Bug fixes and performance improvements."
        self.image = #imageLiteral(resourceName: "video_calling_splash1")
        try super.init(dictionary: dictionaryValue)
    }

    func markAsSeen(transaction: YapDatabaseReadWriteTransaction) {
        self.seenAt = Date()
        super.save(with: transaction)
    }
}
