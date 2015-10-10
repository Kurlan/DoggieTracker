//
//  DogViewController.swift
//  DoggieTracker
//
//  Created by STEVE HUYNH on 10/6/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit

class DogViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var dog: Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        checkValidDogName()
        
        if let dog = dog {
            navigationItem.title = dog.name
            nameTextField.text = dog.name
            photoImageView.image = dog.photo
            ratingControl.rating = dog.rating
        }
    }
    
    // MARK: UITetFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    func checkValidDogName() {
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDogName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        photoImageView.image = selectedImage
        
        dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddDogMode = presentingViewController is UINavigationController
        if isPresentingInAddDogMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            dog = Dog(name: name, photo: photo, rating: rating)
        }
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {

        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated:true, completion:nil)
    }
    
}

