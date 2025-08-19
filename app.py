from flask import Flask, request, jsonify, render_template
import pickle
import pandas as pd
import os

app = Flask(__name__)

# Load model and objects
with open('best_model.pkl', 'rb') as f:
    loaded_model = pickle.load(f)
with open('scaler.pkl', 'rb') as f:
    scaler = pickle.load(f)
with open('encoder.pkl', 'rb') as f:
    encoders = pickle.load(f)


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        input_df = pd.DataFrame([data])

        # Encode categorical features
        for col, encoder in encoders.items():
            input_df[col] = encoder.transform(input_df[col])

        # Scale numerical features
        num_cols = ['tenure', 'MonthlyCharges', 'TotalCharges']
        input_df[num_cols] = scaler.transform(input_df[num_cols])

        # Make prediction
        prediction = loaded_model.predict(input_df)[0]
        probability = loaded_model.predict_proba(input_df)[0][1]

        return jsonify({
            'prediction': 'Churn' if prediction == 1 else 'No Churn',
            'probability': float(probability)
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 400


if __name__ == '__main__':
    # Bind to 0.0.0.0 so AWS can access it, use PORT from environment if available
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
