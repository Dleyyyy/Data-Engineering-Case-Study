CREATE TABLE IF NOT EXISTS sales.buyinggroups(
    BuyingGroupID INT PRIMARY KEY,
    BuyingGroupName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.customercategories(
    CustomerCategoryID INT PRIMARY KEY,
    CustomerCategoryName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.customers(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    BillToCustomerID INT NULL,
    CustomerCategoryID INT NOT NULL,
    BuyingGroupID INT NULL,
    PrimaryContactPersonID INT NOT NULL,
    AlternateContactPersonID INT NULL,
    DeliveryMethodID INT NULL,
    DeliveryCityID INT NULL,
    CreditLimit FLOAT NULL,
    AccountOpenedDate TIMESTAMP NOT NULL,
    StandardDiscountPercentage FLOAT NOT NULL,
    IsStatementSent BOOLEAN NOT NULL,
    IsOnCreditHold BOOLEAN NOT NULL,
    PaymentDays INT NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    WebsiteURL VARCHAR(100) NOT NULL,
    DeliveryAddressLine VARCHAR(100) NOT NULL,
    deliveryLocationLat FLOAT NOT NULL,
    DeliveryLocationLong FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.customertransactions(
    CustomerTransactionID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionTypeID INT NOT NULL,
    InvoiceID INT NULL,
    PaymentMethodID INT NULL,
    TransactionDate DATE NOT NULL,
    AmountExcludingTax FLOAT NOT NULL,
    TaxAmount FLOAT NOT NULL,
    TransactionAmount FLOAT NOT NULL,
    OutstandingBalance FLOAT NOT NULL,
    FinalizationDate DATE,
    IsFinalized BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.invoicelines(
    InvoiceLineID INT PRIMARY KEY,
    InvoiceID INT NOT NULL,
    StockItemID INT NOT NULL,
    Description VARCHAR(100) NOT NULL,
    PackageTypeID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice FLOAT NOT NULL,
    TaxRate FLOAT NOT NULL,
    TaxAmount FLOAT NOT NULL,
    LineProfit FLOAT NOT NULL,
    ExtendedPrice FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS sales.invoices(
    InvoiceID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BillToCustomerID INT NOT NULL,
    OrderID INT NOT NULL,
    DeliveryMethodID INT NOT NULL,
    ContactPersonID INT NOT NULL,
    AccountsPersonID INT NOT NULL,
    SalespersonPersonID INT NOT NULL,
    PackedByPersonID INT NOT NULL,
    InvoiceDate TIMESTAMP NOT NULL,
    CustomerPurchaseOrderNumber VARCHAR(100) NOT NULL,
    DeliveryInstructions VARCHAR(100) NOT NULL,
    TotalDryItems FLOAT NOT NULL,
    TotalChillerItems FLOAT NOT NULL,
    ConfirmedDeliveryTime TIMESTAMP,
    ConfirmedReceivedBy VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS sales.orderlines(
    OrderLineID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    StockItemID INT NOT NULL,
    Description VARCHAR(100) NOT NULL,
    PackageTypeID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice FLOAT NOT NULL,
    TaxRate FLOAT NOT NULL,
    PickedQuantity INT NOT NULL,
    PickingCompletedWhen TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales.orders(
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    SalespersonPersonID INT NOT NULL,
    PickerByPersonID INT,
    ContactPersonID INT NOT NULL,
    BackorderOrderID INT NULL,
    OrderDate TIMESTAMP NOT NULL,
    ExpectedDeliveryDate TIMESTAMP NOT NULL,
    CustomerPurchaseOrderNumber VARCHAR(100) NOT NULL,
    IsUndersupplyBackordered BOOLEAN NOT NULL,
    PickingCompletedWhen TIMESTAMP
);
