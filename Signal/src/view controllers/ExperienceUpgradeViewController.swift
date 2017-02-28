//
//  Copyright (c) 2017 Open Whisper Systems. All rights reserved.
//

import Foundation

class ExperienceUpgradeViewController: UIViewController, UIScrollViewDelegate {
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

        let containerView = UIView()

        let slideView = UIView()
        containerView.addSubview(slideView)

        let containerPadding = ScaleFromIPhone5To7Plus(12, 24)
        slideView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: containerPadding, left: containerPadding, bottom: containerPadding, right: containerPadding))

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
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: ScaleFromIPhone5To7Plus(16, 32))

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

        return containerView
    }

    var carouselView: UIScrollView!
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = UIColor.ows_materialBlue()

        let splashView = UIView()
        view.addSubview(splashView)
        splashView.autoPinEdgesToSuperviewEdges()

        let carouselView = UIScrollView()
        carouselView.delegate = self
        self.carouselView = carouselView
        splashView.addSubview(carouselView)
        self.carouselView.isPagingEnabled = true
        carouselView.showsHorizontalScrollIndicator = false
        carouselView.showsVerticalScrollIndicator = false
        carouselView.autoPinEdgesToSuperviewEdges()

        // Build slides for carousel
        var previousSlideView: UIView?
        for experienceUpgrade in experienceUpgrades {
            let slideView = buildSlideView(header: experienceUpgrade.title, body: experienceUpgrade.body, image: experienceUpgrade.image)
            self.slideViews.append(slideView)
            carouselView.addSubview(slideView)

            slideView.autoPinEdge(toSuperviewEdge: .top, withInset: ScaleFromIPhone5(10))
            slideView.autoPinEdge(toSuperviewEdge: .bottom)
            slideView.autoMatch(.width, to: .width, of: carouselView)

            // first slide
            if previousSlideView == nil {
               slideView.autoPinEdge(toSuperviewEdge: .left)
            } else {
               slideView.autoPinEdge(.left, to: .right, of: previousSlideView!)
            }

            previousSlideView = slideView
        }
        // last slide
        previousSlideView?.autoPinEdge(toSuperviewEdge: .right)

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
        let arrowButtonInset = ScaleFromIPhone5(180)
        previousButton.autoPinEdge(toSuperviewEdge: .top, withInset: arrowButtonInset)

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
        nextButton.autoPinEdge(toSuperviewEdge: .top, withInset: arrowButtonInset)

        // Dismiss button
        let dismissButton = UIButton()
        splashView.addSubview(dismissButton)
        dismissButton.isUserInteractionEnabled = true
        dismissButton.setTitle(NSLocalizedString("DISMISS_BUTTON_TEXT", comment: ""), for: .normal)
        dismissButton.addTarget(self, action:#selector(didTapDismissButton), for: .touchUpInside)

        // Dismiss button layout
        dismissButton.autoPinWidthToSuperview()
        dismissButton.autoPinEdge(.top, to: .bottom, of: carouselView, withOffset: ScaleFromIPhone5(16))
        dismissButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: ScaleFromIPhone5(32))

        // Debug
//        splashView.addRedBorderRecursively()
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

    func updateSlideControls() {
        self.nextButton.isHidden = !hasNextSlide()
        self.previousButton.isHidden = !hasPreviousSlide()
    }

    func showCurrentSlide() {
        Logger.debug("\(TAG) showing slide: \(currentSlideIndex)")
        updateSlideControls()

        // update the scroll view to the appropriate page
        let bounds = carouselView.bounds

        let point = CGPoint(x: bounds.width * CGFloat(currentSlideIndex), y: 0)
        let pageBounds = CGRect(origin: point, size: bounds.size)

        carouselView.scrollRectToVisible(pageBounds, animated: true)
    }

    // MARK: - Actions

    func didTapNextButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
        showNextSlide()
    }

    func didTapPreviousButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
        showPreviousSlide()
    }

    func didTapDismissButton(sender: UIButton) {
        Logger.debug("\(TAG) in \(#function)")
        self.dismiss(animated: true)
    }

    func handleDismissGesture(sender: AnyObject) {
        Logger.debug("\(TAG) in \(#function)")
        self.dismiss(animated: true)
    }


    // MARK: - ScrollViewDelegate

    // Upadate the slider controls to reflect which page we think we'll end up on.
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = scrollView.frame.size.width
        let page = floor(targetContentOffset.pointee.x / pageWidth)
        currentSlideIndex = Int(page)
        updateSlideControls()
    }
}
