clear all
clc

% --- ACCELERATED SETTINGS ---
RunCount = 10;
SearchAgents = 20;
Max_iterations = 80;
dimension = 100;
lowerbound = 0;
upperbound = 1;
StockLength = 100;

% --- 1. DATA GENERATION ---
rand('state', 12345);
PieceDemands = randi([15, 60], 1, dimension);

fprintf('===========================================\n');
fprintf('       HIPPOPOTAMUS ALGORITHM\n');
fprintf('===========================================\n');

% --- 2. TARGET (FFD) CALCULATION ---
% if our system find this target, it wont continue the loop
[pieces_ffd, ~] = sort(PieceDemands, 'descend');
[stock_ffd, fullness_ffd] = FirstFit(pieces_ffd, StockLength);
baseline_cost = stock_ffd * 1000 + (stock_ffd*StockLength - sum(fullness_ffd)); % using new stock has a bigger punishment
fprintf('TARGET: %d Stocks (Cost: %.0f)\n\n', stock_ffd, baseline_cost);

% --- 3. INTELLIGENT ALGORITHM LOOP ---
GlobalBestScore = inf;
GlobalBestPos = [];
GlobalCurve = [];
fitness_func = @(x) CuttingCost(x, PieceDemands, StockLength);

t_start = tic;

for run = 1:RunCount
    fprintf('>> Trial %d...\n', run);

    % Randomness changes each run
    rand('state', sum(100*clock) + run);

    [current_score, current_pos, current_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness_func);

    fprintf(' Result: %.0f', current_score);

    % --- ACCELERATION ---
    if current_score <= baseline_cost
        fprintf(' -> TARGET REACHED! (Stopping loop)\n');
        GlobalBestScore = current_score;
        GlobalBestPos = current_pos;
        GlobalCurve = current_curve;
        break; % Found the goal, no need to run the other 9 trials!
    elseif current_score < GlobalBestScore
        GlobalBestScore = current_score;
        GlobalBestPos = current_pos;
        GlobalCurve = current_curve;
        fprintf(' (New best)\n');
    else
        fprintf('\n');
    end
end

total_time = toc(t_start);

% --- 4. RESULT ANALYSIS ---
fprintf('\n===========================================\n');
fprintf('  RESULT REPORT\n');
fprintf('===========================================\n');
fprintf('Target (FFD):       %.0f\n', baseline_cost);
fprintf('Algorithm:          %.0f\n', GlobalBestScore);
fprintf('Total Time:         %.2f seconds\n', total_time);
fprintf('===========================================\n\n');

% --- 5. VISUALIZATION ---
ShowResult(GlobalBestPos, GlobalBestScore, GlobalCurve, PieceDemands, StockLength);
