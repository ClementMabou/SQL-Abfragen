/*
Online-Verkäufe nach Region und Land mit Bestellanzahl, Menge und Umsatz im 2013.
*/

SELECT
    dst.SalesTerritoryGroup AS SalesRegion,                   -- Übergeordnete Region (z. B. Europe, North America)
    dst.SalesTerritoryCountry AS SalesTerritoryName,           -- Verkaufsland (z. B. United States, Germany)
    COUNT(DISTINCT fis.SalesOrderNumber) AS NumberOfOrders,    -- Anzahl eindeutiger Bestellungen
    SUM(fis.OrderQuantity) AS TotalOrderQuantity,              -- Gesamtmenge der bestellten Produkte
    SUM(fis.SalesAmount + fis.TaxAmt) AS TotalRevenue          -- Gesamtumsatz inkl. Steuern
FROM
    FactInternetSales fis                                      -- Faktentabelle mit Internetverkäufen
JOIN
    DimSalesTerritory dst ON fis.SalesTerritoryKey = dst.SalesTerritoryKey -- Verknüpfung mit Verkaufsgebiet
JOIN
    DimDate d ON fis.OrderDateKey = d.DateKey                  -- Verknüpfung mit Datumstabelle zur Filterung nach Jahr
WHERE
    d.CalendarYear = 2013                                      -- Betrachtung nur für das Jahr 2013
GROUP BY
    dst.SalesTerritoryGroup,                                  -- Gruppierung nach Region
    dst.SalesTerritoryCountry                                  -- Gruppierung nach Verkaufsland
ORDER BY
    TotalRevenue DESC;                                         -- Sortierung nach Umsatz in absteigender Reihenfolge