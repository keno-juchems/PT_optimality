function [grid] = get_loss_ptprob(alphas,gammas,n_iter,sigma,left_v,left_p,right_v,right_p,left,right,flag)

grid    = nan(n_iter,n_iter);

% Search over grid 
for i = 1:n_iter % gammas (y-axis)
    for j = 1:n_iter % alphas (x-axis)
        [this_mean] = get_point_loss(left_v,left_p,right_v,right_p,left,right,alphas(j),gammas(i),sigma,flag);
        grid(i,j) = this_mean;
    end
end

end