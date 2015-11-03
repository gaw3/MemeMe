//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/6/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
										  UINavigationControllerDelegate, UITextFieldDelegate {

	// MARK: - IB Outlets

	@IBOutlet weak var actionButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var photosButton: UIBarButtonItem!

	// MARK: - Class Variables

	var bottomMemeTextField: UITextField!
	var memeImageView:       UIImageView!
	var originalImage:       UIImage!
	var topMemeTextField:    UITextField!
	var amountToShiftMainViewOnYAxis: CGFloat = 0.0

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.redColor()
		view.layer.borderColor = UIColor.greenColor().CGColor
		view.layer.borderWidth = 5.0

		cancelButton.enabled = true
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		photosButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)

		memeImageView = initMemeImageView()
		view.addSubview(memeImageView)

		topMemeTextField = initMemeTextField("TOP")
		view.addSubview(topMemeTextField)

		bottomMemeTextField = initMemeTextField("BOTTOM")
		view.addSubview(bottomMemeTextField)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		actionButton.enabled = (originalImage != nil)
		resetMemeImageView()
		resetMemeTextFields()
		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		unsubscribeFromKeyboardNotifications()
	}

	// MARK: - IB Actions

	@IBAction func actionButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == actionButton, "received action from unexpected UIBarButtonItem")

		let memedImage = generateMemedImage()
		let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

		activityVC.excludedActivityTypes = [UIActivityTypePostToWeibo,
														UIActivityTypePrint,
														UIActivityTypeCopyToPasteboard,
														UIActivityTypeAssignToContact,
														UIActivityTypeSaveToCameraRoll,
														UIActivityTypeAddToReadingList,
														UIActivityTypePostToFlickr,
														UIActivityTypePostToVimeo,
														UIActivityTypePostToTencentWeibo,
														UIActivityTypeAirDrop]
		
		let meme = Meme(originalImage: originalImage, topPhrase: topMemeTextField.text!,
			             bottomPhrase: bottomMemeTextField.text!, memedImage: memedImage)

		presentViewController(activityVC, animated: true, completion: {() -> Void in
			MemesManager.sharedInstance.add(meme)})
	}

	@IBAction func cameraButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cameraButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.Camera)
	}

	@IBAction func cancelButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cancelButton, "received action from unexpected UIBarButtonItem")

		dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func photosButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == photosButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
	}

	// MARK: - NSNotifications

	func keyboardWillHide(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillHideNotification, "received unexpected NSNotification")

		view.frame.origin.y += amountToShiftMainViewOnYAxis
	}

	func keyboardWillShow(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillShowNotification, "received unexpected NSNotification")

		amountToShiftMainViewOnYAxis = 0.0

		if (bottomMemeTextField.isFirstResponder()) {
			let keyboardSize                           = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
			let topLeftCornerOfKeyboardInWindow        = CGPointMake(0, view.window!.frame.size.height - keyboardSize.CGRectValue().height)
			let topLeftCornerOfKeyboardInMemeImageView = memeImageView.convertPoint(topLeftCornerOfKeyboardInWindow, fromView: view.window!)
			let amountOfKeyboardOverlap                = memeImageView.bounds.size.height - topLeftCornerOfKeyboardInMemeImageView.y

			if amountOfKeyboardOverlap > 0 {
				amountToShiftMainViewOnYAxis = amountOfKeyboardOverlap
			}

		}

		view.frame.origin.y -= amountToShiftMainViewOnYAxis
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
		UIGraphicsBeginImageContext(memeImageView.frame.size)

		view.drawViewHierarchyInRect(memeImageView.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()

		return memedImage
	}

	private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()

		imagePicker.delegate   = self
		imagePicker.sourceType = sourceType

		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	// MARK: - Private:  Initialization

	private func initMemeImageView() -> UIImageView {
		let imageView = UIImageView()

		imageView.backgroundColor = UIColor.blackColor()
		imageView.contentMode     = .ScaleAspectFit
		imageView.hidden          = false
		imageView.layer.borderColor = UIColor.yellowColor().CGColor
		imageView.layer.borderWidth = 5.0

		return imageView
	}

	private func initMemeTextField(text: String) -> UITextField {
		let textField          = UITextField()
		let memeTextAttributes = [NSStrokeColorAttributeName     : UIColor.blackColor(),
			                       NSForegroundColorAttributeName : UIColor.whiteColor(),
			                       NSFontAttributeName            : UIFont(name: "Impact", size: 40)!,
			                       NSStrokeWidthAttributeName     : -3.0]

		textField.adjustsFontSizeToFitWidth = true
		textField.autocapitalizationType    = .AllCharacters
		textField.borderStyle               = .Line
		textField.clearButtonMode           = .Never
		textField.clearsOnBeginEditing      = true
		textField.defaultTextAttributes     = memeTextAttributes
		textField.delegate                  = self
		textField.frame.size.height         = 50.0
		textField.hidden                    = false
		textField.keyboardType              = .Default
		textField.minimumFontSize           = 12.0
		textField.text                      = text
		textField.textAlignment             = .Center

		return textField
	}

	// MARK: - Private:  Keyboards

	private func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
	}

	private func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
	}
	
	// MARK: - Private:  Resetting Views

	private func resetMemeImageView() {
		memeImageView.frame = view.bounds

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
		}
		
	}

	private func resetMemeTextFields() {
		let xInset: CGFloat = 5.0 // dist(x) between leading edges or trailing edges of meme image view & text fields
		let yInset: CGFloat = 5.0 // dist(y) between top edges or bottom edges of meme image view & text fields
		let textFieldWidth: CGFloat = memeImageView.frame.size.width - (2 * xInset)

		topMemeTextField.enabled          = (originalImage != nil)
		topMemeTextField.frame.size.width = textFieldWidth
		topMemeTextField.frame.origin     = CGPointMake(memeImageView.frame.origin.x + xInset,
																		memeImageView.frame.origin.y + yInset)

		bottomMemeTextField.enabled          = (originalImage != nil)
		bottomMemeTextField.frame.size.width = textFieldWidth
		bottomMemeTextField.frame.origin     = CGPointMake(memeImageView.frame.origin.x + xInset,
																			memeImageView.frame.origin.y + memeImageView.frame.size.height -
																			yInset - bottomMemeTextField.frame.height)
	}

	private func logBoxExtents() {
		print("\nview.window.bounds = \(view.window!.bounds)")
		print("view.window.frame  = \(view.window!.frame)")
		print("\nmain view.bounds = \(view.bounds)")
		print("main view.frame  = \(view.frame)")
		print("\nmemeImageView.bounds = \(memeImageView.bounds)")
		print("memeImageView.frame  = \(memeImageView.frame)")
		print("\ntopMemeTextField.bounds = \(topMemeTextField.bounds)")
		print("topMemeTextField.frame  = \(topMemeTextField.frame)")
		print("\nbottomMemeTextField.bounds = \(bottomMemeTextField.bounds)")
		print("bottomMemeTextField.frame  = \(bottomMemeTextField.frame)")
	}

}
