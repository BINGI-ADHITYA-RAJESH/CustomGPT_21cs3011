# CustomGPT
## 1. Project Overview
### Purpose
This project implements a chatbot capable of answering questions based on a custom dataset. It leverages Flutter for the frontend, LangChain and Python for the backend, and Firebase for user authentication and cloud data storage. The OpenAI GPT 3.5 API is used for intelligent data interpretation.
### Key Features
*   **Custom Knowledge Base:** Answers questions based on a provided dataset (e.g., mining regulations).
*   **User Authentication:** Secure user login and signup using Firebase.
*   **Chat History:** Stores and retrieves chat history for each user.
*   **Voice Input:** Allows users to input queries using speech-to-text.
*   **Flutter Frontend:** Provides a user-friendly mobile interface.
*   **LangChain Backend:** Uses LangChain to connect to the OpenAI GPT-3.5 API and process queries.
*   **Real-time Chat:** Displays messages in a chat bubble format.
*   **Clear Chat History:** Allows users to delete their chat history.
### Supported Platforms
*   Android
*   iOS
*   Web (Firebase configuration required)
### Requirements
*   Flutter SDK
*   Python 3.6+
*   Firebase project
*   OpenAI API key
## 2. Getting Started
### Installation and Setup
#### Flutter Frontend
1.  **Install Flutter:** Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2.  **Clone the repository:** `git clone <repository_url>`
3.  **Navigate to the Flutter frontend directory:** `cd flutter frontend Lib folder`
4.  **Install dependencies:** `flutter pub get`
5.  **Configure Firebase:**
    *   Create a Firebase project in the Firebase console: [https://console.firebase.google.com/](https://console.firebase.google.com/)
    *   Enable Authentication and Firestore.
    *   Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place it in the appropriate directory in your Flutter project.
    *   Update `firebase_options.dart` with your Firebase project's configuration.
6.  **Run the app:** `flutter run`
#### LangChain Backend
1.  **Install Python:** Ensure Python 3.6 or higher is installed.
2.  **Create a virtual environment (recommended):**
    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Linux/macOS
    venv\Scripts\activate  # On Windows
3.  **Navigate to the LangChain backend directory:** `cd LangChain backend`
4.  **Install dependencies:** `pip install -r requirements.txt` (Create a `requirements.txt` file with the following dependencies: `Flask`, `langchain`, `openai`, `chromadb`, `tiktoken`)
5.  **Set the OpenAI API key:** Replace `"YOUR OPENAI API KEY"` in `LangChain backend/constants.py` with your actual OpenAI API key.
    ```python
    # LangChain backend/constants.py
    APIKEY = "YOUR OPENAI API KEY"
6.  **Run the backend:** `python chatgpt.py`
### Dependencies
#### Flutter Frontend
*   `firebase_auth`
*   `cloud_firestore`
*   `firebase_core`
*   `http`
*   `speech_to_text`
#### LangChain Backend
*   `Flask`
*   `langchain`
*   `openai`
*   `chromadb`
*   `tiktoken`
## 3. Usage
### Flutter Frontend
1.  **Login/Signup:** Use the login or signup screens to authenticate with Firebase.  You can also skip login for testing purposes.
2.  **Chat Interface:** The home screen provides a chat interface.
3.  **Input Query:** Type your query in the text field or use the microphone icon to input your query using speech-to-text.
4.  **Send Request:** Press the send icon to send the query to the backend.
5.  **View Response:** The chatbot's response will be displayed in a chat bubble.
6.  **Clear Chat:** Use the drawer menu to clear the chat history.
7.  **Logout:** Use the logout button in the appbar to sign out.
### LangChain Backend
The backend runs as a Flask API. It listens for POST requests on the `/query` endpoint.
#### Example Request
```json
{
  "query": "What is the capital of France?"
}
```
#### Example Response
```json
{
  "answer": "The capital of France is Paris."
}
```
