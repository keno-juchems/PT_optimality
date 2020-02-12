% this script reproduces the figures for Juechems et al 2019 "Optimal utility functions for agents 
% with finite computational precision"

close all
clear all

%% add scripts to path
addpath(genpath([pwd(),filesep,'code']));

%% Figure 1a

% plot with reward only objective
noiselevels = 0:0.02:0.1;  % simulated values of sigma. sigma = 0 is no noise.
riskornot = 0;
prospect_unconstrained_fit(noiselevels,riskornot);


%% load & combine human data

thresh = 0.001; % threshold prob of nonrandom choices for excluding participants
[bothdata,subcor,subinclude] = load_combine_data(thresh); 
% subinclude is an indicator vector for which participants were included in
% each group/experiment
% subcor is a vector of acccuracies for included participants in each
% group/experiment
% bothdata is a big struct with the combined data from both experiments

%% figure 2a

% plot with reward + risk objective
noiselevels = 0:0.02:0.1;
riskornot = 1;
prospect_unconstrained_fit(noiselevels,riskornot);
% here we do the same as Fig.1a but with the risk/reward objective.


%% Figure 2b
% note - you need to install the VBA toolbox: https://mbb-team.github.io/VBA-toolbox/ 
model_stuff = compare_models_crossval(bothdata,subcor,subinclude);
% this function loads up a previously run analysis using hierachical
% expectation maximisation for each group/experiment.  it performs BMS on
% combined data from each experiment. the figure generated plots exceedance
% probabilties for both crossvalidated loglikelihoods (odd vs. even
% trials) and for BIC scores [only the former is reported in the paper, but
% both tell approximately the same story and I always trust crossvaldation more].

%% figure 3

% this function generates the loss landscape over parameterisations of
% kappa and gamma for each experiment/group.  It generates this for each
% model [prospect + double exponent] although only the best-fitting model
% is reported in the paper (i.e prospect for uncertain groups and 2-exp for
% certain groups).

% the "out" which is generated contains a bunch of stuff that is useful for
% the figures that demonstrate why distortions are optimal, which are below
% [figs 1b-e in the paper].  

% group certain, experiment 1 [fig 3a]
out = plot_prospect_landscapes(1,1,bothdata,subinclude);

% group certain, experiment 2 [fig 3b]
plot_prospect_landscapes(1,2,bothdata,subinclude);

% group UNcertain, experiment 1 [fig 3c]
plot_prospect_landscapes(2,1,bothdata,subinclude);

% group UNcertain, experiment 2 [fig 3d]
plot_prospect_landscapes(2,2,bothdata,subinclude);


%% figure 1b-e

% note that here we use "out" from group1/exp1 which means the *certain*
% group. this is because in FIg. 1b-e we are interested in demonstrating why distortion
% maximised expected value, without considering risk.

prospect_plot_dv(out);

%% figure 4
prospect_plot_pfunctions(1,1,subinclude)

prospect_plot_pfunctions(1,2,subinclude)

prospect_plot_pfunctions(2,1,subinclude)

prospect_plot_pfunctions(2,2,subinclude)

