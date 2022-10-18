function out = Rotate(in,varargin)
% Rotate
% rotates points|lines|polygons "in"
%
% Usage...:
% out = Rotate(in,varargin);
%
% Input...: in        (n,4|6|cell),points|lines|polygons
%           varargin  {...}
% Output..: out       any,rotated
%
% Examples:
%{
pts = Rotate(rand(10,2),'ang',45,'mov',[1,10]); % 2d points|polygons
pts = Rotate(rand(10,3),'x',45,'y',30,'z',10); % 3d points
lns = Rotate(rand(10,4),'ang',45); % 2d lines
lns = Rotate(rand(10,6),'x',45); % 3d lines
ply = Rotate(Poly.Top,'x',45); % 3d polygons
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

opt = Option(varargin,'x',0,'y',0,'z',0,'cnt',[0,0,0],'ang',0,'mov',nan);       % default arguments
in = Convert('cell',in);                                                        % converts to cell if necessary
n = length(in);                                                                 % size of input 'in'
dim = size(in{1},2);                                                            % determines dimension
switch dim
    case 2                                                                      % 2D points,polygons
        in = in{1};
        if opt.ang == 0                                                         % no rotation requested
            out = in;
        else
            if any(isnan(opt.cnt)); opt.cnt = mean(in,1); end                   % center of rotation
            ang = Convert('rad',opt.ang);                                       % to radians
            out = [in(:,1)-opt.cnt(1),in(:,2)-opt.cnt(2)]*[cos(ang),sin(ang);...  % does rotation
                -sin(ang),cos(ang)];
            out = [out(:,1)+opt.cnt(1),out(:,2)+opt.cnt(2)];                    % moves to original center
        end
    case 3                                                                      % 3D points,polygons
        T = eye(4,4);                                                           % initializes rotation matrix
        if opt.z ~= 0
            ang = Convert('rad',opt.z);
            T = T*[cos(ang),-sin(ang),0,0;sin(ang),cos(ang),0,0;0,0,1,0;0,0,0,1];  % around Z axis
        end
        if opt.y ~= 0
            ang = Convert('rad',opt.y);
            T = T*[cos(ang),0,sin(ang),0;0,1,0,0;-sin(ang),0,cos(ang),0;0,0,0,1];  % around Y axis
        end
        if opt.x ~= 0
            ang = Convert('rad',opt.x);
            T = T*[1,0,0,0;0,cos(ang),-sin(ang),0;0,sin(ang),cos(ang),0;0,0,0,1];  % around X axis
        end
        if any(opt.cnt ~= 0)
            t = [1,0,0,opt.cnt(1);0,1,0,opt.cnt(2);0,0,1,opt.cnt(3);0,0,0,1];   % translates to center
            T = t*T/t;
        end
        cts = Center(in);                                                       % centers
        out = cell(n,1);
        for i = 1:n
            [x,y,z] = CData.Deal(in{i});
            t = [x,y,z,ones(numel(x),1)]*T';                                    % applies rotation
            %out{i} = t(:,1:3)-Center(t(:,1:3));                                % MR2017
            out{i} = bsxfun(@minus,t(:,1:3),Center(t(:,1:3)));                  % MR2015
            if isnan(opt.mov)
                %out{i} = out{i}+cts(i,:);                                      % translation to original center
                out{i} = bsxfun(@plus,out{i},cts(i,:));                         % ...MR2015
            else
                %out{i} = out{i}+opt.mov;                                       % translation to given point
                out{i} = bsxfun(@plus,out{i},opt.mov);                          % ...MR2015
            end
        end
        if n == 1; out = out{1}; end
    otherwise                                                                   % 2D|3D lines
        opt.cnt = nan(1,dim/2);
        opt = Convert('cell',opt);                                              % to cell if required
        out = Reshape(Rotate(Reshape(in{1},[],dim/2),opt{:}),[],dim);           % does rotation
end
