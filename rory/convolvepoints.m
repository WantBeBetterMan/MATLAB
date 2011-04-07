function imout = convolvepoints(x,y,psf_tmp,np,pixelsize)
% imout = convolvepoints(x,y,psf_tmp,np,pixelsize)
%
% Generates an image with multiple (N) PSFs placed at coordinates ([x,y]).
% x,y:          x,y coordiantes (each Nx1 vector)
% psf_tmp:      image of a psf
% np:           vector of intensities of each PSF (default: 1 for all)
% pixelsize:    size of a pixel if x and y are in [pixels], if x and
% y are in nm then pixelsize = 1; (default: pixelsize = 1)
%
% Size of the psf image should be odd with the maximum in the central pixel. 

if ~exist ('np', 'var')
    np = ones(size(x));
end

if ~isequal(length(x), length(np))
    np = np * ones(size(x));
end

if ~exist ('pixelsize', 'var')
    pixelsize = 1;
end

minx = min(x);
maxx = max(x);
miny = min(y);
maxy = max(y);
sp = size(psf_tmp);
psf_tmp2 = double(psf_tmp/sum(psf_tmp(:))); %normalize to 1
sizeim_tmp = [ceil((maxx-minx)/pixelsize), ceil((maxy-miny)/pixelsize)];
sizeim = sizeim_tmp + ~mod(sizeim_tmp,2); %to make it odd

centerim = [maxx-minx, maxy-miny]/2;
psf_tmp3 = padimage(psf_tmp2,fliplr(sizeim)+2*sp);
xr=x-minx;
yr=y-miny;

psf = dip_image(psf_tmp3);
imout_tmp = newim(psf);
for ii=1:length(x)
    imout_tmp = imout_tmp + np(ii)*shift(psf, [xr(ii)-centerim(1), yr(ii)-centerim(2)]);
end
imout = imout_tmp(sp:end-sp,sp:end-sp);