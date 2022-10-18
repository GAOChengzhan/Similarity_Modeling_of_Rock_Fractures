function dcs = Stereonet(dip,dir,varargin)
% Stereonet
% draws Stereonet diagram for given dip and dip-direction angles
%
% Usage...:
% dcs = Stereonet(dip,ddir,varargin);
%
% Input...: dip       (n),dip angles
%           dir       (n),dip-direction angles
%           varargin  {skip|density|marker|color}
% Output..: dcs       {x,y,center,count},density information
%
% Examples:
%{
c = Stereonet([0,45,90],[0,180,270],'density',true);
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE1.5_License.txt and at http://alghalandis.net/products/adfne/adfne15
%
% Citations:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% Fadakar-A Y, 2018, "DFNE Practices with ADFNE", Alghalandis Computing, Toronto, 
% Ontario, Canada, http://alghalandis.net, pp61.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

opt = Option(varargin,'skip',false,'density',false,'marker','*','color','r',...
    'ndip',3,'ndir',12,'ang',5,'ec','k','fa',1,'label',false,'cmap',@jet);      % default arguments
if ~opt.skip                                                                    % to draw the background net
    gc = [0.8,0.85,0.9];                                                        % grid color
    hold on
    R = Scale(15:15:75,0,90,0,1);                                               % setup for dip angles
    rectangle('Position',[-1,-1,2,2],'Curvature',[1,1],'LineWidth',1.5,...      % draws the largest circle
        'EdgeColor',[0,0,0],'FaceColor','w');                                   % ...clears background
    for r = R                                                                   % draws centered circles
        rectangle('Position',[-r,-r,2*r,2*r],'Curvature',[1,1],'LineWidth',1,...
            'EdgeColor',gc);
    end
    th = linspace(0,2*pi,37);
    [x,y] = pol2cart(th(1:end-1),ones(1,36));
    [x0,y0] = pol2cart(th(1:end-1),zeros(1,36)+R(1));
    plot([x0;x],[y0;y],'-','Color',gc);                                         % draws centered rays
    plot([0,R(1);0,0;0,-R(1);0,0]',[0,0;0,R(1);0,0;0,-R(1)]','Color',gc);       % draws cross at the center
    text(1.035,0,'0','HorizontalAlignment','center','VerticalAlignment',...
        'middle');                                                              % main direction's labels
    text(0,1.04,'90','HorizontalAlignment','center','VerticalAlignment',...     % 90 label
        'middle');
    text(-1.04,0,'180','HorizontalAlignment','center','VerticalAlignment',...   % 180 label
        'middle','Rotation',90);
    text(0,-1.04,'270','HorizontalAlignment','center','VerticalAlignment',...   % 270 label
        'middle');
    axis image off                                                              % sets axis properties and hides it
end
hold on
dip = Scale(dip,0,90,0,1);                                                      % projects dips to [0..1]
dir = Convert('rad',dir);                                                       % converts to radians
if opt.density                                                                  % if density requested
    [X,Y] = pol2cart(dir,dip);                                                  % computes coordinates
    R = Scale(linspace(0,pi/2,opt.ndip+1),0,1);                                 % sections for dip
    R = R(1:end-1);
    dr = R(2)-R(1);
    T = linspace(0,2*pi,opt.ndir+1);                                            % sections for dir
    T = T(1:end-1);
    tr = Convert('rad',opt.ang);                                                % patch resolution
    t = T(1):tr:T(2);
    if t(end) < T(2); t(end+1) = T(2); end
    k = numel(t);
    dcs = cell(0);
    i = 0;                                                                      % counter
    for r1 = R                                                                  % loops over all dips
        for t1 = T                                                              % loops over all dirs
            [x,y] = pol2cart([t(end:-1:1)+t1,t+t1],[repmat(r1,1,k),...
                repmat(r1+dr,1,k)]);
            d = sum(inpolygon(X,Y,x,y));                                        % determines density
            if d > 0
                cnt = [mean(x),mean(y)];                                        % center of the section cell
                i = i+1;                                                        % adds up counter
                dcs{i} = {[x;y]',cnt,d};                                        % stores information
            end
        end
    end
    n = length(dcs);                                                            % number of section cells with density
    d = zeros(1,n);                                                             % initializes density vector
    for i = 1:n                                                                 % loops over sections with density
        d(i) = dcs{i}{3};                                                       % density values
    end
    colors = Convert('color',d,opt.cmap,64);                                    % densities to colors
    for i = 1:n                                                                 % loops over sections with density
        dat = dcs{i};                                                           % section cell data
        pts = dat{1};                                                           % points in the section cell
        h = patch(pts(:,1),pts(:,2),'r');
        h.EdgeColor = opt.ec;                                                   % edge color, density patch
        h.FaceColor = colors(i,:);                                              % face color
        h.FaceAlpha = opt.fa;                                                   % face alpha
        if opt.label
            text(dat{2}(1),dat{2}(2),num2str(dat{3}),...                        % density value
                'HorizontalAlignment','center','VerticalAlignment','middle');
        end
    end
end
h = polar(dir,dip);                                                             % plots all dips-dirs pairs
h.Marker = opt.marker;                                                          % marker type
h.LineStyle = 'none';                                                           % removes lines
h.Color = opt.color;                                                            % marker color
