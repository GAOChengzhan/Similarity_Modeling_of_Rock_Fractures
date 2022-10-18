function out = DFN(varargin)
% DFN
% generates fracture network models, 2D|3D
%
% Usage...:
% out = DFN(varargin);
%
% Input...: varargin  any
% Output..: out       struct,{Line,Orig|Poly,Orig}
%
% Examples:
%{
fnm = DFN; % 2d fnm
fnm = DFN('dim',2,'n',300,'dir',45,'ddir',0,'minl',0.1,'mu',0.2,'maxl',0.3); % 2d fnm
fnm = [Field(DFN('dim',2,'n',30,'dir',45,'ddir',-100,'minl',0.1,'mu',0.2,... % combined fnm
    'maxl',0.3),'Line');Field(DFN('dim',2,'n',30,'dir',135,'ddir',-100,'minl',...
    0.1,'mu',0.2,'maxl',0.3),'Line')];
fnm = Field(DFN('dim',3),'Poly'); % 3d fnm
fnm = Field(DFN('dim',3,'dip',45,'ddip',0,'dir',180,'ddir',0),'Poly'); % 3d fnm
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

global Report
opt = Option(varargin,'n',100,'minl',0.05,'mu',0.3,'maxl',0.6,...               % default arguments
    'bbx',[0,0,1,1],'dim',2,'asep',0,'dsep',0,'mit',100,'scale',1,...
    'shape','c','q',24,'dip',45,'ddip',-1e-7,'dir',0,'ddir',-1e-7);
Ticot(sprintf('Generating %dD FNM [n = %d]',opt.dim,opt.n));                    % initializes timing
lhs = 0.5*Rand(opt.n,'fun','exp','mu',opt.mu,'ab',[opt.minl,opt.maxl]);         % half lengths~ Exp(mu) dist.
if opt.dim == 2                                                                 % 2D case
    if (opt.asep > 0) || (opt.dsep > 0)                                         % conditional simulation
        lns = zeros(opt.n,4);                                                   % initializes lines
        ags = zeros(opt.n,1);                                                   % initializes angles
        bxs = zeros(opt.n,4);                                                   % initializes bounding boxes
        enl = [-opt.dsep,-opt.dsep,opt.dsep,opt.dsep];                          % enlargement values 
        bxs(1,:) = enl;                                                         % 'dsep' based box
        k = 0;                                                                  % counter to meet required 'n'
        rep = 0;                                                                % repetition counter 
        while k < opt.n
            ang = rand*180;                                                     % random angle
            [x,y] = pol2cart(Convert('rad',ang),lhs(k+1));                      % axes aligned lengths
            cnt = rand(1,2);                                                    % random point, center of line
            lin = [cnt-[x,y],cnt+[x,y]];                                        % the candidate line
            box = Bbox(lin,'pp')+enl;                                           % enlarged bounding box of line
            ok = true;
            for i = 1:k                                                         % test for existing fractures
                dt = all(box(1:2) <= bxs(i,3:4)) && all(bxs(i,1:2) <= box(3:4));
                at = (abs(ang-ags(i)) < opt.asep);
                if dt || at
                    ok = false;                                                 % so, candidate is unaccepted
                    break
                end
            end
            if ok                                                               % if all good, add
                k = k+1;                                                        % adds up counter
                lns(k,:) = lin;                                                 % adds candidate to lines
                ags(k) = ang;                                                   % updates angles
                bxs(k,:) = box;                                                 % updates bounding boxes
                rep = 0;                                                        % resets repetition counter
            else
                rep = rep+1;                                                    % adds up repetition counter
            end
            if rep >= opt.mit; break; end                                       % maximum repetition occurred
        end
        ols = lns(1:k,:);                                                       % output
    else                                                                        % simple simulation
        n = opt.n;
        pts = rand(n,2);                                                        % locations~ U(0,1)
        ags = Rand(n,'fun','f','mu',opt.dir,'k',-opt.ddir);                     % orientation, Fisher dist. 
        [dx,dy] = pol2cart(Convert('rad',ags),lhs);
        ols = [pts(:,1)-dx,pts(:,2)-dy,pts(:,1)+dx,pts(:,2)+dy];                % original lines
    end
    out.Orig = ols;
    out.Line = Clip(ols,opt.bbx);                                               % clipped by region of study
    if Report                                                                   
        Display('Original Lines#',size(out.Orig,1),...                          % displays information
            'Clipped Lines#',size(out.Line,1));
    end
else                                                                            % 3D case
    lhs = 2*lhs;                                                                % reverts to original lengths
    if numel(opt.bbx) == 4; opt.bbx = [0,0,0,1,1,1]; end                        % default bounding box
    switch opt.shape                                                            % polygon shape selection
        case {'c','circle'}                                                     % circle
            elp = Convert('3d',Geometry('ellipse','cnt',[0,0],'r',[0.5,0.5],...  % 3d circle, the base shape
                'q',opt.q));
            rcs = zeros(opt.n,opt.q,3);
            for i = 1:opt.n
                rcs(i,:,:) = elp*lhs(i);                                        % updates the shape sizes
            end
        case {'e','ellipse'}                                                    % ellipse
            elp = Convert('3d',Geometry('ellipse','cnt',[0,0],'r',[0.5,0.25],...  % 3d ellipse, the base shape
                'q',opt.q));
            rcs = zeros(opt.n,opt.q,3);
            for i = 1:opt.n
                rcs(i,:,:) = elp*lhs(i);                                        % updates the shape sizes
            end
        case {'s','square'}                                                     % square
            rcs = zeros(opt.n,4,3);
            for i = 1:opt.n
                r = 0.5*lhs(i);                                                 % updates the shape sizes
                rcs(i,:,:) = [0,-r,-r; 0,r,-r; 0,r,r; 0,-r,r];
            end
        otherwise                                                               % legacy method, see citation
            rcs = zeros(opt.n,4,3);
            for i = 1:opt.n
                r = lhs(i)*(rand(1,4)-0.5);
                rcs(i,:,:) = [0,r(1),-lhs(i);0,lhs(i),r(2);0,r(3),lhs(i);0,...
                    -lhs(i),r(4)];
            end
    end
%----dip
    dip = Angle(opt.dip,90);                                                    % ensures correct angle
    ddip = opt.ddip;                                                            % angle variation
    if ddip > 0                                                                 % ddip is in degree
        dp1 = dip-ddip;
        dp2 = dip+ddip;
        if dp1 < 0; dp1 = 0; end
        if dp2 > 90; dp2 = 90; end
        dps = Scale(rand(opt.n,1),0,1,dp1,dp2);                                 % uniform random dips
    elseif ddip < 0                                                             % then -ddip is k (kappa)
        dps = Rand(opt.n,'fun','f','mu',dip,'k',-ddip,'ab',[0,90]);             % Fisher dip angles
    else
        dps = zeros(opt.n,1)+dip;                                               % constant dip angles
    end
%----ddir
    dir = Angle(opt.dir,360);                                                   % ensures correct angle
    ddir = opt.ddir;                                                            % angle variation 
    if ddir > 0                                                                 % ddir is in degree
        dd1 = dir-ddir;
        dd2 = dir+ddir;
        if dd1 < 0; dd1 = 0; end
        if dd2 > 360; dd2 = 360; end
        dds = Scale(rand(opt.n,1),0,1,dd1,dd2);                                 % uniform rand dir angles
    elseif ddir < 0                                                             % then -ddir is k (kappa)
        dds = Rand(opt.n,'fun','f','mu',dir,'k',-ddir);                         % Fisher dir angles
    else
        dds = zeros(opt.n,1)+dir;                                               % constant dir angles
    end
    dps = Convert('rad',dps);                                                   % dips in radians
    dds = Convert('rad',dds);                                                   % dip-directions in radians
%----polygons
    plys = cell(opt.n,1);                                                       % initializes polygons
    for i = 1:opt.n
        ply = squeeze(rcs(i,:,:));                                              % fixes abundant dimension
        pt = rand(1,3);                                                         % TODO: other dists.
        T = [1,0,0,pt(1);0,1,0,pt(2);0,0,1,pt(3);0,0,0,1]*...                   % transformers
            [opt.scale,0,0,0;0,opt.scale,0,0;0,0,opt.scale,0;0,0,0,1]*...       % scaling
            [cos(dds(i)),-sin(dds(i)),0,0;sin(dds(i)),cos(dds(i)),0,0;...       % rotations
            0,0,1,0;0,0,0,1]*[cos(dps(i)),0,sin(dps(i)),0;0,1,0,0;...
			-sin(dps(i)),0,cos(dps(i)),0;0,0,0,1];
        t = [ply(:,1),ply(:,2),ply(:,3),ones(size(ply,1),1)]*T';                % applies transformations
        plys{i} = t(:,1:3);                                                     % stores the resulting polygon
    end
    out.Orig = plys;                                                            % original polygons
    out.Poly = Clip(plys,opt.bbx);                                              % clipped by region of study
    if Report
        Display('Original Polys#',size(out.Orig,1),...                          % displays information
            'Clipped Polys#',size(out.Poly,1));
    end
end
Ticot;                                                                          % ends timing
