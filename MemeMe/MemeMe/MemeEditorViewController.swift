//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/6/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import UIKit

final class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - IB Outlets

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var doneButton:   UIBarButtonItem!
    @IBOutlet weak var photosButton: UIBarButtonItem!
    
    // MARK: - IB Actions

    @IBAction func barButtonWasTapped(_ barButton: UIBarButtonItem) {

        switch barButton {

        case actionButton: actionButtonWasTapped()
        case cameraButton: pickImage(from: UIImagePickerController.SourceType.camera)
        case doneButton:   dismiss(animated: true, completion: nil)
        case photosButton: pickImage(from: UIImagePickerController.SourceType.photoLibrary)

        default: assertionFailure("Received action from unknown bar button = \(barButton)")
        }
        
    }

    // MARK: - Variables

    var memeToEdit: Meme!

    fileprivate var bottomMemeTextField: UITextField!
    fileprivate var memeImageView:		 UIImageView!
    fileprivate var originalImage:		 UIImage!
    fileprivate var topMemeTextField:	 UITextField!

    fileprivate var amountToShiftMainViewOnYAxis             = CGFloat(0.0)
    fileprivate var originTopMemeTextFieldInMainViewSpace    = CGPoint.zero
    fileprivate var originBottomMemeTextFieldInMainViewSpace = CGPoint.zero

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled   = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        photosButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)

        memeImageView = initMemeImageView()
        view.addSubview(memeImageView)

        if let memeToEdit = memeToEdit {
            originalImage       = memeToEdit.originalImage
            topMemeTextField    = initMemeTextField(memeToEdit.topPhrase)
            bottomMemeTextField = initMemeTextField(memeToEdit.bottomPhrase)
        } else {
            originalImage       = nil
            topMemeTextField    = initMemeTextField(TextField.PlaceholderTextTop)
            bottomMemeTextField = initMemeTextField(TextField.PlaceholderTextBottom)
        }

        view.addSubview(topMemeTextField)
        view.addSubview(bottomMemeTextField)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        actionButton.isEnabled = (originalImage != nil)
        reset()
        addNotificationObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotificationObservers()
    }

}



// MARK: -
// MARK: - Notifications

extension MemeEditorViewController {

    @objc func processNotification(_ notification: Notification) {

        switch notification.name {

        case UIResponder.keyboardWillHideNotification:  keyboardWillHide()
        case UIResponder.keyboardWillShowNotification:  keyboardWillShow(notification)
        case UIDevice.orientationDidChangeNotification: reset()
            
        default: assertionFailure("Received unknown notification = \(notification)")
        }

    }

}



// MARK: -
// MARK: - Image Picker Controller Delegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let pickedImagePNGData = pickedImage.pngData() {
            originalImage = UIImage(data: pickedImagePNGData)
            reset()
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}



// MARK: -
// MARK: - Text Field Delegate

extension MemeEditorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension MemeEditorViewController {

    // MARK: - Actions

    func actionButtonWasTapped() {

        if let memedImage = generateMemedImage() {
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            let meme       = Meme(originalImage: originalImage, topPhrase: topMemeTextField.text!,
                                  bottomPhrase: bottomMemeTextField.text!, memedImage: memedImage)

            present(activityVC, animated: true, completion: {() -> Void in MemesManager.shared.add(meme)})
        } else {
            assertionFailure("Unable to generate meme")
        }

    }

    // MARK: - Image Processing

    struct Scale {
        static let DefaultToMainScreen = CGFloat(0.0)
    }
    
    func generateMemedImage() -> UIImage? {
        prepareViewHierarchyForGraphicsImageContext()

        UIGraphicsBeginImageContextWithOptions(memeImageView.frame.size, true, Scale.DefaultToMainScreen)
        memeImageView.drawHierarchy(in: memeImageView.bounds, afterScreenUpdates: true)

        var memedImagePNG: UIImage? = nil

        if let memedImage = UIGraphicsGetImageFromCurrentImageContext(), let pngData = memedImage.pngData() {
            memedImagePNG = UIImage(data: pngData)
        }

        UIGraphicsEndImageContext()
        restoreViewHierarchyFromGraphicsImageContext()

        return memedImagePNG
    }

    func pickImage(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate   = self
        imagePicker.sourceType = sourceType

        present(imagePicker, animated: true, completion: nil)
    }

    func prepareViewHierarchyForGraphicsImageContext() {
        topMemeTextField.removeFromSuperview()
        bottomMemeTextField.removeFromSuperview()

        memeImageView.addSubview(topMemeTextField)
        memeImageView.addSubview(bottomMemeTextField)

        originTopMemeTextFieldInMainViewSpace    = topMemeTextField.frame.origin
        originBottomMemeTextFieldInMainViewSpace = bottomMemeTextField.frame.origin

        topMemeTextField.frame.origin    = view.convert(originTopMemeTextFieldInMainViewSpace, to: memeImageView)
        bottomMemeTextField.frame.origin = view.convert(originBottomMemeTextFieldInMainViewSpace, to: memeImageView)
    }

    func restoreViewHierarchyFromGraphicsImageContext() {
        topMemeTextField.removeFromSuperview()
        bottomMemeTextField.removeFromSuperview()

        view.addSubview(topMemeTextField)
        view.addSubview(bottomMemeTextField)

        topMemeTextField.frame.origin    = originTopMemeTextFieldInMainViewSpace
        bottomMemeTextField.frame.origin = originBottomMemeTextFieldInMainViewSpace

        originTopMemeTextFieldInMainViewSpace    = CGPoint.zero
        originBottomMemeTextFieldInMainViewSpace = CGPoint.zero
    }

    // MARK: - Initialization
    
    struct ImpactFont {
        static let Name        = "Impact"
        static let Size        = CGFloat(40.0)
        static let StrokeWidth = CGFloat(-3.0)
    }
    
    func initMemeImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.backgroundColor = UIColor.black
        imageView.contentMode     = .scaleAspectFit
        imageView.isHidden        = false

        return imageView
    }

    func initMemeTextField(_ text: String) -> UITextField {
        let textField          = UITextField()
        let memeTextAttributes = [NSAttributedString.Key.strokeColor:     UIColor.black,
                                  NSAttributedString.Key.foregroundColor: UIColor.white,
                                  NSAttributedString.Key.font:            UIFont(name: ImpactFont.Name, size: ImpactFont.Size)!,
                                  NSAttributedString.Key.strokeWidth:     ImpactFont.StrokeWidth] as [NSAttributedString.Key : Any]

        textField.adjustsFontSizeToFitWidth = true
        textField.autocapitalizationType    = .allCharacters
        textField.borderStyle               = .none
        textField.clearButtonMode           = .never
        textField.clearsOnBeginEditing      = true
        textField.defaultTextAttributes     = memeTextAttributes
        textField.delegate                  = self
        textField.frame.size.height         = TextField.Height
        textField.isHidden                  = false
        textField.keyboardType              = .default
        textField.minimumFontSize           = TextField.MinSizeFont
        textField.text                      = text
        textField.textAlignment             = .center

        return textField
    }

    // MARK: - Notifications

    struct Selector {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: UIResponder.keyboardWillHideNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: UIResponder.keyboardWillShowNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector.ProcessNotification, name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    func keyboardWillHide() {
        
        if amountToShiftMainViewOnYAxis > 0.0 {
            view.frame.origin.y += amountToShiftMainViewOnYAxis
            amountToShiftMainViewOnYAxis = 0.0
        }
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomMemeTextField.isFirstResponder {
            let keyboardSize                    = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let originOfKeyboardInWindow        = CGPoint(x: 0, y: view.window!.frame.size.height - keyboardSize.cgRectValue.height)
            let originOfKeyboardInMemeImageView = memeImageView.convert(originOfKeyboardInWindow, from: view.window!)
            let amountOfKeyboardOverlapInYDim   = memeImageView.bounds.size.height - originOfKeyboardInMemeImageView.y
            
            if amountOfKeyboardOverlapInYDim > 0 {
                amountToShiftMainViewOnYAxis = amountOfKeyboardOverlapInYDim
                view.frame.origin.y -= amountOfKeyboardOverlapInYDim
            }
            
        }
        
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Reset
    
    struct TextField {
        static let PlaceholderTextTop    = "TOP"
        static let PlaceholderTextBottom = "BOTTOM"
        
        static let Height      = CGFloat(50.0)
        static let MinSizeFont = CGFloat(12.0)
        static let InsetX      = CGFloat(5.0) // dist(x) between leading edges or trailing edges of meme image view & text fields
        static let InsetY      = CGFloat(5.0) // dist(y) between top edges or bottom edges of meme image view & text fields
    }
    
    func reset() {
        resetMemeImageView()
        resetMemeTextFields()
    }

    func resetMemeImageView() {

        if let originalImage = originalImage {
            let widthScale         = view.frame.size.width / originalImage.size.width
            let heightScale        = view.frame.size.height / originalImage.size.height
            let scaleToUse         = min(widthScale, heightScale)
            let widthAfterScaling  = originalImage.size.width * scaleToUse
            let heightAfterScaling = originalImage.size.height * scaleToUse
            
            memeImageView.image        = originalImage
            memeImageView.frame.size   = CGSize(width: widthAfterScaling, height: heightAfterScaling)
            memeImageView.frame.origin = CGPoint(x: (view.frame.size.width - widthAfterScaling) / 2,
                                                 y: (view.frame.size.height - heightAfterScaling) / 2)
        } else {
            memeImageView.frame = view.bounds
        }
        
    }
    
    func resetMemeTextFields() {
        let textFieldWidth = CGFloat(memeImageView.frame.size.width - (2 * TextField.InsetX))
        
        topMemeTextField.isEnabled        = (originalImage != nil)
        topMemeTextField.frame.size.width = textFieldWidth
        topMemeTextField.frame.origin     = CGPoint(x: memeImageView.frame.origin.x + TextField.InsetX,
                                                    y: memeImageView.frame.origin.y + TextField.InsetY)
        
        bottomMemeTextField.isEnabled        = (originalImage != nil)
        bottomMemeTextField.frame.size.width = textFieldWidth
        bottomMemeTextField.frame.origin     = CGPoint(x: memeImageView.frame.origin.x + TextField.InsetX,
                                                       y: memeImageView.frame.origin.y + memeImageView.frame.size.height - TextField.InsetY - bottomMemeTextField.frame.height)
    }
    
}
