from flask import Flask, request, jsonify, render_template
import pickle
import pandas as pd
import os
import pymysql
from datetime import datetime
from sklearn.metrics import accuracy_score
import warnings
warnings.filterwarnings("ignore")

app = Flask(__name__)


with open('best_model.pkl', 'rb') as f:
    loaded_model = pickle.load(f)
with open('scaler.pkl', 'rb') as f:
    scaler = pickle.load(f)
with open('encoder.pkl', 'rb') as f:
    encoders = pickle.load(f)


MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'MtM307@#1wh',
    'database': 'customer_churn',
    'charset': 'utf8mb4'
}


def get_mysql_connection():
    """Get MySQL connection"""
    return pymysql.connect(**MYSQL_CONFIG)


def log_customer_prediction(customer_id, actual_churn, predicted_churn, probability):
    """Log prediction to customer_predictions table"""
    try:
        conn = get_mysql_connection()
        cursor = conn.cursor()
        insert_sql = """
        INSERT INTO customer_predictions (customerID, actual_churn, predicted_churn, churn_probability, model_name)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(insert_sql, (customer_id, actual_churn if actual_churn is not None else 0,
                       predicted_churn, probability, 'Random Forest'))
        conn.commit()
        cursor.close()
        conn.close()
        print(f"Prediction logged: {customer_id}")
    except Exception as e:
        print(f"Log error: {e}")


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        customer_id = data.get(
            'customerID', f'cust_{datetime.now().strftime("%Y%m%d%H%M%S")}')

        input_df = pd.DataFrame([data])
        for col, encoder in encoders.items():
            input_df[col] = encoder.transform(input_df[col])
        num_cols = ['tenure', 'MonthlyCharges', 'TotalCharges']
        input_df[num_cols] = scaler.transform(input_df[num_cols])

        prediction = loaded_model.predict(input_df)[0]
        probability = loaded_model.predict_proba(input_df)[0][1]

        print("Prediction:", prediction, "Probability:", round(probability, 4))

        log_customer_prediction(customer_id, data.get(
            'actual_churn'), prediction, probability)

        return jsonify({
            'prediction': 'Churn' if prediction == 1 else 'No Churn',
            'probability': round(float(probability), 4),
            'customerID': customer_id
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/predictions', methods=['GET'])
def get_predictions():
    try:
        conn = get_mysql_connection()
        df = pd.read_sql("""
            SELECT customerID, predicted_churn, churn_probability, model_name, prediction_date 
            FROM customer_predictions 
            ORDER BY prediction_id DESC 
            LIMIT 10
        """, conn)
        conn.close()
        return jsonify(df.to_dict('records'))
    except Exception as e:
        print(f"Predictions error: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/metrics', methods=['GET'])
def get_metrics():
    try:
        conn = get_mysql_connection()
        df = pd.read_sql("""
            SELECT model_name, accuracy, precision_score, recall, f1_score, roc_auc
            FROM model_metrics
            ORDER BY id DESC
            LIMIT 5
        """, conn)
        conn.close()
        return jsonify(df.to_dict('records'))
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':

    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
