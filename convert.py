import tensorflow as tf

# Load your model (.keras OR .h5)
model = tf.keras.models.load_model("CerviAI_90_Model.keras")

# Convert to TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Optional (reduces size, faster)
converter.optimizations = [tf.lite.Optimize.DEFAULT]

tflite_model = converter.convert()

# Save model
with open("cervical_model.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ Conversion done!")