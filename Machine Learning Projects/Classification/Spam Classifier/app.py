import streamlit as st
import pickle
import string
import nltk
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer

# Download NLTK data (required for stopwords and tokenization)
try:
    nltk.data.find('tokenizers/punkt')
    nltk.data.find('corpora/stopwords')
except LookupError:
    nltk.download('punkt')
    nltk.download('stopwords')

# Initialize PorterStemmer
ps = PorterStemmer()

# Function to transform text
def transform_text(text):
    text = text.lower()
    text = nltk.word_tokenize(text)

    y = []
    for i in text:
        if i.isalnum():
            y.append(i)

    text = y[:]
    y.clear()
    
    for i in text:
        if i not in stopwords.words("english") and i not in string.punctuation:
            y.append(i)

    text = y[:]
    y.clear()

    for i in text:
        y.append(ps.stem(i))

    return " ".join(y)

# Load pre-trained vectorizer and model
tfidf = pickle.load(open("vectorizer.pkl", "rb"))
model = pickle.load(open("model.pkl", "rb"))

# Streamlit UI
st.title("Spam Classifier")

input_text = st.text_area("Enter the text", height=150)

if st.button("Predict"):
    if input_text.strip() == "":
        st.warning("Please enter some text to classify!")
    else:
        # Preprocess the input
        transformed_input_text = transform_text(input_text)

        # Vectorize using TF-IDF
        vector_input = tfidf.transform([transformed_input_text])

        # Predict the result
        result = model.predict(vector_input)[0]

        # Display the result
        if result == 1:
            st.header("Spam mail/message")
        else:
            st.header("Not Spam")
else:
    st.write("Enter text and click 'Predict' to classify.")