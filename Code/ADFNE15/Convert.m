function varargout = Convert(to,varargin)
% Convert
% converts any 'varargin' to 'to', see examples below
%
% Examples:
%{
------- strcut to cell
s.a = 1; s.b = '2';
c = Convert('cell',s);            					% = {'a',[1],'b','2'}
c = Convert('cell',[7,8]);        					% = {[1,2]}

------- seconds to clock
clk = Convert('clock',1000); 						% = '00:16:40.00'

------- vector to colors
cls = Convert('color',rand(1,10));                  % returns 10 colors
cls = Convert('color',rand(1,10),@hot,128);         % ...from hot colormap(128)

------- radians to degrees
deg = Convert('deg',pi); 							% = 180

------- degrees to radians
rad = Convert('rad',180); 							% = pi

------- any to normalized
y = Convert('norm',rand(1,3));                      % normalized (3)

------- polygons to triangles
trs = Convert('tri',[0,0;1,0;1,1;0,1]); 			% = {4 triangles}

------- varargin to struct
s = Convert('struct','a',1,'b',34); 				% = {a:1, b:34}

------- 3d points to 2d points                      
pts = Convert('2d',rand(10,3));                     % size(pts) == [10,2]

------- 2d points to 3d points
pts = Convert('3d',rand(10,2));						% size(pts) == [10,3]
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

switch lower(to)
    case 'cell'
        [c,b] = Cell(varargin{1});
        varargout = {c,b};
    case 'clock'
        varargout = {Clock(varargin{1})};
    case 'color'
        varargout = {Colorize(varargin{:})};
    case 'deg'
        varargout = {Deg(varargin{1})};
    case 'rad'
        varargout = {Rad(varargin{1})};
    case 'norm'
        varargout = {Normed(varargin{1})};
    case 'tri'
        varargout = {Polytri(varargin{1})};
    case 'struct'
        varargout = {Struct(varargin{:})};
    case '2d'
        varargout = {T2(varargin{:})};
    case '3d'
        varargout = {T3(varargin{1})};
end
end

function [c,b] = Cell(s)
% Cell
% converts struct "s" or any to cell "c"
%
% Usage...:
% [c,b] = Cell(s);
%
% Input...: s         any,struct
% Output..: c         cell
%           b         boolean,true if "s" was already a cell
%
% Examples:
%{
s.a = 1;
s.b = '2';
c = Cell(s); % = {'a',[1],'b','2'}
c = Cell([7,8]); % = {[1,2]}
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

b = false;
if isstruct(s)                                                                  % if struct
    t = cellfun(@(i){i,s.(i)},fieldnames(s),'UniformOutput',false);             % extracts information
    c = [t{:}];                                                                 % combines as cell
else
    b = iscell(s);
    if b                                                                        % if already a cell?
        c = s;
    else
        c = {s};                                                                % converts to cell
    end
end
end

function clk = Clock(snd)
% Clock
% converts seconds "snd" to clock format
%
% Usage...:
% clk = Clock(snd);
%
% Input...: snd       (1),seconds
% Output..: clk       (1),string
%
% Examples:
%{
clk = Clock(1000); % = '00:16:40.00'
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

h = floor(snd/3600);                                                            % hours
m = floor((snd-(h*3600))/60);                                                   % minutes
s = rem(snd,3600)-m*60;                                                         % seconds
clk = sprintf('%02d:%02d:%05.2f',h,m,s);                                        % into clock format
end

function colors = Colorize(x,cmap,n,col,tol)
% Colorize
% returns colors according to values in "x"
%
% Usage...:
% colors = Colorize(x,cmap,n,col,tol);
%
% Input...: x         (n),number
%           cmap      (1),colormap handle, e.g., @jet
%           n         (1),numer of colors
%           col       (3),color, constant color
%           tol       (1),tolerance for case: (x2-x1) < tol >>> constant color
% Output..: colors    (n,3),colors
%
% Examples:
%{
cls = Colorize(rand(1,10));
cls = Colorize(rand(1,10),@hot,128);
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

global Tolerance
if nargin < 5; tol = Tolerance; end
if nargin < 4; col = [1,0,0]; end
x(isnan(x)) = 0;
x1 = min(x(:));                                                                 % minimum of data
x2 = max(x(:));                                                                 % maximum of data
if (x2-x1) < tol                                                                % almost all constant values
    sz = size(x);
    if sz(1) == 1; sz = circshift(sz,-1); end
    colors = repmat(col,sz);                                                    % repeats color as needed
    return
end
if nargin < 3; n = 64; end                                                      % colors discretization number
if nargin < 2; cmap = @jet; end                                                 % default colormap
colors = cmap(n);                                                               % prepares colormap colors
colors = squeeze(reshape(colors(int32(Scale(x,x1,x2,1,n)),:),[size(x),3]));     % maps all to colors
end

function deg = Deg(rad)
% Deg
% converts radian "rad" to degree
%
% Usage...:
% deg = Deg(rad);
%
% Input...: rad       any,radian
% Output..: deg       any,degree
%
% Examples:
%{
deg = Deg([0,pi,2*pi]);
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

deg = rad2deg(rad);
end

function rad = Rad(deg)
% Rad
% converts degrees to radians
%
% Usage...:
% rad = Rad(deg);
%
% Input...: deg       any,degree
% Output..: rad       any,radian
%
% Examples:
%{
rad = Rad(180); % = pi
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

rad = deg2rad(deg);
end

function y = Normed(x)
% Normed
% returns norm of "x"
%
% Usage...:
% y = Normed(x);
%
% Input...: x         any
% Output..: y         any
%
% Examples:
%{
y = Normed(rand(1,3));
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

y = bsxfun(@rdivide,x,sqrt(sum(x.^2,2)));
end

function trs = Polytri(ply)
% Polytri
% triangulates polygons "ply"
%
% Usage...:
% trs = Polytri(ply);
%
% Input...: ply       cell
% Output..: trs       cell, of cell
%
% Examples:
%{
trs = Polytri([0,0;1,0;1,1;0,1]); % = {4 triangles}
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

ply = Convert('cell',ply);
cts = Center(ply);                                                              % centers
n = size(ply,1);
trs = cell(n,1);
for i = 1:n
    py = ply{i};                                                                % polygon
    k = size(py,1);                                                             % number of edges
    trs{i} = arrayfun(@(j)[cts(i,:);py(j,:);py(Wrap(j+1,k),:)],1:k,...          % triangles
        'UniformOutput',false)';
end
end

function s = Struct(varargin)
% Struct
% converts cell "varargin" to struct
%
% Usage...:
% s = Struct(varargin);
%
% Input...: varargin  any
% Output..: s         struct
%
% Examples:
%{
s = Struct('a',1,'b',34); % = {a:1, b:34}
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

s = cell2struct(varargin(2:2:end),varargin(1:2:end),2);
end

function pts = T2(pts,pln,centered)
% T2
% converts 3D points "pts" into 2D
%
% Usage...:
% pts = T2(pts,pln,centered);
%
% Input...: pts       (n,3),points
%           pln       (9),plane of projection
%           centered  boolean, if true to center
% Output..: pts       (n,2)
%
% Examples:
%{
pts = T2(rand(10,3));
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

if nargin < 3; centered = false; end
if (nargin < 2) || isempty(pln); pln = Plane(pts); end                          % plane of points
if centered; cnt = Center(pts); end
pts = Project(pts,pln);
if centered
    pts = pts-(Center(pts)-cnt(1:2));
end
end

function y = T3(x)
% T3
% converts 2D "x" lines|points|polygons into 3D
%
% Usage...:
% y = T3(x);
%
% Input...: x         (n,2|3|4|6,cell),points|lines|polygons 2D
% Output..: y         any,3D
%
% Examples:
%{
pts = T3(rand(10,2));
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

if iscell(x)                                                                    % 2D polygons
    y = cellfun(@(ply)AddZ(ply),x,'UniformOutput',false)';
else
    if size(x,2) == 4                                                           % 2D lines
        y = [AddZ(x(:,1:2)),AddZ(x(:,3:4))];
    else                                                                        % 2D points
        y = AddZ(x);
    end
end
    function x = AddZ(x)
        x = [x,zeros(size(x,1),1)];
    end
end
