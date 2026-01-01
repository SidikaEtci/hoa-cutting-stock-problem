function [maliyet] = KesimMaliyeti(x)
    % PERSISTENT: Verileri hafızada tut
    persistent ParcaTalepleri StokBoyu;

    if isempty(ParcaTalepleri)
        % --- AYARLAR ---
        StokBoyu = 100;
        rand('seed', 12345);
        ParcaTalepleri = randi([30, 70], 1, 100);
    end

    % --- RANDOM KEY DECODING ---
    [~, SiralamaIndeksi] = sort(x);
    SiralanmisParcalar = ParcaTalepleri(SiralamaIndeksi);

    % --- FIRST FIT ALGORİTMASI ---
    KullanilanStokSayisi = 1;
    KalanStoklar = StokBoyu;     % Kalan boşlukları tutar

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

    StokDoluluklari = StokBoyu - KalanStoklar;

    % Karesel Ceza (Sıkışıklık Bonusu)
    F = sum((StokDoluluklari ./ StokBoyu).^2) / KullanilanStokSayisi;

    % Maliyet Hesabı
    maliyet = KullanilanStokSayisi - (F * 0.99);
end
