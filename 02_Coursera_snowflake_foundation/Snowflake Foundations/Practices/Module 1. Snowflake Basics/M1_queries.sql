---> query sample_menu table
SELECT * FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU;

---> total count item_category of 'Snack' and an item_subcategory of 'Warm Option'
SELECT item_category, COUNT(*) AS total_items 
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU 
WHERE item_category = 'Snack' AND item_subcategory = 'Warm Option' 
GROUP BY item_category; 

SELECT COUNT(*)
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE ITEM_CATEGORY = 'Snack' AND ITEM_SUBCATEGORY = 'Warm Option';

-- Answer: 3 Snacks on the warm option subcategory

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

-- Price answer: $21 Max Price for Hot, $12.5 Max Price for Warm and $11 Max Price for Cold

---> what menu items does the Freezing Point brand sell?
SELECT 
   menu_item_name
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
WHERE truck_brand_name = 'Freezing Point';

---> what is the profit on Mango Sticky Rice?
SELECT 
   menu_item_name,
   (sale_price_usd - cost_of_goods_usd) AS profit_usd
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
WHERE 1=1
AND truck_brand_name = 'Freezing Point'
AND menu_item_name = 'Mango Sticky Rice';