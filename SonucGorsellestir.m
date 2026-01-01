% --- SONUÇ GÖRSELLEŞTİRME KODU ---
% Bu kodu Main_Kesim.m bittikten hemen sonra çalıştırın.

if ~exist('Best_pos', 'var')
    error('Lütfen önce Main_Kesim dosyasını çalıştırın!');
end

% 1. AYNI PROBLEMİ TEKRAR OLUŞTUR
% KesimMaliyeti.m içindeki aynı "seed" değerini kullanmalıyız ki
% parçalar birebir aynı olsun.
StokBoyu = 100;
rand('seed', 12345);

% DÜZELTME: Değişken ismindeki 'ç' harfi 'c' yapıldı.
% Hedef: 50 stok civarı sonuç için [30, 70] aralığı kullanıldı.
ParcaTalepleri = randi([30, 70], 1, 100);

% 2. EN İYİ SIRALAMAYI ÇÖZÜMLE
[~, SiralamaIndeksi] = sort(Best_pos);
SiralanmisParcalar = ParcaTalepleri(SiralamaIndeksi);

% 3. YERLEŞTİRME İŞLEMİNİ TEKRARLA VE KAYDET
% Hangi parçanın hangi stoğa gittiğini tutacağız.
Stoklar = {}; % Hücre dizisi (Her hücre bir stok çubuğu)
Stoklar{1} = [];
KalanStoklar = StokBoyu;
MevcutStok = 1;

for i = 1:length(SiralanmisParcalar)
    Parca = SiralanmisParcalar(i);
    Yerlesti = false;

    % Mevcut stokları kontrol et
    for j = 1:MevcutStok
        if (StokBoyu - sum(Stoklar{j})) >= Parca
            Stoklar{j} = [Stoklar{j}, Parca];
            Yerlesti = true;
            break;
        end
    end

    % Yerleşmediyse yeni stok aç
    if Yerlesti == false
        MevcutStok = MevcutStok + 1;
        Stoklar{MevcutStok} = [Parca];
    end
end

% 4. GRAFİK ÇİZİMİ (Bar Chart)
figure('Name', 'Kesim Planı ve Fireler', 'Color', 'w');
hold on;
title(['Toplam Kullanılan Stok: ' num2str(MevcutStok)]);
xlabel('Stok Numarası');
ylabel('Doluluk (Birim)');
xlim([0, MevcutStok + 1]);
ylim([0, StokBoyu + 10]);

% Renkler
RenkDolu = [0.2, 0.6, 0.8]; % Mavi tonu (Parçalar)
RenkFire = [0.9, 0.3, 0.3]; % Kırmızı tonu (Fire)

for k = 1:MevcutStok
    Parcalar = Stoklar{k};
    Yukseklik = 0;

    % Parçaları Çiz (Mavi)
    for p = 1:length(Parcalar)
        p_boy = Parcalar(p);
        % rectangle('Position', [x, y, w, h])
        rectangle('Position', [k-0.4, Yukseklik, 0.8, p_boy], ...
                  'FaceColor', RenkDolu, 'EdgeColor', 'w', 'LineWidth', 1);

        % Parça boyunu içine yaz (Sığarsa)
        if p_boy > 5
            text(k, Yukseklik + p_boy/2, num2str(p_boy), ...
                 'HorizontalAlignment', 'center', 'Color', 'w', 'FontWeight', 'bold');
        end

        Yukseklik = Yukseklik + p_boy;
    end

    % Fire Kısmını Çiz (Kırmızı)
    FireMiktari = StokBoyu - Yukseklik;
    if FireMiktari > 0
        rectangle('Position', [k-0.4, Yukseklik, 0.8, FireMiktari], ...
                  'FaceColor', RenkFire, 'EdgeColor', 'none');

        text(k, Yukseklik + FireMiktari/2, num2str(FireMiktari), ...
             'HorizontalAlignment', 'center', 'Color', 'w', 'FontSize', 8);
    end
end


h1 = plot(nan, nan, 's', 'MarkerSize', 10, 'MarkerFaceColor', RenkDolu, 'MarkerEdgeColor', 'none');
h2 = plot(nan, nan, 's', 'MarkerSize', 10, 'MarkerFaceColor', RenkFire, 'MarkerEdgeColor', 'none');
legend([h1, h2], {'Kesilen Parça', 'Fire (Boşluk)'}, 'Location', 'northeastoutside');

grid on;
hold off;
