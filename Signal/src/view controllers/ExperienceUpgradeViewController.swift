//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeViewController: UIViewController {
    let TAG = "[ExperienceUpgradeViewController]"

    let experienceUpgrade: ExperienceUpgrade
    var hasConstraints = false

    var splashContainerView: UIView!
    var splashView: UIView!
    var titleLabel: UILabel!
    var bodyLabel: UILabel!
    var splashImageView: UIImageView!
    var nextButton: UIButton!
    var dismissButton: UIButton!

    // MARK: - Initializers
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

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        updateViewConstraints()
        addDismissGesture()
    }

    func addDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    func createViews() {
        // TODO transparent?
        view.backgroundColor = UIColor.ows_materialBlue()

        splashContainerView = UIView()
        view.addSubview(splashContainerView)
//        splashContainerView.backgroundColor = UIColor.ows_materialBlue()

        splashView = UIView()
        splashContainerView.addSubview(splashView)

        titleLabel = UILabel()
        splashView.addSubview(titleLabel)
        titleLabel.text = experienceUpgrade.title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.ows_lightFont(withSize:ScaleFromIPhone5To7Plus(26, 32))
        titleLabel.textColor = UIColor.white
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true;

        bodyLabel = UILabel()
        splashView.addSubview(bodyLabel)
        bodyLabel.text = experienceUpgrade.body
        bodyLabel.font = UIFont.ows_lightFont(withSize:ScaleFromIPhone5To7Plus(16, 18))
        bodyLabel.textColor = UIColor.white
        bodyLabel.numberOfLines = 0

        splashImageView = UIImageView(image:#imageLiteral(resourceName: "video_calling_splash1"))
        splashView.addSubview(splashImageView)
        splashImageView.contentMode = .scaleAspectFit

        nextButton = UIButton()
        splashView.addSubview(nextButton)
        nextButton.accessibilityLabel = NSLocalizedString("UPGRADE_CAROUSEL_NEXT_BUTTON", comment: "accessability label for slide")
        nextButton.setTitle("▸", for: .normal)
        nextButton.addTarget(self, action:#selector(didTapNextButton), for: .touchUpInside)

        dismissButton = UIButton()
        splashView.addSubview(dismissButton)
        dismissButton.setTitle(NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""),
                            for: .normal)
        dismissButton.addTarget(self, action:#selector(didTapDismissButton), for: .touchUpInside)

        // Debug
//        splashView.addRedBorderRecursively()
    }

    override func updateViewConstraints() {
        if !hasConstraints {
            hasConstraints = true

            splashContainerView.autoPinWidthToSuperview()
            splashContainerView.autoVCenterInSuperview()

            let containerPadding = ScaleFromIPhone5To7Plus(12, 18)
            splashView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: containerPadding,
                                                                       left: containerPadding,
                                                                       bottom: containerPadding,
                                                                       right: containerPadding))

            nextButton.autoPinEdge(toSuperviewEdge: .right)
            nextButton.autoAlignAxis(.vertical, toSameAxisOf: splashImageView)

            titleLabel.autoPinWidthToSuperview()
            titleLabel.autoPinEdge(toSuperviewEdge: .top)

            splashImageView.autoPinWidthToSuperview()
            splashImageView.autoSetDimension(.height, toSize: ScaleFromIPhone5To7Plus(200, 350))
            splashImageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset:containerPadding)

            bodyLabel.autoPinWidthToSuperview()
            bodyLabel.autoPinEdge(.top, to: .bottom, of: splashImageView, withOffset:containerPadding)

            dismissButton.autoPinWidthToSuperview()
            dismissButton.autoPinEdge(.top, to: .bottom, of: bodyLabel, withOffset:ScaleFromIPhone5(4) + containerPadding)
            dismissButton.autoPinEdge(toSuperviewEdge: .bottom, withInset:ScaleFromIPhone5(4))
        }

        super.updateViewConstraints()
    }

    // MARK: - Actions

    func didTapNextButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
    }

    func didTapDismissButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
        self.dismiss(animated: true)
    }

    func handleDismissGesture(sender: AnyObject) {
        Logger.debug("\(TAG) in \(#function)")
        self.dismiss(animated: true)
    }
}
