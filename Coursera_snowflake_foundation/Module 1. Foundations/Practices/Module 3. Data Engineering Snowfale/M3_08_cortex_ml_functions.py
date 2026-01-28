# -------------------------------------------------------------
# Snowflake Cortex – Specialized ML Functions Demo (Cursor IDE)
# -------------------------------------------------------------
# Este script demuestra cómo ejecutar cada una de las funciones
# ML especializadas mostradas en la imagen:
#   1. FORECAST
#   2. ANOMALY_DETECTION
#   3. TOP_INSIGHTS
#   4. CLASSIFICATION
#
# Requisitos:
#   - Una sesión Snowpark activa
#   - Vistas/tablas mencionadas en los ejemplos
# -------------------------------------------------------------

import snowflake.snowpark as snowpark

def main(session: snowpark.Session):

    # ---------------------------------------------------------
    # 1. FORECAST — Pronóstico de series temporales
    # ---------------------------------------------------------
    forecast_create = """
        CREATE OR REPLACE SNOWFLAKE.ML.FORECAST model_forecast(
            INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'v1'),
            TIMESTAMP_COLUMN => 'date',
            TARGET_COLUMN => 'sales'
        );
    """
    session.sql(forecast_create).collect()

    forecast_run = """
        CALL model_forecast!FORECAST(FORECASTING_PERIODS => 3);
    """
    df_forecast = session.sql(forecast_run)
    print("\n=== FORECAST ===")
    df_forecast.show()

    # ---------------------------------------------------------
    # 2. ANOMALY_DETECTION — Detección de anomalías
    # ---------------------------------------------------------
    anomaly_create = """
        CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION anomaly_model(
            INPUT_DATA => SYSTEM$QUERY_REFERENCE(
                'SELECT date, sales FROM historical_sales_data WHERE store_id=1'
            ),
            TIMESTAMP_COLUMN => 'date',
            TARGET_COLUMN => 'sales',
            LABEL_COLUMN => '1'
        );
    """
    session.sql(anomaly_create).collect()

    anomaly_run = """
        CALL anomaly_model!DETECT_ANOMALIES(
            INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'view_with_data_to_analyze'),
            TIMESTAMP_COLUMN => 'date',
            TARGET_COLUMN => 'sales'
        );
    """
    df_anomaly = session.sql(anomaly_run)
    print("\n=== ANOMALY DETECTION ===")
    df_anomaly.show()

    # ---------------------------------------------------------
    # 3. TOP_INSIGHTS — Contribution Explorer
    # ---------------------------------------------------------
    top_insights_query = """
        SELECT res.* 
        FROM input, TABLE(
            SNOWFLAKE.ML.TOP_INSIGHTS(
                input.categorical_dimensions,
                input.continuous_dimensions,
                CAST(input.metric AS FLOAT),
                input.label
            )
            OVER (PARTITION BY 0)
        ) res 
        ORDER BY res.surprise DESC;
    """
    df_insights = session.sql(top_insights_query)
    print("\n=== TOP INSIGHTS ===")
    df_insights.show()

    # ---------------------------------------------------------
    # 4. CLASSIFICATION — Clasificación supervisada
    # ---------------------------------------------------------
    classification_create = """
        CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_binary(
            INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
            TARGET_COLUMN => 'label'
        );
    """
    session.sql(classification_create).collect()

    classification_predict = """
        SELECT model_binary!PREDICT(INPUT_DATA => object_construct(*)) AS prediction
        FROM prediction_purchase_data;
    """
    df_classification = session.sql(classification_predict)
    print("\n=== CLASSIFICATION ===")
    df_classification.show()

    # ---------------------------------------------------------
    # Retornar los DataFrames para inspección o uso posterior
    # ---------------------------------------------------------
    return {
        "forecast": df_forecast,
        "anomalies": df_anomaly,
        "insights": df_insights,
        "classification": df_classification
    }
