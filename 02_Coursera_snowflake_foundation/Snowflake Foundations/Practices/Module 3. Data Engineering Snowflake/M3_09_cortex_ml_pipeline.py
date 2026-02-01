# -------------------------------------------------------------
# Snowpark ML – Full Pipeline Demo (Cursor IDE)
# -------------------------------------------------------------
# Este script replica y explica cada feature ML mostrado en la
# imagen: imputación, escalamiento, pipeline, XGBoost, métricas.
#
# Requisitos:
#   - Una sesión Snowpark activa
#   - Tabla: Gamma_Telescope_Data
# -------------------------------------------------------------

from snowflake.ml.utils.connection_params import SnowflakeLoginOptions
from snowflake.snowpark import Session, DataFrame

# Preprocesamiento
from snowflake.ml.modeling.preprocessing import StandardScaler
from snowflake.ml.modeling.impute import SimpleImputer

# Pipeline ML
from snowflake.ml.modeling.pipeline import Pipeline

# Modelo
from snowflake.ml.modeling.xgboost import XGBClassifier

# Métricas
from snowflake.ml.modeling.metrics import accuracy_score


# -------------------------------------------------------------
# Crear sesión Snowpark
# -------------------------------------------------------------
session = Session.builder.configs(SnowflakeLoginOptions()).create()


# -------------------------------------------------------------
# Step 1 — Cargar datos y dividir en train/test
# -------------------------------------------------------------
all_data = session.sql("""
    SELECT *, IFF(CLASS = 'g', 1.0, 0.0) AS LABEL
    FROM Gamma_Telescope_Data
""").collect()

train_data, test_data = all_data.random_split(weights=[0.9, 0.1], seed=0)

FEATURE_COLS = [c for c in train_data.columns if c != "LABEL"]
LABEL_COLS = ["LABEL"]


# -------------------------------------------------------------
# Step 2 — Construir pipeline ML
# -------------------------------------------------------------
pipeline = Pipeline(steps=[
    # Imputación de valores faltantes
    {"impute": SimpleImputer(input_cols=FEATURE_COLS, output_cols=FEATURE_COLS)},
    
    # Escalamiento estándar
    {"scaler": StandardScaler(input_cols=FEATURE_COLS, output_cols=FEATURE_COLS)},
    
    # Modelo XGBoost
    {"model": XGBClassifier(input_cols=FEATURE_COLS, label_cols=LABEL_COLS)}
])


# -------------------------------------------------------------
# Step 3 — Entrenar modelo
# -------------------------------------------------------------
pipeline.fit(train_data)


# -------------------------------------------------------------
# Step 4 — Evaluación
# -------------------------------------------------------------
predict_train = pipeline.predict(train_data)
training_accuracy = accuracy_score(
    df=predict_train,
    y_true_col_names=["LABEL"],
    y_pred_col_name="PREDICTION"
)

predict_test = pipeline.predict(test_data)
eval_accuracy = accuracy_score(
    df=predict_test,
    y_true_col_names=["LABEL"],
    y_pred_col_name="PREDICTION"
)

print(f"Training accuracy: {training_accuracy}")
print(f"Eval accuracy: {eval_accuracy}")


# -------------------------------------------------------------
# Retornar resultados para inspección
# -------------------------------------------------------------
{
    "train_predictions": predict_train,
    "test_predictions": predict_test,
    "training_accuracy": training_accuracy,
    "eval_accuracy": eval_accuracy
}
