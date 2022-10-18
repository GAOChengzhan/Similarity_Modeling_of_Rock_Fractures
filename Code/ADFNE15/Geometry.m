function out = Geometry(wht,varargin)
% Geometry
% prepares geometries as requested in 'wht', see examples below
%
% Examples:
%{
elp = Ellipse('cn',[0,0],'q',12,'r',[1,0.5],'ang',45);
ax = Ellipsoid([0,0,0,1,1,1]);
sph = Sphere;
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

switch lower(wht)
    case {'elp','ellipse'}                                     				    % ellipse
        out = Ellipse(varargin{:});
    case {'els','ellipsoid'}                                                    % ellipsoid
        out = Ellipsoid(varargin{:});
    case {'sph','sphere'}                                                       % sphere
        out = Sphere(varargin{:});
end
end

function out = Ellipse(varargin)
% Ellipse
% returns coordinates of an ellipse, 2D
%
% Usage...:
% out = Ellipse(varargin);
%
% Input...: varargin  {...}
% Output..: out       (k,2),points
%
% Examples:
%{
elp = Ellipse('cn',[0,0],'q',12,'r',[1,0.5],'ang',45);
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
%
% Citation:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

opt = Option(varargin,'cnt',[0,0],'r',[1,0.5],'q',12,'ang',0);                  % default arguments
t = linspace(0,2*pi,opt.q+1)';                                                  % angles
t = t(1:end-1);
out = [opt.cnt(1)+opt.r(1)*cos(t),opt.cnt(2)+opt.r(2)*sin(t)];                  % ellipse
if opt.ang ~= 0
    out = Rotate(out,'cnt',opt.cnt,'ang',opt.ang);                              % rotated ellipse
end
end

function h = Ellipsoid(varargin)
% Ellipsoid
% draws an ellipsoid on top of line "lin", 3D
%
% Usage...:
% ax = Ellipsoid(lin,varargin);
%
% Input...: varargin  {...}
%
% Examples:
%{
ax = Ellipsoid([0,0,0,1,1,1]);
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
%
% Citation:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

opt = Option(varargin,'r',[0.5,0.5],'q',32,'cix',30,'cnt',nan,'ec','k',...
    'fa',0.7);                                                                  % default arguments
if isfield(opt,'in')                                                            % if endpoints provided
    lin = opt.in;
else
    lin = [0,0,0,1,1,1];                                                        % default endpoints
end
pts = Geometry('ellipse','cnt',[0,0],'r',opt.radius,'q',(opt.q-1)*2);           % ellipse
pts = pts(1:opt.q,:);
x = Scale(pts(:,1)+opt.radius(1));
%ets = lin(1:3)+(1-x).*lin(1:3)+x.*lin(4:end);                                  % endpoints, MR2017
ets = bsxfun(@plus,lin(1:3),bsxfun(@times,(1-x),lin(1:3))+bsxfun(@times,x,...
    lin(4:end)));                                                               % endpoints, MR2015
if ~isnan(opt.center); ets = bsxfun(@plus,ets,opt.center-mean(ets,1)); end      % centered?
h = Draw('cyl',ets,'cix',opt.cix,'r',pts(:,2),'fa',opt.facealpha,'ec',...       % draws cylinder (ellipsoid)
    opt.edgecolor);
end

function out = Sphere(varargin)
% Sphere
% generates mesh coordinates for sphere
%
% Usage...:
% out = Sphere(varargin);
%
% Input...: varargin  {cnt|r|q}
% Output..: out       struct
%
% Examples:
%{
sph = Sphere;
%}
%
% Alghalandis Discrete Fracture Network Engineering (ADFNE),*R1.5*
% Copyright (c) 2018 Alghalandis Computing @
% Author: Dr. Younes Fadakar Alghalandis
% (w) http://alghalandis.net        (e) alghalandis.net@gmail.com
% All rights reserved.
%
% License.: ADFNE_License.txt and at http://alghalandis.net/products/adfne
%
% Citation:
% Fadakar-A Y, 2017, "ADFNE: Open source software for discrete fracture network
% engineering, two and three dimensional applications", Journal of Computers &
% Geosciences, 102:1-11.
%
% see more at: http://alghalandis.net/products/adfne
% Updated.: 2018-01-11

opt = Option(varargin,'cnt',[0,0,0],'r',1,'q',12);                              % default arguments
k = opt.q;                                                                      % resolution
t = (-k:2:k)/k*pi;
p = (-k:2:k)'/k*pi/2;
cp = cos(p);
cp(1) = 0;
cp(k+1) = 0;
st = sin(t);
st(1) = 0;
st(k+1) = 0;
out.x = opt.cnt(1)+(cp*cos(t)*opt.r);                                           % X coordinates
out.y = opt.cnt(2)+(cp*st*opt.r);                                               % Y coordinates
out.z = opt.cnt(3)+(sin(p)*ones(1,k+1)*opt.r);                                  % Z coordinates
end
