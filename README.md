# Customer Churn Prediction 🚀

A machine learning project to predict **customer churn** in a telecom company using historical usage patterns, demographic details, and service information.  
This project includes model training, evaluation, and deployment through a simple Flask web application.

---

## 📌 Table of Contents
- [Overview](#overview)
- [Dataset](#dataset)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Results](#results)
- [Future Improvements](#future-improvements)
- [License](#license)

---

## 🔎 Overview
Customer churn is when a customer stops using a company’s product/service.  
The goal of this project is to **predict which customers are likely to churn**, so businesses can take proactive action to retain them.

The project uses:
- **Python**
- **Flask** (for deployment)
- **scikit-learn** (for ML models)
- **Pandas / NumPy** (for data preprocessing)
- **Pickle** (for saving ML models)

---

## 📊 Dataset
We used the **Telco Customer Churn dataset** from [IBM Sample Data](https://www.ibm.com/communities/analytics/watson-analytics-blog/guide-to-sample-datasets/).

- Features include demographics, account information, and service usage.
- Target variable: `Churn` (Yes/No).

> 📁 The dataset (`WA_Fn-UseC_Telco-Customer-Churn.csv`) is included in this repo for testing purposes.

---

## 📂 Project Structure

customer-churn-prediction/
│── templates/ # HTML templates for Flask app
│── app.py # Flask application
│── wsgi.py # WSGI entry point (for deployment)
│── ccp.ipynb # Jupyter notebook with data exploration & model training
│── best_model.pkl # Trained model
│── encoder.pkl # Label encoder
│── scaler.pkl # Data scaler
│── requirements.txt # Python dependencies
│── LICENSE # License file
│── README.md # Project documentation


---

## ⚙️ Installation
Clone this repository and install dependencies:

```bash
git clone https://github.com/magar-m31/customer-churn-prediction.git
cd customer-churn-prediction
pip install -r requirements.txt


▶️ Usage

Run the Flask app:
python app.py


Open the app in your browser:

http://127.0.0.1:5000/


Enter customer details and get churn prediction instantly ✅

📈 Results

Achieved ~XX% accuracy on the test set.

The model helps identify high-risk customers who are likely to leave.

(You can update this with your actual results/metrics.)

🚀 Future Improvements

Deploy app on Heroku / Render / Hugging Face Spaces for public access

Add visualization dashboards

Experiment with deep learning models

Improve feature engineering

📜 License

This project is licensed under the MIT License. See the LICENSE
 file for details.
 