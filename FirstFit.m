function [StockCount, StockFullness, StockList] = FirstFit(PieceOrder, StockLength)
    StockList = {};      % Which pieces are in which stock
    StockList{1} = [];
    RemainingStocks = StockLength;
    StockCount = 1;

    for i = 1:length(PieceOrder)
        Piece = PieceOrder(i);
        Placed = false;

        for j = 1:StockCount
            if RemainingStocks(j) >= Piece
                RemainingStocks(j) = RemainingStocks(j) - Piece;
                StockList{j} = [StockList{j}, Piece]; % Save details
                Placed = true;
                break;
            end
        end

        if Placed == false
            StockCount = StockCount + 1;
            RemainingStocks(StockCount) = StockLength - Piece;
            StockList{StockCount} = [Piece];
        end
    end

    StockFullness = StockLength - RemainingStocks;
end
