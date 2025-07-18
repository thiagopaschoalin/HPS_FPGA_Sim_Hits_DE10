clear all
close all

% Definig the target cell
cell = "D2";

gen_no = 10;


% Loading some energy and pulse informations
orign_archive = (strcat("orign/eng_truth_",cell,".mat"));
load("pulse_fenics_original.mat");
standard_pulse = y_amostrado;
clear y_amostrado;



% Flag to define if you want to use a previous simulated dataset or
% simulate again: 0 - Previous | 1 - Simulate new dataset
gen_new = 0;

% Desired simulation
generated_samples = 1e5; % number of samples
delay = 0; % in ns
noise_std = 2*4; % electronic noise std in ADC (1.5 was with actual electronic. We used 4 times because it will have 12-bit length


%% Simulating new dataset or loading a previous simulated

if gen_new
    N = generated_samples + 2;
    delay_ns = delay * 1e-9;

    % Determining the positions
    [hits,bt_mask_out] = hits_positions(orign_archive, N);

    % Simulating energy of a cell
    eng_temp = energy_collision(orign_archive,hits);
    pos_hits = find(hits == 1);
    eng_truth = zeros(1,N);
    eng_truth(pos_hits) = eng_temp;

    % Convolving the energy with fenics pulse
    [snl_fir,eng_fir] = conv_fir(eng_truth,standard_pulse); % Using a FIR technique
    snl_fir_pure = snl_fir; % store without Noise
    
    [snl_iir,eng_iir] = conv_iir_fenics(eng_truth,delay_ns); % Using a FIR technique
    snl_iir_pure = snl_iir;% store without Noise
    
    samples_gen = length(snl_fir);
    samples_gen = length(snl_iir);
    % It can be used one pair of data wanted. The results were the same with my
    % tests. Use the one which you prefer.
    
    bt_mask_out = bt_mask_out(3:end); % ajust to match with snl    
    
    % Noise simulation
    noise = noise_std.*randn(1,samples_gen);
    snl_fir = snl_fir + noise;
    snl_iir = snl_iir + noise;
    
    % Saving the data to avoid all simulation again
    save(strcat("simulated_data/",cell,"_Delay_",num2str(delay),"ns","_gen_",num2str(gen_no),".mat"),"snl_fir_pure","snl_iir_pure","snl_fir","snl_iir","eng_fir","eng_iir","bt_mask_out","noise");
else
    load(strcat("simulated_data/",cell,"_Delay_",num2str(delay),"ns","_gen_",num2str(gen_no),".mat"))
    %load(strcat("simulated_data/",cell,"_Delay_",num2str(delay),"ns.mat"))
end

%% Ploting data

% 
% % Ploting the signal x energy truth (for FIR technique)
% figure;
% stairs(snl_fir);
% hold on;
% stairs(eng_fir,'g');
% legend('Shaper Signal','Truth Energy');
% title("Shaper output - FIR Tech");
% hold off;
% 
% % Ploting the signal x energy truth (for IIR technique)
% figure;
% stairs(snl_iir);
% hold on;
% stairs(eng_iir,'g');
% legend('Shaper Signal','Truth Energy');
% title("Shaper output - IIR Tech");
% hold off;
% 
% % Plot the comparison between FIR and IIR techinique
% figure;
% stairs(snl_fir);
% hold on;
% stairs(snl_iir);
% legend('FIR','IIR')
% title("FIR x IIR Techniques");
% hold off;

    

%% PZC

tau = 1.1364e-05; % tau - decay exp time
T_clk = 25e-9; % Clock period

% PZC M factor calculation
M_factor = inv(exp(T_clk/tau) - 1);


[snl_pzc, mean] = pzc(snl_iir,M_factor,bt_mask_out);

% % Ploting energy, shaper signal and pzc output;
% figure;
% stairs(snl_iir);
% hold on;
% stairs(eng_iir,'g');
% stairs(snl_pzc,'r');
% legend('Shaper Signal','Truth Energy',"PZC Output");
% title("PZC Performance");
% hold off;

%% Wiener Filter

num_samples = 4.5e4;

num_weights = 5
ls_bias = 0; %0 - não     1 - sim

if ls_bias
    quant = 185;
else
    quant = 450;
    
end

start = 2000;

snl_iir_train = snl_iir(start:start+num_samples);
eng_iir_train = eng_iir(start:start+num_samples);
snl_pzc_train = snl_pzc(start:start+num_samples);

snl_iir_test = snl_iir(start+num_samples+1:start+2*num_samples);
eng_iir_test = eng_iir(start+num_samples+1:start+2*num_samples);
snl_pzc_test = snl_pzc(start+num_samples+1:start+2*num_samples);


w_normal = LS_filter(snl_iir_train,eng_iir_train,num_weights,ls_bias);
w_pzc    = LS_filter(snl_pzc_train,eng_iir_train,num_weights,ls_bias);

amp_est_normal = LS_FIR(w_normal,snl_iir_test,ls_bias);
amp_est_pzc    = LS_FIR(w_pzc,   snl_pzc_test,ls_bias);

amp_est_rounded_normal = LS_FIR(round(w_normal*quant),ceil(snl_iir_test), ls_bias)/quant;
amp_est_rounded_pzc    = LS_FIR(round(w_pzc   *quant),ceil(snl_pzc_test), ls_bias)/quant;

error_normal = amp_est_normal - eng_iir_test';
error_pzc    = amp_est_pzc    - eng_iir_test';

error_rounded_normal = amp_est_rounded_normal - eng_iir_test';
error_rounded_pzc     = amp_est_rounded_pzc    - eng_iir_test';



std_normal = std(error_normal)
std_pzc    = std(error_pzc)

rms_normal = rms(error_normal)
rms_pzc    = rms(error_pzc)


% Ploting energy, shaper signal and pzc output;
%figure;
figure('DefaultAxesFontSize',24);
stairs(amp_est_normal);
hold on;
stairs(eng_iir_test,'g');
stairs(amp_est_pzc,'r');
ylabel('Amplitude[ADC Counts]');
xlabel('Sample');
legend('Wiener','Truth Energy',"PZC+Wiener");
title("PZC Performance");
hold off;


error_normal_filter = error_normal(abs(error_normal) < 60);
%error_normal_filter = error_normal;
error_pzc_filter = error_pzc(abs(error_pzc) < 60);
%error_pzc_filter = error_pzc;

% Plotting error histograms
figure
hist(error_normal_filter,60)
title("Histogram Error Wiener")
%text(-60, 2000, {strcat('Std = ',num2str(std_normal)) , strcat('RMSE = ',num2str(rms_normal))}, 'EdgeColor', 'black');
text(20, 4000, {strcat('Std = ',num2str(std_normal)) , strcat('RMSE = ',num2str(rms_normal))}, 'EdgeColor', 'black');
%xlim([-180 40])
xlabel("Error")
ylabel("Frequency")

figure
hist(error_pzc_filter,60)
title("Histogram Error Wiener+PZC")
%text(-140, 1500, {strcat('Std = ',num2str(std_pzc)) , strcat('RMSE = ',num2str(rms_pzc))}, 'EdgeColor', 'black');
%xlim([-180 40])
text(20, 4000, {strcat('Std = ',num2str(std_pzc)) , strcat('RMSE = ',num2str(rms_pzc))}, 'EdgeColor', 'black');
xlabel("Error")
ylabel("Frequency")


