-- Analyse der meistverkauften Produkte nach Umsatz (inkl. Steuern)
SELECT Top 5
    dp.EnglishProductName AS ProductName,                  -- Produktname
    SUM(fis.OrderQuantity) AS TotalQuantitySold,           -- Gesamtstückzahl der Verkäufe
    SUM(fis.SalesAmount + fis.TaxAmt) AS TotalRevenue      -- Gesamtumsatz inkl. Steuern
FROM
    FactInternetSales fis                                  -- Faktentabelle für Online-Verkäufe
JOIN
    DimProduct dp ON fis.ProductKey = dp.ProductKey        -- Verknüpfung mit Produkttabelle
GROUP BY
    dp.EnglishProductName                                  -- Gruppierung nach Produkt
ORDER BY
    TotalRevenue DESC                                      -- Absteigend nach Umsatz sortieren
;
