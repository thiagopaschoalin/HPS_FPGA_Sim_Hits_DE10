clear all
close all


% Load example cell
cell = "A13";
load(strcat('original_data/eng_truth_',cell,'.mat'));

% Cutting energy
posicao = find(eng_truth > 0);%(20/3));
eng_truth = eng_truth(posicao);

posicao = find(eng_truth <= 4095);%(20/3));
eng_truth = eng_truth(posicao);


% Creating histogram
%[num, edges] = histcounts(eng_truth, 'Normalization','probability', 'BinMethod', 'auto'); 
[num, edges] = histcounts(eng_truth, round(max(eng_truth)) , 'Normalization','probability'); 

% Adjusting values to the center of bins
x_vals = (edges(1:end-1) + edges(2:end)) / 2;
x_vals_n = x_vals;
y_vals_n = num;

% Creating the CDF
diff_x = (edges(2:end) - edges(1:end-1));
y_vals(1) = num(1) * diff_x(1);

for i = 2: length(num)
    y_vals(i) = num(i)*diff_x(i) + y_vals(i-1);
end

%Normalizing the CDF
y_vals = y_vals/max(y_vals);


samples = length(eng_truth);


% Size of the memory
num_table = 2^10;


div_y = 1/(num_table-1);


%Populating the memory 1
y_ticks = [0:div_y:1];

for i = 1:length(y_ticks)
    pos_tick_greater = find (y_vals > y_ticks(i));
    pos_tick_equal =   find (y_vals >= y_ticks(i));
    
    empty_pos_tick_greater = isempty(pos_tick_greater);
    
    if(empty_pos_tick_greater == 1)
        x_ticks(i) = x_vals(pos_tick_equal(1));
        
    else
        if (pos_tick_greater(1) == pos_tick_equal(1))
            if(pos_tick_greater(1) == 1)
                x_ticks(i) = x_vals(pos_tick_greater(1));
            else
                x_ticks(i) = x_vals(pos_tick_greater(1)-1);
            end
        else
            x_ticks(i) = x_vals(pos_tick_equal(1));
        end
    end
    
    
%     if (pos_tick(1) == 1)
%         x_ticks(i) = x_vals(1);
%     else
%         x_ticks(i) = x_vals(pos_tick(1)-1);
%     end
end

%Thrshold for the first memory (empirichal)
threshold1 = 10; % Change for each cell
dist_x_ticks1 = x_ticks(2:end) - x_ticks(1:end-1);
pos_dist_x_ticks1 = find(dist_x_ticks1 > threshold1);


%Creating the initial point for the 2nd memory
parada1 = pos_dist_x_ticks1(1);
inicio1 = y_ticks(pos_dist_x_ticks1(1));


%Populating the 2nd memory
div_y1 = (1-inicio1)/(num_table-1);

y_ticks1 = [inicio1:div_y1:1];

for i = 1:length(y_ticks1)
    pos_tick_greater1 = find (y_vals > y_ticks1(i));
    pos_tick_equal1 =   find (y_vals >= y_ticks1(i));
    
    empty_pos_tick_greater1 = isempty(pos_tick_greater1);
    
    if(empty_pos_tick_greater1 == 1)
        x_ticks1(i) = x_vals(pos_tick_equal1(1));
        
    else
        if (pos_tick_greater1(1) == pos_tick_equal1(1))
            if(pos_tick_greater1(1) == 1)
                x_ticks1(i) = x_vals(pos_tick_greater1(1));
            else
                x_ticks1(i) = x_vals(pos_tick_greater1(1)-1);
            end
        else
            x_ticks1(i) = x_vals(pos_tick_equal1(1));
        end
    end
    
    
%     if (pos_tick(1) == 1)
%         x_ticks(i) = x_vals(1);
%     else
%         x_ticks(i) = x_vals(pos_tick(1)-1);
%     end
end

%Thrshold for the 2nd memory (empirichal)
threshold2 = 10; % Change for each cell
dist_x_ticks2 = x_ticks1(2:end) - x_ticks1(1:end-1);
pos_dist_x_ticks2 = find(dist_x_ticks2 > threshold2);

%Creating the initial point for the 3rd memory
parada2 = pos_dist_x_ticks2(1);
inicio2 = y_ticks1(pos_dist_x_ticks2(1));


%Populating the 3rd memory
div_y2 = (1-inicio2)/(num_table-1);

y_ticks2 = [inicio2:div_y2:1];

for i = 1:length(y_ticks2)
    pos_tick_greater2 = find (y_vals > y_ticks2(i));
    pos_tick_equal2 =   find (y_vals >= y_ticks2(i));
    
    empty_pos_tick_greater2 = isempty(pos_tick_greater2);
    
    if(empty_pos_tick_greater2 == 1)
        x_ticks2(i) = x_vals(pos_tick_equal2(1));
        
    else
        if (pos_tick_greater2(1) == pos_tick_equal2(1))
            if(pos_tick_greater2(1) == 1)
                x_ticks2(i) = x_vals(pos_tick_greater2(1));
            else
                x_ticks2(i) = x_vals(pos_tick_greater2(1)-1);
            end
        else
            x_ticks2(i) = x_vals(pos_tick_equal2(1));
        end
    end
    
    
%     if (pos_tick(1) == 1)
%         x_ticks(i) = x_vals(1);
%     else
%         x_ticks(i) = x_vals(pos_tick(1)-1);
%     end
end


x_ticks_junto = [x_ticks(1:parada1-1),x_ticks1(1:parada2-1),x_ticks2];
y_ticks_junto = [y_ticks(1:parada1-1),y_ticks1(1:parada2-1),y_ticks2];


% Exibiting the CDF
figure
bar(x_vals, y_vals);
hold on;
plot(x_ticks_junto,y_ticks_junto)
xlabel('Valores do eixo X');
ylabel('Frequência');
title('Histograma dos Dados');


%Testing if it is good
%Genrating random numbers and using the table to generate the energy
%rand_num = randi(num_table,samples,1)
rand_num1 = randi(num_table,samples,1);

posicao_rand1_1 = find(rand_num1 <= parada1);
posicao_rand2_1 = find(rand_num1 > parada1);

samples_mem2 = length(posicao_rand2_1);
rand_num2 = randi(num_table,samples_mem2,1);

posicao_rand1_2 = find(rand_num2 <= parada2);
posicao_rand2_2 = find(rand_num2 > parada2);

samples_mem3 = length(posicao_rand2_2);
rand_num3 = randi(num_table,samples_mem3,1);

eng_rand_temp = zeros(1,samples_mem2);
eng_rand_temp(posicao_rand1_2) = x_ticks1(rand_num2(posicao_rand1_2));
eng_rand_temp(posicao_rand2_2) = x_ticks2(rand_num3);


eng_rand = zeros(1,samples);
eng_rand(posicao_rand1_1) = x_ticks(rand_num1(posicao_rand1_1));
eng_rand(posicao_rand2_1) = eng_rand_temp;


% eng_rand = zeros(1,samples);
% eng_rand(posicao_rand1_1) = x_ticks(rand_num1(posicao_rand1_1));
% eng_rand(posicao_rand2_1) = x_ticks1(rand_num2);


% Histograms
%[num, edges,bin] = histcounts(eng_rand, 'Normalization','probability', 'BinMethod', 'auto'); 
%[num2, edges2,bin2] = histcounts(eng_truth, length(num), 'Normalization','probability'); 

%[num2, edges2,bin2] = histcounts(eng_rand, 'Normalization','probability', 'BinMethod', 'auto'); 
%[num, edges,bin] = histcounts(eng_truth, length(num2), 'Normalization','probability'); 
[num2, edges2,bin2] = histcounts(eng_truth, 150, 'Normalization','probability'); 
[num, edges,bin] = histcounts(eng_rand, 150, 'Normalization','probability'); 

% Adjusting the center of bins
x_vals2 = (edges(1:end-1) + edges(2:end)) / 2;
y_vals2 = num;

x_vals3 = (edges2(1:end-1) + edges2(2:end)) / 2;
y_vals3 = num2;


% Exibiting Histograms
figure
bar(x_vals3, y_vals3,'FaceAlpha',.5);
%bar(x_vals3, y_vals3);
hold on;
bar(x_vals2, y_vals2,'FaceAlpha',.5);
%bar(x_vals2, y_vals2);
xlabel('Valores do eixo X');
%set(gca, 'YScale', 'log');
ylabel('Frequência');
legend('Truth','MC');
title('Histograma dos Dados');
grid on;

figure
bar(x_vals3, y_vals3,'FaceAlpha',.5);
%bar(x_vals3, y_vals3);
hold on;
bar(x_vals2, y_vals2,'FaceAlpha',.5);
%bar(x_vals2, y_vals2);
xlabel('Valores do eixo X');
set(gca, 'YScale', 'log');
ylabel('Frequência');
legend('Truth','MC');
title('Histograma dos Dados');
grid on;


%% Saving memory files

% Name of the memory files
nome_arquivo1 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/',cell,'_PART11.mif');
nome_arquivo2 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/',cell,'_PART21.mif');
nome_arquivo3 = strcat('../../../HPS_FPGA_Simulador_v1_DE10/Simulador_Arquivos/',cell,'_PART31.mif');

%quantization factor
factor_quant = 1;


x_ticks_int = round(x_ticks * factor_quant);
x_ticks1_int = round(x_ticks1 * factor_quant);
x_ticks2_int = round(x_ticks2 * factor_quant);

%Number of bits of the memory data
num_bits = 13;

%Converting to binary
x_ticks_bin = dec2bin(typecast(int32(x_ticks_int),'uint32'));
x_ticks1_bin = dec2bin(typecast(int32(x_ticks1_int),'uint32'));
x_ticks2_bin = dec2bin(typecast(int32(x_ticks2_int),'uint32'));

% x_ticks_bin_10 = x_ticks_bin(:,32-num_bits+1:32);
% x_ticks1_bin_10 = x_ticks1_bin(:,32-num_bits+1:32);
% x_ticks2_bin_10 = x_ticks2_bin(:,32-num_bits+1:32);

x_ticks_bin_10 = x_ticks_bin;
x_ticks1_bin_10 = x_ticks1_bin;
x_ticks2_bin_10 = x_ticks2_bin;

%Openning files to write
fid1 = fopen(nome_arquivo1, 'w');
fid2 = fopen(nome_arquivo2, 'w');
fid3 = fopen(nome_arquivo3, 'w');

% Checking if it opened correctly
if fid1 == -1
    error('Error in opening file 1.');
end
if fid2 == -1
    error('Error in opening file 2.');
end
if fid3 == -1
    error('Error in opening file 3.');
end


% Writing strings in the files
for i = 1:length(x_ticks_bin_10)
    fprintf(fid1, '%s\n', x_ticks_bin_10(i,:));
end

for i = 1:length(x_ticks1_bin_10)
    fprintf(fid2, '%s\n', x_ticks1_bin_10(i,:));
end

for i = 1:length(x_ticks2_bin_10)
    fprintf(fid3, '%s\n', x_ticks2_bin_10(i,:));
end


% Closing files
fclose(fid1);
fclose(fid2);
fclose(fid3);

disp('Files created with success.');