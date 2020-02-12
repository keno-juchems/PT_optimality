function [bothdata,subcor,subinclude] = load_combine_data(thresh);

exmat = [1 2];
grmat = [0 2];

do_comparison = 1;

options.DisplayWin = 0;

data_path = [pwd(),filesep,'data',filesep,'raw_data',filesep];

%%
bothdata = [];
for e = 1:2;  % loop over experiments
    
    if e==1;
        load([data_path,'PT_180802.mat']);    % experiment 1;
    else
        load([data_path,'PT_190808.mat']);    % experiment 2;
    end
    
    data = alldata.sdata;
    data.exper = ones(length(data.expt_trial),1).*e;
    
    try data.vb_subject = data.expt_subject;end
    
    if e == 1
        data = transposefields(data);
        bothdata = data;
    else
        data = transposefields(data);
        bothdata = catstruct(bothdata,data);
    end
end

bothdata.choice = 1-bothdata.resp_response;
bothdata.cor = bothdata.choice.*0;
EV = bothdata.vbxi_value.*bothdata.vbxi_probability;
signV = double(EV(1,:)>EV(2,:));
bothdata.cor(isnan(bothdata.choice))= 0;
bothdata.cor(bothdata.choice==signV) = 1;



%% work out participant selection

[choice,cor] = prospectgetchoicecor(transposefields(bothdata));

for e = 1:length(exmat);
    
    for g = 1:2;
        submat = unique(bothdata.vb_subject(bothdata.expt_group == grmat(g) & bothdata.exper==e));
        
        for s = 1:length(submat);
            indx = find(bothdata.vb_subject==submat(s));
            pval = binopdf(sum(bothdata.cor(indx)),length(indx),0.5);
            
            subinclude{e,g}(s) = double(pval<thresh);
            subcor{e,g}(s) = mean(cor(indx));
        end
        
    end
    
end

for e = 1:2;
    for g = 1:2
        subcor{e,g} = subcor{e,g}(subinclude{e,g}==1);
    end
end

