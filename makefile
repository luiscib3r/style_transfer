.PHONY:
server:
	uvicorn tflite_server:app --host 0.0.0.0 --port 8080

.PHONY:
workers:
	sh build_web_workers.sh http://localhost:8080

.PHONY:
models:	
	curl https://storage.googleapis.com/download.tensorflow.org/models/tflite/task_library/style_transfer/android/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite \
    -o assets/models/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite

	curl https://storage.googleapis.com/download.tensorflow.org/models/tflite/task_library/style_transfer/android/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite \
    -o assets/models/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite