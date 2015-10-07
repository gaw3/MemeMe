//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Gregory White on 10/6/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// MARK: - IB Outlets

	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var actionButton: UIBarButtonItem!

	@IBOutlet weak var photosButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!

	@IBOutlet weak var pickedImageView: UIImageView!

	// MARK: - Class Variables

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		actionButton.enabled = false
		cancelButton.enabled = false

		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		photosButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
	}

	// MARK: - IB Actions

	@IBAction func actionButtonWasClicked(sender: UIBarButtonItem) {
		if sender == actionButton {
			// TODO: implement activity view
		} else {
			// TODO: how to handle this?
		}
	}

	@IBAction func cameraButtonWasClicked(sender: UIBarButtonItem) {
		if sender == cameraButton {
			pickImageFromSource(UIImagePickerControllerSourceType.Camera)
		} else {
			// TODO: how to handle this?
		}
	}

	@IBAction func cancelButtonWasClicked(sender: UIBarButtonItem) {
		if sender == cancelButton {
			// TODO: how to handle this?
		} else {
			// TODO: how to handle this?
		}
	}

	@IBAction func photosButtonWasClicked(sender: UIBarButtonItem) {
		if sender == photosButton {
			pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
		} else {
			// TODO: how to handle this?
		}
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

	// MARK: - Private

	private func pickImageFromSource(sourceType: UIImagePickerControllerSourceType) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}

}
