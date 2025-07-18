% TESTING THE MODELSIM SIMULATION
close all
clear all

%Loading signals
eng_truth = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/event_bt_tb.txt'); %energy truth
snl_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/shaper_out_tb.txt'); %Shaper signal
pzc_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/pzc_out_tb.txt'); %PZC output
pedestal_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/pedestal_out_tb.txt'); %Pedestal compensation output
shaper_clip_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/shaper_clip_tb.txt'); %ADC output
shaper_corrupted_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/shaper_corrupted_tb.txt'); %Shaper+Noise
noise_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/noise_out_tb.txt'); %Noise output
offset_fpga = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/offset_tb.txt'); %Pedestal added before ADC
ls_normal = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/wiener_normal_out_tb.txt'); % Wiener output
ls_pzc = load('../../HPS_FPGA_Simulador_v1_DE10/simulation/questa/wiener_pzc_out_tb.txt'); % PZC+Wiener output

%PZC factor
m_factor = 455;

%Gain of the shaper
Gs = 2^10;

%Gain of Wiener filter weights
Gw = 450;

%Matching all signals 
snl_fpga = snl_fpga(3:end)/(Gs);
pzc_fpga = pzc_fpga(4:end)/(m_factor);
pedestal_fpga = pedestal_fpga(4:end);
shaper_clip_fpga = shaper_clip_fpga(4:end);
shaper_corrupted_fpga = shaper_corrupted_fpga(4:end)/(Gs);
noise_fpga = noise_fpga(3:end)/(Gs);
%if the weigths number change, it needs to change the start. To do so, use
%the plot of estimated amplitude and energy truth
ls_normal = ls_normal(6:end);
ls_pzc = ls_pzc(6:end);

%MAtching number of samples
eng_truth = eng_truth(1:length(ls_normal));


%Start point of analysis to avoid the pedestal trackin effect of PZC
inicio = 100000;

% Calculating the estimation errors, std and RMSE
error_normal = ls_normal(inicio:end) - 450*eng_truth(inicio:end);
error_pzc = ls_pzc(inicio:end) - 450*455*eng_truth(inicio:end);

std_normal = std(error_normal/450);
std_pzc = std(error_pzc/(450*455));

rms_normal = rms(error_normal/450);
rms_pzc = rms(error_pzc/(450*455));



%Ploting the ADC, PZC and pedestal tracking
figure('DefaultAxesFontSize',24)
%stairs(eng_truth,'DisplayName','Energy Truth')
hold on;
%stairs(snl_fpga,'DisplayName','Shaper out')%,'b')
stairs(pzc_fpga,'DisplayName','PZC out')%,'r')
stairs(shaper_clip_fpga,'DisplayName','ADC Signal')%,'r')
%stairs(shaper_corrupted_fpga,'DisplayName','Shaper + Noise')%,'r')
%stairs(noise_fpga, 'DisplayName','Noise')%,'r')
stairs(pedestal_fpga, 'DisplayName','Pedestal Compensation')%,'r')
stairs(offset_fpga, 'DisplayName','Pedestal')%,'r')
hold off;
legend;
xlabel('Sample');
ylabel('Amplitude [ADC Count]');
%xlim([17601,18180]);
%ylim([-150,1600]);


%Ploting the Amplitude estimation
figure('DefaultAxesFontSize',24)
stairs(eng_truth,'DisplayName','Energy Truth')
hold on;
%stairs(snl_fpga,'DisplayName','Shaper out')%,'b')
%stairs(shaper_clip_fpga,'DisplayName','Shaper Clip')%,'r')
%stairs(shaper_corrupted_fpga,'DisplayName','Shaper + Noise')%,'r')
%stairs(noise_fpga, 'DisplayName','Noise')%,'r')
stairs(ls_normal/450, 'DisplayName','Wiener')%,'r')
stairs(ls_pzc/(450*455), 'DisplayName','PZC+Wiener')%,'r')
hold off;
legend;
xlabel('Sample');
ylabel('Amplitude [ADC Count]');
%xlim([17601,18180]);
%ylim([-150,1600]);


error_normal_filter = error_normal/Gw;
error_pzc_filter = error_pzc/(Gw*m_factor);

% Plotting error histograms
figure
hist(error_normal_filter,60)
title("Histogram Error Wiener")
text(-200, 5000, {strcat('Std = ',num2str(std_normal)) , strcat('RMSE = ',num2str(rms_normal))}, 'EdgeColor', 'black');
%text(-80, 4000, {strcat('Std = ',num2str(std_normal)) , strcat('RMSE = ',num2str(rms_normal))}, 'EdgeColor', 'black');
xlim([-250 150])
%xlim([-100 50])
xlabel("Error")
ylabel("Frequency")

figure
hist(error_pzc_filter,60)
title("Histogram Error Wiener+PZC")
text(-200, 4000, {strcat('Std = ',num2str(std_pzc)) , strcat('RMSE = ',num2str(rms_pzc))}, 'EdgeColor', 'black');
xlim([-250 150])
%xlim([-100 50])
%text(-80, 3000, {strcat('Std = ',num2str(std_pzc)) , strcat('RMSE = ',num2str(rms_pzc))}, 'EdgeColor', 'black');
xlabel("Error")
ylabel("Frequency")