function cts = Center(x)
% Center
% returns centroid of "x", points, lines, polygons, 2D|3D
%
% Usage...:
% cts = Center(x);
%
% Input...: x         any,lines|polygons|single polygon|points
% Output..: cts       any
%
% Examples:
%{
cts = Center(rand(10,2)); % 2d points
cts = Center(rand(10,3)); % 3d points
cts = Center({rand(3,2);rand(3,2)}); % 2d polygons
cts = Center({rand(3,3);rand(3,3)}); % 3d polygons
cts = Center(rand(3,4)); % 2d lines
cts = Center(rand(3,6)); % 3d lines
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
    cts = cell2mat(cellfun(@Centroid,x,'UniformOutput',false));
else                                                                            % 2D|3D lines,points
    k = size(x,2);
    if (k > 2) && (mod(k,2) == 0)                                               % if lines
        k = 0.5*k;
        cts = 0.5*(x(:,1:k)+x(:,k+1:end));                                      % average points for each line
    else                                                                        % if points
        cts = mean(x,1);                                                        % average point
    end
end
    function cnt = Centroid(x)                                                  % internal function
        v = size(x,2);
        if v == 3                                                               % if 3D?
            pln = Plane(x);                                                     % plane of points
            x = Project(x,pln);                                                 % projected points, 2D
        end
        f = [2:size(x,1),1];
        c = x(:,1).*x(f,2)-x(f,1).*x(:,2);
        cnt = [sum((x(:,1)+x(f,1)).*c),sum((x(:,2)+x(f,2)).*c)]/(3*sum(c));     % center points, 2D
        if v == 3
			cnt = pln(1:3)+bsxfun(@times,pln(4:6),cnt(:,1))+bsxfun(@times,...   % back to 3D
			    pln(7:9),cnt(:,2));
  	    end
    end
end
