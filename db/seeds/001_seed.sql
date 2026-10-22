INSERT INTO properties (name, street, city, state, zip, property_type, beds, baths, house_size_sqft, units, acquisition_date, status) VALUES
('Maple Ridge',     '412 Maple Ridge Dr', 'Asheville',    'NC', '28803', 'STR',         4, 3.0, 2480, 1,  '2024-05-12', 'Owned'),
('Sunset Bungalow', '88 Sunset Ave',      'Scottsdale',   'AZ', '85251', 'STR',         3, 2.0, 1760, 1,  '2023-11-03', 'Owned'),
('Gulf Breeze',     '215 Gulf Breeze Ln', 'Destin',       'FL', '32541', 'STR',         5, 4.0, 3120, 1,  '2024-08-21', 'Owned'),
('Birch Court',     '1900 Birch Court',   'Nashville',    'TN', '37206', 'Multifamily', NULL, NULL, 8400, 8, '2023-06-30', 'Owned'),
('Crestline Flats', '77 Crestline Blvd',  'Boise',        'ID', '83702', 'Multifamily', NULL, NULL, 11200, 12,'2024-02-18', 'Owned'),
('Harbor View',     '3 Harbor View Rd',   'Charleston',   'SC', '29401', 'STR',         4, 3.5, 2650, 1,  NULL,         'Pipeline'),
('Aspen Meadow',    '640 Aspen Meadow Way','Bozeman',     'MT', '59715', 'STR',         3, 2.5, 1980, 1,  NULL,         'Pipeline'),
('Cedar Park 24',   '24 Cedar Park Cir',  'Austin',       'TX', '78745', 'Multifamily', NULL, NULL, 19500, 24,NULL,      'Pipeline'),
('Lakeside Cottage','9 Lakeside Cottage Rd','Traverse City','MI','49684','STR',         2, 1.0, 1240, 1,  NULL,         'Passed'),
('Pine Hollow',     '155 Pine Hollow Dr', 'Gatlinburg',   'TN', '37738', 'STR',         6, 5.0, 3600, 1,  NULL,         'Passed'),
-- Same and similar names in different markets (intentional, for disambiguation testing)
('Birch Court',     '52 Birch Court',     'Savannah',     'GA', '31401', 'STR',         3, 2.5, 1920, 1,  '2024-09-15', 'Owned'),
('Harbor View',     '210 Harbor View Dr', 'Galveston',    'TX', '77550', 'STR',         4, 3.0, 2400, 1,  NULL,         'Pipeline'),
('Crestview Flats', '300 Crestview Ave',  'Spokane',      'WA', '99201', 'Multifamily', NULL, NULL, 14800, 16, '2024-04-09','Owned'),
('Maple Ridge Lodge','71 Maple Ridge Rd', 'Park City',    'UT', '84060', 'STR',         5, 4.5, 3380, 1,  NULL,         'Pipeline'),
('Pinehurst Hollow','420 Pinehurst Hollow Ct','Flagstaff','AZ', '86001', 'STR',         4, 3.0, 2280, 1,  NULL,         'Passed');

INSERT INTO financials (property_id, purchase_price, list_price, noi_annual, cap_rate, dscr, debt_amount, occupancy_rate) VALUES
(1,  725000.00,  749000.00,  61200.00, 0.084, 1.42,  507500.00, 0.71),
(2,  548000.00,  559000.00,  39800.00, 0.073, 1.31,  383600.00, 0.68),
(3,  995000.00, 1025000.00,  82900.00, 0.083, 1.55,  696500.00, 0.74),
(4, 1640000.00, 1699000.00, 118500.00, 0.072, 1.28, 1148000.00, 0.93),
(5, 2280000.00, 2350000.00, 159600.00, 0.070, 1.25, 1596000.00, 0.95),
(6,  880000.00,  899000.00,  70400.00, 0.080, NULL,       NULL, NULL),
(7,  612000.00,  629000.00,  46500.00, 0.076, NULL,       NULL, NULL),
(8, 3950000.00, 4100000.00, 268600.00, 0.068, NULL,       NULL, NULL),
(9,  398000.00,  415000.00,  24900.00, 0.063, NULL,       NULL, NULL),
(10, 1180000.00, 1249000.00, 70800.00, 0.060, NULL,       NULL, NULL),
(11,  685000.00,  699000.00,  56400.00, 0.082, 1.38,  479500.00, 0.69),
(12,  742000.00,  759000.00,  58600.00, 0.079, NULL,       NULL, NULL),
(13, 1980000.00, 2040000.00, 134600.00, 0.068, 1.30, 1386000.00, 0.96),
(14,  555000.00,  569000.00,  44200.00, 0.080, NULL,       NULL, NULL),
(15,  462000.00,  479000.00,  28100.00, 0.061, NULL,       NULL, NULL);

INSERT INTO lp_distributions (investor_name, property_id, commitment, ownership_pct, distribution_q1_2026) VALUES
('Tamarind Family Office',     4,  450000.00, 28.50, 9200.00),
('Tamarind Family Office',     5,  600000.00, 24.00, 11800.00),
('Greenfield Partners LLC',    4,  300000.00, 19.00, 6100.00),
('Greenfield Partners LLC',    1,  180000.00, 32.00, 4300.00),
('R. Okafor (individual)',     2,  120000.00, 40.00, 2700.00),
('Summit Hollow Trust',        3,  350000.00, 35.00, 7900.00),
('Summit Hollow Trust',        5,  500000.00, 20.00, 9800.00),
('Blue Heron Capital',         3,  250000.00, 25.00, 5600.00);
