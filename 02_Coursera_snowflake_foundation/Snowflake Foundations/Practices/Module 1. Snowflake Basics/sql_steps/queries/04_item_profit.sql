---> what is the profit on Mango Sticky Rice?
SELECT 
   menu_item_name,
   (sale_price_usd - cost_of_goods_usd) AS profit_usd
FROM DATAEXPERT_STUDENT.THOMRADAD4TA.SAMPLE_MENU
WHERE 1=1
AND truck_brand_name = 'Freezing Point'
AND menu_item_name = 'Mango Sticky Rice';