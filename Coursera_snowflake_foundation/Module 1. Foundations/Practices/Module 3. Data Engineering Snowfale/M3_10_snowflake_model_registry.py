# -------------------------------------------------------------
# Snowflake Model Registry – Demo Completa (Cursor IDE)
# -------------------------------------------------------------
# Este script replica y explica cada feature mostrado en la imagen:
#   - Entrenar un modelo sklearn
#   - Registrar el modelo en Snowflake Model Registry
#   - Configurar opciones de métodos
#   - Ejecutar predicciones desde el registro
#
# Requisitos:
#   - Una sesión Snowpark activa
#   - Haber inicializado un objeto "registry"
# -------------------------------------------------------------

from sklearn import datasets, ensemble

# -------------------------------------------------------------
# 1. Cargar dataset Iris
# -------------------------------------------------------------
iris_X, iris_y = datasets.load_iris(return_X_y=True, as_frame=True)

# -------------------------------------------------------------
# 2. Entrenar modelo RandomForest
# -------------------------------------------------------------
model = ensemble.RandomForestClassifier(random_state=42)
model.fit(iris_X, iris_y)

# -------------------------------------------------------------
# 3. Registrar modelo en Snowflake Model Registry
# -------------------------------------------------------------
# NOTA:
#   "registry" debe ser un objeto válido del Model Registry de Snowflake.
#   Ejemplo de inicialización:
#       from snowflake.ml.registry import Registry
#       registry = Registry(session=session)
#
model_ref = registry.log_model(
    model,
    model_name="RandomForestClassifier",
    version_name="v1",
    sample_input_data=iris_X,
    options={
        "method_options": {
            "predict": {"case_sensitive": True},
            "predict_proba": {"case_sensitive": True},
            "predict_log_proba": {"case_sensitive": True},
        },
    },
)

# -------------------------------------------------------------
# 4. Ejecutar predicción usando el modelo registrado
# -------------------------------------------------------------
prediction = model_ref.run(
    iris_X[:10],
    function_name="predict_proba"
)

print("\n=== PREDICT_PROBA OUTPUT ===")
print(prediction)

# -------------------------------------------------------------
# Retornar resultados para inspección
# -------------------------------------------------------------
{
    "model_reference": model_ref,
    "prediction_output": prediction
}
