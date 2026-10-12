CREATE TABLE IF NOT EXISTS purchasing.purchaseorderlines(
    PurchaseOrderLineID INT PRIMARY KEY,
    PurhaseOrderID INT NOT NULL,
    StockItemID INT NOT NULL,
    OrderedOuters INT NOT NULL,
    Description VARCHAR(100) NOT NULL,
    ReceivedOuters INT NOT NULL,
    PackageTypeID INT NOT NULL,
    ExpectedUnitPricePerOuter FLOAT NOT NULL,
    LastReceiptDate TIMESTAMP,
    IsOrderLineFinalized BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS purchasing.purchaseorders(
    PurchaseOrderID INT PRIMARY KEY,
    SupplierID INT NOT NULL,
    OrderDate TIMESTAMP NOT NULL,
    ContactPersonID INT NOT NULL,
    ExpectedDeliveryDate TIMESTAMP NOT NULL,
    SupplierReference VARCHAR(100) NOT NULL,
    IsOrderFinalized BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS purchasing.suppliercategories(
    SupplierCategoryID INT PRIMARY KEY,
    SupplierCategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS purchasing.suppliers(
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierCategoryID INT NOT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NOT NULL,
    DeliveryMethodID INT NULL,
    DeliveryCityID INT NULL,
    PostalCityID INT NULL,
    SupplierReference VARCHAR(100) NOT NULL,
    PaymentDays INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    WebsiteURL VARCHAR(100) NOT NULL,
    DeliveryAddressLine VARCHAR(100) NOT NULL,
    DeliveryLocationLat FLOAT NOT NULL,
    DeliveryLocationLong FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS purchasing.suppliertransactions(
    SupplierTransactionID INT PRIMARY KEY,
    SupplierID INT NOT NULL,
    TransactionTypeID INT NOT NULL,
    PurchaseOrderID INT,
    PaymentMethodID INT NOT NULL,
    SupplierInvoiceNumber VARCHAR(100),
    TransactionDate TIMESTAMP NOT NULL,
    AmountExcludingTax FLOAT NOT NULL,
    TaxAmount FLOAT NOT NULL,
    TransactionAmount FLOAT NOT NULL,
    OutstandingBalance FLOAT NOT NULL,
    FinalizationDate DATE,
    IsFinalized BOOLEAN NOT NULL
);