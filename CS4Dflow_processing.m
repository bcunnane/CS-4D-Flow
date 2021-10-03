%% CS4Dflow processing
% description

%% import vepc data
% go to desired vepc data directory
dcm_files = dir('*IMA');

for k = length(dcm_files):-1:1
    info = dicominfo(dcm_files(k).name);
    vepc_data(:,:,k) = dicomread(info);
    %vepc_data(:,:,k) = int16(dicomread(info))*info.RescaleSlope + info.RescaleIntercept;
    locs(k,1) = info.SliceLocation;
end

try
    direction = info.Private_0051_1014;
    if contains(direction,'through')
        dynamic.vz = vepc_data;
    elseif contains(direction,'ap')
        dynamic.vx = vepc_data;
    elseif contains(direction,'fh')
        dynamic.vy = vepc_data;
    end
catch
    dynamic.m = vepc_data;
    dynamic.locs = locs;
    
    % get volume (vol) size
    vol_repeats = find(locs == locs(1));
    vol_size(3) = vol_repeats(2)-vol_repeats(1);
    [vol_size(1),vol_size(2),~] = size(vepc_data);
    dynamic.vol_size = vol_size;
end
%% select roi
% figure
% montage(dynamic.m(:,:,1:24),colormap('gray'),'ThumbnailSize',[],'Size',[3 8]) % view slices


foi = 14; %frame of interest

% SHOULD THIS BE SLICE OF INTEREST?

% matrix info
m = dynamic.vol_size(1);
n = dynamic.vol_size(2);
h = dynamic.vol_size(3);
frs = length(dynamic.m)/h;

% get roi and mask
figure
imshow(dynamic.m(:,:,foi),[])
polygon = drawpolygon();
roi = polygon.Position;
roi = [roi;roi(1,:)]; %close roi by including first point again
mask = poly2mask(roi(:,1), roi(:,2), m, n);
close

%% get average velocity for each frame
v = zeros(1,frs);
data = dynamic.vz(:,:,foi:h:h*frs);
for fr = 1:frs
    im = squeeze(data(:,:,fr));
    im = im(mask);
    v(fr) = mean(im);
end

plot(v)
%title('vz')
ylabel('velocity')
xlabel ('frame')
xlim([0 50])


