function legal_pixel = pixel_limit(origin_pixel, nr, nc)
% PIXEL_LIMIT limits the pixel within legal region

% Written by Qiong Wang at University of Pennsylvania
% Oct. 9th, 2013

legal_pixel = round(bsxfun(@rdivide, origin_pixel, origin_pixel(end, :)));
legal_pixel = bsxfun(@min, bsxfun(@max, legal_pixel, [1 1 1]'), [nc, nr, 1]');  
end