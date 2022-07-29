clc;clear;close all;

%% Read images
strain = '120dark';
for i = 1:3
    for j = 1:3
        nl_ims{i}(:,:,j) = double(imread(['UntaggedTorR/' strain '_off_1_00' num2str(i) '.tif'],'Index',j));
        nl_ims{i+3}(:,:,j) = double(imread(['UntaggedTorR/' strain '_off_2_00' num2str(i) '.tif'],'Index',j));
        yl_ims{i}(:,:,j) = double(imread(['UntaggedTorR/' strain '_on_1_00' num2str(i) '.tif'],'Index',j));
        yl_ims{i+3}(:,:,j) = double(imread(['UntaggedTorR/' strain '_on_2_00' num2str(i) '.tif'],'Index',j));
    end
end

%% Create masks
% close all;
for i = 1:6
    I_nl = nl_ims{i}(:,:,1);
    I_nl = medfilt2(I_nl/max(I_nl(:)),[7 7]);
%     imagesc(I_nl);
    [~,threshold] = edge(I_nl,'sobel');
    fudgeFactor = 1.2;
    BWs = edge(I_nl,'sobel',threshold * fudgeFactor);
%     imagesc(BWs)
%     title('Binary Gradient Mask')
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    BWsdil = imdilate(BWs,[se90 se0]);
%     imagesc(BWsdil)
%     title('Dilated Gradient Mask')
    BWdfill = imfill(BWsdil,'holes');
%     imagesc(BWdfill)
%     title('Binary Image with Filled Holes')
    BWnobord = imclearborder(BWdfill,4);
%     imagesc(BWnobord)
%     title('Cleared Border Image')
    seD = strel('diamond',1);
    BWfinal = imerode(BWnobord,seD);
    BWfinal_nl{i} = imerode(BWfinal,seD);
%     imagesc(labeloverlay(I_nl,BWfinal))
%     title('Segmented Image');

    I_yl = yl_ims{i}(:,:,1);
    I_yl = medfilt2(I_yl/max(I_yl(:)),[7 7]);
%     imagesc(I_yl);
    [~,threshold] = edge(I_yl,'sobel');
    fudgeFactor = 1.2;
    BWs = edge(I_yl,'sobel',threshold * fudgeFactor);
%     imagesc(BWs)
%     title('Binary Gradient Mask')
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    BWsdil = imdilate(BWs,[se90 se0]);
%     imagesc(BWsdil)
%     title('Dilated Gradient Mask')
    BWdfill = imfill(BWsdil,'holes');
%     imagesc(BWdfill)
%     title('Binary Image with Filled Holes')
    BWnobord = imclearborder(BWdfill,4);
%     imagesc(BWnobord)
%     title('Cleared Border Image')
    seD = strel('diamond',1);
    BWfinal = imerode(BWnobord,seD);
    BWfinal_yl{i} = imerode(BWfinal,seD);
%     imagesc(BWfinal)
%     title('Segmented Image');
end

%% Acquire ROIs
mNG_nl = [];
mCh_nl = [];
mNG_yl = [];
mCh_yl = [];

mNG_nl_ar = [];
mCh_nl_ar = [];
mNG_yl_ar = [];
mCh_yl_ar = [];

for i = 1:6
mNG_in_nl = medfilt2(nl_ims{i}(:,:,2).*BWfinal_nl{i} - median(median(nl_ims{i}(:,:,2).*(-BWfinal_nl{i}+1))),[3,3]);
mCh_in_nl = medfilt2(nl_ims{i}(:,:,3).*BWfinal_nl{i} - median(median(nl_ims{i}(:,:,3).*(-BWfinal_nl{i}+1))),[3,3]);
mNG_in_yl = medfilt2(yl_ims{i}(:,:,2).*BWfinal_yl{i} - median(median(yl_ims{i}(:,:,2).*(-BWfinal_yl{i}+1))),[3,3]);
mCh_in_yl = medfilt2(yl_ims{i}(:,:,3).*BWfinal_yl{i} - median(median(yl_ims{i}(:,:,3).*(-BWfinal_yl{i}+1))),[3,3]);
mNG_in_nl(mNG_in_nl<0) = 0;
mCh_in_nl(mCh_in_nl<0) = 0;
mNG_in_yl(mNG_in_yl<0) = 0;
mCh_in_yl(mCh_in_yl<0) = 0;
props = {'Area','PixelValues'};
mNG_nl_roi = regionprops(BWfinal_nl{i},mNG_in_nl,props);
mCh_nl_roi = regionprops(BWfinal_nl{i},mCh_in_nl,props);
mNG_yl_roi = regionprops(BWfinal_yl{i},mNG_in_yl,props);
mCh_yl_roi = regionprops(BWfinal_yl{i},mCh_in_yl,props);

for j = 1:length(mNG_nl_roi)
    mNG_nl = [mNG_nl; median(mNG_nl_roi(j).PixelValues)];
    mCh_nl = [mCh_nl; median(mCh_nl_roi(j).PixelValues)];
    mNG_nl_ar = [mNG_nl_ar; mNG_nl_roi(j).Area];
    mCh_nl_ar = [mCh_nl_ar; mCh_nl_roi(j).Area];
end
for j = 1:length(mNG_yl_roi)
    mNG_yl = [mNG_yl; median(mNG_yl_roi(j).PixelValues)];
    mCh_yl = [mCh_yl; median(mCh_yl_roi(j).PixelValues)];
    mNG_yl_ar = [mNG_yl_ar; mNG_yl_roi(j).Area];
    mCh_yl_ar = [mCh_yl_ar; mCh_yl_roi(j).Area];
end
end
mNG_nl = mNG_nl(mNG_nl_ar>150);
mCh_nl = mCh_nl(mNG_nl_ar>150);
mNG_yl = mNG_yl(mNG_yl_ar>150);
mCh_yl = mCh_yl(mNG_yl_ar>150);

mCh_nl = rmoutliers(mCh_nl,'percentiles',[10 90] + [0 0]);
mCh_yl = rmoutliers(mCh_yl,'percentiles',[10 90] + [0 0]); 
%% Plotting
% close all

figure('Units', 'normalized', 'Position', [0 0 .75 .5]); hold on;
scatter(median(mNG_nl),median(mCh_nl),30,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0])
scatter(median(mNG_yl),median(mCh_yl),30,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1])
xlabel('mNG (a.u.)');ylabel('mCherry (a.u.)');
% xlim([100 30000]);
% ylim([-100 2000]);
legend('0mM NO3', ...
    '5mM NO3', ...
    'Location', 'EastOutside','AutoUpdate','off')

pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',15)
set(gca,'Xscale','log');

fprintf('OFF\n%.2f\n%.2f\n',mean(mCh_nl),std(mCh_nl));
fprintf('ON\n%.2f\n%.2f\n',mean(mCh_yl),std(mCh_yl));