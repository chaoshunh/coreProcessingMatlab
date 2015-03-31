function makePE_PotaXPLOT(X1, Y1)
%CREATEFIGURE(X1, Y1)
%  X1:  vector of x data
%  Y1:  vector of y data

%  Auto-generated by MATLAB on 23-Feb-2015 09:47:31

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on',...
    'Position',[0.13 0.0363924050632911 0.695439783491204 0.888607594936709]);
%% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes1,[0 10]);
%% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes1,[0 10]);
box(axes1,'on');
hold(axes1,'on');

% Create ylabel
ylabel({'Photoelectric Factor, PE, (barns/e)'},...
    'HorizontalAlignment','center');

% Create xlabel
xlabel({'Potassium Concentration, K (%)'},'HorizontalAlignment','center');

% Create title
title({'Potassium/PE Lithology Crossplot'},'HorizontalAlignment','center',...
    'FontWeight','bold');

% Create plot
plot(X1,Y1,'DisplayName','','Marker','+','LineStyle','none');
