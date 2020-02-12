function prospect_plot_pfunctions(g,e,subinclude)

exmat = [1 2];
grmat = [0 2];

subz = subinclude{e,g}==1;

dir_path = [pwd(),filesep,'data',filesep,'RFX',filesep];


hum = load([dir_path,'GAstuff2_exp',num2str(exmat(e)),'_group',num2str(grmat(g)),'.mat'],'submat','logdata');
opt = load([dir_path,'GAstuff2EV_exp',num2str(exmat(e)),'_group',num2str(grmat(g)),'.mat'],'logdata');
any = load([dir_path,'GAstuff2any_exp',num2str(exmat(e)),'_group',num2str(grmat(g)),'.mat'],'logdata');

vv = linspace(0,1,100);

% extract best fitting prospect params for each subject
for s = 1:length(hum.submat);
    if g == 2; % Use prospect model
    kappa = (any.logdata.x(s,1,2));
    gamma = (any.logdata.x(s,3,2));
    noise = (any.logdata.x(s,4,2));
    v_prospect(s,:) = vv.^kappa;
    p_prospect(s,:) = (vv.^gamma)./((vv.^gamma)+((1-vv).^gamma)).^(1./gamma);
    else  % use 2-exp model
    kappa = (any.logdata.x(s,1,1));    % exp1
    gamma = (any.logdata.x(s,3,1));    % exp1
    noise = (any.logdata.x(s,4,1));   
    v_prospect(s,:) = vv.^kappa;      % we call this v_prospect but it's for either model
    p_prospect(s,:) = vv.^gamma;      % ditto
    end      
end


%%
reddy = [ones(64,1) linspace(1,0,64)' linspace(1,0,64)'];
bluey = [linspace(1,0,64)' linspace(1,0,64)' ones(64,1)];

figure('color',[1 1 1],'position',[560 622 857 326]);

subplot(1,2,1);
hold on;
opty = opt.logdata.x(subz,1:10);

for s = 1:size(opty,1);iopty(s,:) = interp(opty(s,:),10);end
mu = mean(iopty);
sigma = std(iopty);
im = normpdf(vv,mu',sigma');
imagesc(vv,vv,im');set(gca,'ydir','normal');
set(gca,'colormap',bluey);
plot(vv,mean(v_prospect),'color','k','linewidth',3);

xlim([0 1]);
ylim([0 1]);
%set(gca,'xtick',1:11);
%set(gca','xticklabel',vv);
line([0 1],[0 1],'color','k');
xlabel('value x','fontsize',15);
ylabel('est. coeff. v(x)','fontsize',15);

subplot(1,2,2);
hold on;
opty = opt.logdata.x(subz,11:20);
for s = 1:size(opty,1);iopty(s,:) = interp(opty(s,:),10);end
mu = mean(iopty);
sigma = std(iopty);
im = normpdf(vv,mu',sigma');
imagesc(vv,vv,im');set(gca,'ydir','normal');
set(gca,'colormap',reddy);
plot(vv,mean(p_prospect),'color','k','linewidth',3);
%plot(0.05:0.1:0.95,mean(hum.logdata.x(subz,11:20)),'linewidth',3,'color','k');

xlim([0 1]);
ylim([0 1]);
line([0 1],[0 1],'color','k');
xlabel('prob p','fontsize',15);
ylabel('est. coeff. w(p)','fontsize',15);
