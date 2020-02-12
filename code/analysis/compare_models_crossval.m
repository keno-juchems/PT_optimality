function model_stuff = compare_models_crossval(bothdata,subcor,subinclude)

grmat = [0 2];
grnames = {'cert','uncert'};

modelspace = 1:2;

options.DisplayWin = 0;

dir_path = [pwd(),filesep,'data',filesep,'hierarchicalEM',filesep];

for g = 1:length(grmat);
    tmp1 = load([dir_path,'HEMstuff2_exp1_group',num2str(grmat(g)),'.mat'],'*');
    tmp2 = load([dir_path,'HEMstuff2_exp2_group',num2str(grmat(g)),'.mat'],'*');
    
    concat_cross = -[tmp1.new_cross_model_evidence(subinclude{1,g}==1,modelspace);tmp2.new_cross_model_evidence(subinclude{2,g}==1,modelspace)];
    concat_bic =  [tmp1.model_evidence(subinclude{1,g}==1,modelspace);tmp2.model_evidence(subinclude{2,g}==1,modelspace)];
    
    [posterior,out] = VBA_groupBMC(concat_cross',options);
    concat_cross_freqs{g} = posterior.r;
    concat_cross_ep(:,g) = out.ep;
    
    [posterior,out] = VBA_groupBMC(concat_bic',options);
    concat_bic_freqs{g} = posterior.r;
    concat_bic_ep(:,g) = out.ep;
end

close all;


% plot concat
figure('color',[1 1 1]);

for g = 1:length(grmat);
    subplot(2,2,g);
    bar(concat_cross_ep(:,g),'facecolor',[0.2 0.8 0.2]);
    ylim([0 1]);
    title(['crossval LL  group ',num2str(grnames{g})]);
    set(gca,'xticklabel',{'prospect','2exp'});
    ylabel('exceedance prob.');
    subplot(2,2,g+2);
    bar(concat_bic_ep(:,g),'facecolor',[0.2 0.8 0.2]);
    ylim([0 1]);
    title(['BIC  group ',num2str(grnames{g})]);
    set(gca,'xticklabel',{'prospect','2exp'});
    ylabel('exceedance prob.');
end

model_stuff = tmp1;

