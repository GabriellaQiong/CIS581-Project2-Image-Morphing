function [im1_pts, im2_pts] = click_correspondences(im1, im2, verbose)
% CLICK_CORRESPONDENCES let the user to click the corresponding points in
% two images which are used to morph.

% Written by Qiong Wang at University of Pennsylvania
% Oct. 9th, 2013

if nargin < 3
   verbose = false; 
end

% Pad with zero at the largest extent
[nr1, nc1, ~] = size(im1);
[nr2, nc2, ~] = size(im2);
nr            = max(nr1, nr2); 
nc            = max(nc1, nc2);
im1_pad       = padarray(im1, [nr-nr1, nc-nc1], 'replicate', 'post');
im2_pad       = padarray(im2, [nr-nr2, nc-nc2], 'replicate', 'post');

% Select corresponding points
disp('Please do not click the four corner points, this function will choose them automatically.');
[im2_pts, im1_pts] = cpselect(im2_pad, im1_pad,'Wait', true);

% Add the corner points
im1_pts = [im1_pts; 0, 0; 0, nr; nc, nr; nc, 0];
im2_pts = [im2_pts; 0, 0; 0, nr; nc, nr; nc, 0];

% Check the points
if verbose
    figure();
    subplot(1,2,1);imshow(im1_pad);title('Original Image');  axis image;
    hold on; plot(im1_pts(:,1), im1_pts(:,2), 'r*');
    subplot(1,2,2);imshow(im2_pad);title('Objective Image'); axis image;
    hold on; plot(im2_pts(:,1), im2_pts(:,2), 'g*')
end

end