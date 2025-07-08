-- Umsatzanalyse nach Produktkategorie und Subkategorie im Jahr 2013 inklusive Gesamtsummen und Prozentanteilen

-- CTE "CategorySubcategoryRevenue": Berechnet den Umsatz (inkl. Steuern) je Produktkategorie und Subkategorie für das Jahr 2013
WITH CategorySubcategoryRevenue AS (
    SELECT
        dpc.EnglishProductCategoryName AS ProductCategory,          -- Name der Produktkategorie (z. B. Bikes)
        dpsc.EnglishProductSubcategoryName AS ProductSubcategory,   -- Name der Produktsubkategorie (z. B. Mountain Bikes)
        SUM(fis.SalesAmount + fis.TaxAmt) AS TotalRevenue           -- Umsatz inkl. Steuern für diese Kombination
    FROM
        FactInternetSales fis
    JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey                            -- Verbindung zur Produkttabelle
    JOIN DimProductSubcategory dpsc ON dp.ProductSubcategoryKey = dpsc.ProductSubcategoryKey -- Verbindung zur Subkategorie
    JOIN DimProductCategory dpc ON dpsc.ProductCategoryKey = dpc.ProductCategoryKey           -- Verbindung zur Hauptkategorie
    JOIN DimDate d ON fis.OrderDateKey = d.DateKey                                  -- Verbindung zur Datumstabelle
    WHERE
        d.CalendarYear = 2013                                                       -- Filter auf das Jahr 2013
    GROUP BY
        dpc.EnglishProductCategoryName,                                             -- Gruppierung nach Kategorie
        dpsc.EnglishProductSubcategoryName                                          -- und Subkategorie
),

-- CTE "OverallRevenue": Berechnet den gesamten Umsatz über alle Kategorien/Subkategorien
OverallRevenue AS (
    SELECT
        SUM(TotalRevenue) AS GrandTotalRevenue         -- Gesamtumsatz über alle Gruppen hinweg
    FROM
        CategorySubcategoryRevenue
)

-- Hauptabfrage: Gibt Umsätze, Gesamtsummen und Prozentanteile je Subkategorie/Kategorie aus
SELECT
    ISNULL(ProductCategory, 'Grand Total') AS ProductCategory,              -- NULL = Gesamtsumme über alle Kategorien
    ISNULL(ProductSubcategory, 'Total for Category') AS ProductSubcategory, -- NULL = Gesamtsumme je Kategorie
    SUM(TotalRevenue) AS TotalRevenue,                                      -- Aggregierter Umsatz (Detail- oder Gesamtebene)
    FORMAT(
        SUM(TotalRevenue) * 100.0 / (SELECT GrandTotalRevenue FROM OverallRevenue), -- Prozentanteil am Gesamtumsatz
        'N2'
    ) + ' %' AS RevenuePercent                                              -- Prozentwert mit 2 Nachkommastellen und %‑Zeichen
FROM
    CategorySubcategoryRevenue
GROUP BY
    ROLLUP(ProductCategory, ProductSubcategory)                             -- Hierarchische Gruppierung mit automatischen Totalzeilen
ORDER BY
    GROUPING(ProductCategory),                                              -- 'Grand Total' am Ende
    ProductCategory,
    GROUPING(ProductSubcategory),
    TotalRevenue DESC;                                                     -- Absteigend nach Umsatz innerhalb der Gruppen