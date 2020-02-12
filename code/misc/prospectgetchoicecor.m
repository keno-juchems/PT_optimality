function [choice,cor] = prospectgetchoicecor(data);

VV = data.vbxi_value;
PP = data.vbxi_probability;

EV = VV.*PP;
g1high = EV(:,1) > EV(:,2);

choice = 1-data.resp_response;
cor = g1high==choice;

