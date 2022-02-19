%% Setup
clc; clear; close all;

%Load correction files
load('tot_fit.mat');
load('drift_fit_mono.mat');

%% load hour timecourse data
filename = 'mNG_data_compiled.xlsx';

%Number of sample columns
cols = 20;

%Calibration value
G = .9201;

%Data cell location, these may vary
read_zone_pa = 'B5:U23';
read_zone_pe = 'B24:U42';

%Time axis
time = [0.001 240 288 336 576 816 1056 1296 1536 1776 2016 2256 2496 2736 2976 3216 3456 3696 3936];

%Centering time on media injection
lag = time(3);
time = time([1:2 4:19]);

%Read excel file for parallel and perpendicular channel data
for z = 1:3
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z)],'Range',read_zone_pa);
    rr_pa(1:2,:,z) = data(1:2,:);
    rr_pa(3:18,:,z) = data(4:19,:);
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z)],'Range',read_zone_pe);
    rr_pe(1:2,:,z) = data(1:2,:);
    rr_pe(3:18,:,z) = data(4:19,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end

%Compute total fluorescence and polarization value
rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% Corrections for expression level and timecourse-drift
for z = 1:3
    for i = 1:cols
        tot = rr_tot(1:18,i,z);
        rr_r(1:18,i,z) = rr_r(1:18,i,z)./tot_fit(tot);
        tot = mean(rr_tot(1:18,i,z));
        drift = mean(rr_r(1:2,i,z))*(dr_p1_fit(tot)*time(3:18)'.^2+dr_p2_fit(tot)*time(3:18)'-(1-dr_p3_fit(tot)));
        rr_r(3:18,i,z) = rr_r(3:18,i,z)-drift;
    end
end

%% Fitting expression level artifact- comment out relevent correction before proceeding

%Initialize arrays
x=[];
y=[];
x2=[];
y2=[];

%Fill arrays with mNG and mNG-mNG data from timepoint 1
for i = 1:10
    for j = 1:3
        m=1;
        y = [y rr_r(m,i,j)];
        x = [x rr_tot(m,i,j)];
        y2 = [y2 rr_r(m,i+10,j)];
        x2 = [x2 rr_tot(m,i+10,j)];
    end
end

%For plotting, comment out for actual correction file
% x = x/10000; x2 = x2/10000;

%Normalization values, comment out for raw fit
y = y/.3156;
y2 = y2/.2645;

%Fitting data
% fitobj = fit(x',y','power2')
% fitobj2 = fit(x2',y2','power2')
fitobj_tot = fit([x'; x2'],[y'; y2'],'power2')

%Untransformed cell data copied from 'settle_test'
% wc_pa = [1534 1555 1552 1572 1546 1555]/10000;
% wc_pe = G*[1303 1316 1319 1345 1316 1324]/10000;
% wc_tot = wc_pa+2*wc_pe;
% wc_r = (wc_pa-wc_pe)./wc_tot;

%Plotting data
% figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
% for i = 1:10
% plot(fitobj,x',y');
% plot(fitobj2,x2',y2');
% scatter(wc_tot,wc_r)
% % plot(fitobj_tot,x',y');
% % plot(fitobj_tot,x2',y2');
% 
% legend('Location','SouthEast')
% xlabel('Total Fluorescence (a.u. x10^4)','FontSize',16, 'FontName', 'Arial'); 
% ylabel('\itr','FontSize',16, 'FontName', 'Arial');
% ylim([0 .4])
% pbaspect([1,1,1]);
% grid on; box on;
% set(gca,'LineWidth',2,'FontSize',16)
% end
%% Fitting expression level artifact- comment out relevent correction before proceeding 
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;

x=[];y=[];y2=[];fitobj={};
count=1;
for j = 1:3
    for i = [4:10]
        if i<11
            mark = '^';
            size = 60;
            c_ind = i;
        else
            mark = 'h';
            size = 80;
            c_ind = i-10;
        end
        x = time(3:18);
        y = smooth(rr_r(3:18,i,j)/mean(rr_r(1:2,i,j)),3);
        fitobj{count} = fit(x',y,'poly2');
        x1{count}=mean(rr_tot(1:18,i,j));
        plot(x,fitobj{count}(x),'Color',[0 .8 0]*c_ind/10,'LineWidth',2)
        scatter(time(1:18),rr_r(1:18,i,j)/mean(rr_r(1:2,i,j)),size,'Marker',mark,'MarkerFaceColor',[0 .8 0]*c_ind/10,'MarkerEdgeColor','k')
        count=count+1;
    end
end
plot([lag lag],[.5 1],'--k','LineWidth',2)
xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('Normalized \itr','FontSize',16, 'FontName', 'Arial');
ylim([.5 1])
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)

x=[];
for i = 1:21
    x(i)=x1{i};
    y1(i)=fitobj{i}.p1;
    y2(i)=fitobj{i}.p2;
    y3(i)=fitobj{i}.p3;
end
% fitobj1 = fit(x',y1','exp2')
% fitobj2 = fit(x',y2','exp2')
% fitobj3 = fit(x',y3','exp2')
fitobj1 = fit(x',y1','a*exp(b*x)+c','StartPoint',[-1.6e-8 -6.8e-5 0])
fitobj2 = fit(x',y2','a*exp(b*x)+c','StartPoint',[-3.6e-4 -3.8e-4 -6.5e-6])
fitobj3 = fit(x',y3','a*exp(b*x)+c','StartPoint',[-.16 -9.8e-5 1.011])
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
plot(fitobj1,x,y1')
xlabel('Total Fluorescence (a.u. x10^4)','FontSize',16, 'FontName', 'Arial'); 
ylabel('Coefficient a','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
legend('off')
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
plot(fitobj2,x',y2')
xlabel('Total Fluorescence (a.u. x10^4)','FontSize',16, 'FontName', 'Arial'); 
ylabel('Coefficient b','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
legend('off')
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
plot(fitobj3,x',y3')
xlabel('Total Fluorescence (a.u. x10^4)','FontSize',16, 'FontName', 'Arial'); 
ylabel('Coefficient c','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
legend('off')
%% Final Plotting
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
c = [0 .8 0]
for j = [1:3]
scatter(mean(rr_tot(1,[4:10],j),3)/10000,mean(rr_r(1,[4:10],j),3),60,'MarkerEdgeColor',c,'MarkerFaceColor',c,'Marker','^')
scatter(mean(rr_tot(1,[4:10]+10,j)/10000,3),mean(rr_r(1,[4:10]+10,j),3),60,'MarkerEdgeColor',c,'MarkerFaceColor',c,'Marker','h')
end
legend('mNG', ...
    'mNG-mNG', ...
    'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
ylim([0 .4]);
xlabel('Total Fluorescence (a.u. x10^4)','FontSize',16, 'FontName', 'Arial'); 
ylabel('r','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
%Time
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
j = [1:3];
for i = 4:10
    c = [0 .8 0]*(i*.1);
    scatter(time(1:18),mean(rr_r(1:18,[i],j),3),60,'MarkerEdgeColor',c,'MarkerFaceColor',c,'Marker','^')
    scatter(time(1:18),mean(rr_r(1:18,[i]+10,j),3),80,'MarkerEdgeColor',c,'MarkerFaceColor',c,'Marker','h')
    legend('mNG', ...
        'mNG-mNG', ...
        'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
    plot(time(1:18),mean(rr_r(1:18,[i],j),3),'Color',c,'LineWidth',2)
    plot(time(1:18),mean(rr_r(1:18,[i]+10,j),3),'Color',c,'LineWidth',2)

end
plot([lag lag],[-.1 .5],'--k','LineWidth',2)
ylim([0 .4]);
xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)

%% WC plotting
x1 = [0.396	0.394	0.398; 0.79	0.787	0.815];
y1 = [0.082489017	0.084314077	0.084222755; 0.055720758	0.0566665	0.056256852];
x2 = [0.83	0.873	0.889; 1.229	1.261	1.251];
y2 = [0.059510874	0.058832783	0.059090891; 0.044044469	0.043086195	0.044637572];
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
errorbar(mean(x1(1,:)),mean(y1(1,:)),std(y1(1,:)),std(y1(1,:)),std(x1(1,:)),std(x1(1,:)), ...
    'LineWidth',2,'Color','k')
errorbar(mean(x1(2,:)),mean(y1(2,:)),std(y1(2,:)),std(y1(2,:)),std(x1(2,:)),std(x1(2,:)), ...
    'LineWidth',2,'Color','k')
plot([mean(x1(1,:)) mean(x1(2,:))],[mean(y1(1,:)) mean(y1(2,:))],'k','LineWidth',2)
errorbar(mean(x2(1,:)),mean(y2(1,:)),std(y2(1,:)),std(y2(1,:)),std(x2(1,:)),std(x2(1,:)), ...
    'LineWidth',2,'Color','k')
errorbar(mean(x2(2,:)),mean(y2(2,:)),std(y2(2,:)),std(y2(2,:)),std(x2(2,:)),std(x2(2,:)), ...
    'LineWidth',2,'Color','k')
plot([mean(x2(1,:)) mean(x2(2,:))],[mean(y2(1,:)) mean(y2(2,:))],'k','LineWidth',2)
xlabel('OD600','FontSize',16, 'FontName', 'Arial'); 
ylabel('r','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([0 .4])
xlim([.2 1.4])