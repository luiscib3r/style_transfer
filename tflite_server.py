"""Main FastAPI application."""

from typing import Annotated

import tensorflow as tf
from fastapi import FastAPI, File, Header
from fastapi import __version__ as fastapi_version
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response

predictInterpreter = tf.lite.Interpreter(
    model_path="magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite"
)
transferInterpreter = tf.lite.Interpreter(
    model_path="magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite"
)

predictInterpreter.allocate_tensors()
transferInterpreter.allocate_tensors()

predict_input_details = predictInterpreter.get_input_details()
predict_output_details = predictInterpreter.get_output_details()

transfer_input_details = transferInterpreter.get_input_details()
transfer_output_details = transferInterpreter.get_output_details()


app = FastAPI(
    title="StyleTransfer API",
    description="API for style transfer model",
    docs_url=None,
    redoc_url=None,
)

# Cors
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


imageJpeg = "image/jpeg"


@app.post("/run")
async def run_style_transfer(
    image: Annotated[bytes, File(description="Image in bytes")],
    style: Annotated[bytes, File(description="Style in bytes")],
):
    """Run style transfer."""
    image_tensor = tf.io.decode_image(image, channels=3)
    image_tensor = tf.divide(image_tensor, 255)
    style_tensor = tf.io.decode_image(style, channels=3)
    style_tensor = tf.divide(style_tensor, 255)

    # Run predict inference
    predictInterpreter.set_tensor(predict_input_details[0]["index"], [style_tensor])
    predictInterpreter.invoke()
    predict_result = predictInterpreter.get_tensor(predict_output_details[0]["index"])

    # Run transfer inference
    transferInterpreter.set_tensor(transfer_input_details[0]["index"], [image_tensor])
    transferInterpreter.set_tensor(transfer_input_details[1]["index"], predict_result)
    transferInterpreter.invoke()
    transfer_result = transferInterpreter.get_tensor(
        transfer_output_details[0]["index"]
    )

    new_image = tf.multiply(transfer_result[0], 255.0)
    new_image = tf.cast(new_image, tf.uint8)
    new_image = tf.io.encode_jpeg(new_image)

    return Response(content=new_image.numpy(), media_type=imageJpeg)
