clear all
clc

SearchAgents = 50;
Max_iterations = 500;
dimension = 100;
lowerbound = 0;
upperbound = 1;

fitness_func = @KesimMaliyeti;

% HO Algoritmasını Çağır
[Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness_func);

% SONUCU YORUMLAMA
fprintf('----------------------------------------\n');
fprintf('Algoritma Tamamlandı.\n');
fprintf('En İyi Maliyet Değeri: %.4f\n', Best_score);

% En iyi pozisyonu tekrar çözüp kaç stok gittiğini görelim
[~, Siralama] = sort(Best_pos);
fprintf('En İyi Çözüm İçin İlk 10 Parça Sırası: ');
fprintf('%d ', Siralama(1:10));
fprintf('...\n');

% Stok hesaplaması
StokBoyu = 100;
rand('seed', 12345);
ParcaTalepleri = randi([30, 70], 1, 100);

% En iyi sıralamayı uygula
SiralanmisParcalar = ParcaTalepleri(Siralama);

% First Fit algoritmasıyla stok sayısını hesapla
KullanilanStokSayisi = 1;
KalanStoklar = StokBoyu;

for i = 1:length(SiralanmisParcalar)
    Parca = SiralanmisParcalar(i);
    Yerlesti = false;

    for j = 1:KullanilanStokSayisi
        if KalanStoklar(j) >= Parca
            KalanStoklar(j) = KalanStoklar(j) - Parca;
            Yerlesti = true;
            break;
        end
    end

    if Yerlesti == false
        KullanilanStokSayisi = KullanilanStokSayisi + 1;
        KalanStoklar(KullanilanStokSayisi) = StokBoyu - Parca;
    end
end

% Fire hesapla
ToplamFire = sum(KalanStoklar(1:KullanilanStokSayisi));

fprintf('Toplam Kullanılan Stok Sayısı: %d\n', KullanilanStokSayisi);
fprintf('Toplam Fire Miktarı: %d\n', ToplamFire);
fprintf('Fire Oranı: %.2f%%\n', (ToplamFire/(KullanilanStokSayisi*StokBoyu))*100);


figure('Position', [100, 100, 1000, 600]); % Büyük pencere
hold on;

% 1. Ana grafiği çiz (kalın çizgi)
plot(HO_curve, 'b-', 'LineWidth', 2.5);

% 2. En iyi değeri işaretle
[best_value, best_idx] = min(HO_curve);
plot(best_idx, best_value, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% 3. Başlangıç değerini işaretle
plot(1, HO_curve(1), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');

% 4. Grid ekle
grid on;
grid minor;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.3);

% 5. Başlık ve etiketler (Büyük font)
title('Hipopotam Optimizasyon Algoritması - Kesim Problemi İyileşme Eğrisi', ...
      'FontSize', 16, 'FontWeight', 'bold');
xlabel('İterasyon Sayısı', 'FontSize', 14);
ylabel('Maliyet Fonksiyonu Değeri', 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Arial');

y_min = min(HO_curve) * 0.98;
y_max = max(HO_curve) * 1.02;

ylim([y_min, y_max]);

yticks = linspace(y_min, y_max, 10); % 10 eşit aralık
yticklabels = arrayfun(@(x) sprintf('%.2f', x), yticks, 'UniformOutput', false);
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels);

if Max_iterations > 100
    xtick_step = floor(Max_iterations / 10);
    xticks = 0:xtick_step:Max_iterations;
else
    xticks = 0:10:Max_iterations;
end
set(gca, 'XTick', xticks);

% 10. Legend (açıklama) ekle
legend('İyileşme Eğrisi', ...
       sprintf('En İyi Değer: %.3f (Iter. %d)', best_value, best_idx), ...
       sprintf('Başlangıç: %.3f', HO_curve(1)), ...
       'Location', 'best', 'FontSize', 11);

% 11. Grafik kutusu
box on;

% 12. Arkaplan rengi
set(gcf, 'Color', 'w');

% 13. İstatistikleri göster (grafik üzerine yaz)
stats_text = sprintf(['İstatistikler:\n' ...
                      'Başlangıç: %.3f\n' ...
                      'En İyi: %.3f\n' ...
                      'İyileşme: %.2f%%\n' ...
                      'Iterasyon: %d/%d'], ...
                     HO_curve(1), best_value, ...
                     (HO_curve(1)-best_value)/HO_curve(1)*100, ...
                     best_idx, Max_iterations);

text(0.02, 0.98, stats_text, 'Units', 'normalized', ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
     'FontSize', 10, 'BackgroundColor', [0.95 0.95 0.95], ...
     'EdgeColor', 'k', 'Margin', 5);

hold off;
