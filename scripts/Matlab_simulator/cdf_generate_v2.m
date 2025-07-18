function [y,x,eng_truth] = cdf_generate_v2(archive);
% Funciton to generate the CDF information of the original energy values
% y and x: axes of the CDF plot
% eng_truth: used to check the histograms later

% Criar histograma
load(archive);

% Removing values less or equal than zero
eng_truth = eng_truth(eng_truth > 0);

% Calculating the histogram
[num, edges] = histcounts(eng_truth, 100 * round(max(eng_truth)), 'Normalization', 'probability');

% Adjusting the X-Values (center of bins)
x_vals = (edges(1:end-1) + edges(2:end)) / 2;
diff_x = diff(edges);  % Diffence between bins borders

% Calculating the CDF in vector form
y_vals = cumsum(num .* diff_x);
y_vals = y_vals / max(y_vals);  % Normalization

% Plot histogram (PDF)
figure;
bar(x_vals, num);
xlabel('Energu');
ylabel('Frequency');
title('Data Histogram');

% Plot CDF
figure;
bar(x_vals, y_vals);
xlabel('Energy');
ylabel('Probability');
title('CDF Plot');

% Número total de amostras
samples = length(eng_truth);

y = y_vals;
x = x_vals;

