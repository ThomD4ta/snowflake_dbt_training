---> total count item_category of 'Snack' and an item_subcategory of 'Warm Option'
SELECT item_category, COUNT(*) AS total_items 
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU 
WHERE item_category = 'Snack' AND item_subcategory = 'Warm Option' 
GROUP BY item_category; 

SELECT COUNT(*)
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE ITEM_CATEGORY = 'Snack' AND ITEM_SUBCATEGORY = 'Warm Option';