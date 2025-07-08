/*
Monatliche online Bestellanzahlen,Bestellmengen  und Umsätze über Jahren.
*/
SELECT
    d.CalendarYear AS SalesYear,                         -- Verkaufsjahr, z.B. 2014
    d.MonthNumberOfYear AS SalesMonth,                   -- Verkaufsmonat (1–12)
    COUNT(DISTINCT fis.SalesOrderNumber) AS NumberOfOrders,  -- Anzahl eindeutiger Bestellungen im Zeitraum
    SUM(fis.OrderQuantity) AS TotalOrderQuantity,           -- Gesamtmenge der bestellten Produkte
    SUM(fis.SalesAmount + fis.TaxAmt) AS TotalRevenue       -- Gesamtumsatz inkl. Steuern für den Zeitraum
FROM
    FactInternetSales AS fis                               -- Faktentabelle mit allen Internetverkäufen
JOIN
    DimDate AS d ON fis.OrderDateKey = d.DateKey          -- Verbindung zur Datumstabelle über OrderDateKey,
                                                         -- um Zeitdimensionen (Jahr, Monat) abzufragen
GROUP BY
    d.CalendarYear,                                       -- Gruppierung nach Verkaufsjahr
    d.MonthNumberOfYear                                  -- Gruppierung nach Verkaufsmonat
ORDER BY
    SalesYear ASC,                                        -- Sortierung aufsteigend nach Jahr
    SalesMonth ASC;                                       -- Sortierung aufsteigend nach Monat innerhalb des Jahres