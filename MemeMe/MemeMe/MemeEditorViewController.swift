//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/6/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import UIKit

final class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
										                 UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - Private Constants

	fileprivate struct ImpactFont {
		static let Name = "Impact"

		static let Size:        CGFloat = 40.0
		static let StrokeWidth: CGFloat = -3.0
	}

	fileprivate struct Scale {
		static let DefaultToMainScreen: CGFloat = 0.0
	}

	fileprivate struct SEL {
		static let KeyboardWillHide = #selector(keyboardWillHide(_:))
		static let KeyboardWillShow = #selector(keyboardWillShow(_:))
	}

	fileprivate struct TextField {
		static let PlaceholderTextTop    = "TOP"
		static let PlaceholderTextBottom = "BOTTOM"

		static let Height:      CGFloat = 50.0
		static let MinSizeFont: CGFloat = 12.0
		static let InsetX:      CGFloat = 5.0 // dist(x) between leading edges or trailing edges of meme image view & text fields
		static let InsetY:      CGFloat = 5.0 // dist(y) between top edges or bottom edges of meme image view & text fields
	}

	// MARK: - Internal Stored Variables

	var memeToEdit: Meme!

	// MARK: - Private Stored Variables

	fileprivate var bottomMemeTextField: UITextField!
	fileprivate var memeImageView:			UIImageView!
	fileprivate var originalImage:			UIImage!
	fileprivate var topMemeTextField:		UITextField!

	fileprivate var amountToShiftMainViewOnYAxis:             CGFloat = 0.0
	fileprivate var originTopMemeTextFieldInMainViewSpace:    CGPoint = CGPoint.zero
	fileprivate var originBottomMemeTextFieldInMainViewSpace: CGPoint = CGPoint.zero

	// MARK: - IB Outlets

	@IBOutlet weak internal var actionButton: UIBarButtonItem!
	@IBOutlet weak internal var cameraButton: UIBarButtonItem!
	@IBOutlet weak internal var cancelButton: UIBarButtonItem!
	@IBOutlet weak internal var photosButton: UIBarButtonItem!
	
	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		cancelButton.isEnabled = true
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
		photosButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)

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
		resetMemeImageView()
		resetMemeTextFields()
		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		unsubscribeFromKeyboardNotifications()
	}

	// MARK: - View Layout

	override func updateViewConstraints() {
		super.updateViewConstraints()

		resetMemeImageView()
		resetMemeTextFields()
	}

	// MARK: - IB Actions

	@IBAction func actionButtonWasTapped(_ sender: UIBarButtonItem) {
		assert(sender == actionButton, "received action from unexpected UIBarButtonItem")

		let memedImage = generateMemedImage()
		let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
		let meme       = Meme(originalImage: originalImage, topPhrase: topMemeTextField.text!,
			                   bottomPhrase: bottomMemeTextField.text!, memedImage: memedImage)

		present(activityVC, animated: true, completion: {() -> Void in
			self.memesMgr.add(meme)})
	}

	@IBAction func cameraButtonWasTapped(_ sender: UIBarButtonItem) {
		assert(sender == cameraButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.camera)
	}

	@IBAction func cancelButtonWasTapped(_ sender: UIBarButtonItem) {
		assert(sender == cancelButton, "received action from unexpected UIBarButtonItem")

		dismiss(animated: true, completion: nil)
	}

	@IBAction func photosButtonWasTapped(_ sender: UIBarButtonItem) {
		assert(sender == photosButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.photoLibrary)
	}

	// MARK: - NSNotifications

	func keyboardWillHide(_ notification: Notification) {
		assert(notification.name == NSNotification.Name.UIKeyboardWillHide, "received unexpected NSNotification")

		if amountToShiftMainViewOnYAxis > 0.0 {
			view.frame.origin.y += amountToShiftMainViewOnYAxis
			amountToShiftMainViewOnYAxis = 0.0
		}
		
	}

	func keyboardWillShow(_ notification: Notification) {
		assert(notification.name == NSNotification.Name.UIKeyboardWillShow, "received unexpected NSNotification")

		if (bottomMemeTextField.isFirstResponder) {
			let keyboardSize                    = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
			let originOfKeyboardInWindow        = CGPoint(x: 0, y: view.window!.frame.size.height - keyboardSize.cgRectValue.height)
			let originOfKeyboardInMemeImageView = memeImageView.convert(originOfKeyboardInWindow, from: view.window!)
			let amountOfKeyboardOverlapInYDim   = memeImageView.bounds.size.height - originOfKeyboardInMemeImageView.y

			if amountOfKeyboardOverlapInYDim > 0 {
				amountToShiftMainViewOnYAxis = amountOfKeyboardOverlapInYDim
				view.frame.origin.y -= amountOfKeyboardOverlapInYDim
			}

		}

	}

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			originalImage = image
			dismiss(animated: true, completion: nil)
		}

	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		assert(textField == topMemeTextField || textField == bottomMemeTextField,
				 "received notification from unexpected UITextField")

		textField.resignFirstResponder()
      return true
	}

	// MARK: - Private:  Images

	fileprivate func generateMemedImage() -> UIImage {
		prepareViewHierarchyForGraphicsImageContext()

		UIGraphicsBeginImageContextWithOptions(memeImageView.frame.size, true, Scale.DefaultToMainScreen)
		memeImageView.drawHierarchy(in: memeImageView.bounds, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

      restoreViewHierarchyFromGraphicsImageContext()

		return memedImage
	}

	fileprivate func pickImageFromSource(_ sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()

		imagePicker.delegate   = self
		imagePicker.sourceType = sourceType

		present(imagePicker, animated: true, completion: nil)
	}
	
	fileprivate func prepareViewHierarchyForGraphicsImageContext() {
		topMemeTextField.removeFromSuperview()
		bottomMemeTextField.removeFromSuperview()

		memeImageView.addSubview(topMemeTextField)
		memeImageView.addSubview(bottomMemeTextField)

		originTopMemeTextFieldInMainViewSpace    = topMemeTextField.frame.origin
		originBottomMemeTextFieldInMainViewSpace = bottomMemeTextField.frame.origin

		topMemeTextField.frame.origin    = view.convert(originTopMemeTextFieldInMainViewSpace, to: memeImageView)
		bottomMemeTextField.frame.origin = view.convert(originBottomMemeTextFieldInMainViewSpace, to: memeImageView)
	}

	fileprivate func restoreViewHierarchyFromGraphicsImageContext() {
		topMemeTextField.removeFromSuperview()
		bottomMemeTextField.removeFromSuperview()

		view.addSubview(topMemeTextField)
		view.addSubview(bottomMemeTextField)

		topMemeTextField.frame.origin    = originTopMemeTextFieldInMainViewSpace
		bottomMemeTextField.frame.origin = originBottomMemeTextFieldInMainViewSpace

		originTopMemeTextFieldInMainViewSpace    = CGPoint.zero
		originBottomMemeTextFieldInMainViewSpace = CGPoint.zero
	}
	
	// MARK: - Private:  Initialization

	fileprivate func initMemeImageView() -> UIImageView {
		let imageView = UIImageView()

		imageView.backgroundColor = UIColor.black
		imageView.contentMode     = .scaleAspectFit
		imageView.isHidden          = false

		return imageView
	}

	fileprivate func initMemeTextField(_ text: String) -> UITextField {
		let textField          = UITextField()
		let memeTextAttributes = [NSStrokeColorAttributeName:     UIColor.black,
			                       NSForegroundColorAttributeName: UIColor.white,
			                       NSFontAttributeName:            UIFont(name: ImpactFont.Name, size: ImpactFont.Size)!,
			                       NSStrokeWidthAttributeName:     ImpactFont.StrokeWidth] as [String : Any]

		textField.adjustsFontSizeToFitWidth = true
		textField.autocapitalizationType    = .allCharacters
		textField.borderStyle               = .none
		textField.clearButtonMode           = .never
		textField.clearsOnBeginEditing      = true
		textField.defaultTextAttributes     = memeTextAttributes
		textField.delegate                  = self
		textField.frame.size.height         = TextField.Height
		textField.isHidden                    = false
		textField.keyboardType              = .default
		textField.minimumFontSize           = TextField.MinSizeFont
		textField.text                      = text
		textField.textAlignment             = .center

		return textField
	}

	// MARK: - Private:  Keyboards

	fileprivate func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: SEL.KeyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: SEL.KeyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}

	fileprivate func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}
	
	// MARK: - Private:  Resetting Views

	fileprivate func resetMemeImageView() {

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

	fileprivate func resetMemeTextFields() {
		let textFieldWidth: CGFloat = memeImageView.frame.size.width - (2 * TextField.InsetX)

		topMemeTextField.isEnabled          = (originalImage != nil)
		topMemeTextField.frame.size.width = textFieldWidth
		topMemeTextField.frame.origin     = CGPoint(x: memeImageView.frame.origin.x + TextField.InsetX,
																		y: memeImageView.frame.origin.y + TextField.InsetY)

		bottomMemeTextField.isEnabled          = (originalImage != nil)
		bottomMemeTextField.frame.size.width = textFieldWidth
		bottomMemeTextField.frame.origin     = CGPoint(x: memeImageView.frame.origin.x + TextField.InsetX,
																			y: memeImageView.frame.origin.y + memeImageView.frame.size.height -
																			TextField.InsetY - bottomMemeTextField.frame.height)
	}

}
