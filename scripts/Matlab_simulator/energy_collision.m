function [generated_energy] = energy_collision(archive,hits);
% Function to simulate the energy according to a given energy vector data 
% archive: archive which are stored the enery vector samples
% hits: vector with position where occurs collisions

% Filtering number of collisions
total_eng = sum(hits);

% Generating the CDF of the data
[y_cdf,x_cdf,eng_original] = cdf_generate_v2(archive);

% Generating the energy values for the hits
generated_energy = eng_gen_v2(x_cdf,y_cdf,total_eng);

% Checking if the two histograms match
check_histogram(eng_original,generated_energy);


