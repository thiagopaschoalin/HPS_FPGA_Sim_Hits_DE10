% CREATE MEMORY FILES FOR THE WIENER FILTER AND PZC+WIENER FILTER FROM MATLAB simulator_main

% Run matlab simulator
run('../../Matlab_simulator/simulator_main.m');

% Name of the memories with weights
nome_arquivo1 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/weight_ls_normal_',cell,'.mif');
nome_arquivo2 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/weight_ls_pzc_',cell,'.mif');

% Converting data and creating the memory files
w_10bits = round(w_normal*quant);
w_10bits_bin = dec2bin(typecast(int16(w_10bits),'uint16'));
w_10bits_bin_10 = w_10bits_bin(:,7:16);
fid = fopen(nome_arquivo1, 'w');

if fid == -1
    error('Error in opening file 1.');
end

for i = 0:length(w_10bits_bin_10(:,1))-1
    fprintf(fid, '%s\n', w_10bits_bin_10(end-i,:));
end

fclose(fid);

disp('File 1 created with success.');

w_10bits = round(w_pzc*quant);

w_10bits_bin = dec2bin(typecast(int16(w_10bits),'uint16'));

w_10bits_bin_10 = w_10bits_bin(:,7:16);

fid = fopen(nome_arquivo2, 'w');

if fid == -1
    error('Error in opening file 2.');
end

for i = 0:length(w_10bits_bin_10(:,1))-1
    fprintf(fid, '%s\n', w_10bits_bin_10(end-i,:));
end

fclose(fid);

disp('File 2 created with success.');