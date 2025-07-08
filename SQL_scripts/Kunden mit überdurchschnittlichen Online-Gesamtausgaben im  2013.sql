-- Kunden im Jahr 2013, deren Online-Gesamtausgaben (inkl. Steuern) über dem Durchschnitt aller Kunden liegen
SELECT 
    dc.FirstName + ' ' + dc.LastName AS CustomerName,             -- Vollständiger Name des Kunden
    SUM(fis.SalesAmount + fis.TaxAmt) AS TotalSpent               -- Gesamtausgaben pro Kunde (inkl. Steuern)
FROM 
    FactInternetSales fis                                         -- Faktentabelle mit Online-Verkäufen
JOIN DimCustomer dc ON fis.CustomerKey = dc.CustomerKey           -- Verknüpfung mit der Kundendimension
JOIN DimDate d ON fis.OrderDateKey = d.DateKey                    -- Verknüpfung mit der Datumstabelle
WHERE 
    d.CalendarYear = 2013                                         -- Betrachtung ausschließlich des Jahres 2014
GROUP BY 
    dc.CustomerKey, dc.FirstName, dc.LastName                     -- Gruppierung auf Kundenebene
HAVING 
    -- Filter: Nur Kunden mit Ausgaben über dem durchschnittlichen Kundenwert
    SUM(fis.SalesAmount + fis.TaxAmt) > (
        SELECT 
            -- Durchschnittliche Gesamtausgaben pro Kunde (inkl. Steuern) im Jahr 2013
            SUM(fis2.SalesAmount + fis2.TaxAmt) * 1.0 
            / COUNT(DISTINCT fis2.CustomerKey)
        FROM 
            FactInternetSales fis2
        JOIN DimDate d2 ON fis2.OrderDateKey = d2.DateKey
        WHERE 
            d2.CalendarYear = 2013
    )
ORDER BY 
    TotalSpent DESC;                                              -- Ausgabe  absteigend sortiert