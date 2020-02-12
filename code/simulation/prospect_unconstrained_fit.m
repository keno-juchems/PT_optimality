function prospect_unconstrained_fit(noiselevels,riskornot,removetrivial);

if nargin<2
    riskornot = 1;
end

if nargin <3
    bins = 10;
end

if nargin<4
    removetrivial = 1;
end

%% sanity check: fit PT to perfect greedy choices

vmat = linspace(0.01,0.99,bins);        % gamble values
pmat = linspace(0.01,0.99,bins);        % gamble probabilities

options = optimoptions('fmincon','Display',        'none',...
    'OptimalityTolerance',      0,...
    'StepTolerance',            0,...
    'MaxIterations',            1e4,...
    'MaxFunctionEvaluations',   1e4);

% generate training gamble indices (P1 and V1) and test gamble indices (P2 and V2)
[X1 T1 EV1 V1 P1 X2 T2 EV2 V2 P2] = makeprospectoddeven(pmat,vmat,removetrivial);

figure('color', [1 1 1],'position',[289 540 1174 394]);

for s = 1:length(noiselevels)
    
    sigma = noiselevels(s);
    disp(['late noise...',num2str(sigma)]);
    
    % probabilities and values on each trials
    PP = pmat(P1);  %compute gamble prob list from indices
    VV = vmat(V1);  %compute gamble value list from indicess
    
    % compute entropy
    H = 1-((-PP.*log(PP)) - ((1-PP).*log(1-PP)));  % entropy
    
    % compute Y
    if riskornot;
        Y = VV.*PP.*H;  % target, with entro
    else
        Y = VV.*PP;
    end
    
    x.V = VV;
    x.P = PP;
    x.Y = Y;
    x.indx = 1:length(VV);
    
    startfree = [(vmat) (pmat) sigma];  % initialisation
    minfree = [ones(1,10)*floor(min(vmat)) zeros(1,10) sigma];  % constraints (max)
    maxfree = [ones(1,10)*ceil(max(vmat)) ones(1,10) sigma];  % constraints (min)
    
    % optimize
    freeparamz(s,:) = fmincon(@(p) freefitEV(x,p),startfree,[],[],[],[],minfree,maxfree,[],options);
    
    % refit to test data
    PP = pmat(P2);
    VV = vmat(V2);
    H = 1-((-PP.*log(PP)) - ((1-PP).*log(1-PP)));  % entropy from natural logarithm
    
    if riskornot;
        Y = VV.*PP.*H;
    else
        Y = VV.*PP;
    end
    
    x.V = VV;
    x.P = PP;
    x.Y = Y;
    x.indx = 1:length(VV);
    
    ff(s,1) = freefitEV(x,freeparamz(s,:));
    disp(['free fit = ',num2str(ff(s,1))]);
    ff(s,2) = freefitEV(x,[vmat pmat sigma]);
    disp(['linear fit = ',num2str(ff(s,2))]);
    ff(s,3) = freefitEV(x,[rand(1,20) sigma]);
    disp(['random fit = ',num2str(ff(s,3))]);
    
    
    %% now plot
    
    minV = floor(min(VV(:)));
    maxV = ceil(max(VV(:)));
    minP = floor(min(pmat));
    maxP = ceil(max(pmat));
    
    subplot(2,length(noiselevels),s);
    hold on;
    line([minV maxV],[minV maxV],'color','k','linestyle',':');
    line([0 0],[minV maxV],'color','k','linestyle','-');
    line([minV maxV],[0 0],'color','k','linestyle','-');
    plot(vmat,freeparamz(s,1:10),'bo-','linewidth',2);
    
    ylim([minV maxV]);
    xlabel('x_j');
    ylabel('c^x_j')
    title(['\sigma = ',num2str(sigma)]);
    
    subplot(2,length(noiselevels),s+length(noiselevels))
    
    hold on;
    line([minP maxP],[minP maxP],'color','k','linestyle',':');
    line([0.5 0.5],[minP maxP],'color','k','linestyle','-');
    line([minP maxP],[0.5 0.5],'color','k','linestyle','-');
    plot(pmat,freeparamz(s,11:20),'ro-','linewidth',2);
    
    ylim([minP maxP]);
    xlabel('p_j');
    ylabel('c^p_j')
    
end