clear all
clc

SearchAgents = 50;
Max_iterations = 500;
dimension = 100;
lowerbound = 0;
upperbound = 1;

% Fitness fonksiyonunu tanıtıyoruz (Handle olarak)
fitness_func = @KesimMaliyeti;

% HO Algoritmasını Çağır
[Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness_func);

% SONUCU YORUMLAMA
fprintf('----------------------------------------\n');
fprintf('Algoritma Tamamlandı.\n');
fprintf('En İyi Maliyet Değeri: %.2f\n', Best_score);

% En iyi pozisyonu tekrar çözüp kaç stok gittiğini görelim
[~, Siralama] = sort(Best_pos);
fprintf('Kesim Sırası (Parça İndeksleri): ');
fprintf('%d ', Siralama);
fprintf('\n');

KullanilanStok = floor(Best_score / 1000);
Fire = mod(Best_score, 1000);

fprintf('Toplam Kullanılan Stok Sayısı: %d\n', KullanilanStok);
fprintf('Toplam Kalan Fire Miktarı: %.2f\n', Fire);

figure;
plot(HO_curve);
title('Kesim Problemi İyileşme Eğrisi');
xlabel('İterasyon');
ylabel('Maliyet (Stok Sayısı)');
