# 📊 Customer Churn Prediction System

A complete **end-to-end Machine Learning project** for predicting customer churn, storing results in a database, and visualizing them through a dashboard.

This system predicts whether a telecom customer will leave(churn), keeps a log of prediction history, and shows model performance on a web UI.

---

## 🚀 Features

| Feature                      | Status                         |
| ---------------------------- | ------------------------------ |
| 🔮 **Real-time Predictions** | ✅ Flask Web App                |
| 🗄️ **MySQL Integration**    | ✅ Data + Predictions + Metrics |
| 📊 **Jupyter EDA**           | ✅ churn_pred.ipynb             |
| 💾 **Model Persistence**     | ✅ Pickle files                 |
| 🌐 **Web Dashboard**         | ✅ templates/index.html         |
| 📈 **Performance Tracking**  | ✅ Model metrics logged         |

---

## 🏗️ Project Structure

```plaintext
customer-churn-prediction/
│
├── app/                     # Flask backend and templates
│   ├── templates/
│   │   └── index.html       # Frontend UI
│   ├── app.py               # Flask app
│   └── wsgi.py              # WSGI entry point for deployment
│
├── dashboard/               # Dashboard screenshots
│   ├── info.png
│   ├── result1.png
│   └── result2.png
│
├── database/                # Data and SQL scripts
│   ├── WA_Fn-UseC_-Telco-Customer-Churn.csv  # Dataset
│   └── churn_schema.sql     # SQL schema
│
├── notebooks/               # Jupyter notebooks
│   └── churn_pred.ipynb     # EDA and model training
│
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt         # Python dependencies
```

---

## 🧠 ML Pipeline Overview

1. Data → MySQL (`raw_data`)
2. EDA → SQL Queries (`churn_pred.ipynb`)
3. Feature Engineering → SQL CASE statements
4. Training → Random Forest (77.7% Accuracy)
5. API → Flask `/predict` endpoint
6. Logging → `customer_predictions` table

### Model Performance

| Model         | Accuracy | ROC-AUC | Precision | Recall | F1-Score |
| ------------- | -------- | ------- | --------- | ------ | -------- |
| Random Forest | 77.7%    | 74.3%   | 75.0%     | 72.0%  | 73.5%    |

---

## ⚙️ Installation

1. **Clone the repository**

```bash
git clone https://github.com/magar-m31/customer-churn-prediction.git
cd customer-churn-prediction
```

2. **Install dependencies**

```bash
pip install -r requirements.txt
```

3. **Setup MySQL database**

```sql
CREATE DATABASE customer_churn;
```

* Run SQL script inside `database/churn_schema.sql` to create tables.

4. **Start the Flask app**

```bash
cd app
python app.py
```

5. **Open dashboard**

```
http://127.0.0.1:5000
```

---

## 📈 How It Works

1. User enters customer details in the web form (`index.html`)
2. Flask API receives the input (`app.py`)
3. Model predicts churn + probability
4. Results stored in MySQL
5. Dashboard displays prediction logs and model metrics

---

## 📸 Dashboard & Visuals

* `dashboard/info.png` – General info view
* `dashboard/result1.png` – Sample prediction results
* `dashboard/result2.png` – Model performance metrics


---

## 🎯 Future Improvements

* Add interactive charts for visual analysis 📊
* Improve model accuracy using feature engineering & hyperparameter tuning 🚀
* Deploy app online (Heroku / AWS / Render) 🌍
* Add user authentication & role-based access 🔐
* Automate model retraining with new data


---

📜 License

This project is licensed under the MIT License. See the LICENSE
 file for details.
