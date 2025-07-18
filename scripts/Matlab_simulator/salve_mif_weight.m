nome_arquivo1 = 'weight_ls_normal.mif';
nome_arquivo2 = 'weight_ls_pzc.mif';

if ls_bias
    quant = 185;
else
    quant = 450;
    
end

w_10bits = round(w_normal*quant);

w_10bits_bin = dec2bin(typecast(int16(w_10bits),'uint16'));

w_10bits_bin_10 = w_10bits_bin(:,7:16);

% Abra o arquivo para escrita
fid = fopen(nome_arquivo1, 'w');

% Verifique se o arquivo foi aberto com sucesso
if fid == -1
    error('Não foi possível abrir o arquivo 1 para escrita.');
end

% Escreva as strings no arquivo
for i = 0:length(w_10bits_bin_10)-1
    fprintf(fid, '%s\n', w_10bits_bin_10(end-i,:));
end

% Feche o arquivo
fclose(fid);

disp('Arquivo 1 criado com sucesso.');

w_10bits = round(w_pzc*quant);

w_10bits_bin = dec2bin(typecast(int16(w_10bits),'uint16'));

w_10bits_bin_10 = w_10bits_bin(:,7:16);

% Abra o arquivo para escrita
fid = fopen(nome_arquivo2, 'w');

% Verifique se o arquivo foi aberto com sucesso
if fid == -1
    error('Não foi possível abrir o arquivo 2 para escrita.');
end

% Escreva as strings no arquivo
for i = 0:length(w_10bits_bin_10)-1
    fprintf(fid, '%s\n', w_10bits_bin_10(end-i,:));
end

% Feche o arquivo
fclose(fid);

disp('Arquivo 2 criado com sucesso.');