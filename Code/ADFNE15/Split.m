function [ols,jds,sn,xts,ids,La] = Split(lns,itv)
% Split
% splits 2D|3D lines at intersection points or by interval
%
% Usage...:
% [ols,jds,sn,xts,ids,La] = Split(lns,itv);
%
% Input...: lns       (n,4|6),lines
%           itv       (1),interval
% Output..: ols       (?,4|6)lines |cell,points
%           jds       (?),id of original lines
%           sn        (?),segment numbers
%           xts       (?,2),intersection points
%           ids       (?,2),intersection ids
%           La        (?),cluster labels
%
% Examples:
%{
ols = Split(rand(10,4),0); % split 2d lines at intersections
ols = Split(rand(10,4),0.01); % split 2d lines at intervals = 0.01
ols = Split(rand(10,6),0.01); % split 3d lines at intervals = 0.01
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

if nargin < 2; itv = 0; end                                                     % default method
Ticot('Splitting Lines');                                                       % initializes timing
[m,k] = size(lns);
switch itv
    case 0                                                                      % at intersections
        assert(k == 4,'2D lines, mismatch!');                                   % should be 2d lines
        [xts,ids,La] = Intersect(lns);                                          % intersections
        gxs = Group(xts,ids,m);                                                 % groups points etc.
        ols = cell(m,1);
        for i = 1:m                                                             % loops over all lines
            if La(i) < 0
                ols{i} = lns(i,:);
            else
                ots = Sort([gxs{i};lns(i,1:2);lns(i,3:4)],nan);                 % sorts in topological order
                lls = [ots(1:end-1,:),ots(2:end,:)];
                ols{i} = lls(Length(lls) > 0,:);
            end
        end
        sn = cellfun(@numel,ols)/4;
        f = (sn > 0);
        jds = repelem(1:m,sn)';
        sn = sn(f);
        ols = Stack(ols(f));                                                    % stacks up all lines
    otherwise                                                                   % at intervals 'itv'
        k = k/2;                                                                % determines dimension
        D = sqrt(sum((lns(:,k+1:end)-lns(:,1:k)).^2,2));                        % lengths
        N = floor(D/itv);
        R = itv./D;
        ols = cell(m,1);
        for j = 1:m
            I = (1:N(j))'.*R(j);
            pts = [lns(j,1:k);(1-I)*lns(j,1:k)+I*lns(j,k+1:end)];
            if any(abs(pts(N(j)+1,:)-lns(j,k+1:end)))
                pts(N(j)+2,:) = lns(j,k+1:end);
            end
            ols{j} = pts;
        end
end
Ticot;                                                                          % ends timing
