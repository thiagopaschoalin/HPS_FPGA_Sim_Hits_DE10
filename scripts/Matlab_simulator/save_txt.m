function save_txt(celula, delay, eng_fir,snl_fir, eng_iir, snl_iir);

% Nome do arquivo .txt
nome_arquivo_eng_fir = strcat("Dados_Simulados/",celula,"_Delay_",num2str(delay),"ns/eng_fir");
nome_arquivo_snl_fir = strcat("Dados_Simulados/",celula,"_Delay_",num2str(delay),"ns/snl_fir");
nome_arquivo_eng_iir = strcat("Dados_Simulados/",celula,"_Delay_",num2str(delay),"ns/eng_iir");
nome_arquivo_snl_iir = strcat("Dados_Simulados/",celula,"_Delay_",num2str(delay),"ns/snl_iir");

% Abra o arquivo para escrita
fid_eng_fir = fopen(nome_arquivo_eng_fir, 'w');
fid_snl_fir = fopen(nome_arquivo_snl_fir, 'w');
fid_eng_iir = fopen(nome_arquivo_eng_iir, 'w');
fid_snl_iir = fopen(nome_arquivo_snl_iir, 'w');

% Verifique se o arquivo foi aberto com sucesso
if (fid_eng_fir == -1 || fid_eng_iir == -1 || fid_snl_fir == -1 || fid_snl_iir == -1)
    error('Não foi possível abrir os arquivos para escrita.');
end

% Escreva as strings no arquivo
for i = 1:length(eng_fir)
    fprintf(fid_eng_fir, '%d\n', eng_fir);
    fprintf(fid_snl_fir, '%d\n', snl_fir);
    fprintf(fid_eng_iir, '%d\n', eng_iir);
    fprintf(fid_snl_iir, '%d\n', snl_iir);
end

% Feche o arquivo
fclose(fid_eng_fir);
fclose(fid_snl_fir);
fclose(fid_eng_iir);
fclose(fid_snl_iir);

disp('Arquivo criados com sucesso.');