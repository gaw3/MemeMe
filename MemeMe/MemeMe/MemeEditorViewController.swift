//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/6/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreGraphics
import UIKit

final internal class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
										                 UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - Private Constants

	private struct ImpactFont {
		static let Name = "Impact"

		static let Size:        CGFloat = 40.0
		static let StrokeWidth: CGFloat = -3.0
	}

	private struct Scale {
		static let DefaultToMainScreen: CGFloat = 0.0
	}

	private struct SEL {
		static let KeyboardWillHide: Selector = "keyboardWillHide:"
		static let KeyboardWillShow: Selector = "keyboardWillShow:"
	}

	private struct TextField {
		static let PlaceholderTextTop    = "TOP"
		static let PlaceholderTextBottom = "BOTTOM"

		static let Height:      CGFloat = 50.0
		static let MinSizeFont: CGFloat = 12.0
		static let InsetX:      CGFloat = 5.0 // dist(x) between leading edges or trailing edges of meme image view & text fields
		static let InsetY:      CGFloat = 5.0 // dist(y) between top edges or bottom edges of meme image view & text fields
	}

	// MARK: - Internal Stored Variables

	internal var memeToEdit: Meme!

	// MARK: - Private Stored Variables

	private var bottomMemeTextField: UITextField!
	private var memeImageView:			UIImageView!
	private var originalImage:			UIImage!
	private var topMemeTextField:		UITextField!

	private var amountToShiftMainViewOnYAxis:             CGFloat = 0.0
	private var originTopMemeTextFieldInMainViewSpace:    CGPoint = CGPointZero
	private var originBottomMemeTextFieldInMainViewSpace: CGPoint = CGPointZero

	// MARK: - IB Outlets

	@IBOutlet weak internal var actionButton: UIBarButtonItem!
	@IBOutlet weak internal var cameraButton: UIBarButtonItem!
	@IBOutlet weak internal var cancelButton: UIBarButtonItem!
	@IBOutlet weak internal var photosButton: UIBarButtonItem!
	
	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

		cancelButton.enabled = true
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		photosButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)

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

	override internal func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		actionButton.enabled = (originalImage != nil)
		resetMemeImageView()
		resetMemeTextFields()
		subscribeToKeyboardNotifications()
	}

	override internal func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		unsubscribeFromKeyboardNotifications()
	}

	// MARK: - View Layout

	override internal func updateViewConstraints() {
		super.updateViewConstraints()

		resetMemeImageView()
		resetMemeTextFields()
	}

	// MARK: - IB Actions

	@IBAction internal func actionButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == actionButton, "received action from unexpected UIBarButtonItem")

		let memedImage = generateMemedImage()
		let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
		let meme       = Meme(originalImage: originalImage, topPhrase: topMemeTextField.text!,
			                   bottomPhrase: bottomMemeTextField.text!, memedImage: memedImage)

		presentViewController(activityVC, animated: true, completion: {() -> Void in
			MemesManager.sharedInstance.add(meme)})
	}

	@IBAction internal func cameraButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cameraButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.Camera)
	}

	@IBAction internal func cancelButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cancelButton, "received action from unexpected UIBarButtonItem")

		dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction internal func photosButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == photosButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
	}

	// MARK: - NSNotifications

	internal func keyboardWillHide(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillHideNotification, "received unexpected NSNotification")

		if amountToShiftMainViewOnYAxis > 0.0 {
			view.frame.origin.y += amountToShiftMainViewOnYAxis
			amountToShiftMainViewOnYAxis = 0.0
		}
		
	}

	internal func keyboardWillShow(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillShowNotification, "received unexpected NSNotification")

		if (bottomMemeTextField.isFirstResponder()) {
			let keyboardSize                    = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
			let originOfKeyboardInWindow        = CGPointMake(0, view.window!.frame.size.height - keyboardSize.CGRectValue().height)
			let originOfKeyboardInMemeImageView = memeImageView.convertPoint(originOfKeyboardInWindow, fromView: view.window!)
			let amountOfKeyboardOverlapInYDim   = memeImageView.bounds.size.height - originOfKeyboardInMemeImageView.y

			if amountOfKeyboardOverlapInYDim > 0 {
				amountToShiftMainViewOnYAxis = amountOfKeyboardOverlapInYDim
				view.frame.origin.y -= amountOfKeyboardOverlapInYDim
			}

		}

	}

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			originalImage = image
			dismissViewControllerAnimated(true, completion: nil)
		}

	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == topMemeTextField || textField == bottomMemeTextField,
				 "received notification from unexpected UITextField")

		textField.resignFirstResponder()
      return true
	}

	// MARK: - Private:  Images

	private func generateMemedImage() -> UIImage {
		prepareViewHierarchyForGraphicsImageContext()

		UIGraphicsBeginImageContextWithOptions(memeImageView.frame.size, true, Scale.DefaultToMainScreen)
		memeImageView.drawViewHierarchyInRect(memeImageView.bounds, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

      restoreViewHierarchyFromGraphicsImageContext()

		return memedImage
	}

	private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()

		imagePicker.delegate   = self
		imagePicker.sourceType = sourceType

		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	private func prepareViewHierarchyForGraphicsImageContext() {
		topMemeTextField.removeFromSuperview()
		bottomMemeTextField.removeFromSuperview()

		memeImageView.addSubview(topMemeTextField)
		memeImageView.addSubview(bottomMemeTextField)

		originTopMemeTextFieldInMainViewSpace    = topMemeTextField.frame.origin
		originBottomMemeTextFieldInMainViewSpace = bottomMemeTextField.frame.origin

		topMemeTextField.frame.origin    = view.convertPoint(originTopMemeTextFieldInMainViewSpace, toView: memeImageView)
		bottomMemeTextField.frame.origin = view.convertPoint(originBottomMemeTextFieldInMainViewSpace, toView: memeImageView)
	}

	private func restoreViewHierarchyFromGraphicsImageContext() {
		topMemeTextField.removeFromSuperview()
		bottomMemeTextField.removeFromSuperview()

		view.addSubview(topMemeTextField)
		view.addSubview(bottomMemeTextField)

		topMemeTextField.frame.origin    = originTopMemeTextFieldInMainViewSpace
		bottomMemeTextField.frame.origin = originBottomMemeTextFieldInMainViewSpace

		originTopMemeTextFieldInMainViewSpace    = CGPointZero
		originBottomMemeTextFieldInMainViewSpace = CGPointZero
	}
	
	// MARK: - Private:  Initialization

	private func initMemeImageView() -> UIImageView {
		let imageView = UIImageView()

		imageView.backgroundColor = UIColor.blackColor()
		imageView.contentMode     = .ScaleAspectFit
		imageView.hidden          = false

		return imageView
	}

	private func initMemeTextField(text: String) -> UITextField {
		let textField          = UITextField()
		let memeTextAttributes = [NSStrokeColorAttributeName:     UIColor.blackColor(),
			                       NSForegroundColorAttributeName: UIColor.whiteColor(),
			                       NSFontAttributeName:            UIFont(name: ImpactFont.Name, size: ImpactFont.Size)!,
			                       NSStrokeWidthAttributeName:     ImpactFont.StrokeWidth]

		textField.adjustsFontSizeToFitWidth = true
		textField.autocapitalizationType    = .AllCharacters
		textField.borderStyle               = .None
		textField.clearButtonMode           = .Never
		textField.clearsOnBeginEditing      = true
		textField.defaultTextAttributes     = memeTextAttributes
		textField.delegate                  = self
		textField.frame.size.height         = TextField.Height
		textField.hidden                    = false
		textField.keyboardType              = .Default
		textField.minimumFontSize           = TextField.MinSizeFont
		textField.text                      = text
		textField.textAlignment             = .Center

		return textField
	}

	// MARK: - Private:  Keyboards

	private func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: SEL.KeyboardWillHide, name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: SEL.KeyboardWillShow, name: UIKeyboardWillShowNotification, object: nil)
	}

	private func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
	}
	
	// MARK: - Private:  Resetting Views

	private func resetMemeImageView() {

		if let originalImage = originalImage {
			let widthScale         = view.frame.size.width / originalImage.size.width
			let heightScale        = view.frame.size.height / originalImage.size.height
			let scaleToUse         = min(widthScale, heightScale)
			let widthAfterScaling  = originalImage.size.width * scaleToUse
			let heightAfterScaling = originalImage.size.height * scaleToUse

			memeImageView.image        = originalImage
			memeImageView.frame.size   = CGSizeMake(widthAfterScaling, heightAfterScaling)
			memeImageView.frame.origin = CGPointMake((view.frame.size.width - widthAfterScaling) / 2,
															     (view.frame.size.height - heightAfterScaling) / 2)
		} else {
			memeImageView.frame = view.bounds
		}
		
	}

	private func resetMemeTextFields() {
		let textFieldWidth: CGFloat = memeImageView.frame.size.width - (2 * TextField.InsetX)

		topMemeTextField.enabled          = (originalImage != nil)
		topMemeTextField.frame.size.width = textFieldWidth
		topMemeTextField.frame.origin     = CGPointMake(memeImageView.frame.origin.x + TextField.InsetX,
																		memeImageView.frame.origin.y + TextField.InsetY)

		bottomMemeTextField.enabled          = (originalImage != nil)
		bottomMemeTextField.frame.size.width = textFieldWidth
		bottomMemeTextField.frame.origin     = CGPointMake(memeImageView.frame.origin.x + TextField.InsetX,
																			memeImageView.frame.origin.y + memeImageView.frame.size.height -
																			TextField.InsetY - bottomMemeTextField.frame.height)
	}

}
