---> max sales prices for each of the three item subcategories (hot option, warm option, cold option)
SELECT DISTINCT item_subcategory,
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU;

SELECT 
    item_subcategory,
    MAX(sale_price_usd) AS max_sale_price
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
WHERE item_subcategory IN ('Hot Option', 'Warm Option', 'Cold Option')
GROUP BY item_subcategory
ORDER BY max_sale_price DESC;

SELECT ITEM_SUBCATEGORY,
MAX(SALE_PRICE_USD)
FROM tasty_bytes_sample_data.raw_pos.menu
GROUP BY 1
ORDER BY 2 DESC;