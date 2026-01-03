% --- SONUÇ GÖRSELLEŞTİRME KODU ---

if ~exist('Best_pos', 'var')
    error('Lütfen önce Main_Kesim dosyasını çalıştırın!');
end

% 1. AYNI PROBLEMİ TEKRAR OLUŞTUR
StokBoyu = 100;
rand('seed', 12345);
ParcaTalepleri = randi([30, 70], 1, 100);

% 2. EN İYİ SIRALAMAYI ÇÖZÜMLE
[~, SiralamaIndeksi] = sort(Best_pos);
SiralanmisParcalar = ParcaTalepleri(SiralamaIndeksi);

% 3. YERLEŞTİRME İŞLEMİNİ TEKRARLA VE KAYDET
Stoklar = {}; % Hücre dizisi (Her hücre bir stok çubuğu)
Stoklar{1} = [];
KalanStoklar = StokBoyu;
MevcutStok = 1;
StokAtamalari = zeros(1, 100); % Her parçanın hangi stokta olduğunu tut

for i = 1:length(SiralanmisParcalar)
    Parca = SiralanmisParcalar(i);
    Yerlesti = false;

    % Mevcut stokları kontrol et
    for j = 1:MevcutStok
        if (StokBoyu - sum(Stoklar{j})) >= Parca
            Stoklar{j} = [Stoklar{j}, Parca];
            StokAtamalari(i) = j; % Parçanın atandığı stok
            Yerlesti = true;
            break;
        end
    end

    % Yerleşmediyse yeni stok aç
    if Yerlesti == false
        MevcutStok = MevcutStok + 1;
        Stoklar{MevcutStok} = [Parca];
        StokAtamalari(i) = MevcutStok;
    end
end

% 4. SONUÇLARI EKRANA YAZDIR
fprintf('\n=== GÖRSELLEŞTİRME SONUÇLARI ===\n');
fprintf('Toplam Stok Sayısı: %d\n', MevcutStok);

ToplamFire = 0;
for k = 1:MevcutStok
    Doluluk = sum(Stoklar{k});
    Fire = StokBoyu - Doluluk;
    ToplamFire = ToplamFire + Fire;
    fprintf('  Stok %d: Doluluk = %d, Fire = %d (%.1f%% verim)\n', ...
        k, Doluluk, Fire, (Doluluk/StokBoyu)*100);
end

fprintf('\nToplam Fire: %d\n', ToplamFire);
fprintf('Ortalama Verimlilik: %.2f%%\n', ...
    ((MevcutStok*StokBoyu - ToplamFire)/(MevcutStok*StokBoyu))*100);

% 5. GRAFİK ÇİZİMİ (Bar Chart)
figure('Name', 'Kesim Planı ve Fireler', 'Color', 'w', 'Position', [100, 100, 1200, 600]);
hold on;
title(sprintf('Kesim Planı - %d Stok, %.1f%% Ortalama Verim', ...
    MevcutStok, ((MevcutStok*StokBoyu - ToplamFire)/(MevcutStok*StokBoyu))*100));
xlabel('Stok Numarası');
ylabel('Doluluk (Birim)');

% Dinamik x sınırları
if MevcutStok <= 20
    xlim([0, MevcutStok + 1]);
    stokGenislik = 0.8;
else
    xlim([0, 21]); % İlk 20 stoku göster
    stokGenislik = 0.6;
end
ylim([0, StokBoyu + 5]);

% Renkler
RenkDolu = [0.2, 0.6, 0.8]; % Mavi tonu (Parçalar)
RenkFire = [0.9, 0.3, 0.3]; % Kırmızı tonu (Fire)

% Stokları çiz (maksimum 20 stok göster)
gosterilecekStok = min(MevcutStok, 20);

for k = 1:gosterilecekStok
    Parcalar = Stoklar{k};
    Yukseklik = 0;

    % Parçaları Çiz (Mavi)
    for p = 1:length(Parcalar)
        p_boy = Parcalar(p);
        rectangle('Position', [k-0.4, Yukseklik, stokGenislik, p_boy], ...
                  'FaceColor', RenkDolu, 'EdgeColor', 'w', 'LineWidth', 0.5);

        % Parça boyunu içine yaz (Sığarsa)
        if p_boy > 8
            text(k-0.4+stokGenislik/2, Yukseklik + p_boy/2, num2str(p_boy), ...
                 'HorizontalAlignment', 'center', 'Color', 'w', ...
                 'FontWeight', 'bold', 'FontSize', 8);
        end

        Yukseklik = Yukseklik + p_boy;
    end

    % Fire Kısmını Çiz (Kırmızı)
    FireMiktari = StokBoyu - Yukseklik;
    if FireMiktari > 0
        rectangle('Position', [k-0.4, Yukseklik, stokGenislik, FireMiktari], ...
                  'FaceColor', RenkFire, 'EdgeColor', 'none');

        if FireMiktari > 5
            text(k-0.4+stokGenislik/2, Yukseklik + FireMiktari/2, ...
                sprintf('%d\n(%.0f%%)', FireMiktari, (FireMiktari/StokBoyu)*100), ...
                'HorizontalAlignment', 'center', 'Color', 'w', ...
                'FontSize', 7, 'FontWeight', 'bold');
        end
    end

    % Stok numarasını alt kısma yaz
    text(k-0.4+stokGenislik/2, -2, sprintf('Stok %d', k), ...
         'HorizontalAlignment', 'center', 'FontSize', 9);
end

% Eğer 20'den fazla stok varsa uyarı ekle
if MevcutStok > 20
    text(10, StokBoyu + 15, ...
        sprintf('Not: Toplam %d stok var, sadece ilk 20 gösteriliyor', MevcutStok), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'red');
end

% Legend
h1 = plot(nan, nan, 's', 'MarkerSize', 10, ...
    'MarkerFaceColor', RenkDolu, 'MarkerEdgeColor', 'none');
h2 = plot(nan, nan, 's', 'MarkerSize', 10, ...
    'MarkerFaceColor', RenkFire, 'MarkerEdgeColor', 'none');
legend([h1, h2], {'Kesilen Parça', 'Fire (Boşluk)'}, ...
    'Location', 'northeastoutside', 'FontSize', 10);

grid on;
box on;
hold off;

% 6. EK GRAFİK: Parça Dağılımı
figure('Name', 'Parça Dağılım Analizi', 'Color', 'w');
subplot(2,2,1);
hist(ParcaTalepleri, 10:5:70);
title('Parça Uzunlukları Dağılımı');
xlabel('Uzunluk');
ylabel('Adet');
grid on;

subplot(2,2,2);
stokDoluluklari = zeros(1, MevcutStok);
for k = 1:MevcutStok
    stokDoluluklari(k) = sum(Stoklar{k});
end
bar(1:MevcutStok, stokDoluluklari);
title('Stok Dolulukları');
xlabel('Stok No');
ylabel('Doluluk');
grid on;

subplot(2,2,3);
verimlilik = (stokDoluluklari / StokBoyu) * 100;
pie([mean(verimlilik), 100-mean(verimlilik)], {'Ortalama Doluluk', 'Fire'});
colormap([0.2, 0.6, 0.8; 0.9, 0.3, 0.3]);
title(sprintf('Ortalama Verimlilik: %.1f%%', mean(verimlilik)));

subplot(2,2,4);
scatter(1:100, ParcaTalepleri(SiralamaIndeksi), 20, StokAtamalari, 'filled');
xlabel('Sıralama Pozisyonu');
ylabel('Parça Uzunluğu');
title('Parçaların Sıralaması ve Stok Atamaları');
colorbar;
colormap(jet(MevcutStok));
grid on;
