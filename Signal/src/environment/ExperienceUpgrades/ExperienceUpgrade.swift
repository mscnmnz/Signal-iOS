//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgrade: TSYapDatabaseObject {
    var title: String?
    var body: String?
    var seenAt: Date?

    required init(uniqueId: String, title: String, body: String) {
        self.title = title
        self.body = body
        super.init(uniqueId: uniqueId)
    }

    override required init(uniqueId: String) {
        super.init(uniqueId: uniqueId)
    }
    
    required init!(coder: NSCoder!) {
        super.init(coder: coder)
    }
    
    required init(dictionary dictionaryValue: [AnyHashable : Any]!) throws {
        try super.init(dictionary: dictionaryValue)
    }

    func markAsSeen(transaction: YapDatabaseReadWriteTransaction) {
        self.seenAt = Date()
        super.save(with: transaction)
    }
}
