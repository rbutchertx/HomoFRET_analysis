%% Read data
clc; clear; close all;

%Load correction files
load('../../mNG/tot_fit.mat');
load('../../mNG/drift_fit_mono.mat');
G = .9201;
%% hour data
filenames = {'comp.xlsx'};

read_zone_pa = 'A6:BD23';
read_zone_pe = 'A26:BD43';

time = [0 2:4:62]*60;

for z = 1:1    
    data(:,:) = readmatrix(filenames{z},'Sheet',[1],'Range',read_zone_pa);
    rr_pa(1:2,:,z) = data(1:2,:);
    rr_pa(3:18,:,z) = data(3:18,:);
    data(:,:) = readmatrix(filenames{z},'Sheet',[1],'Range',read_zone_pe);
    rr_pe(1:2,:,z) = data(1:2,:);
    rr_pe(3:18,:,z) = data(3:18,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% Hour timecourse plotting

c = [1 1 1];
var = 1;
sel_unit = [1:7];
sel = [sel_unit sel_unit+14 sel_unit+28 sel_unit+42];

samp1 = rr_r(:,sel);
samp2 = rr_r(:,sel+7);

samp1_corr = mean(samp1(1:2,:))-samp1;
samp2_corr = mean(samp2(1:2,:))-samp2;

samp1_corr = [mean(samp1_corr(1:2,:)); samp1_corr(3:18,:)];
samp2_corr = [mean(samp2_corr(1:2,:)); samp2_corr(3:18,:)];


for i = 1:4
blfit = fit(time(2:end)',mean(samp1_corr(2:end,[1:7]+7*(i-1)),2),'SmoothingSpline');
samp1_corr2(:,[1:7]+7*(i-1)) = [samp1_corr(1,[1:7]+7*(i-1)); samp1_corr(2:end,[1:7]+7*(i-1))-blfit(time(2:end))*ones(1,7)];
samp2_corr2(:,[1:7]+7*(i-1)) = [samp2_corr(1,[1:7]+7*(i-1)); samp2_corr(2:end,[1:7]+7*(i-1))-ones(1,7).*blfit(time(2:end))];
end

figure('Name','3C','IntegerHandle','off','Units', 'inches', 'Position', [0 0 6 4.725]); hold on;

w = ones(17,1);w(1) = w(1)*2;
c2 = [209 227 235]/255;

c = {[1 1 1], [1 1 1], [1 1 1], c2};
m = {'o','^','v','d'};
for i = 1:4
    inds = [1:7]+7*(i-1);
    means = mean(samp2_corr2(:,inds),2);
    stds = std(samp2_corr2(:,inds),[],2);

    scatter(time,means,40,'Marker',m{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
end
legend('No inducer', ...
    'aTc (t = 0)', ...
    'IPTG (t = 0)', ...
    'aTc + IPTG (t = 0)', ...
    'Location', 'NorthWest', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
for i = 1:4
    inds = [1:7]+7*(i-1);
    means = mean(samp2_corr2(:,inds),2);
    stds = std(samp2_corr2(:,inds),[],2);
    
    fitobj = fit(time',smooth(means,1),'SmoothingSpline','Weights',w);
    plot(0:3000,fitobj(0:3000),'Color',[.65 .65 .65],'LineWidth',2)
    scatter(time,means,40,'Marker',m{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
end

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-{\Delta\itr}','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.015 .075]);set(gca, 'YTick', -.015:.015:.075)
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])

%%
figure('Name','3F','IntegerHandle','off','Units', 'inches', 'Position', [0 0 6 4.725]); hold on;
load('holddata.mat')
for i = 4
    inds = [1:7]+7*(i-1);
    means = mean(samp2_corr2(:,inds),2);
    stds = std(samp2_corr2(:,inds),[],2);

    scatter(time,means/max(means),40,'Marker',m{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
    scatter(time(1:14),gen_data/max(gen_data),40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',c2)
end
legend('Plasmid', ...
    'Genomic', ...
    'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
for i = 4
    inds = [1:7]+7*(i-1);
    means = mean(samp2_corr2(:,inds),2);
    stds = std(samp2_corr2(:,inds),[],2);
    
    fitobj = fit(time',smooth(means,1),'SmoothingSpline','Weights',w);
    plot(0:3000,fitobj(0:3000)/max(means),'Color',[.65 .65 .65],'LineWidth',2)
    plot(0:3000,gen_fit/max(gen_data),'Color',[.65 .65 .65],'LineWidth',2)
    errorbar(time,means/max(means),stds/max(means),'Color','k','LineWidth',1,'LineStyle','none')
    errorbar(time(1:14),gen_data/max(gen_data),gen_std/max(gen_data),'Color','k','LineWidth',1,'LineStyle','none')
    scatter(time,means/max(means),40,'Marker',m{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
    scatter(time(1:14),gen_data/max(gen_data),40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',c2)
end

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('Normalized -{\Delta\itr}','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.5 2]);set(gca, 'YTick', -.5:.5:2)
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])