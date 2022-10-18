function d = Distance(pts,in)
% Distance
% finds minimum distance for points "pts" from "in", 2D|3D, lines|polygons
%
% Usage...:
% d = Distance(pts,in);
%
% Input...: pts       (n,2|3),points
%           in        (k,4|6,cell),lines,polygons
% Output..: d         (n),minimum distances
%
% Examples:
%{
d = Distance(rand(10,2),rand(3,4)); % 2d points and lines
d = Distance(rand(10,3),rand(3,6)); % 3d points and lines
d = Distance(rand(10,3),{rand(3,3);rand(3,3)}); % 3d points and polygons
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

if iscell(in)                                                                   % 2D|3D point distance from polygons
    m = length(in);                                                             % number of polygons
    n = size(pts,1);                                                            % number of points
    d = zeros(n,m);                                                             % initializes distance matrix
    dim = size(in{1},2);                                                        % determines dimension
    for i = 1:length(in)                                                    	% loop over all polygons
        ply = in{i};                                                        	% chooses a polygon
		if dim == 3                                                             % so, from 3D polygons
            pln = Plane(ply);                                                   % ...its plane
            d(:,i) = abs(sum(bsxfun(@times,Convert('norm',cross(pln(4:6),...
			    pln(7:9),2)),bsxfun(@minus,pln(1:3),pts)),2));                  % point distances from plane
            pjs = Project([pts;ply],pln);                                       % projects all on the plane
            pts_ = pjs(1:n,:);                                                  % now, 2d points
            ply_ = pjs(n+1:end,:);                                              % ...and 2d polygon
            [in_,on_] = inpolygon(pts_(:,1),pts_(:,2),ply_(:,1),ply_(:,2));     % inpolygon test
		else
            [in_,on_] = inpolygon(pts(:,1),pts(:,2),ply(:,1),ply(:,2));         % inpolygon test
		end
		f = ~(in_ | on_);                                                   	% not inside nor on the polygon
		d(f,i) = min(Snap(pts(f,:),Polyline(ply),0),[],2);                  	% ...find minimum distances
	end
else                                                                            
    d = min(Snap(pts,in,0),[],2);                                               % 2D|3D, point distance from lines
end
