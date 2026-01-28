# -------------------------------------------------------------
# Snowflake Cortex – Specialized LLM Functions Demo (Cursor IDE)
# -------------------------------------------------------------
# Este script demuestra cómo ejecutar cada una de las funciones
# LLM especializadas mostradas en la imagen:
#   - SUMMARIZE
#   - SENTIMENT
#   - EXTRACT_ANSWER
#   - TRANSLATE
#
# Requiere:
#   - Una sesión Snowpark activa
#   - Una tabla llamada "reviews" o equivalente
# -------------------------------------------------------------

import snowflake.snowpark as snowpark

def main(session: snowpark.Session):

    # ---------------------------------------------------------
    # 1. SUMMARIZE
    # Ejecuta tareas rápidas de resumen sin necesidad de ajuste.
    # ---------------------------------------------------------
    summarize_query = """
        SELECT SNOWFLAKE.CORTEX.SUMMARIZE(content) AS summary
        FROM reviews
        LIMIT 5;
    """
    df_summarize = session.sql(summarize_query)
    print("\n=== SUMMARIZE ===")
    df_summarize.show()

    # ---------------------------------------------------------
    # 2. SENTIMENT
    # Detecta sentimiento: Positive, Neutral o Negative.
    # ---------------------------------------------------------
    sentiment_query = """
        SELECT 
            SNOWFLAKE.CORTEX.SENTIMENT(content) AS sentiment,
            content
        FROM reviews
        LIMIT 5;
    """
    df_sentiment = session.sql(sentiment_query)
    print("\n=== SENTIMENT ===")
    df_sentiment.show()

    # ---------------------------------------------------------
    # 3. EXTRACT_ANSWER
    # Extrae información desde texto no estructurado en formato Q&A.
    # ---------------------------------------------------------
    extract_query = """
        SELECT 
            SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
                review_content,
                'What dishes does this review mention?'
            ) AS extracted_answer
        FROM reviews
        LIMIT 5;
    """
    df_extract = session.sql(extract_query)
    print("\n=== EXTRACT_ANSWER ===")
    df_extract.show()

    # ---------------------------------------------------------
    # 4. TRANSLATE
    # Traduce texto entre idiomas soportados (ejemplo: inglés → alemán).
    # ---------------------------------------------------------
    translate_query = """
        SELECT 
            SNOWFLAKE.CORTEX.TRANSLATE(review_content, 'en', 'de') AS translated_text
        FROM reviews
        LIMIT 5;
    """
    df_translate = session.sql(translate_query)
    print("\n=== TRANSLATE ===")
    df_translate.show()

    # Devuelve un diccionario con los DataFrames por si deseas usarlos luego
    return {
        "summaries": df_summarize,
        "sentiments": df_sentiment,
        "extracted_answers": df_extract,
        "translations": df_translate
    }
