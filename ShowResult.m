function ShowResult(Best_pos, Best_score, HO_curve, PieceDemands, StockLength)
    % --- RESULT VISUALIZATION FUNCTION (FIXED & IMPROVED) ---

    % 1. DECODE THE BEST ORDERING
    [~, OrderIndex] = sort(Best_pos);
    SortedPieces = PieceDemands(OrderIndex);

    % 2. REPEAT PLACEMENT PROCESS AND RECORD
    Stocks = {};
    Stocks{1} = [];
    CurrentStock = 1;
    StockAssignments = zeros(1, length(PieceDemands));

    for i = 1:length(SortedPieces)
        Piece = SortedPieces(i);
        Placed = false;

        % Check existing stocks
        for j = 1:CurrentStock
            if (StockLength - sum(Stocks{j})) >= Piece
                Stocks{j} = [Stocks{j}, Piece];
                StockAssignments(i) = j;
                Placed = true;
                break;
            end
        end

        % If not placed, open new stock
        if ~Placed
            CurrentStock = CurrentStock + 1;
            Stocks{CurrentStock} = [Piece];
            StockAssignments(i) = CurrentStock;
        end
    end

    % 3. PRINT RESULTS TO SCREEN
    fprintf('\n=== VISUALIZATION RESULTS ===\n');
    fprintf('Total Stock Count: %d\n', CurrentStock);
    fprintf('Algorithm Cost: %.0f\n', Best_score);

    TotalWaste = 0;
    for k = 1:CurrentStock
        Fullness = sum(Stocks{k});
        Waste = StockLength - Fullness;
        TotalWaste = TotalWaste + Waste;
    end

    fprintf('\nTotal Waste: %d\n', TotalWaste);
    fprintf('Average Efficiency: %.2f%%\n', ...
        ((CurrentStock*StockLength - TotalWaste)/(CurrentStock*StockLength))*100);

    % 4. CONVERGENCE CURVE GRAPH
    figure('Name', 'Optimization Process', 'Color', 'w');
    plot(1:length(HO_curve), HO_curve, 'b-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Cost');
    title('Hippopotamus Algorithm - Convergence Curve');
    grid on;

    % 5. CUTTING PLAN GRAPH (Bar Chart) - VISUAL FIXES APPLIED
    figure('Name', 'Cutting Plan and Waste', 'Color', 'w', 'Position', [100, 100, 1200, 700]); % Height increased
    hold on;

    % Title Updated
    title(sprintf('Cutting Plan - %d Stocks, %.1f%% Efficiency', ...
        CurrentStock, ((CurrentStock*StockLength - TotalWaste)/(CurrentStock*StockLength))*100), ...
        'FontSize', 12, 'FontWeight', 'bold');

    ylabel('Fullness (Units)');

    % Fix X-Axis Limits
    if CurrentStock <= 20
        xlim([0, CurrentStock + 1]);
        stockWidth = 0.8;
    else
        xlim([0, 21]);
        stockWidth = 0.6;
    end

    % Fix Y-Axis Limits (Add 15% headroom for top labels)
    ylim([0, StockLength * 1.15]);

    ColorFull = [0.2, 0.6, 0.8];
    ColorWaste = [0.9, 0.3, 0.3];

    showStocks = min(CurrentStock, 20);
    xLabels = cell(1, showStocks); % Prepare cell array for labels

    for k = 1:showStocks
        Pieces = Stocks{k};
        Height = 0;

        % Store Label for X-Axis (Instead of manual text)
        xLabels{k} = sprintf('Stock %d', k);

        % Draw each piece in the stock
        for p = 1:length(Pieces)
            p_size = Pieces(p);

            rectangle('Position', [k-0.4, Height, stockWidth, p_size], ...
                      'FaceColor', ColorFull, 'EdgeColor', 'k', 'LineWidth', 1);

            if p_size > 8
                text(k-0.4+stockWidth/2, Height + p_size/2, num2str(p_size), ...
                     'HorizontalAlignment', 'center', 'Color', 'w', ...
                     'FontWeight', 'bold', 'FontSize', 8);
            end

            Height = Height + p_size;
        end

        % Draw waste area (if any)
        WasteAmount = StockLength - Height;
        if WasteAmount > 0
            rectangle('Position', [k-0.4, Height, stockWidth, WasteAmount], ...
                      'FaceColor', ColorWaste, 'EdgeColor', 'k', 'LineWidth', 1);

            if WasteAmount > 5
                text(k-0.4+stockWidth/2, Height + WasteAmount/2, ...
                    sprintf('%d\n(%.0f%%)', WasteAmount, (WasteAmount/StockLength)*100), ...
                    'HorizontalAlignment', 'center', 'Color', 'w', ...
                    'FontSize', 7, 'FontWeight', 'bold');
            end
        end

        % Add stock fullness percentage at the top
        fullnessPercentage = (sum(Pieces) / StockLength) * 100;
        text(k-0.4+stockWidth/2, StockLength + 2, sprintf('%.1f%%', fullnessPercentage), ...
             'HorizontalAlignment', 'center', 'FontSize', 8, 'FontWeight', 'bold', 'BackgroundColor', 'w');
    end

    % --- FIX: PROPER X-AXIS LABELS ---
    % Remove default ticks and set custom labels properly
    xticks(1:showStocks);
    xticklabels(xLabels);
    xtickangle(45); % Rotate 45 degrees to prevent overlap

    if CurrentStock > 20
        text(10, StockLength + 10, ...
            sprintf('Note: Total %d stocks, only first 20 shown', CurrentStock), ...
            'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'red');
    end

    % --- FIX: LEGEND POSITION ---
    % Moved to 'southoutside' (bottom) to avoid overlap with title
    h1 = plot(nan, nan, 's', 'MarkerSize', 10, ...
        'MarkerFaceColor', ColorFull, 'MarkerEdgeColor', 'k');
    h2 = plot(nan, nan, 's', 'MarkerSize', 10, ...
        'MarkerFaceColor', ColorWaste, 'MarkerEdgeColor', 'k');
    legend([h1, h2], {'Cut Piece', 'Waste (Space)'}, ...
        'Location', 'southoutside', 'Orientation', 'horizontal', 'FontSize', 10);

    grid on;
    box on;
    hold off;

    % 6. ADDITIONAL GRAPH: Piece Distribution
    figure('Name', 'Piece Distribution Analysis', 'Color', 'w');

    subplot(2,2,1);
    hist(PieceDemands, 10);
    title('Piece Lengths Distribution');
    xlabel('Length');
    ylabel('Count');
    grid on;

    subplot(2,2,2);
    stockFullnessArray = zeros(1, CurrentStock);
    for k = 1:CurrentStock
        stockFullnessArray(k) = sum(Stocks{k});
    end
    bar(1:CurrentStock, stockFullnessArray);
    title('Stock Fullness');
    xlabel('Stock No');
    ylabel('Fullness');
    grid on;

    subplot(2,2,3);
    efficiency = (stockFullnessArray / StockLength) * 100;
    pie([mean(efficiency), 100-mean(efficiency)], {'Average Fullness', 'Waste'});
    colormap([0.2, 0.6, 0.8; 0.9, 0.3, 0.3]);
    title(sprintf('Average Efficiency: %.1f%%', mean(efficiency)));

    subplot(2,2,4);
    scatter(1:length(PieceDemands), PieceDemands(OrderIndex), 20, StockAssignments, 'filled');
    xlabel('Order Position');
    ylabel('Piece Length');
    title('Piece Ordering and Stock Assignments');
    colorbar;
    colormap(jet(CurrentStock));
    grid on;
end
