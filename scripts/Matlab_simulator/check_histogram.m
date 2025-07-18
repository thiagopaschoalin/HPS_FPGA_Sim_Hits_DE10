function check_histogram(eng_original,eng_gen);
% Function to compare the two histograms


[num2, edges2,bin2] = histcounts(eng_original, 150, 'Normalization','probability'); 
[num, edges,bin] = histcounts(eng_gen, 150, 'Normalization','probability'); 


x_vals2 = (edges(1:end-1) + edges(2:end)) / 2;
y_vals2 = num;

x_vals3 = (edges2(1:end-1) + edges2(2:end)) / 2;
y_vals3 = num2;


figure
bar(x_vals3, y_vals3,'FaceAlpha',.5);
%bar(x_vals3, y_vals3);
hold on;
bar(x_vals2, y_vals2,'FaceAlpha',.5);
%bar(x_vals2, y_vals2);
xlabel('Energy');
%set(gca, 'YScale', 'log');
ylabel('Frequency');
legend('Truth','Generated');
title('Data Histogram - Linear Scale');
grid on;

% Exibir histograma
figure
bar(x_vals3, y_vals3,'FaceAlpha',.5);
%bar(x_vals3, y_vals3);
hold on;
bar(x_vals2, y_vals2,'FaceAlpha',.5);
%bar(x_vals2, y_vals2);
xlabel('Energy');
set(gca, 'YScale', 'log');
ylabel('Frequency');
legend('Truth','Generated');
title('Data Histogram - Log Scale');
grid on;

