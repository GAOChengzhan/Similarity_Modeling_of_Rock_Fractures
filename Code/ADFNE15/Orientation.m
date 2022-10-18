function out = Orientation(in)
% Orientation
% returns orientation angles (dip,dip-direction) for 3D, direction for 2D
%
% Usage...:
% out = Orientation(in);
%
% Input...: in        any,lines|polygons
% Output..: out       {Angle|Dip,Dir}
%
% Examples:
%{
out = Orientation(rand(10,4)); % out.Angle
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

if iscell(in)                                                                   % 3D polygons
    out = struct;
    for i = 1:length(in)
        nrm = CExt.planeNormal(Plane(in{i},true));
        out(i).Dir = Angle(Convert('deg',atan2(nrm(2),nrm(1))),360);            % dip-direction angles, [0..360)
        out(i).Dip = Angle(Convert('deg',pi/2-asin(nrm(3))),90);                % dip angles, [0..90]
    end
else                                                                            % 2D lines
    k = size(in,2);
    if k == 4
        ags = num2cell(Angle(Convert('deg',atan2(in(:,4)-in(:,2),...            % direction angles, [0..360)
            in(:,3)-in(:,1))),360));
        [out(1:size(in,1)).Angle] = ags{:};
    else                                                                        % 3D lines
        out = struct;
        df = diff(in(:,[3,6]),[],2);
        f = (df > 0);
        ljs = in(:,[1,2,4,5]);                                                  % ignoring Z coordinates
        o = Orientation(ljs);                                                   % orientations
        out.Dir = [o.Angle]';
        out.Dir(f) = Angle(out.Dir(f)+180,360);                                 % dip-direction angles, [0..360)
        f = (df ~= 0);
        p0 = in(f,1:3);
        p1 = in(f,4:6);
        p2 = p1;
        p1(:,3) = p0(:,3);
        v1 = p1-p0;
        v2 = p2-p0;
        dps = zeros(size(in,1),1);
        dps(f) = Convert('deg',acos(dot(bsxfun(@rdivide,v1,sqrt(sum(v1.^2,2))),...
            bsxfun(@rdivide,v2,sqrt(sum(v2.^2,2))),2)));
        out.Dip = dps;                                                          % dip angles [0..90]
    end
end
end
