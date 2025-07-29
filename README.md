# agro_sav
    AgroSaviour - Crop Disease Analysis App
AgroSaviour is a Flutter-based mobile application programmed to farmers and agricultural experts analyze crpo images using AI models.

## Features

- Upload crop images from **camera** or **gallery**
- Choose between multiple machine learning models (e.g., EfficientNet)
- Real-time prediction via **backend API**
- Displays prediction **label** and **confidence percentage**
- Stores results securely in **Firestore**
- Firebase Authentication support (Google/Email)
- Simple and responsive UI with theme support


## API INtegration
- Endpoint:
  `https://agrosaviour-backend-947103695812.europe-west1.run.app/predict/`

- Method: 'POST'
- Body: 
    -model_name:
    -file: Multipart file

## Authentication
- Firebase Authentication: Email/password and Google Sign-In