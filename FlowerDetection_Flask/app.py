from flask import Flask, request, jsonify
import tensorflow as tf
from tensorflow.python.keras.models import load_model
from PIL import Image
import numpy as np
import os

app = Flask(__name__)

# Load the model once when the Flask app starts
MODEL_PATH = 'my_model3/best_model(7).keras'  # Path to your model
model = tf.keras.models.load_model (MODEL_PATH)


# Route to accept and classify an image
@app.route('/classify', methods=['POST'])
def predict():
    try:
        # Check if an image file was included in the request
        if 'image' not in request.files:
            return jsonify({"error": "No image provided"}), 400

        # Read the image file from the request
        file = request.files['image']

        # Open the image using PIL
        img = Image.open(file)

        # Preprocess the image (assuming the model expects 224x224 images and normalization)
        img = img.resize((224, 224))  # Resize image to the expected input size
        img_array = np.array(img)  # Convert to numpy array
        img_array = img_array / 255.0  # Normalize to [0, 1]
        img_array = np.expand_dims(img_array, axis=0)  # Add batch dimension (1, 224, 224, 3)

        # Use the loaded model to make a prediction
        predictions = model.predict(img_array)

        # Assuming it's a classification problem and you want the class with the highest score
        predicted_class = np.argmax(predictions, axis=1)[0]
        confidence = np.max(predictions, axis=1)[0]

        # Send back the prediction and confidence as JSON
        return jsonify({"predicted_class": int(predicted_class), "confidence": float(confidence)})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
