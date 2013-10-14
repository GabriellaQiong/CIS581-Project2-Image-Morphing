function  [a1,ax,ay,w] = est_tps(pts, target_val, lambda)
% EST_TPS estimates parameters for thin-plate_spline model

% Written by Qiong Wang at University of Pennsylvania
% Oct. 10th, 2013

% Initialize
pts_num = size(pts, 1);
if nargin < 3
    lambda  = eps;
end

% Function handles
mat_diff = @(vector) repmat(vector, 1, pts_num) - transpose(repmat(vector, 1, pts_num));
U        = @(r_sqr) -r_sqr.* log(r_sqr);

% Matrices and vectors
P = [ones(pts_num, 1), pts];
K = U(mat_diff(pts(:,1)).^2 + mat_diff(pts(:,2)).^2);
K(isnan(K)) = 0;
A = [K P; P', zeros(3)];
v = [target_val; zeros(3,1)];

% Compute and output results
coef = (A + lambda * eye(pts_num + 3))\v;
w    = coef(1:pts_num);
a1   = coef(pts_num+1);
ax   = coef(pts_num+2);
ay   = coef(pts_num+3);
end