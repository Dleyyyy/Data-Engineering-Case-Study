CREATE TABLE IF NOT EXISTS warehouse.coldroomtemperatures(
    ColdRoomTemperatureID INT PRIMARY KEY,
    ColdRoomSensorNumber INT NOT NULL,
    RecordedWhen TIMESTAMP NOT NULL,
    Temperature FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.colors(
    ColorID INT PRIMARY KEY,
    ColorName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.packagetypes(
    PackageTypeID INT PRIMARY KEY,
    PackageTypeName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.stockgroups(
    StockGroupID INT PRIMARY KEY,
    StockGroupName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.stockitemholdings(
    StockItemID INT PRIMARY KEY,
    QuantityOnHand INT NOT NULL,
    BinLocation VARCHAR(20) NOT NULL,
    LastStocktakeQuantity INT NOT NULL,
    LastCostPrice FLOAT NOT NULL,
    ReorderLevel INT NOT NULL,
    TargetStockLevel INT NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.stockitems(
    StockItemID INT PRIMARY KEY,
    StockItemName VARCHAR(100) NOT NULL,
    SupplierID INT NOT NULL,
    ColorID INT,
    UnitPackageID INT NOT NULL,
    OuterPackageID INT NOT NULL,
    Brand VARCHAR(100) NULL,
    Size VARCHAR(100) NULL,
    LeadTimeDays INT NOT NULL,
    QuantityPerOuter INT NOT NULL,
    IsChillerStock BOOLEAN NOT NULL,
    Barcode VARCHAR(100),
    TaxRate FLOAT NOT NULL,
    UnitPrice FLOAT NOT NULL,
    RecommendedRetailPrice FLOAT NOT NULL,
    TypicalWeightPerUnit FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.stockitemstockgroups(
    StockItemStockGroupID INT PRIMARY KEY,
    StockItemID INT NOT NULL,
    StockGroupID INT NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.stockitemtransactions(
    StockItemTransactionID INT PRIMARY KEY,
    StockItemID INT NOT NULL,
    TransactionTypeID INT NOT NULL,
    CustomerID INT NULL,
    InvoiceID INT NULL,
    SupplierID INT NULL,
    PurchaseOrderID INT NULL,
    TransactionOccurredWhen TIMESTAMP NOT NULL,
    Quantity FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.vehicletemperatures(
    VehicleTemperatureID INT PRIMARY KEY,
    VehicleRegistration VARCHAR(20) NOT NULL,
    ChillerSensorNumber INT NOT NULL,
    RecordedWhen TIMESTAMP NOT NULL,
    Temperature FLOAT NOT NULL,
    FullSensorData TEXT
);