% CREATE MEMORY FILES FOR THE WIENER FILTER AND PZC+WIENER FILTER FROM
% MODELSIM SIMULATION

clear all
close all

%Loading signal
snl_fpga = load('../../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/shaper_clip_tb.txt');
eng_fpga = load('../../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/event_bt_tb.txt');
pzc_fpga = load('../../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/pzc_out_tb.txt');

%Matching the signal to the energy truth
snl_fpga = snl_fpga(4:end);
pzc_fpga = pzc_fpga(4:end);

snl_noise = snl_fpga;

%% Wiener Filter

%PZC M Factor
m_factor = 455;

% Cut the data to fast the process
num_samples = 1e4;

% Start point of the training to avoid the initial pedestal tracking of PZC
inicio = 100000;

% Weights of Wiener filter
num_weights = 5;
ls_bias = 0; %0 - without bias     1 - with bias

%Quantization factors
if ls_bias
    quant = 185;
else
    quant = 450;
end

%Adjusting the data
snl_noise = snl_noise(inicio:num_samples+inicio);
eng_fpga = eng_fpga(inicio:num_samples+inicio);
pzc_fpga = pzc_fpga(inicio:num_samples+inicio);

% Training the weights
w_normal = LS_filter(snl_noise',(eng_fpga)',num_weights,ls_bias);
w_pzc    = LS_filter(pzc_fpga',(eng_fpga*m_factor)',num_weights,ls_bias);

%Estimating the amplitudes
amp_est_normal = LS_FIR(w_normal,snl_noise',ls_bias);
amp_est_pzc    = LS_FIR(w_pzc,   pzc_fpga',ls_bias);

%Estimating amplitudes with quantized weights
amp_est_rounded_normal = LS_FIR(round(w_normal*quant),ceil(snl_noise'), ls_bias)/quant;
amp_est_rounded_pzc    = LS_FIR(round(w_pzc   *quant),ceil(pzc_fpga'), ls_bias)/quant;

% Calculating errors and Std in estimation (without and with quantization)
error_normal = amp_est_normal - (eng_fpga);
error_pzc    = amp_est_pzc    - (eng_fpga*m_factor);

error_rounded_normal = amp_est_rounded_normal - eng_fpga;
error_rounded_pzc     = amp_est_rounded_pzc    - eng_fpga*m_factor;

std_normal = std(error_normal);
std_normal_pzc = std(error_pzc/m_factor);
std_rounded_normal = std(error_rounded_normal);
std_rounded_pzc = std(error_rounded_pzc/m_factor);

%% Saving the memory files

cell = "A13";

% Name of the memories with weights
nome_arquivo1 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/weight_ls_normal_',cell,'_test.mif');
nome_arquivo2 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/weight_ls_pzc_',cell,'_test.mif');

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