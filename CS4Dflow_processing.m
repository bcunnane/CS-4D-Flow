%% CS4Dflow processing
% Script for processing DICOMS collected from Siemens CS 4D flow sequence

%% Import vepc data
% go to desired vepc data directory
dcm_files = dir('*IMA');

% import velocity phase data
for k = 24:-1:1%length(dcm_files):-1:1
    info = dicominfo(dcm_files(k).name);
    vepc_data(:,:,k) = int16(dicomread(info))*info.RescaleSlope + info.RescaleIntercept;
    locs(k,1) = info.SliceLocation;
end

% assign direction
direction = info.Private_0051_1014;
if contains(direction,'through')
    dynamic.vz = vepc_data;
elseif contains(direction,'ap')
    dynamic.vx = vepc_data;
elseif contains(direction,'fh')
    dynamic.vy = vepc_data;
end
%% Import magnitude data
% go to desired magnitude image data directory
dcm_files = dir('*IMA');

% import magnitude data
for k = 24:-1:1%length(dcm_files):-1:1
    info = dicominfo(dcm_files(k).name);
    vepc_data(:,:,k) = dicomread(info);
    locs(k,1) = info.SliceLocation;
end

dynamic.m = vepc_data;
dynamic.locs = locs;

% get volume (vol) size
vol_repeats = find(locs == locs(1));
vol_size(3) = vol_repeats(2) - vol_repeats(1);
[vol_size(1),vol_size(2),~] = size(vepc_data);
dynamic.vol_size = vol_size;

%% Testing 
montage(dynamic.m(:,:,1:24),colormap('gray'),'ThumbnailSize',[],'Size',[3 8]) % view slices if needed
slice = 14; % set slice of interest that ROI will be drawn on

% get matrix info
m = dynamic.vol_size(1);
n = dynamic.vol_size(2);
h = dynamic.vol_size(3);
frs = length(dynamic.m)/h;

% get roi and mask
figure
imshow(dynamic.m(:,:,slice),[])
polygon = drawpolygon();
roi = polygon.Position;
roi = [roi;roi(1,:)]; %close roi by including first point again
mask = poly2mask(roi(:,1), roi(:,2), m, n);
close

% get average velocity for each frame
v = zeros(1,frs);
data = dynamic.vz(:,:,slice:h:h*frs);
for fr = 1:frs
    im = squeeze(data(:,:,fr));
    im = im(mask);
    v(fr) = mean(im);
end

% plot results
plot(v)
title('vz')
ylabel('velocity')
xlabel ('frame')
xlim([0 50])