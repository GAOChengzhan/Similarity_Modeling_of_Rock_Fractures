function [xts,ids,La] = Intersect(in)
% Intersect
% finds intersection for "in", lines|polygons, 2D|3D
%
% Usage...:
% [xts,ids,La] = Intersect(in);
%
% Input...: in        (n,4|cell),lines|polygons
% Output..: xts       (k,2|6),intersection points|lines
%           ids       (k,2),indices
%           La        (n),cluster labels
%
% Examples:
%{
[xts,ids,La] = Intersect(Field(DFN('dim',2),'Line'));
[xts,ids,La] = Intersect(Field(DFN('dim',3),'Poly'));
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

global Runtime Left Silent
if iscell(in)                                                                   % 3D polygons
    n = size(in,1);
    needed = (n > 100) && (Runtime > 0) && ~Silent;                             % if needs to report
    if needed; fprintf([Left,'%d <Poly X Poly> Tests\n'],n*(n-1)/2); end        % report
    ids = Bbox(in,'intersect');                                                 % finds intersection between
    m = size(ids,1);                                                            % ...bounding boxes of polygons
    if needed; fprintf([Left,'[%d BB]:    '],m); end                            % report
    xts = zeros(m,6);                                                           % initialize intersection lines
    k = 0;                                                                      % counter
    for i = 1:m                                                                 % loops over all candidate lines
        xpt = PolyXPoly(in{ids(i,1)},in{ids(i,2)});                             % intersection line
        if isempty(xpt)                                                         % if not intersecting
            ids(i,:) = 0;                                                       % remove index
            continue;
        end
        k = k+1;                                                                % adds up counter
        xts(k,:) = xpt;                                                         % intersection lines
        if needed                                                               % progress report
            p = 10*i/m;
            if abs(p-round(p)) < 1e-1
                fprintf('\b\b\b\b%3d%%',round(p)*10);
            end
        end
    end
    if needed; fprintf('\n'); end
else                                                                            % 2D lines
    n = size(in,1);                                                             % number of lines
    ids = Bbox(in,'intersect');                                                 % finds intersection between
    m = size(ids,1);                                                            % ...bounding boxes of lines
    xts = zeros(m,2);                                                           % initialize intersection points
    k = 0;                                                                      % counter
    for i = 1:m
        xpt = CExt.intersectEdges(in(ids(i,1),:),in(ids(i,2),:));
        if ~isfinite(xpt(1))                                                    % if not intersecting
            ids(i,:) = 0;
            continue
        end
        k = k+1;                                                                % adds up counter
        xts(k,:) = xpt;                                                         % intersection points
    end
end
xts = xts(1:k,:);                                                               % updates 'xts'
ids = ids(~any(ids == 0,2),:);                                                  % updates 'ids'
if k > 1
    La = Label(Cluster(ids),n);                                                 % fracture cluster labels
else                                                                            % if only two intersecting
    if isempty(xts)                                                             % ...or only two items
        La = [-1,-2];                                                           % isolated
    else
        La = [1,1];                                                             % intersecting
    end
end
end

% internal functions
function xts = PolyXPoly(ply1,ply2)
% intersection between two polygons, 3D
xts = zeros(0,6);
xl1 = PolyXPlane(ply1,ply2);                                                    % intersection bw. poly and plane
xl2 = PolyXPlane(ply2,ply1);
ats = Reshape([xl1;xl2],[],3);
b = Inpoly(ats,ply1) & Inpoly(ats,ply2);                                        % tests points belong to both
ats = unique(ats(b,:),'rows');                                                  % remove duplicates
if isempty(ats); return; end                                                    % exits if empty
xts = [ats(1,:),ats(end,:)];                                                    % returns intersection line
end

function xts = PolyXPlane(ply,pln)
% intersection between a polygon and a plane, 3D
egs = [ply,circshift(ply,[-1,0])];
xts = LineXPlane(egs,Plane(pln));                                               % intersection bw. lines and plane
xts = xts(~any(isnan(xts),2),:);                                                % intersection points
if isempty(xts)
    xts = zeros(0,6);
else
    xts = unique(xts,'rows');                                                   % removes duplicates
    xts = [xts(1,:),xts(2,:)];
end
end

function pts = LineXPlane(lns,pln)
% intersection between lines and a plane, 3D
global Tolerance
tol = Tolerance;                                                                % default tolerance
n = size(lns,1);
nrm = repmat(cross(pln(4:6),pln(7:9),2),n,1);
lns = [lns(:,1:3),lns(:,4:6)-lns(:,1:3)];
f = (abs(dot(nrm,lns(:,4:6),2)) >= tol);
pts = nan(n,3);
d = bsxfun(@minus,pln(1:3),lns(:,1:3));
t = dot(nrm(f,:),d(f,:),2)./dot(nrm(f,:),lns(f,4:6),2);
r = (-tol < t) & (t < (1+tol));
f(f) = r;
%pts(f,:) = lns(f,1:3)+t(r).*lns(f,4:6);                                        % intersection points, MR2017
pts(f,:) = lns(f,1:3)+bsxfun(@times,t(r),lns(f,4:6));                           % intersection points, MR2015
end
