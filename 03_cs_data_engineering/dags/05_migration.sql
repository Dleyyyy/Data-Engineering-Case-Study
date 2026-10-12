-- ============================================================================
-- 01. APPLICATION MIGRATION
-- ============================================================================

INSERT INTO application.transactiontypes (TransactionTypeID, TransactionTypeName)
SELECT 
    NULLIF("TransactionTypeID"::TEXT, 'NULL')::INT,
    "TransactionTypeName"
FROM raw.application_transactiontypes;

INSERT INTO application.deliverymethods (DeliveryMethodID, DeliveryMethodName)
SELECT 
    NULLIF("DeliveryMethodID"::TEXT, 'NULL')::INT, 
    "DeliveryMethodName"
FROM raw.application_deliverymethods;

INSERT INTO application.paymentmethods (PaymentMethodID, PaymentMethodName)
SELECT 
    NULLIF("PaymentMethodID"::TEXT, 'NULL')::INT, 
    "PaymentMethodName"
FROM raw.application_paymentmethods;

INSERT INTO application.countries (CountryID, CountryName, FormalName, LatestRecordedPopulation, Continent, Region, Subregion)
SELECT 
    NULLIF("CountryID"::TEXT, 'NULL')::INT,
    "CountryName",
    "FormalName",
    NULLIF("LatestRecordedPopulation"::TEXT, 'NULL')::INT,
    "Continent",
    "Region",
    "Subregion"
FROM raw.application_countries;

INSERT INTO application.stateprovinces (StateProvinceID, StateProvinceCode, StateProvinceName, CountryID, SalesTerritory, LatestRecordedPopulation)
SELECT 
    NULLIF("StateProvinceID"::TEXT, 'NULL')::INT,
    "StateProvinceCode",
    "StateProvinceName",
    NULLIF("CountryID"::TEXT, 'NULL')::INT,
    "SalesTerritory",
    NULLIF("LatestRecordedPopulation"::TEXT, 'NULL')::INT
FROM raw.application_stateprovinces;

INSERT INTO application.cities (CityID, CityName, StateProvinceID, Latitude, Longitude, LatestRecordedPopulation)
SELECT 
    NULLIF("CityID"::TEXT, 'NULL')::INT,
    "CityName",
    NULLIF("StateProvinceID"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("Latitude"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("Longitude"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("LatestRecordedPopulation"::TEXT, 'NULL')::INT
FROM raw.application_cities;

INSERT INTO application.people (PersonID, FullName, PreferredName, SearchName, IsEmployee, IsSalesPerson)
SELECT 
    NULLIF("PersonID"::TEXT, 'NULL')::INT,
    "FullName",
    "PreferredName",
    "SearchName",
    NULLIF("IsEmployee"::TEXT, 'NULL')::BOOLEAN,
    NULLIF("IsSalesperson"::TEXT, 'NULL')::BOOLEAN
FROM raw.application_people;

-- ============================================================================
-- 02. PURCHASING MIGRATION
-- ============================================================================

INSERT INTO purchasing.suppliercategories (SupplierCategoryID, SupplierCategoryName)
SELECT 
    NULLIF("SupplierCategoryID"::TEXT, 'NULL')::INT,
    "SupplierCategoryName"
FROM raw.purchasing_suppliercategories;

INSERT INTO purchasing.suppliers (SupplierID, SupplierName, SupplierCategoryID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, PostalCityID, SupplierReference, PaymentDays, PhoneNumber, WebsiteURL, DeliveryAddressLine, DeliveryLocationLat, DeliveryLocationLong)
SELECT 
    NULLIF("SupplierID"::TEXT, 'NULL')::INT,
    "SupplierName",
    NULLIF("SupplierCategoryID"::TEXT, 'NULL')::INT,
    NULLIF("PrimaryContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("AlternateContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("DeliveryMethodID"::TEXT, 'NULL')::INT,
    NULLIF("DeliveryCityID"::TEXT, 'NULL')::INT,
    NULLIF("PostalCityID"::TEXT, 'NULL')::INT,
    "SupplierReference",
    NULLIF("PaymentDays"::TEXT, 'NULL')::INT,
    "PhoneNumber",
    "WebsiteURL",
    "DeliveryAddressLine", 
    REPLACE(NULLIF("DeliveryLocationLat"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("DeliveryLocationLong"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.purchasing_suppliers;

INSERT INTO purchasing.purchaseorders (PurchaseOrderID, SupplierID, OrderDate, ContactPersonID, ExpectedDeliveryDate, SupplierReference, IsOrderFinalized)
SELECT 
    NULLIF("PurchaseOrderID"::TEXT, 'NULL')::INT,
    NULLIF("SupplierID"::TEXT, 'NULL')::INT,
    NULLIF("OrderDate"::TEXT, 'NULL')::TIMESTAMP,
    NULLIF("ContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("ExpectedDeliveryDate"::TEXT, 'NULL')::TIMESTAMP,
    "SupplierReference",
    NULLIF("IsOrderFinalized"::TEXT, 'NULL')::BOOLEAN
FROM raw.purchasing_purchaseorders;

INSERT INTO purchasing.purchaseorderlines (PurchaseOrderLineID, PurhaseOrderID, StockItemID, OrderedOuters, Description, ReceivedOuters, PackageTypeID, ExpectedUnitPricePerOuter, LastReceiptDate, IsOrderLineFinalized)
SELECT 
    NULLIF("PurchaseOrderLineID"::TEXT, 'NULL')::INT,
    NULLIF("PurchaseOrderID"::TEXT, 'NULL')::INT,
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    NULLIF("OrderedOuters"::TEXT, 'NULL')::INT,
    "Description",
    NULLIF("ReceivedOuters"::TEXT, 'NULL')::INT,
    NULLIF("PackageTypeID"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("ExpectedUnitPricePerOuter"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("LastReceiptDate"::TEXT, 'NULL')::TIMESTAMP,
    NULLIF("IsOrderLineFinalized"::TEXT, 'NULL')::BOOLEAN
FROM raw.purchasing_purchaseorderlines;

INSERT INTO purchasing.suppliertransactions (SupplierTransactionID, SupplierID, TransactionTypeID, PurchaseOrderID, PaymentMethodID, SupplierInvoiceNumber, TransactionDate, AmountExcludingTax, TaxAmount, TransactionAmount, OutstandingBalance, FinalizationDate, IsFinalized)
SELECT 
    NULLIF("SupplierTransactionID"::TEXT, 'NULL')::INT,
    NULLIF("SupplierID"::TEXT, 'NULL')::INT,
    NULLIF("TransactionTypeID"::TEXT, 'NULL')::INT,
    NULLIF("PurchaseOrderID"::TEXT, 'NULL')::INT,
    NULLIF("PaymentMethodID"::TEXT, 'NULL')::INT,
    "SupplierInvoiceNumber",
    NULLIF("TransactionDate"::TEXT, 'NULL')::TIMESTAMP,
    REPLACE(NULLIF("AmountExcludingTax"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TaxAmount"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TransactionAmount"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("OutstandingBalance"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("FinalizationDate"::TEXT, 'NULL')::DATE,
    NULLIF("IsFinalized"::TEXT, 'NULL')::BOOLEAN
FROM raw.purchasing_suppliertransactions;

-- ============================================================================
-- 03. WAREHOUSE MIGRATION
-- ============================================================================

INSERT INTO warehouse.colors (ColorID, ColorName)
SELECT 
    NULLIF("ColorID"::TEXT, 'NULL')::INT, 
    "ColorName"
FROM raw.warehouse_colors;

INSERT INTO warehouse.packagetypes (PackageTypeID, PackageTypeName)
SELECT 
    NULLIF("PackageTypeID"::TEXT, 'NULL')::INT, 
    "PackageTypeName"
FROM raw.warehouse_packagetypes;

INSERT INTO warehouse.stockgroups (StockGroupID, StockGroupName)
SELECT 
    NULLIF("StockGroupID"::TEXT, 'NULL')::INT, 
    "StockGroupName"
FROM raw.warehouse_stockgroups;

INSERT INTO warehouse.stockitems (StockItemID, StockItemName, SupplierID, ColorID, UnitPackageID, OuterPackageID, Brand, Size, LeadTimeDays, QuantityPerOuter, IsChillerStock, Barcode, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit)
SELECT 
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    "StockItemName",
    NULLIF("SupplierID"::TEXT, 'NULL')::INT,
    NULLIF("ColorID"::TEXT, 'NULL')::INT,
    NULLIF("UnitPackageID"::TEXT, 'NULL')::INT,
    NULLIF("OuterPackageID"::TEXT, 'NULL')::INT,
    NULLIF("Brand"::TEXT, 'NULL'),
    NULLIF("Size"::TEXT, 'NULL'),
    NULLIF("LeadTimeDays"::TEXT, 'NULL')::INT,
    NULLIF("QuantityPerOuter"::TEXT, 'NULL')::INT,
    NULLIF("IsChillerStock"::TEXT, 'NULL')::BOOLEAN,
    "Barcode",
    REPLACE(NULLIF("TaxRate"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("UnitPrice"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("RecommendedRetailPrice"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TypicalWeightPerUnit"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.warehouse_stockitems;

INSERT INTO warehouse.stockitemholdings (StockItemID, QuantityOnHand, BinLocation, LastStocktakeQuantity, LastCostPrice, ReorderLevel, TargetStockLevel)
SELECT 
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    NULLIF("QuantityOnHand"::TEXT, 'NULL')::INT,
    "BinLocation",
    NULLIF("LastStocktakeQuantity"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("LastCostPrice"::TEXT, 'NULL'), ',', '.')::NUMERIC(18,2),
    NULLIF("ReorderLevel"::TEXT, 'NULL')::INT,
    NULLIF("TargetStockLevel"::TEXT, 'NULL')::INT
FROM raw.warehouse_stockitemholdings;

INSERT INTO warehouse.stockitemstockgroups (StockItemStockGroupID, StockItemID, StockGroupID)
SELECT 
    NULLIF("StockItemStockGroupID"::TEXT, 'NULL')::INT,
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    NULLIF("StockGroupID"::TEXT, 'NULL')::INT
FROM raw.warehouse_stockitemstockgroups;

INSERT INTO warehouse.stockitemtransactions (StockItemTransactionID, StockItemID, TransactionTypeID, CustomerID, InvoiceID, SupplierID, PurchaseOrderID, TransactionOccurredWhen, Quantity)
SELECT 
    NULLIF("StockItemTransactionID"::TEXT, 'NULL')::INT,
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    NULLIF("TransactionTypeID"::TEXT, 'NULL')::INT,
    NULLIF("CustomerID"::TEXT, 'NULL')::INT,
    NULLIF("InvoiceID"::TEXT, 'NULL')::INT,
    NULLIF("SupplierID"::TEXT, 'NULL')::INT,
    NULLIF("PurchaseOrderID"::TEXT, 'NULL')::INT,
    NULLIF("TransactionOccurredWhen"::TEXT, 'NULL')::TIMESTAMP,
    REPLACE(NULLIF("Quantity"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.warehouse_stockitemtransactions;

INSERT INTO warehouse.coldroomtemperatures (ColdRoomTemperatureID, ColdRoomSensorNumber, RecordedWhen, Temperature)
SELECT 
    NULLIF("ColdRoomTemperatureID"::TEXT, 'NULL')::INT,
    NULLIF("ColdRoomSensorNumber"::TEXT, 'NULL')::INT,
    NULLIF("RecordedWhen"::TEXT, 'NULL')::TIMESTAMP,
    REPLACE(NULLIF("Temperature"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.warehouse_coldroomtemperatures;

INSERT INTO warehouse.vehicletemperatures (VehicleTemperatureID, VehicleRegistration, ChillerSensorNumber, RecordedWhen, Temperature, FullSensorData)
SELECT 
    NULLIF("VehicleTemperatureID"::TEXT, 'NULL')::INT,
    "VehicleRegistration",
    NULLIF("ChillerSensorNumber"::TEXT, 'NULL')::INT,
    NULLIF("RecordedWhen"::TEXT, 'NULL')::TIMESTAMP,
    REPLACE(NULLIF("Temperature"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("FullSensorData"::TEXT, 'NULL')::TEXT
FROM raw.warehouse_vehicletemperatures;

-- ============================================================================
-- 04. SALES MIGRATION
-- ============================================================================

INSERT INTO sales.buyinggroups (BuyingGroupID, BuyingGroupName)
SELECT 
    NULLIF("BuyingGroupID"::TEXT, 'NULL')::INT, 
    "BuyingGroupName"
FROM raw.sales_buyinggroups;

INSERT INTO sales.customercategories (CustomerCategoryID, CustomerCategoryName)
SELECT 
    NULLIF("CustomerCategoryID"::TEXT, 'NULL')::INT, 
    "CustomerCategoryName"
FROM raw.sales_customercategories;

INSERT INTO sales.customers (CustomerID, CustomerName, BillToCustomerID, CustomerCategoryID, BuyingGroupID, PrimaryContactPersonID, AlternateContactPersonID, DeliveryMethodID, DeliveryCityID, CreditLimit, AccountOpenedDate, StandardDiscountPercentage, IsStatementSent, IsOnCreditHold, PaymentDays, PhoneNumber, WebsiteURL, DeliveryAddressLine, deliveryLocationLat, DeliveryLocationLong)
SELECT 
    NULLIF("CustomerID"::TEXT, 'NULL')::INT,
    "CustomerName",
    NULLIF("BillToCustomerID"::TEXT, 'NULL')::INT,
    NULLIF("CustomerCategoryID"::TEXT, 'NULL')::INT,
    NULLIF("BuyingGroupID"::TEXT, 'NULL')::INT,
    NULLIF("PrimaryContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("AlternateContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("DeliveryMethodID"::TEXT, 'NULL')::INT,
    NULLIF("DeliveryCityID"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("CreditLimit"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("AccountOpenedDate"::TEXT, 'NULL')::TIMESTAMP,
    REPLACE(NULLIF("StandardDiscountPercentage"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("IsStatementSent"::TEXT, 'NULL')::BOOLEAN,
    NULLIF("IsOnCreditHold"::TEXT, 'NULL')::BOOLEAN,
    NULLIF("PaymentDays"::TEXT, 'NULL')::INT,
    "PhoneNumber",
    "WebsiteURL",
    "DeliveryAddressLine",
    REPLACE(NULLIF("DeliveryLocationLat"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("DeliveryLocationLong"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.sales_customers;

INSERT INTO sales.orders (OrderID, CustomerID, SalespersonPersonID, PickerByPersonID, ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate, CustomerPurchaseOrderNumber, IsUndersupplyBackordered, PickingCompletedWhen)
SELECT 
    NULLIF("OrderID"::TEXT, 'NULL')::INT,
    NULLIF("CustomerID"::TEXT, 'NULL')::INT,
    NULLIF("SalespersonPersonID"::TEXT, 'NULL')::INT,
    NULLIF("PickedByPersonID"::TEXT, 'NULL')::INT,
    NULLIF("ContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("BackorderOrderID"::TEXT, 'NULL')::INT,
    NULLIF("OrderDate"::TEXT, 'NULL')::TIMESTAMP,
    NULLIF("ExpectedDeliveryDate"::TEXT, 'NULL')::TIMESTAMP,
    "CustomerPurchaseOrderNumber",
    NULLIF("IsUndersupplyBackordered"::TEXT, 'NULL')::BOOLEAN,
    NULLIF("PickingCompletedWhen"::TEXT, 'NULL')::TIMESTAMP
FROM raw.sales_orders;

INSERT INTO sales.orderlines (OrderLineID, OrderID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, PickedQuantity, PickingCompletedWhen)
SELECT 
    NULLIF("OrderLineID"::TEXT, 'NULL')::INT,
    NULLIF("OrderID"::TEXT, 'NULL')::INT,
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    "Description",
    NULLIF("PackageTypeID"::TEXT, 'NULL')::INT,
    NULLIF("Quantity"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("UnitPrice"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TaxRate"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("PickedQuantity"::TEXT, 'NULL')::INT,
    NULLIF("PickingCompletedWhen"::TEXT, 'NULL')::TIMESTAMP
FROM raw.sales_orderlines;

INSERT INTO sales.invoices (InvoiceID, CustomerID, BillToCustomerID, OrderID, DeliveryMethodID, ContactPersonID, AccountsPersonID, SalespersonPersonID, PackedByPersonID, InvoiceDate, CustomerPurchaseOrderNumber, DeliveryInstructions, TotalDryItems, TotalChillerItems, ConfirmedDeliveryTime, ConfirmedReceivedBy)
SELECT 
    NULLIF("InvoiceID"::TEXT, 'NULL')::INT,
    NULLIF("CustomerID"::TEXT, 'NULL')::INT,
    NULLIF("BillToCustomerID"::TEXT, 'NULL')::INT,
    NULLIF("OrderID"::TEXT, 'NULL')::INT,
    NULLIF("DeliveryMethodID"::TEXT, 'NULL')::INT,
    NULLIF("ContactPersonID"::TEXT, 'NULL')::INT,
    NULLIF("AccountsPersonID"::TEXT, 'NULL')::INT,
    NULLIF("SalespersonPersonID"::TEXT, 'NULL')::INT,
    NULLIF("PackedByPersonID"::TEXT, 'NULL')::INT,
    NULLIF("InvoiceDate"::TEXT, 'NULL')::TIMESTAMP,
    "CustomerPurchaseOrderNumber",
    "DeliveryInstructions",
    REPLACE(NULLIF("TotalDryItems"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TotalChillerItems"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("ConfirmedDeliveryTime"::TEXT, 'NULL')::TIMESTAMP,
    "ConfirmedReceivedBy"
FROM raw.sales_invoices;

INSERT INTO sales.invoicelines (InvoiceLineID, InvoiceID, StockItemID, Description, PackageTypeID, Quantity, UnitPrice, TaxRate, TaxAmount, LineProfit, ExtendedPrice)
SELECT 
    NULLIF("InvoiceLineID"::TEXT, 'NULL')::INT,
    NULLIF("InvoiceID"::TEXT, 'NULL')::INT,
    NULLIF("StockItemID"::TEXT, 'NULL')::INT,
    "Description",
    NULLIF("PackageTypeID"::TEXT, 'NULL')::INT,
    NULLIF("Quantity"::TEXT, 'NULL')::INT,
    REPLACE(NULLIF("UnitPrice"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TaxRate"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TaxAmount"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("LineProfit"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("ExtendedPrice"::TEXT, 'NULL'), ',', '.')::FLOAT
FROM raw.sales_invoicelines;

INSERT INTO sales.customertransactions (CustomerTransactionID, CustomerID, TransactionTypeID, InvoiceID, PaymentMethodID, TransactionDate, AmountExcludingTax, TaxAmount, TransactionAmount, OutstandingBalance, FinalizationDate, IsFinalized)
SELECT 
    NULLIF("CustomerTransactionID"::TEXT, 'NULL')::INT,
    NULLIF("CustomerID"::TEXT, 'NULL')::INT,
    NULLIF("TransactionTypeID"::TEXT, 'NULL')::INT,
    NULLIF("InvoiceID"::TEXT, 'NULL')::INT,
    NULLIF("PaymentMethodID"::TEXT, 'NULL')::INT,
    NULLIF("TransactionDate"::TEXT, 'NULL')::DATE,
    REPLACE(NULLIF("AmountExcludingTax"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TaxAmount"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("TransactionAmount"::TEXT, 'NULL'), ',', '.')::FLOAT,
    REPLACE(NULLIF("OutstandingBalance"::TEXT, 'NULL'), ',', '.')::FLOAT,
    NULLIF("FinalizationDate"::TEXT, 'NULL')::DATE,
    NULLIF("IsFinalized"::TEXT, 'NULL')::BOOLEAN
FROM raw.sales_customertransactions;