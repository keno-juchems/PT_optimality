function out = plot_prospect_landscapes(g,e,bothdata,subinclude);


modelspace = 1:2;
grmat = [0 2];

dir_path = [pwd(),filesep,'data',filesep,'hierarchicalEM',filesep];

tmp = load([dir_path,'HEMstuff2_exp',num2str(e),'_group',num2str(grmat(g)),'.mat'],'*');
close;
all_model_params{e,g} = tmp.model_params(subinclude{e,g}==1,:,modelspace);
X = tmp.X(modelspace);

modelspace = 1:2;

indx = find(bothdata.expt_group==grmat(g) & bothdata.exper==e);

models = length(X);

VV = bothdata.vbxi_value./100;
PP = bothdata.vbxi_probability./100;

% search range
yy = [-3 3];

% correct for infinite entropy under p = 1 or p = 0
PP(PP == 1) = 0.99;
PP(PP == 0) = 0.01;
ent = 1-((-PP.*log(PP)) - ((1-PP).*log(1-PP)));  % entropy

figure('color', [1 1 1],'position',[704 289 737 666]);

nbins = 50;
binspace = linspace(yy(1),yy(2),nbins);
[x,y] = ndgrid(binspace,binspace);

modelnames = {'prospect','double exp'};

for m = 1:models;
    
    EV = VV(:,indx).*PP(:,indx);
    EVdiff = EV(1,:) - EV(2,:);
    X(m).V = VV(:,indx);
    X(m).P = PP(:,indx);
    X(m).ent = ent(:,indx);
    
    if g == 2;
        X(m).U = X(m).V.*X(m).P.*X(m).ent;
    elseif g == 1;
        X(m).U = X(m).V.*X(m).P;
    end
    
    noise = median(all_model_params{e,g}(:,4,m));
    leak = median(all_model_params{e,g}(:,5,m));
    
    for d1 = 1:nbins
        for d2 = 1:nbins
            valz(d1,d2,m) = -fitEV(X(m),[x(d1,d2) y(d1,d2) 0 noise leak]);
            valz0(d1,d2,m) = -fitEV(X(m),[0 0 0 noise leak]);
            
            [~,modelcp,DV_0] = fitEV(X(m),[0 0 0 noise leak]);
            [~,modelcp,DV_1] = fitEV(X(m),[x(d1,d2) y(d1,d2) 0 noise leak]);
            
            % these are useful for later
            out.meandiff_0(d1,d2,m) = mean(sign(EVdiff)==sign(DV_0));
            out.meandiff_1(d1,d2,m) = mean(sign(EVdiff)==sign(DV_1));
            
            out.absmeanDV_0(d1,d2,m) = mean(abs(DV_0));
            out.absmeanDV_1(d1,d2,m) = mean(abs(DV_1));
            
            out.allDV_0(d1,d2,m,:) = DV_0;
            out.allDV_1(d1,d2,m,:) = DV_1;
           
        end
    end
    
    
    valspace = linspace(min(valz(:)),max(valz(:)),20);
    
    
    subplot(2,models,m);
    hold on;
    contourf(binspace,binspace,valz(:,:,m)',valspace);
    [xx_max yy_max] = find(valz(:,:,m) == max(squelch(valz(:,:,m))));
    plot((all_model_params{e,g}(:,1,m)),(all_model_params{e,g}(:,2,m)),'ro');
    mk = mean(all_model_params{e,g}(:,1,m));
    mg = mean(all_model_params{e,g}(:,2,m));
    %  line([mk mk],yy,'color','r','linewidth',2);line(yy,[mg mg],'color','r','linewidth',2);
    plot(binspace(xx_max),binspace(yy_max),'o','markersize',15,'markeredgecolor','k','linewidth',4);
    ylabel('log(gamma)');
    xlabel('log(kappa)');
    set(gca,'FontSize',16);
    xlim(yy);
    ylim(yy);
    set(gca,'clim',[min(valspace) max(valspace)]);
    line([0  0],yy,'color','k');
    line(yy,[0 0],'color','k');
    title(modelnames{m});
    %colorbar;
    
    subplot(2,models,m+models);
    hold on;
    imagesc(binspace,binspace,double(valz(:,:,m)'-valz0(:,:,m)'));
    if g == 2 & e == 2
        set(gca,'clim',[-0.025 0.025]);
    else
        set(gca,'clim',[-0.01 0.01]);
    end
    
    set(gca,'ydir','normal');
    
    plot((all_model_params{e,g}(:,1,m)),(all_model_params{e,g}(:,2,m)),'ro');
    ylabel('log(gamma)');
    xlabel('log(kappa)');
    set(gca,'FontSize',16);
    xlim(yy);
    ylim(yy);
    %colorbar;
    line([0  0],yy,'color','k');
    line(yy,[0 0],'color','k');
    title(modelnames{m});
end

out.xx_max = xx_max;
out.yy_max = yy_max;
out.binspace = binspace;
out.yy = yy;
out.indx = indx;
