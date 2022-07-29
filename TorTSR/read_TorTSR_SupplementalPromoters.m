%% Read data
clc; clear; close all;

%Load correction files
load('../mNG/tot_fit.mat');
load('../mNG/drift_fit_mono.mat');
G = .9201;
%% hour data
filename = 'TorTSR_data_compiled.xlsx';

cols = 20;

read_zone_a = 'Y5:AR5';
read_zone_pa = 'B6:U24';
read_zone_pe = 'B25:U43';

time = [0	240	289	337	577	817	1057	1297	1537	1777	2017	2257	2497	2737	2977	3217	3457];

lag = time(3);
time = time([1:2 4:17]);

for z = 1:3
    a(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z+6)],'Range',read_zone_a);
    rr_a(:,:,z) = a(:,:);
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z+6)],'Range',read_zone_pa);
    rr_pa(1:2,:,z) = data(1:2,:);
    rr_pa(3:16,:,z) = data(4:17,:);
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z+6)],'Range',read_zone_pe);
    rr_pe(1:2,:,z) = data(1:2,:);
    rr_pe(3:16,:,z) = data(4:17,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;
rr_conc = rr_tot(1,:,:)./rr_a;
%% hour corrections
for z = 1:3
    for i = 1:cols
        tot = rr_tot(1:16,i,z);
        rr_r(1:16,i,z) = rr_r(1:16,i,z)./tot_fit(tot);
        tot = mean(rr_tot(1:16,i,z));
        drift = mean(rr_r(1:2,i,z))*(dr_p1_fit(tot)*time(3:16)'.^2+dr_p2_fit(tot)*time(3:16)'-(1-dr_p3_fit(tot)));
        rr_r(3:16,i,z) = rr_r(3:16,i,z)-drift;
    end
end

%% Hour timecourse plotting
j = [1:3];
c = [1 1 1];
var = 1;
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
for i = [3 8]
    base = mean(mean(rr_r(1:2,i,j)),3);
    scatter([0 time(3:16)-lag],-smooth([base; mean(rr_r(3:16,i,j),3)],3),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_TorTSR_longTC_SuppPromotersTC(rr_r);close(f1)

f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
for j = 1:3
    var = 1;
for i = [1:10]
    base = mean(mean(rr_r(1:2,i,j)),3);    
    scatter([0 time(3:16)-lag],smooth(-[base; mean(rr_r(3:16,i,j),3)],3),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
end
analyze_TorTSR_longTC_SuppPromoters(rr_conc);close(f1)