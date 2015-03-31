function createPE_TH_K_Xplot(X1,Y1)
%CREATEFIGURE(X1, YMATRIX1, Y1, X2)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data
%  Y1:  vector of y data
%  X2:  vector of x data

%  Auto-generated by MATLAB on 23-Feb-2015 09:52:04

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','XScale','log',...
    'Position',[0.13 0.11 0.602746955345061 0.815]);
%% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes1,[0.1 100]);
%% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes1,[0 10]);
box(axes1,'on');
hold(axes1,'on');

% Create ylabel
ylabel({'Photoelectric Factor, PE, (barns/e)'});

% Create xlabel
xlabel({'Thorium/Potassium Ratio, Th/K'});

% Create title
title({'Thorium/Potassium Ratio & PE Lithology Cross Plot'});

% Create multiple lines using matrix input to semilogx


% Create semilogx
semilogx(X1,Y1,'DisplayName','','Marker','+','LineStyle','none');


