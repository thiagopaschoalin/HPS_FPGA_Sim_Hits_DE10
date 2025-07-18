% ANALYSIS THE SIGNAL TAOP RESULTS. BEFORE RUN THIS CODE, USE THE SIGNAL
% TAP AND EXPORT IN CSV FORMAT, WITH NAME "stp1.csv" at
% "HPS_FPGA_Simulador_v1_DE10" folder

clear all
close all

% PZC M Factor
m_fac = 454;

% Name of the csv to import
filename = '../../HPS_FPGA_Simulador_v1_DE10/stp1.csv'; %If the name changes, changes the path too

disp(['Reading file: ', filename]);

% Read CSV, ignoring the header if it exists
opts = detectImportOptions(filename);
opts.DataLines = 2; % Jump first line it was a header
opts.VariableNamesLine = 1;

data = readtable(filename, opts);

disp('CSV Loaded!');

% Exibit the first lines of the table
head(data)

%Convert the table in separeted variables
times = data{:,1}; % Assuming the first column as time

%Creating workspace variabels, converting columns drom cell to double
varNames = data.Properties.VariableNames;

for i = 2:length(varNames) % Starts in the second line
    colData = data{:, i}; % Catch the column

    % If it is a cell, try to convert into double
    if iscell(colData)
        colData = str2double(colData); % String to number
    end
    
    % Salve the variable in workspace
    assignin('base', varNames{i}, colData);
end

disp('Variable loaded in workspaceAs variáveis foram carregadas no workspace!');


%Gain of shaper
Gs = 2^10;

% Gain of wiener filter weights
Gw = 450;

%Givinng new names to variables. Excluding first datas (doesn't represent
%data)
eng_truth = FPGA_Simulator_v1_PZC_sim_event_bt_12__0_(10:end);
snl_fpga = FPGA_Simulator_v1_PZC_sim_shaper_out_29__0_(10:end);
pzc_fpga = FPGA_Simulator_v1_PZC_sim_pzc_out_28__0_(10:end);
bt_mask_fpga = FPGA_Simulator_v1_PZC_sim_bt_mask_out(10:end);
pedestal_fpga = FPGA_Simulator_v1_PZC_sim_pedestal_out_12__0_(10:end);
shaper_clip_fpga = FPGA_Simulator_v1_PZC_sim_shaper_clip_11__0_(10:end);

shaper_uns = FPGA_Simulator_v1_PZC_sim_pzc_ped_track_pzc_zero_in_12__0_(10:end);

wiener_normal = FPGA_Simulator_v1_PZC_sim_wiener_normal_out_32__0_(14:end);
wiener_pzc = FPGA_Simulator_v1_PZC_sim_wiener_pzc_out_43__0_(14:end);

snl_fpga = snl_fpga(3:end)/(Gs);
shaper_clip_fpga = shaper_clip_fpga(3:end);
%snl_fpga = snl_fpga(3:end)/(1);

shaper_uns = shaper_uns(3:end);
pzc_fpga = pzc_fpga(3:end)/(1*(m_fac+1));

wiener_normal = wiener_normal(2:end)/(Gw);
wiener_pzc = wiener_pzc(2:end)/(Gw*(m_fac+1));

%MAtching number of samples
eng_truth = eng_truth(1:length(wiener_normal));

%Calculating the estimation errors, std and RMSE
error_normal = wiener_normal - eng_truth;
error_pzc = wiener_pzc - (m_fac+1)*eng_truth;

std_normal = std(error_normal);
std_pzc = std(error_pzc);

rms_normal = rms(error_normal);
rms_pzc = rms(error_pzc);




figure('DefaultAxesFontSize',24)
stairs(eng_truth,'g')
hold on;
%stairs(snl_fpga,'b')
stairs(pzc_fpga,'r')
%stairs(shaper_uns,'k')
stairs(shaper_clip_fpga,'k')
%stairs(bt_mask_fpga*2000,'k')
%legend('Generated Amplitude','Shaper Signal','PZC Signal','Shaper Clip');
legend('Generated Amplitude','PZC Signal','Shaper Clip');
xlabel('Sample');
ylabel('Amplitude [ADC Count]');
%xlim([0,1000]);
%ylim([-150,1600]);


%Ploting the Amplitude estimation
figure('DefaultAxesFontSize',24)
stairs(eng_truth,'DisplayName','Energy Truth')
hold on;
%stairs(snl_fpga,'DisplayName','Shaper out')%,'b')
%stairs(shaper_clip_fpga,'DisplayName','Shaper Clip')%,'r')
%stairs(shaper_corrupted_fpga,'DisplayName','Shaper + Noise')%,'r')
%stairs(noise_fpga, 'DisplayName','Noise')%,'r')
stairs(wiener_normal, 'DisplayName','Wiener')%,'r')
stairs(wiener_pzc, 'DisplayName','PZC+Wiener')%,'r')
hold off;
legend;
xlabel('Sample');
ylabel('Amplitude [ADC Count]');
%xlim([17601,18180]);
%ylim([-150,1600]);
