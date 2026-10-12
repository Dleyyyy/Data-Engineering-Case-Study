CREATE TABLE IF NOT EXISTS application.cities(
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL,
    StateProvinceID INT NOT NULL,
    Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
    LatestRecordedPopulation INT
);

CREATE TABLE IF NOT EXISTS application.countries(
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL,
    FormalName VARCHAR(100) NOT NULL,
    LatestRecordedPopulation INT,
    Continent VARCHAR(50) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Subregion VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS application.deliverymethods(
    DeliveryMethodID INT PRIMARY KEY,
    DeliveryMethodName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS application.paymentmethods(
    PaymentMethodID INT PRIMARY KEY,
    PaymentMethodName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS application.people(
    PersonID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    PreferredName VARCHAR(100) NOT NULL,
    SearchName VARCHAR(100) NOT NULL,
    IsEmployee BOOLEAN NOT NULL,
    IsSalesPerson BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS application.stateprovinces(
    StateProvinceID INT PRIMARY KEY,
    StateProvinceCode VARCHAR(10) NOT NULL,
    StateProvinceName VARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,
    SalesTerritory VARCHAR(100) NOT NULL,
    LatestRecordedPopulation INT
);

CREATE TABLE IF NOT EXISTS application.transactiontypes(
    TransactionTypeID INT PRIMARY KEY,
    TransactionTypeName VARCHAR(100) NOT NULL
);
