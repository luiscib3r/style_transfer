FROM python:3.12

# Set the working directory
WORKDIR /app

# Download tflite models
RUN curl https://storage.googleapis.com/download.tensorflow.org/models/tflite/task_library/style_transfer/android/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite -o magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite
RUN curl https://storage.googleapis.com/download.tensorflow.org/models/tflite/task_library/style_transfer/android/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite -o magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite

RUN apt update && apt install -y build-essential libhdf5-dev && apt clean

COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy code to the working directory
COPY tflite_server.py /app/

# Expose the port
EXPOSE 8080

# Run the application
CMD ["uvicorn", "tflite_server:app", "--host", "0.0.0.0", "--port", "8080"]



