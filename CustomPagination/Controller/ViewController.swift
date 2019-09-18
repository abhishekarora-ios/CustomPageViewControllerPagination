//
//  ViewController.swift
//  CustomPagination
//
//  Created by Abhishek Arora on 18/09/19.
//  Copyright © 2019 Abhishek Arora. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tutorialSplashView: UIView!
    @IBOutlet weak var onBoardCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgWrong: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var viewWrongSelection: IBDesignableView!
    @IBOutlet weak var viewRightSelection: IBDesignableView!
    @IBOutlet weak var viewSwipe: UIView!
    
    //Properties
    var layout = AACardFlowLayout()
    var onBoardingViewModel = OnBoardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //        UIApplication.shared.isStatusBarHidden = true
        
        // add observer for location notification events
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.locationResponseObserver), name: NSNotification.Name(rawValue: kNotificationLocationResponse), object: nil)
    }
    
    func initialSetup() {
        self.setCollectionViewLayout()
        self.getOnBoardData()
        onBoardCollectionView.dataSource = self
        onBoardCollectionView.delegate = self
        addGesture(view: viewWrongSelection, selector: #selector(title1Touches(sender:)))
        addGesture(view: viewRightSelection, selector: #selector(title2Touches(sender:)))
        registerCell()
        self.addGesturesToSwipeBackAndForth(view: viewSwipe)
        self.setLabelSelection(isRightAnswerTouches: false, isWrongAnswerTouches: false)
    }
    
    func setCollectionViewLayout() {
        self.layout.minimumLineSpacing = 0;
        self.layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        self.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layout.itemSize = self.cardSize()
        self.onBoardCollectionView.collectionViewLayout = self.layout
    }
    
    func getOnBoardData() {
        self.onBoardingViewModel.getOnBoardData {[weak self] (isSuccess) in
            if isSuccess,let dataModel = self?.onBoardingViewModel.onBoardModel,let onBoardDetailArray = dataModel.onBoardDetails {
                self?.pageControl.numberOfPages = onBoardDetailArray.count
            }
        }
    }
    
    func addGesture(view:UIView,selector:Selector) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: selector)
        view.addGestureRecognizer(tapGesture)
    }
    
    func addGesturesToSwipeBackAndForth(view:UIView) {
        let swipeGestureforward = UISwipeGestureRecognizer()
        swipeGestureforward.direction = UISwipeGestureRecognizer.Direction.left
        swipeGestureforward.addTarget(self, action: #selector(swipeForward))
        view.addGestureRecognizer(swipeGestureforward)
        
        let swipeGestureBackward = UISwipeGestureRecognizer()
        swipeGestureBackward.direction = UISwipeGestureRecognizer.Direction.right
        swipeGestureBackward.addTarget(self, action: #selector(swipeBackward))
        view.addGestureRecognizer(swipeGestureBackward)
        
    }
    
    @objc func swipeForward() {
        if pageControl.currentPage != pageControl.numberOfPages - 1 {
            self.onBoardCollectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage+1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func swipeBackward() {
        if pageControl.currentPage != 0 {
            self.onBoardCollectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage-1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func setLabelSelection(isRightAnswerTouches:Bool,isWrongAnswerTouches:Bool) {
        if isRightAnswerTouches {
            viewRightSelection.backgroundColor = onBoardingViewModel.rightSelectionBgColor
            viewWrongSelection.backgroundColor = onBoardingViewModel.selectionTextColor
            lblTitle1.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
            lblTitle2.textColor = onBoardingViewModel.selectionTextColor
            imgWrong.isHidden = true
            imgRight.isHidden = false
        }
        else if isWrongAnswerTouches {
            viewWrongSelection.backgroundColor = onBoardingViewModel.wrongSelectionBgColor
            lblTitle1.textColor = onBoardingViewModel.selectionTextColor
            viewRightSelection.backgroundColor = onBoardingViewModel.selectionTextColor
            lblTitle2.textColor = onBoardingViewModel.noSelectionTextColor
            imgWrong.isHidden = false
            imgRight.isHidden = true
        }
        else {
            viewWrongSelection.backgroundColor = onBoardingViewModel.selectionTextColor
            lblTitle1.textColor = onBoardingViewModel.noSelectionTextColor
            imgWrong.isHidden = true
            imgRight.isHidden = true
            viewRightSelection.backgroundColor = onBoardingViewModel.selectionTextColor
            lblTitle2.textColor = onBoardingViewModel.noSelectionTextColor
        }
    }
    
    func cardScaleRatio() -> CGFloat {
        return self.cardSize().width/self.view.frame.width
    }
    
    func cardSize() -> CGSize {
        var frame = self.view.bounds
        frame.size.width = frame.size.width
        frame.size.height = self.onBoardCollectionView.frame.height
        return frame.size
    }
    
    @objc func title1Touches(sender:UITapGestureRecognizer) {
        onBoardingViewModel.isWrongAnsTouches = true
        onBoardingViewModel.isRightAnsTouches = false
        onBoardingViewModel.dictSavedState["\(pageControl.currentPage)"] = onBoardingViewModel.wrongSelectedTxt
        self.setLabelSelection(isRightAnswerTouches: onBoardingViewModel.isRightAnsTouches, isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.swipeForward()
        }
    }
    
    @objc func title2Touches(sender:UITapGestureRecognizer) {
        onBoardingViewModel.isWrongAnsTouches = false
        onBoardingViewModel.isRightAnsTouches = true
        onBoardingViewModel.dictSavedState["\(pageControl.currentPage)"] = onBoardingViewModel.rightSelectedTxt
        self.setLabelSelection(isRightAnswerTouches: onBoardingViewModel.isRightAnsTouches, isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.swipeForward()
        }
    }
    
    func registerCell() {
        onBoardCollectionView.register(UINib(nibName: onBoardingViewModel.imageCellIdentifier, bundle: nil), forCellWithReuseIdentifier: onBoardingViewModel.imageCellIdentifier)
    }
    
    @IBAction func btnSkipClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func pageControlClicked(_ sender: UIPageControl) {
        self.onBoardCollectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func setSkipButton() {
        if let dataModel = self.onBoardingViewModel.onBoardModel,let skipButtonText = dataModel.skipButton {
            btnSkip.setTitle(skipButtonText, for: .normal)
        }
    }
    
    func setData(cell:OnBoardCollectionCell,index:Int) {
        if let dataModel = self.onBoardingViewModel.onBoardModel,let onBoardDetailModelArray = dataModel.onBoardDetails {
            
            if let title1 = onBoardDetailModelArray[index].button1,let title2 = onBoardDetailModelArray[index].button2,let headerTitle = onBoardDetailModelArray[index].title {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.lblTitle1.text = title1
                    self.lblTitle2.text = title2
                    self.lblHeaderTitle.text = headerTitle
                }, completion: nil)
            }
            
            if let selectionStateStr = onBoardingViewModel.dictSavedState["\(pageControl.currentPage)"] {
                if selectionStateStr == onBoardingViewModel.rightSelectedTxt {
                    onBoardingViewModel.isRightAnsTouches = true
                    onBoardingViewModel.isWrongAnsTouches = false
                    self.setLabelSelection(isRightAnswerTouches:onBoardingViewModel.isRightAnsTouches , isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
                }else if selectionStateStr == onBoardingViewModel.wrongSelectedTxt {
                    onBoardingViewModel.isRightAnsTouches = false
                    onBoardingViewModel.isWrongAnsTouches = true
                    self.setLabelSelection(isRightAnswerTouches:onBoardingViewModel.isRightAnsTouches , isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
                } else {
                    onBoardingViewModel.isRightAnsTouches = false
                    onBoardingViewModel.isWrongAnsTouches = false
                    self.setLabelSelection(isRightAnswerTouches:onBoardingViewModel.isRightAnsTouches , isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
                }
            } else {
                onBoardingViewModel.isRightAnsTouches = false
                onBoardingViewModel.isWrongAnsTouches = false
                self.setLabelSelection(isRightAnswerTouches:onBoardingViewModel.isRightAnsTouches , isWrongAnswerTouches: onBoardingViewModel.isWrongAnsTouches)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataModel = self.onBoardingViewModel.onBoardModel,let onBoardDetailModelArray = dataModel.onBoardDetails {
            return onBoardDetailModelArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onBoardingViewModel.imageCellIdentifier, for: indexPath) as? OnBoardCollectionCell {
            cell.setupData(onBoardDetails: self.onBoardingViewModel.onBoardModel?.onBoardDetails?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.onBoardCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if onBoardingViewModel.isFirstTimeCellLoad {
            onBoardingViewModel.isFirstTimeCellLoad = false
            self.setAlphaValueToView(alpha: 1)
        }
        else {
            self.setAlphaValueToView(alpha: 0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let collectionCell = cell as? OnBoardCollectionCell {
            pageControl.currentPage = layout.currentIndex
            self.setData(cell: collectionCell, index: layout.currentIndex)
            fadeViewInThenOut(delay: 0.5)
        }
    }
    
    func setAlphaValueToView(alpha:CGFloat) {
        viewRightSelection.alpha = alpha
        viewWrongSelection.alpha = alpha
        lblHeaderTitle.alpha = alpha
    }
    
    func fadeViewInThenOut(delay: TimeInterval) {
        
        let animationDuration = 1.0
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.setAlphaValueToView(alpha: 0)
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                self.setAlphaValueToView(alpha: 1.0)
            },
                           completion: nil)
        }
    }
}



