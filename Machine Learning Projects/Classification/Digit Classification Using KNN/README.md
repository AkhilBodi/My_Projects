# MNIST Digit Classification using K-Nearest Neighbors (KNN)

## Overview
This project implements a K-Nearest Neighbors (KNN) classifier to classify handwritten digits from the MNIST dataset. The goal was to achieve >= 97% accuracy on the test set by tuning hyperparameters using GridSearchCV.

## Results
- **Best Hyperparameters**: `algorithm='auto', 'n_neighbors'=3, 'p'=2, 'weights'='distance'`
- **Test Set Accuracy**: **97.29%**

**Dependencies**:
- Python 3.x
- NumPy
- scikit-learn
- matplotlib (for visualization, if needed)

**Acknowledgements**:
- Thanks to [Aurélien Geron](https://github.com/ageron) & his book **Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow** for the guidance.
