function [snl_iir,eng_iir] = conv_iir_fenics(eng_truth,delay);


freq = 40e6;
T  = 1/freq;

load digitalizeTF.mat

n1o = Ha{1,1}.Numerator{1,1};
d1o = Ha{1,1}.Denominator{1,1};

n2o = Ha{1,2}.Numerator{1,1};
d2o = Ha{1,2}.Denominator{1,1};

n3o = Ha{1,3}.Numerator{1,1};
d3o = Ha{1,3}.Denominator{1,1};

n4o = Ha{1,4}.Numerator{1,1};
d4o = Ha{1,4}.Denominator{1,1};

n5o = Ha{1,5}.Numerator{1,1};
d5o = Ha{1,5}.Denominator{1,1};



H1_o = tf(n1o, d1o);
H2_o = tf(n2o, d2o);
H3_o = tf(n3o, d3o);
H4_o = tf(n4o, d4o);
H5_o = tf(n5o, d5o);

H_total_o = H1_o + H2_o + H3_o + H4_o + H5_o;

[y_cont_o, t_cont_o] = impulse(H_total_o, [0:1e-12:1.3e-6]);  % Resposta contínua ao impulso


% Encontrar o valor máximo e o índice correspondente
[max_val, max_idx] = max(y_cont_o);

% Tempo correspondente ao valor máximo
t_max = t_cont_o(max_idx);

%%%%%%%%%%%%%%%%

s = tf('s');


T_d = 50e-9 - t_max - delay;

atraso_exp = exp(- T_d *s);

% PADE
atraso = pade(atraso_exp,5);


% Sistema total - exemplo: soma das funções de transferência

H_total_taylor = H_total_o * atraso;

[num_taylor, den_taylor] = tfdata(H_total_taylor, 'v'); % Coeficientes em formato de vetor


freqi = 40e6;

[Znt_taylor, Zdt_taylor] = impinvar(num_taylor, den_taylor, freqi);

Znt_taylor = Znt_taylor * (freqi/max_val);


snl = filter(Znt_taylor,Zdt_taylor,eng_truth);

snl_iir   = snl(3:end);
eng_iir   = eng_truth(1:end-2);

