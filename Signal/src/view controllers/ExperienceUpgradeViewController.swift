//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeViewController: UIViewController {
    let TAG = "[ExperienceUpgradeViewController]"

    let experienceUpgrades: [ExperienceUpgrade]

    var nextButton: UIButton!
    var previousButton: UIButton!

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
        showCurrentSlide()
    }

    func addDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    func buildSlideView(header: String, body: String, image: UIImage) -> UIView {
        Logger.debug("\(TAG) in \(#function)")

        let slideView = UIView()

        // Title label
        let titleLabel = UILabel()
        slideView.addSubview(titleLabel)
        titleLabel.text = header
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.ows_regularFont(withSize: ScaleFromIPhone5To7Plus(26, 32))
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
        bodyLabel.autoPinEdge(toSuperviewEdge: .bottom)
        bodyLabel.textAlignment = .center

        // Image
        let imageView = UIImageView(image: image)
        slideView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        // Image layout
        imageView.autoPinWidthToSuperview()
        imageView.autoSetDimension(.height, toSize: ScaleFromIPhone5To7Plus(200, 280))
        imageView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: ScaleFromIPhone5To7Plus(24, 32))
        imageView.autoPinEdge(.bottom, to: .top, of: bodyLabel, withOffset: -ScaleFromIPhone5To7Plus(24, 32))

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
        splashView.autoPinEdgesToSuperviewEdges()

        let carouselView = UIView()
        splashView.addSubview(carouselView)
        let containerPadding = ScaleFromIPhone5To7Plus(12, 24)
        carouselView.autoPinEdge(toSuperviewEdge: .left, withInset: containerPadding)
        carouselView.autoPinEdge(toSuperviewEdge: .top, withInset: containerPadding)
        carouselView.autoPinEdge(toSuperviewEdge: .right, withInset: containerPadding)

        // TODO stack these horizontally so they can be panned through
        for experienceUpgrade in experienceUpgrades {
            let slideView = buildSlideView(header: experienceUpgrade.title, body: experienceUpgrade.body, image: experienceUpgrade.image)
            self.slideViews.append(slideView)
            carouselView.addSubview(slideView)
            slideView.autoPinEdgesToSuperviewEdges()
        }

        // Previous button
        let previousButton = UIButton()
        self.previousButton = previousButton
        splashView.addSubview(previousButton)
        previousButton.isUserInteractionEnabled = true
        previousButton.setTitleColor(UIColor.white, for: .normal)
        previousButton.accessibilityLabel = NSLocalizedString("UPGRADE_CAROUSEL_PREVIOUS_BUTTON", comment: "accessibility label for arrow in slideshow")
        previousButton.setTitle("‹", for: .normal)
        previousButton.titleLabel?.font = UIFont.ows_mediumFont(withSize: ScaleFromIPhone5To7Plus(24, 48))
        previousButton.addTarget(self, action:#selector(didTapPreviousButton), for: .touchUpInside)

        // Previous button layout
        previousButton.autoPinEdge(toSuperviewEdge: .left)
        let arrowButtonOffset =  ScaleFromIPhone5To7Plus(-12, -18)
        previousButton.autoAlignAxis(.horizontal, toSameAxisOf: carouselView, withOffset: arrowButtonOffset)

        // Next button
        let nextButton = UIButton()
        self.nextButton = nextButton
        splashView.addSubview(nextButton)
        nextButton.isUserInteractionEnabled = true
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.accessibilityLabel = NSLocalizedString("UPGRADE_CAROUSEL_NEXT_BUTTON", comment: "accessibility label for arrow in slideshow")
        nextButton.setTitle("›", for: .normal)
        nextButton.titleLabel?.font = UIFont.ows_mediumFont(withSize: ScaleFromIPhone5To7Plus(24, 48))
        nextButton.addTarget(self, action:#selector(didTapNextButton), for: .touchUpInside)

        // Next button layout
        nextButton.autoPinEdge(toSuperviewEdge: .right)
        nextButton.autoAlignAxis(.horizontal, toSameAxisOf: carouselView, withOffset: arrowButtonOffset)

        // Dismiss button
        let dismissButton = UIButton()
        splashView.addSubview(dismissButton)
        dismissButton.isUserInteractionEnabled = true
        dismissButton.setTitle(NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""), for: .normal)
        dismissButton.addTarget(self, action:#selector(didTapDismissButton), for: .touchUpInside)

        // Dismiss button layout
        dismissButton.autoPinWidthToSuperview()
        dismissButton.autoPinEdge(.top, to: .bottom, of: carouselView, withOffset: ScaleFromIPhone5(4) + containerPadding)
        dismissButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: ScaleFromIPhone5(4))

        // Debug
        splashView.addRedBorderRecursively()
    }

    // MARK: Carousel

    var currentSlideIndex = 0
    var slideViews = [UIView]()

    func showNextSlide() {
        guard hasNextSlide() else {
            Logger.debug("\(TAG) no next slide to show")
            return;
        }

        currentSlideIndex += 1
        showCurrentSlide()
    }

    func showPreviousSlide() {
        guard hasPreviousSlide() else {
            Logger.debug("\(TAG) no previous slide to show")
            return
        }

        currentSlideIndex -= 1
        showCurrentSlide()
    }

    func hasPreviousSlide() -> Bool {
        return currentSlideIndex > 0
    }

    func hasNextSlide() -> Bool {
        return currentSlideIndex < slideViews.count - 1
    }

    func showCurrentSlide() {
        Logger.debug("\(TAG) showing slide: \(currentSlideIndex)")
        self.nextButton.isHidden = !hasNextSlide()
        self.previousButton.isHidden = !hasPreviousSlide()
        //animateToSlide(index: currentSlideIndex)
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
