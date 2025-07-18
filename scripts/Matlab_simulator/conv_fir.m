function [snl_fir,eng_fir] = conv_fir(eng_truth,pulso_padrao);

snl = filter(pulso_padrao,1,eng_truth);

snl_fir   = snl(3:end);
eng_fir   = eng_truth(1:end-2);
