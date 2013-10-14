% Run script of image morphing for CIS 581 Project 2
% Written by Qiong Wang at University of Pennsylvania
% Oct. 9th, 2013

% Clear up
clc;
close all;

% Parameters
method        = 'triangulation';  % 'TPS' or 'triangulation' method
verbose       = true;             % Flag to show intermediate details
morph_rate    = 1/60;             % Morphing rate

% Parse the images
if ~exist('im1', 'var') || ~exist('im2', 'var')
    im1 = imread('qiong.jpg');
    im2 = imread('minion.jpg');
end

% Click correspondence points if there is no saved in the script directory
fullpath = mfilename('fullpath');
script_dir = fileparts(fullpath);
cd(script_dir);
pts_file  = fullfile(script_dir,'points.mat');

if ~exist(pts_file, 'file')
    [im1_pts, im2_pts] = click_correspondences(im1, im2, verbose);
    im_pts = ( im1_pts + im2_pts ) / 2;
    save('points.mat', 'im1_pts', 'im2_pts', 'im_pts')
end

if ~exist('im1_pts', 'var') || ~exist('im2_pts', 'var')
    load('points.mat');
end

% Image morphing and iterative recording
if strcmp(method, 'triangulation')
    tri = delaunay(im_pts);
    writerObj = VideoWriter('Project2_qiong_trig.avi');
else
    writerObj = VideoWriter('Project2_qiong_tps.avi');
end
writerObj.FrameRate = 10;
open(writerObj);

for frac = 0 : morph_rate : 1
    assert(morph_rate < 1 || morph_rate > 0, 'Morph rate should be real number from 0 to 1!')
    fprintf('Processing step # %d... \n', frac/morph_rate );
    warp_frac     = frac; % min(max(frac, 0), 1);
    dissolve_frac = frac; % min(max(frac, 0), 1);
    if strcmp(method, 'triangulation')
        morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac);
    else
        morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
    end
    imshow(morphed_im); axis image; axis off; drawnow;
    writeVideo(writerObj, getframe(gcf));
end
close(writerObj);