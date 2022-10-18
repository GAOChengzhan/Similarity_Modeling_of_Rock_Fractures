function Axes(varargin)
% Axes
% sets and draws axes, view, lights, etc., [2D|3D]
%
% Usage...:
% Axes(varargin);
%
% Input...: varargin  {box|view|p|light}
%
% Examples:
%{
Axes('view','top'); % sets as 2d view
Axes(0,'p',5); % expands 2d axes by 5 percentage
Axes('box',[0,0,0,2,2,2],'view',[30,30]); % sets bounding box and view in 3d
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

opt = Option(varargin,'box',[0,0,0,1,1,1],'view',[-35,20],'p',0,...             % default values for arguments
    'light',[]);
if isfield(opt,'in')
    if opt.in == 2
        if (numel(opt.box) == 4); axis(opt.box); end
        axis image; box on; grid on;                                            % sets data aspect equal
    end
else
    if ischar(opt.view) && strcmpi(opt.view,'top')                              % sets top view in 3D
        view([0,90]);
        daspect([1,1,1]);
        camproj('orthographic');                                                % parallel projection
        light('Position',[0,1,1]);
        axis vis3d tight;
        grid on;
    else
        hold on;
        bx = opt.box;
        if ~isempty(bx)
            Draw('cub',bx,'fa',0,'ec','k');                                     % draws the cube
            plot3(bx([1,4]),bx([2,2]),bx([3,3]),'-','LineWidth',1.5,...         % draws axis X
                'Color',[0.7,0,0]);
            plot3(bx([1,1]),bx([2,5]),bx([3,3]),'-','LineWidth',1.5,...         % draws axis Y
                'Color',[0,0.7,0]);
            plot3(bx([1,1]),bx([2,2]),bx([3,6]),'-','LineWidth',1.5,...         % draws axis Z
                'Color',[0,0,0.7]);
            text(mean(bx([1,4])),bx(2),bx(3),'X','BackgroundColor',[0.7,0,0],...% X lable
                'Color',[1,1,0.99],'FontWeight','bold','HorizontalAlignment',...
                'center','Interpreter','none','Margin',6);
            text(bx(1),mean(bx([2,5])),bx(3),'Y','BackgroundColor',[0,0.7,0],...% Y lable
                'Color',[1,1,0.99],'FontWeight','bold','HorizontalAlignment',...
                'center','Interpreter','none','Margin',6);
            text(bx(1),bx(2),mean(bx([3,6])),'Z','BackgroundColor',[0,0,0.7],...% Z lable
                'Color',[1,1,0.99],'FontWeight','bold','HorizontalAlignment',...
                'center','Interpreter','none','Margin',6);
        end
        view(opt.view); daspect([1,1,1]); axis vis3d tight;                     % sets view, data aspect etc.
        camproj('perspective'); grid on;                                        % perspective projection
        if isempty(opt.light)
            c = camlight('headlight');                                          % a light with camera
            h = rotate3d(gca);
            h.ActionPostCallback = @RotCall;                                    % links light and camera rotation
            h.Enable = 'on';
        else
            light('Position',opt.light);
        end
    end
end
if (opt.p ~= 0)                                                                 % to expand axes limits
    axis tight;
    wh = axis;                                                                  % current axes limits
    w = wh(2)-wh(1);
    h = wh(4)-wh(3);
    p = abs(opt.p)*0.01;                                                        % converts to percentage
    if opt.p < 0                                                                % fixed for both x and y axes
        axis([wh(1)-p*w,wh(2)+p*w,wh(3)-p*w,wh(4)+p*w]);
    else                                                                        % relative to each axis
        axis([wh(1)-p*w,wh(2)+p*w,wh(3)-p*h,wh(4)+p*h]);
    end
end
% internal function
    function RotCall(~,~)                                                       % links camera rotation with light
        c = camlight(c,'headlight');
    end
end
