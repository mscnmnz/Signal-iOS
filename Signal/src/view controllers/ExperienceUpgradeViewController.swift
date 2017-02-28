//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeViewController: UIViewController {
    let TAG = "[ExperienceUpgradeViewController]"

    let experienceUpgrades: [ExperienceUpgrade]

    // MARK: - Initializers
    required init(experienceUpgrades: [ExperienceUpgrade]) {
        self.experienceUpgrades = experienceUpgrades
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message:"unavailable, use initWithExperienceUpgrade instead")
    required init?(coder aDecoder: NSCoder) {
        assert(false)
        // This should never happen, but so as not to explode we give some bogus data
        self.experienceUpgrades = [ExperienceUpgrade()]
        super.init(coder: aDecoder)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addDismissGesture()
    }

    func addDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    func buildSlideView(header: String, body: String, image: UIImage) -> UIView {
        let slideView = UIView()

        // Title label
        let titleLabel = UILabel()
        slideView.addSubview(titleLabel)
        titleLabel.text = header
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.ows_lightFont(withSize: ScaleFromIPhone5To7Plus(26, 32))
        titleLabel.textColor = UIColor.white
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true;

        // Title label layout
        titleLabel.autoPinWidthToSuperview()
        titleLabel.autoPinEdge(toSuperviewEdge: .top)

        // Body label
        let bodyLabel = UILabel()
        slideView.addSubview(bodyLabel)
        bodyLabel.text = body
        bodyLabel.font = UIFont.ows_lightFont(withSize: ScaleFromIPhone5To7Plus(16, 18))
        bodyLabel.textColor = UIColor.white
        bodyLabel.numberOfLines = 0

        // Body label layout
        bodyLabel.autoPinWidthToSuperview()

        // Image
        let imageView = UIImageView(image: image)
        slideView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        // Image layout
        imageView.autoPinWidthToSuperview()
        imageView.autoSetDimension(.height, toSize: ScaleFromIPhone5To7Plus(200, 350))
        imageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: ScaleFromIPhone5To7Plus(10, 14))
        imageView.autoPinEdge(.bottom, to: .top, of: bodyLabel, withOffset: ScaleFromIPhone5To7Plus(10, 14))

        return slideView
    }

    override func loadView() {
        self.view = UIView()
        view.backgroundColor = UIColor.ows_materialBlue()

        let splashContainerView = UIView()
        view.addSubview(splashContainerView)
        splashContainerView.autoPinWidthToSuperview()
        splashContainerView.autoVCenterInSuperview()

        let splashView = UIView()
        splashContainerView.addSubview(splashView)
        let containerPadding = ScaleFromIPhone5To7Plus(12, 18)
        splashView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: containerPadding,
                                                                   left: containerPadding,
                                                                   bottom: containerPadding,
                                                                   right: containerPadding))

        let slidesView = UIView()
        splashView.addSubview(slidesView)

        // TODO stack these horizontally so they can be panned through
        for experienceUpgrade in experienceUpgrades {
            slidesView.addSubview(buildSlideView(header: experienceUpgrade.title, body: experienceUpgrade.body, image: experienceUpgrade.image))
        }

        // Previous button
        let previousButton = UIButton()
        splashView.addSubview(previousButton)
        previousButton.setTitleColor(UIColor.white, for: .normal)
        previousButton.accessibilityLabel = NSLocalizedString("UPGRADE_CAROUSEL_PREVIOUS_BUTTON", comment: "accessibility label for arrow in slideshow")
        previousButton.setTitle("◂", for: .normal)
        previousButton.titleLabel?.font = UIFont.ows_lightFont(withSize:ScaleFromIPhone5To7Plus(24, 48))
        previousButton.addTarget(self, action:#selector(didTapPreviousButton), for: .touchUpInside)

        // Previous button layout
        previousButton.autoPinEdge(toSuperviewEdge: .left)
        previousButton.autoAlignAxis(.horizontal, toSameAxisOf: slidesView)

        // Next button
        let nextButton = UIButton()
        splashView.addSubview(nextButton)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.accessibilityLabel = NSLocalizedString("UPGRADE_CAROUSEL_NEXT_BUTTON", comment: "accessibility label for arrow in slideshow")
        nextButton.setTitle("▸", for: .normal)
        nextButton.titleLabel?.font = UIFont.ows_lightFont(withSize:ScaleFromIPhone5To7Plus(24, 48))
        nextButton.addTarget(self, action:#selector(didTapNextButton), for: .touchUpInside)

        // Next button layout
        nextButton.autoPinEdge(toSuperviewEdge: .right)
        nextButton.autoAlignAxis(.horizontal, toSameAxisOf: slidesView)

        // Dismiss button
        let dismissButton = UIButton()
        splashView.addSubview(dismissButton)
        dismissButton.setTitle(NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""), for: .normal)
        dismissButton.addTarget(self, action:#selector(didTapDismissButton), for: .touchUpInside)

        // Dismiss button layout
        dismissButton.autoPinWidthToSuperview()
        dismissButton.autoPinEdge(.top, to: .bottom, of: slidesView, withOffset: ScaleFromIPhone5(4) + containerPadding)
        dismissButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: ScaleFromIPhone5(4))

        // Debug
        splashView.addRedBorderRecursively()
    }

    // MARK: - Actions

    func didTapNextButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
    }

    func didTapPreviousButton(sender: UIButton) {
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
