function [y,b] = Clip(x,bbx)
% Clip
% clips "x", lines|polygons [2D|3D] by bounding box "bbx"
%
% Usage...:
% [y,b] = Clip(x,bbx);
%
% Input...: x         (n,4|6|cell),lines|polygons
%           bbx       (4|6),bounding box
% Output..: y         (k,4|6|cell),clipped
%           b         (n),boolean,record of those fully clipped out
%
% Examples:
%{
[y,b] = Clip(rand(10,4),[0,0,1,1]); % clipping 2d lines
[y,b] = Clip(plys,[0,0,0,1,1,1]); % clipping 3d polygons
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

if iscell(x)                                                                    % 3D polygons
    if nargin < 2; bbx = [0,0,0,1,1,1]; end                                     % default bounding box
    [x1,y1,z1,x2,y2,z2] = CData.Deal(bbx);                                      % for convenience
    xy1 = CExt.Plane([x1,y1,z1],[0,0,-1]);                                     
    xy2 = CExt.Plane([x1,y1,z2],[0,0,1]);
    xz1 = CExt.Plane([x1,y1,z1],[0,-1,0]);
    xz2 = CExt.Plane([x1,y2,z1],[0,1,0]);
    yz1 = CExt.Plane([x1,y1,z1],[-1,0,0]);
    yz2 = CExt.Plane([x2,y1,z1],[1,0,0]);
    n = size(x,1);
    y = cell(n,1);
    k = 0;                                                                      % counter
    b = false(n,1);                                                             % mask for all lines|polygons
    for i = 1:n
        ply = CExt.ClipPolyHP(CExt.ClipPolyHP(CExt.ClipPolyHP(...
            CExt.ClipPolyHP(CExt.ClipPolyHP(CExt.ClipPolyHP(x{i},xy1),xy2),...
            xz1),xz2),yz1),yz2);
        if isempty(ply); continue; end
        k = k+1;
        y{k} = ply;                                                             % stores clipped item
        b(i) = true;
    end
    y = y(1:k);
else                                                                            % 2D lines
    if nargin < 2; bbx = [0,0,1,1]; end                                         % default bounding box
    [y,b] = CExt.ClipLine(x,bbx);
end
end
