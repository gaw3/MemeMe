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

	@IBOutlet weak var pickedImageView: UIImageView!

	@IBOutlet weak var topMemeTextField: UITextField!
	@IBOutlet weak var bottomMemeTextField: UITextField!

	// MARK: - Class Variables

	var meme: Meme!

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		cancelButton.enabled = false
		actionButton.enabled = false

		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		photosButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
		
		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
			NSStrokeWidthAttributeName : -3.0
		]

		topMemeTextField.defaultTextAttributes = memeTextAttributes
		topMemeTextField.textAlignment = .Center
		topMemeTextField.enabled = false

		bottomMemeTextField.defaultTextAttributes	= memeTextAttributes
		bottomMemeTextField.textAlignment = .Center
		bottomMemeTextField.enabled = false
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

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
		meme = Meme(originalImage: pickedImageView.image!, topPhrase: topMemeTextField.text!,
						bottomPhrase: bottomMemeTextField.text!, memedImage: memedImage)
		let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

		activityVC.excludedActivityTypes = [UIActivityTypePostToFacebook,
														UIActivityTypePostToTwitter,
														UIActivityTypePostToWeibo,
														UIActivityTypePrint,
														UIActivityTypeCopyToPasteboard,
														UIActivityTypeAssignToContact,
														UIActivityTypeSaveToCameraRoll,
														UIActivityTypeAddToReadingList,
														UIActivityTypePostToFlickr,
														UIActivityTypePostToVimeo,
														UIActivityTypePostToTencentWeibo,
														UIActivityTypeAirDrop]
		
		presentViewController(activityVC, animated: true, completion: nil)
	}

	@IBAction func cameraButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cameraButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.Camera)
	}

	@IBAction func cancelButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == cancelButton, "received action from unexpected UIBarButtonItem")

		topMemeTextField.text = "TOP"
		topMemeTextField.enabled = false

		bottomMemeTextField.text = "BOTTOM"
		bottomMemeTextField.enabled = false

		pickedImageView.image = nil
		cancelButton.enabled = false
		actionButton.enabled = false
	}

	@IBAction func photosButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == photosButton, "received action from unexpected UIBarButtonItem")

		pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
	}

	// MARK: - NSNotifications

	func keyboardWillHide(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillHideNotification, "received unexpected NSNotification")

		view.frame.origin.y = 0
	}

	func keyboardWillShow(notification: NSNotification) {
		assert(notification.name == UIKeyboardWillShowNotification, "received unexpected NSNotification")

		let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		view.frame.origin.y -= keyboardSize.CGRectValue().height
	}

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			pickedImageView.image = image

			topMemeTextField.enabled = true
			bottomMemeTextField.enabled = true

			cancelButton.enabled = true
			actionButton.enabled = true

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

	// MARK: - Private:  Keyboards

	private func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
	}

	private func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
	}
	
	// MARK: - Private

	private func generateMemedImage() -> UIImage {
		UIGraphicsBeginImageContext(view.frame.size)

		view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()
		return memedImage
	}

	private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		presentViewController(imagePicker, animated: true, completion: nil)
	}

}
