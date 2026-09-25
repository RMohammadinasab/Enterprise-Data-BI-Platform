USE EnterpriseData_DW;
GO

CREATE VIEW semantic.vw_InventoryStatus
AS
SELECT
    fi.FactInventoryKey,
    d.FullDate AS SnapshotDate,
    p.ProductID,
    p.ProductName,
    p.ProductCategoryName,
    l.LocationName,
    fi.QuantityOnHand,
    fi.ReorderPoint,
    fi.SafetyStockLevel,
    fi.InventoryValue,
    fi.DaysOfSupply,
    fi.StockStatus,
    CASE
        WHEN fi.StockStatus = N'Out of Stock' THEN 100
        WHEN fi.StockStatus = N'Below Reorder Point' THEN 75
        WHEN fi.StockStatus = N'Below Safety Stock' THEN 50
        ELSE 10
    END AS StockRiskScore
FROM dw.FactInventory fi
JOIN dw.DimDate d ON d.DateKey = fi.SnapshotDateKey
JOIN dw.DimProduct p ON p.ProductKey = fi.ProductKey
JOIN dw.DimLocation l ON l.LocationKey = fi.LocationKey;
GO
