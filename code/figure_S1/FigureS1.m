%% Reproduces Figure S1: Comparison of late noise and encoding noise models
% Noise is only applied at either the decision level (our model) or the 
% probability encoding (as, for instance, in Steiner & Stewart, 2016, AER),
% which the comparison model is based on

function FigureS1()

%% Load and re-shuffle data, such that the certain gamble is always on the "right"
% load([pwd(),filesep,'raw_data',filesep,'PT_190808.mat');
% data = alldata.sdata;

use = logical(ones(25000,1)); %optional: exclude data
left_v = data.vbxi_value(use,1)/100;
left_p = data.vbxi_probability(use,1)/100;
right_v = data.vbxi_value(use,2)/100;
right_p = data.vbxi_probability(use,2)/100;
left = data.vbxi_product(use,1);
right = data.vbxi_product(use,2);
indx = left_p > 0.99;

% Reshuffle for encoding noise model
tmp = left_p(indx);
left_p(indx) = right_p(indx);
right_p(indx) = tmp;
tmp = left_v(indx);
left_v(indx) = right_v(indx);
right_v(indx) = tmp;
left = left_v .* left_p;
right = right_v .* right_p;

%% Set up the search grid
n_iter = 50;
alphas = exp(linspace(-3,3,n_iter));
alphas = sort([alphas,1]);
gammas = exp(linspace(-3,3,n_iter));
gammas = sort([gammas,1]);

[X,Y] = meshgrid(log(gammas),log(alphas));

%% Our model: No entropy (left column)

best_sigmas = 1./linspace(0,1,6); % our model saturates at: 0.4 (with entropy) and ~1 without
figure();
flag = 'no_entropy';
for s = 1:6
    our_model = get_loss_ptprob(alphas,gammas,n_iter+1,best_sigmas(s),left_v,left_p,right_v,right_p,left,right,flag);
    subplot(1,6,s);
    vals = linspace(min(our_model(:)),max(our_model(:)),20);
    contourf(X,Y,our_model,vals);
    hold on;
    l1 = line([-3,3],[0,0]);
    l1.Color = [0,0,0];
    l1.LineWidth = 1.5;
    l2 = line([0,0,],[-3,3]);
    l2.Color = [0,0,0];
    l2.LineWidth = 1.5;
    [i,j] = find(our_model == max(our_model(:)));
    plot(X(i,j),Y(i,j),'o','markersize',15,'markeredgecolor','k','linewidth',4);
    title(sprintf('No entropy - sigma: %1.2f',1/best_sigmas(s)));
end

%% Our model: with entropy (middle column)

best_sigmas = 1./linspace(0,0.4,6); % our model saturates at: 0.4 (with entropy) and ~1 without
figure();
flag = 'with_entropy';
for s = 1:6
    our_model = get_loss_ptprob(alphas,gammas,n_iter+1,best_sigmas(s),left_v,left_p,right_v,right_p,left,right,flag);
    subplot(1,6,s);
    vals = linspace(min(our_model(:)),max(our_model(:)),20);
    contourf(X,Y,our_model,vals);
    hold on;
    l1 = line([-3,3],[0,0]);
    l1.Color = [0,0,0];
    l1.LineWidth = 1.5;
    l2 = line([0,0,],[-3,3]);
    l2.Color = [0,0,0];
    l2.LineWidth = 1.5;
    [i,j] = find(our_model == max(our_model(:)));
    plot(X(i,j),Y(i,j),'o','markersize',15,'markeredgecolor','k','linewidth',4);
    title(sprintf('With entropy - sigma: %1.2f',1/best_sigmas(s)));
end


%% Encoding noise model (right column)

best_sigmas = linspace(0,1,6); % Saturates at ~sigma = 1
figure();
for s = 1:6
    SnS_model  = get_loss_ptprob_SnS(alphas,gammas,n_iter+1,best_sigmas(s),left_v,left_p,right_v,right_p,left,right);
    subplot(1,6,s);
    vals = linspace(min(SnS_model(:)),max(SnS_model(:)),20);
    contourf(X,Y,SnS_model,20);
    hold on;
    l1 = line([-3,3],[0,0]);
    l1.Color = [0,0,0];
    l1.LineWidth = 1.5;
    l2 = line([0,0,],[-3,3]);
    l2.Color = [0,0,0];
    l2.LineWidth = 1.5;
    [i,j] = find(SnS_model == max(SnS_model(:)));
    plot(X(i,j),Y(i,j),'o','markersize',15,'markeredgecolor','k','linewidth',4);
    title(sprintf('Encoding noise - sigma: %1.2f',best_sigmas(s)));
end


end
