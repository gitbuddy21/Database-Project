-- Lets add some examples! 
-- 1. Let's say you distributed 5 hygiene kits during your first distribution:

INSERT INTO Distribution_Log (item_id, quantity_distributed, distribution_date, event_id)
VALUES (48, 5, '2025-08-26', 1);

UPDATE Item
SET item_qty = item_qty - 5
WHERE item_id = 48;

SELECT * 
FROM distribution_log;

-- 2. Now let's say multiple items were dirtibuted:
INSERT INTO Distribution_Log (item_id, quantity_distributed, distribution_date, event_id) VALUES
(1, 10, '2025-08-26', 2),
(4, 8, '2025-08-26', 2),
(14, 5, '2025-08-26', 2);

-- now lets update the item table! we could do them a couple of ways 
UPDATE Item SET item_qty = item_qty - 10 WHERE item_id = 1;
UPDATE Item SET item_qty = item_qty - 8 WHERE item_id = 4;
UPDATE Item SET item_qty = item_qty - 5 WHERE item_id = 14;

-- or 

UPDATE Item
SET item_qty = CASE item_id
  WHEN 1 THEN item_qty - 10
  WHEN 4 THEN item_qty - 8
  WHEN 14 THEN item_qty - 5
END
WHERE item_id IN (1, 4, 14);

-- 3. now lets look at the updated tables together! The following query hows the distribution log along with the current_stock and the quantity_ditributed.
SELECT 
  i.item_id,
  i.item_name,
  i.item_qty AS current_stock,
  dl.quantity_distributed,
  dl.distribution_date,
  dl.event_id
FROM Distribution_Log dl
JOIN Item i ON dl.item_id = i.item_id
ORDER BY dl.distribution_date DESC, i.item_name;

-- 4. View All Items by Category and Condition
SELECT item_name, item_category, item_condition, item_qty
FROM Item
ORDER BY item_category, item_condition;

-- 5. Items Distributed at Events
SELECT de.event_date, i.item_name, dl.quantity_distributed
FROM Distribution_Log dl
JOIN Item i ON dl.item_id = i.item_id
JOIN Distribution_Event de ON dl.event_id = de.event_id
ORDER BY de.event_date DESC;

-- 6.Reduce item_qty for item_id 101 (Toothbrush) by 45 units
UPDATE Item -- goes into the item table
SET item_qty = item_qty - 45 -- removing 45 units of
WHERE item_id = 1; -- bottled water

SELECT *
FROM item; -- selects everything from the item table, 2x check the data update. Now you should have 5 bottled waters left

-- 7. Set the reorder-limit
INSERT INTO Reorder_Threshold (item_id, min_quantity)
VALUES (101, 20); -- the values are the id, and the quanity you want it to be

-- 8. Identify low inventory items. Since you are now low on bottled water this query should populate that you need to order items below the reorder_treshold
SELECT i.item_name, i.item_qty, r.min_quantity -- Selects the fields and populates them to the result grid
FROM Item i -- goes into the item table
JOIN Reorder_Threshold r ON i.item_id = r.item_id -- joins both reorder_threshold and otem table
WHERE i.item_qty < r.min_quantity; -- this will populate the items that you set your item par

