%% Levy Flight Function (Octave Compatible)
function [z] = levy(n,m,beta)
    % Levy uçuşu için gerekli katsayı hesaplamaları
    num = gamma(1+beta)*sin(pi*beta/2);
    den = gamma((1+beta)/2)*beta*2^((beta-1)/2);
    sigma_u = (num/den)^(1/beta);

    u = randn(n,m) * sigma_u;
    v = randn(n,m);
    z = u./(abs(v).^(1/beta));
end
