function [cost] = CuttingCost(x, PieceDemands, StockLength)
    % x: Ordering keys produced by algorithm
    % PieceDemands: Fixed data from Main

    [~, OrderIndex] = sort(x);
    SortedPieces = PieceDemands(OrderIndex);

    [UsedStockCount, StockFullness] = FirstFit(SortedPieces, StockLength);

    TotalPieceLength = sum(StockFullness);
    TotalCapacity = UsedStockCount * StockLength;
    RealWaste = TotalCapacity - TotalPieceLength;

    cost = UsedStockCount * 1000 + RealWaste;
end
