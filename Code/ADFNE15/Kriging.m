function [krg,err] = Kriging(pts,vrl,d,mdl,gns,draw)
% Kriging
% computes Kriging estimates for points 'pts', 2D|3D
%
% Usage...:
% [krg,err] = Kriging(pts,vrl,d,mdl,gns,draw);
%
% Input...: pts       (n,2|3),points
%           vrl       (n),values
%           d         distances from Variocloud
%           mdl       variogram model, see example below
%           gns       2|3),grid dimensions
%           draw      if true, draw results
% Output..: krg       estimation
%           err       error
%
% Examples:
%{
[d,~,~] = Variocloud([x,y],w,[],true);
[krg,err] = Kriging([x,y],w,d,{'name','sph','nugget',0,'sill',4,'range',50},[50,50],true);
% see Demo for a working example
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
% Updated.: 2017-12-29

if nargin < 6; draw = false; end                                                % default arguments
if nargin < 5; gns = zeros(1,size(pts,2))+7; end                                % mesh dimensions
if (nargin < 4) || isempty(mdl)
    mdl = {'name','exp','nugget',0,'sill',4,'range',40};                        % default variogram model
end
out = squareform(Model(mdl,d));                                                 % results from variogram model
n = size(out,1);
out(:,n+1) = 1;
out(n+1,:) = 1;
out(n+1,n+1) = 0;
gnv = inv(out);                                                                 % inverse
dim = size(pts,2);
if dim == 2                                                                     % 2d case
    [gx,gy] = meshgrid(...                                                      % mesh
        linspace(min(pts(:,1)),max(pts(:,1)),gns(1)),...
        linspace(min(pts(:,2)),max(pts(:,2)),gns(2)));
    sts = [gx(:),gy(:)];                                                        % points for estimation, 2D
else                                                                            % 3d case
    dx = linspace(min(pts(:,1)),max(pts(:,1)),gns(1));
    dy = linspace(min(pts(:,2)),max(pts(:,2)),gns(2));
    dz = linspace(min(pts(:,3)),max(pts(:,3)),gns(3));
    [gx,gy,gz] = meshgrid(dx,dy,dz);                                            % systematic (regular) mesh
    sts = [gx(:),gy(:),gz(:)];                                                  % points for estimation, 3D
    dx = dx(2)-dx(1);
    dy = dy(2)-dy(1);
    dz = dz(2)-dz(1);
end
k = size(sts,1);
krg = nan(k,1);
err = nan(k,1);
for i = 1:k                                                                     % loops over all points
    g = Model(mdl,pdist2(pts,sts(i,:)));                                        % variogram model
    g(n+1) = 1;
    es = gnv*g;                                                                 % solution
    krg(i) = sum(es(1:n).*vrl);                                                 % estimates
    err(i) = sum(es(1:n).*g(1:n,1))+es(n+1);                                    % errors
end
krg = reshape(krg,fliplr(gns));
err = reshape(err,fliplr(gns));
if draw
    if dim == 2                                                                 % 2d case
        h = pcolor(gx,gy,krg);                                                  % draws as color patches
        h.EdgeColor = 'none';                                                   % no edge color
        axis image tight; box on; xlabel('X'); ylabel('Y'); title('Kriging');   % sets axes etc.
    else                                                                        % 3d case
        Draw('cub',[sts,bsxfun(@plus,sts,[dx,dy,dz])],'fc',...
            Convert('color',krg(:)),'fa',0.4,'ec','none');                      % draws cube of estimates
        xlabel('X'); ylabel('Y'); zlabel('Z'); camproj('perspective');          % sets axes labels etc.
        daspect([1,1,1]); grid on; box on; view(145,30); axis vis3d;            % sets axes etc.
    end
end
% internal functions
    function out = Model(mdl,lgs)
        out = Variomodel(mdl,lgs,false).*(lgs > 0);                             % variogram model
    end
end
