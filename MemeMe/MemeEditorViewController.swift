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

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -3.0
		]

		topMemeTextField.defaultTextAttributes = memeTextAttributes
		topMemeTextField.textAlignment = .Center
		bottomMemeTextField.defaultTextAttributes	= memeTextAttributes
		bottomMemeTextField.textAlignment = .Center
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		actionButton.enabled = false
		cancelButton.enabled = false

		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		photosButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)

		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)

		unsubscribeFromKeyboardNotifications()
	}

	// MARK: - IB Actions

	@IBAction func actionButtonWasClicked(sender: UIBarButtonItem) {

		if sender == actionButton {
			// TODO: implement activity view
		}
		else {
			// TODO: how to handle this?
		}
	}

	@IBAction func cameraButtonWasClicked(sender: UIBarButtonItem) {

		if sender == cameraButton {
			pickImageFromSource(UIImagePickerControllerSourceType.Camera)
		}
		else {
			// TODO: how to handle this?
		}

	}

	@IBAction func cancelButtonWasClicked(sender: UIBarButtonItem) {

		if sender == cancelButton {
			// TODO: how to handle this?
		}
		else {
			// TODO: how to handle this?
		}

	}

	@IBAction func photosButtonWasClicked(sender: UIBarButtonItem) {

		if sender == photosButton {
			pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
		}
		else {
			// TODO: how to handle this?
		}

	}

	// MARK: - NSNotifications

	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y += getKeyboardHeight(notification)
	}

	func keyboardWillShow(notification: NSNotification) {
		self.view.frame.origin.y -= getKeyboardHeight(notification)
	}

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			pickedImageView.image = image
			dismissViewControllerAnimated(true, completion: nil)
		}

	}

	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		var doDefault: Bool = true

		textField.resignFirstResponder()

		if textField.text == "" {
			doDefault = false

			if textField == topMemeTextField {
				textField.text = "TOP"
			}
			else if textField == bottomMemeTextField {
				textField.text = "BOTTOM"
			}
			else {
				print("unrecognized text field")
			}

		}

      return doDefault
	}

	// MARK: - Private:  Keyboards

	private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		var keyboardHeight: CGFloat = 0.0

		if bottomMemeTextField.isFirstResponder() {
			let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue

			keyboardHeight = keyboardSize.CGRectValue().height
		}

		return keyboardHeight
	}

	private func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
	}

	private func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
	}
	
	// MARK: - Private

	private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}

}
