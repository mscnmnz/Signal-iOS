//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeViewController: UIViewController {

    let experienceUpgrade: ExperienceUpgrade
    var hasConstraints = false
    var titleLabel: UILabel!
    var bodyLabel: UILabel!

    required init(experienceUpgrade: ExperienceUpgrade) {
        self.experienceUpgrade = experienceUpgrade
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message:"unavailable, use initWithExperienceUpgrade instead")
    required init?(coder aDecoder: NSCoder) {
        assert(false)
        // This should never happen, but so as not to explode we give some bogus data
        self.experienceUpgrade = ExperienceUpgrade(uniqueId: "unknown-experience-upgrade-id", title: "New Feature", body: "Bug fixes and performance improvements")
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        updateViewConstraints()
    }

    func createViews() {
        view.backgroundColor = UIColor.white

        titleLabel = UILabel()
        titleLabel.text = experienceUpgrade.title
        view.addSubview(titleLabel)

        bodyLabel = UILabel()
        bodyLabel.text = experienceUpgrade.body
        view.addSubview(bodyLabel)
    }

    override func updateViewConstraints() {
        if !hasConstraints {
            hasConstraints = true

            titleLabel.autoPinWidthToSuperview()
            titleLabel.autoVCenterInSuperview()

            bodyLabel.autoPinWidthToSuperview()
            bodyLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
        }

        super.updateViewConstraints()
    }
}
