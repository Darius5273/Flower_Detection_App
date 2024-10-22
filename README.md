# Flower Detection App

## Overview
The Flower Detection App is a mobile application developed in Flutter that can identify and classify 299 different species of flowers. Utilizing a model trained with MobileNet in a Jupyter Notebook, the app leverages a Flask backend to process image requests and deliver predictions.


## Features
- **Image Input**: Users can take a picture or upload an image of a flower.
- **Image Cropping**: Crop the image to focus on the flower for better detection.
- **Flower Detection**: The app sends the image to a Flask server, which uses a trained MobileNet model to predict the flower species.
- **Information Display**: Displays the detected flower's name and provides a link to its Wikipedia page.
- **Responsive Design**: Supports both horizontal and vertical screen orientations.

## Usage
1. **Open the App**: Start the Flower Detection app on your device.
2. **Select an Image**: Choose to either take a photo or upload an existing one.
3. **Crop the Image**: Use the cropping tool to focus on the flower.
4. **Detect Flower**: The app sends the image to the Flask backend for processing.
5. **View Results**: The predicted flower name will appear on the screen, along with a link to its Wikipedia page.

## Technologies Used
- **Flutter**: For building the mobile application.
- **Dart**: Programming language for Flutter development.
- **Flask**: Backend server framework for handling image requests and predictions.
- **MobileNet**: Deep learning model used for flower classification.
