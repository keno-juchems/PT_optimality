function prospect_plot_dv(out)

figure('color',[1 1 1]);
for m = 1:2
    subplot(2,2,m);
    hold on;
    imagesc(out.binspace,out.binspace,out.meandiff_1(:,:,m)');set(gca,'ydir','normal');
    colorbar
    ylabel('log(gamma)');
    xlabel('log(kappa)');
    set(gca,'FontSize',16);
    xlim(out.yy);
    ylim(out.yy);
    %colorbar;
    line([0  0],out.yy,'color','k');
    line(out.yy,[0 0],'color','k');
    plot(out.binspace(out.xx_max),out.binspace(out.yy_max),'o','markersize',15,'markeredgecolor','k','linewidth',4);
   
    subplot(2,2,m+2);
    hold on;
    imagesc(out.binspace,out.binspace,out.absmeanDV_1(:,:,m)');set(gca,'ydir','normal');
    colorbar
    ylabel('log(gamma)');
    xlabel('log(kappa)');
    set(gca,'FontSize',16);
    xlim(out.yy);
    ylim(out.yy);
    plot(out.binspace(out.xx_max),out.binspace(out.yy_max),'o','markersize',15,'markeredgecolor','k','linewidth',4);
    line([0  0],out.yy,'color','k');
    line(out.yy,[0 0],'color','k');
end

maxDV_0 = squeeze(out.allDV_0(out.xx_max,out.yy_max,2,:));
maxDV_1 = squeeze(out.allDV_1(out.xx_max,out.yy_max,2,:));

%
[n0 xx] = hist(maxDV_0,-1:0.1:1);
[n1 xx] = hist(maxDV_1,-1:0.1:1);

n0 = n0./length(out.indx);
n1 = n1./length(out.indx);


figure('color',[1 1 1]);
hold on;
plot(xx,n0,'linewidth',4,'color',[0.7 0.7 0.7]);
plot(xx,n1,'linewidth',4,'color',[0.2 0.2 0.2]);
ylabel('fraction of trials');
set(gca,'fontsize',15);
xlabel('decision variable');

kmat = [1 0.5];

figure('color',[1 1 1]);

for k = 1:length(kmat)
    vspace = 0:0.02:1;
    uspace1 = vspace.^kmat(k);
    uspace2 = -(vspace.^kmat(k));
    
    subplot(2,2,1+(k-1)*2);
    hold on;
    plot(vspace,uspace1,'o','color',[0.2 0.7 0.2]);
    plot(vspace,uspace2,'o','color',[0.2 0.3 0.2]);
    ylim([-1 1]);
    xlabel('x','fontsize',14);
    ylabel('v(x)','fontsize',14);
    
    subplot(2,2,2+(k-1)*2);
    hold on;
    plot(vspace,uspace1-uspace2,'o','color',[0.2 0.2 0.2]);
    ylim([0 2]);
    xlabel('x_1 - x_2','fontsize',14);
    ylabel('DV','fontsize',14);
    
end