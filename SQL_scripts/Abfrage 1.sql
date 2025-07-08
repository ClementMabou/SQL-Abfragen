-- Gesamtmenge und Gesamtumsatz (inkl. Steuern) gruppiert nach Verkaufsjahr berechnen
SELECT 
    YEAR(OrderDate) AS SalesYear,                     -- Extrahiert das Verkaufsjahr aus dem Bestelldatum
    SUM(OrderQuantity) AS TotalQuantity,              -- Gesamtanzahl der verkauften Artikel pro Jahr
    SUM(SalesAmount + TaxAmt) AS TotalRevenue         -- Gesamtumsatz inkl. Steuern pro Jahr
FROM 
    FactInternetSales                                 -- Faktentabelle mit allen Online-Verkäufen
GROUP BY 
    YEAR(OrderDate)                                   -- Gruppiert die Ergebnisse nach Verkaufsjahr
ORDER BY 
    SalesYear;                                        -- Sortiert die Ausgabe chronologisch nach Jahr