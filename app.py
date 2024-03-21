from flask import Flask , render_template ,request
import joblib

app = Flask(__name__)


##################################

@app.route("/")
def home():
    return render_template("home.html")

@app.route("/prediction" , methods=["GET","POST"])
def predict():
    text_ = str(request.form.get("Review_data"))

    data_point = [text_]

    model = joblib.load("model/inno_nlp_best_model_logistic_regression.pkl")
    prediction_ = model.predict(data_point)
    
    return render_template("output.html" , prediction_ = prediction_)






###################################

if __name__ == "__main__":
    app.run(debug = True , host='0.0.0.0')