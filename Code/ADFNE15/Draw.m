function ax = Draw(dfn,varargin)
% Draw
% draws primitives, DFN and integrated
%
% Usage...:
% ax = Draw(dfn,varargin);
%
% Input...: dfn       char(cub|sph|cyl|lin|pnt|ply|elp)|cell|struct etc.,
%           varargin  any
% Output..: ax        axis handle
%
% Examples:
%{
Draw(rand(10,4)); % 2d lines
Draw(rand(10,6)); % 3d lines
Draw('cub',[0,0,0,1,1,1]); % cube
Draw('sph',[0,0,0]); % sphere
Draw('cyl',[0,0,0;1,1,1],'cix',[1,64],'ec','k'); % cylinder
Draw('lin',rand(10,4)); % 2d lines
Draw('lin',rand(10,6)); % 3d lines
Draw('ply',rand(3,2)); % 2d polygons
Draw('ply',rand(3,3)); % 3d polygons
Draw(dfn,'what','fsen'); % fnm, solution (edges,nodes)
Draw(dfn,'what','fpxiqseng'); % all possible drawing
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

global Segment Labels Debug RandomColor                                         % global defaults
if ischar(dfn)                                                                  % primitive drawing
    switch dfn
        case {'cube','cub'}                                                     % cube
            opt = Option(varargin,'fc',[0,0.5,1],'fa',0.5,'ec','none');         % default arguments
            if isfield(opt,'in')                                                % if bounding boxes provided
                bxs = opt.in;
            else
                bxs = [0,0,0,1,1,1];                                            % default bounding box
            end
            n = size(bxs,1);                                                    % number of boxes
            vts = zeros(n*8,3);                                                 % initializes vertices
            for i = 1:n
                bx = bxs(i,:);                                                  % chooses a box
                j = (i-1)*8+1;
                vts(j:j+7,:) = [bx(1),bx(2),bx(3); bx(4),bx(2),bx(3);...        % computes all vertices
                    bx(4),bx(5),bx(3); bx(1),bx(5),bx(3); bx(1),bx(2),bx(6);...
                    bx(4),bx(2),bx(6); bx(4),bx(5),bx(6); bx(1),bx(5),bx(6)];
            end
            one = [1,2,6,5; 2,3,7,6; 3,4,8,7; 4,1,5,8; 1,2,3,4; 5,6,7,8];       % vertex indices for faces
            fcs = zeros(6*n,4);                                                 % initializes faces
            for i = 0:n-1                                                       % loop over all boxes
                j = i*6+1;
                fcs(j:j+5,:) = (i*8)+one;                                       % updates faces
            end
            p = patch('Vertices',vts,'Faces',fcs);                              % creates patches
            p.FaceVertexCData = repelem(opt.fc,6,1);                            % applies face color
            p.FaceColor = 'flat';                                               % ...color interpolation
            p.FaceAlpha = opt.fa;                                               % ...face alpha, transparency
            p.EdgeColor = opt.ec;                                               % ...edge color
        case {'sphere','sph'}                                                   % sphere
            opt = Option(varargin,'r',0.03,'q',Segment,'fc',[1,0,0],'fa',1,...  % default arguments
                'ec','none');
            if isfield(opt,'in')                                                % if centers provided
                cts = opt.in;
            else
                cts = [0,0,0];                                                  % default centers
            end
            sph = Geometry('sphere','cnt',[0,0,0],'r',opt.radius,'q',opt.q);    % base sphere shape
            for i = 1:size(cts,1)                                               % loop over all centers
                h = surface(sph.x+cts(i,1),sph.y+cts(i,2),sph.z+cts(i,3));      % draws sphere
                h.FaceColor = CData.Get(opt.facecolor,i);                       % applies face color
                h.FaceAlpha = CData.Get(opt.facealpha,i);                       % ...face alpha
                h.EdgeColor = opt.edgecolor;                                    % ...edge color
            end
        case {'cylinder','cyl'}                                                 % cylinder
            opt = Option(varargin,'r',0.1,'q',Segment,'ec','none','cix',...     % default arguments
                [1,1],'fa',1);
            if isfield(opt,'in')                                                % if endpoints provided
                ets = opt.in;
            else
                ets = [0,0,0;1,1,1];                                            % default endpoints
            end
            n = size(ets,1);
            if numel(opt.radius) == 1; opt.radius = zeros(n,1)+2*opt.radius; end  % corrects radius
            if (numel(opt.cix) <= 2) && (n > 2)
                opt.cix = round(Scale(1:n,opt.cix(1),opt.cix(end)));            % corrects color indices
            end
            h = streamtube({ets},{opt.radius},[1,opt.q]);                       % draws cylinder
            h.EdgeColor = opt.edgecolor;                                        % applies edge color
            h.FaceColor = 'interp';                                             % ...color interpolation
            h.CData = repmat(opt.cix,opt.q+1,1)';                               % ...color information
            h.CDataMapping = 'direct';                                          % ...method of color mapping
            h.FaceAlpha = opt.facealpha;                                        % ...face alpha
            ax = h;
        case {'line','lin'}                                                     % line
            opt = Option(varargin,'color','r','lw',2);                          % default arguments
            if isfield(opt,'in')                                                % if lines is provided
                lns = opt.in;
            else
                lns = [0,0,1,1];                                                % default line
            end
            [n,dim] = size(lns);
            dim = dim/2;                                                        % determines dimension
            if dim == 2                                                         % if 2D
                [x,y] = Naned(lns);                                             % transforms lines to x,y
                if RandomColor                                                  % if random colors
                    h = plot(x,y,'-','linewidth',opt.lw);
                    set(h,{'color'},num2cell(rand(n,3),2));
                else                                                            % same color
                    plot(x,y,'linewidth',opt.lw,'color',opt.color);
                end
                if Labels                                                       % if lines' labels
                    text(x(:),y(:),cellstr(Stack(arrayfun(@(i)split(sprintf(... % prints line endpoints
                        '%d.1,%d.2,',i,i),','),1:n,'UniformOutput',false)')));
                    x = nanmean(x);                                             % center of lines
                    y = nanmean(y);
                    text(x,y,arrayfun(@(i)num2str(i),1:length(x),...            % prints line's ID
                        'UniformOutput',false)','color','r');
                end
                if Debug                                                        % if debugging
                    x = cell2mat(arrayfun(@(i)x([i,i+1,i+1,i,i,i+2]),...        % ...draws bounding box of lines
                        1:3:numel(x),'UniformOutput',false));
                    y = cell2mat(arrayfun(@(i)y([i,i,i+1,i+1,i,i+2]),...
                        1:3:numel(y),'UniformOutput',false));
                    hold on;
                    plot(x,y,'b:','LineWidth',1);
                end
                axis image;                                                     % sets data aspect equal
            else                                                                % 3d case
                [x,y,z] = Naned(lns);                                           % transforms lines to x,y,z
                if RandomColor                                                  % if random colors
                    h = plot3(x,y,z,'-','color',opt.color,'linewidth',opt.lw);
                    set(h,{'color'},num2cell(rand(n,3),2));
                else                                                            % same color
                    plot3(x,y,z,'color',opt.color,'linewidth',opt.lw);
                end
                if Labels                                                       % if lines' labels
                    text(x(:),y(:),z(:),cellstr(Stack(arrayfun(@(i)split(...    % prints line endpoints
                        sprintf('%d.1,%d.2,',i,i),','),1:n,'UniformOutput',...
                        false))));
                    x = nanmean(x);                                             % center of lines
                    y = nanmean(y);
                    z = nanmean(z);
                    text(x,y,z,arrayfun(@(i)num2str(i),1:length(x),...          % prints line's ID
                        'UniformOutput',false)','color','r');
                end
            end
        case {'point','pnt'}                                                    % point
            opt = Option(varargin,'r','*','dim','2d','q',Segment,...            % default arguments
                'color',[0,0,0]);
            if isfield(opt,'in')
                pts = opt.in;                                                   % if points provided
            else
                pts = [0,0,0];                                                  % default point
            end
            [n,k] = size(pts);
            if strcmpi(opt.dim,'2d')                                            % 2d requested
                if k == 2                                                       % 2d case
                    if ~isnumeric(opt.radius)                                   % if radius is '*' etc.
                        plot(pts(:,1),pts(:,2),opt.radius,'Color',opt.color);   % uses 'plot'
                    else
                        scatter(pts(:,1),pts(:,2),opt.radius,'filled',...       % uses 'scatter'
                            'MarkerFaceColor',opt.color,'MarkerEdgeColor','r');
                    end
                    if Labels
                        text(pts(:,1),pts(:,2),cellstr(num2str((1:n)')));       % prints points' ID
                    end
                else                                                            % 3d case
                    if ~isnumeric(opt.radius)                                   % if radius is '*' etc.
                        plot3(pts(:,1),pts(:,2),pts(:,3),opt.radius,'Color',... % uses 'plot3'
                            opt.color);
                    else
                        scatter3(pts(:,1),pts(:,2),pts(:,3),opt.radius,...      % uses 'scatter3'
                            'filled','MarkerFaceColor',opt.color);
                    end
                    if Labels                                                   % if true, prints points' ID
                        text(pts(:,1),pts(:,2),pts(:,3),...
                            cellstr(num2str((1:n)')));
                    end
                    Axes('p',5);                                                % expands axes by 5%
                end
            else                                                                % 3d requested
                if k == 2; pts = T3(pts); end                                   % converts to 3D
                Draw('sph',pts,'Color',opt.color,'k',opt.k,'Radius',opt.radius);  % draws spheres
                Axes('p',5);                                                    % expands axes by 5%
            end
        case {'poly','ply'}                                                     % polygon
            opt = Option(varargin,'la',[],'axes',true,'cmap',@jet,'fc',...      % default arguments
                [1,0.7,0.3],'fa',1,'ec','k','lw',1);
            if isfield(opt,'in')
                plys = opt.in;                                                  % if polygons provided
            else
                plys = {0,0,0;0,0,1;1,1,1};                                     % default polygon
            end
            if ~iscell(plys); plys = {plys}; end                                % if single polygon
            n = length(plys);                                                   % number of polygons
            dim = size(plys{1},2);                                              % determines dimension
            if isempty(opt.la); opt.la = ones(n,1); end                         % cluster labels
            if any(opt.la ~= opt.la(1))                                         % if not all labels the same
                cn = numel(unique(opt.la));                                     % cluster count
                cmap = opt.cmap(cn);                                            % initializes colormap
                cmap = cmap(int32(Scale(opt.la,1,cn)),:);                       % updates colormap
            else
                cmap = [];                                                      % no colormap
            end
            hold on;                                                            % prevents from clearing
            for i = 1:n                                                         % loop over all polygons
                ply = plys{i};                                                  % chooses a polygon
                if dim == 2; ply(:,3) = 0; end                                  % 2D -> 3D
                if opt.la(i) < 0                                                % for isolated polygons
                    patch(ply(:,1),ply(:,2),ply(:,3),[0.5,0.5,0.5],...          % draws polygon
                        'FaceAlpha',0.5,'EdgeColor','none');
                else
                    h = patch(ply(:,1),ply(:,2),ply(:,3),0);                    % draws polygon
                    if ~isempty(cmap)
                        h.FaceColor = 'flat';                                   % if colormap exists
                        h.FaceVertexCData = cmap(i,:);                          % applies color information
                    else
                        h.FaceColor = CData.Get(opt.facecolor,i);               % same face color
                        h.FaceAlpha = CData.Get(opt.facealpha,i);               % same face alpha
                    end
                    h.EdgeColor = opt.edgecolor;                                % edge color
                    h.LineWidth = opt.linewidth;                                % edge line width
                end
                if Labels                                                       % if true,
                    [X,Y,Z] = CData.Deal(Center(plys));                         % center of polygons
                    text(X,Y,Z,cellstr(num2str((1:n)')));                       % prints polygons' ID
                end
            end
            if opt.axes                                                         % if true
                bbx = Bbox(plys,'pp');                                          % bounding box of polygons
                if dim == 2
                    Axes('box','2d');                                           % sets 2d axes
                else
                    Axes('box',bbx);                                            % sets 3d axes
                end
            end
        case {'ellipsoid','els'}                                                % ellipsoid
            Geometry('els',varargin{:});                                        % draws ellipsoid
    end
elseif ~isstruct(dfn)                                                           % DFN drawing
    if iscell(dfn)                                                              % 3d polygons
        Draw('ply',dfn,varargin{:});
    else                                                                        % 2d lines
        Draw('lin',dfn,varargin{:});
    end
else                                                                            % integrated visualizations
    opt = Option(varargin,'what','f','r',0.012,'sub',111,'clear',true,...       % default arguments
        'title','','light',[],'cmap',jet);
    Ticot('Drawing');                                                           % initializes timing
    if opt.sub == 0                                                             % if no subplot requested
        clf;                                                                    % clears current figure
    else
        if opt.sub ~= 111; subplot(opt.sub); end                                % setups subplot
        if opt.clear; cla; end                                                  % clears it
    end
    hold on;                                                                    % prevents from clearing
    if contains(opt.what,'f')                                                   % if fractures
        if contains(opt.what,'q') && isfield(dfn.dfn,'xID')                     % 'q':have pipes,
            f = unique([1;Filter(dfn.dfn.xID,2);length(dfn.dfn.Poly)]);         % 'xID':intersection indices
        else
            f = true(length(dfn.dfn.Poly),1);                                   % accepts all fractures
        end
        if contains(opt.what,'x') & isfield(dfn.dfn,'xLine')                   % to draw intersection lines
            Draw('lin',dfn.dfn.xLine);
        end
        Draw('ply',dfn.dfn.Poly(f),...                                          % draws polygons
            'fc',[1,0,0; 0,1,0; zeros(numel(f)-2,3)+0.5],...                    % face color
            'fa',[0.1; 0.1; zeros(numel(f)-2,1)+0.1],...                        % face alpha
            'ec',[0.6,0.6,0.6],'axes',false);                                   % edge color
    end
    rt = 1;                                                                     % radius rate
    if isfield(dfn,'pip')
        p = dfn.pip;
        if contains(opt.what,'p')                                               % if pipes are ready
            for i = 1:size(p.Pipe,1)                                            % pipes
                switch p.Type(i)
                    case 0                                                      % inner pipes
                        cc = [40,40];
                    otherwise                                                   % anything else
                        cc = [1,1];
                end
                Draw('cyl',Reshape(p.Pipe(i,:),[],3),'r',rt*opt.radius,...
                    'cix',cc,'fa',0.5);                                         % draws cylinder
            end
            rt = rt+1;                                                          % adds up the rate
        end
    end
    if isfield(dfn,'bbn')
        p = dfn.bbn;
        if contains(opt.what,'b')                                               % if backbone exists
            typ = dfn.pip.Type(dfn.bbn.B);                                      % backbone types
            for i = 1:size(p.Backbone,1)                                        % backbone
                switch typ(i)
                    case 0                                                      % inner backbone
                        cc = [27,27];
                    otherwise
                        cc = [1,1];                                             % anything else
                end
                Draw('cyl',Reshape(p.Backbone(i,:),[],3),'r',rt*opt.radius,...  % draws cylinder
                    'cix',cc,'fa',0.5);
            end
            rt = rt+1;                                                          % adds up the rate
        end
    end
    if isfield(dfn,'grh')
        g = dfn.grh;
        if contains(opt.what,'g')                                               % if graph is ready
            if contains(opt.what,'n')                                           % if nodes requested
                for i = 1:g.Size(1)                                             % loop over all nodes
                    switch g.Node(i).Type
                        case 0                                                  % inner node
                            fc = 'k';
                        otherwise                                               % anything else
                            fc = 'b';
                    end
                    Draw('sph',g.Node(i).Location,'r',rt*(opt.radius*2),'fc',...
                        fc,'fa',0.3);                                           % draws sphere
                end
            end
            if contains(opt.what,'e')                                           % if edges requested
                for i = 1:g.Size(2)                                             % loop over all edges
                    Draw('cyl',Stack({g.Node([g.Edge(i).Nodes]).Location}),...  % draws cylinder
                        'r',rt*opt.radius,'cix',[25,25],'fa',0.3);
                end
            end
            rt = rt+1;                                                          % adds up the rate
        end
        if contains(opt.what,'s')                                               % solution
            if contains(opt.what,'n')                                           % if nodes requested
                f = true(g.Size(1),1);
                if contains(opt.what,'i')
                    f = f & cellfun(@(egs)any([g.Edge(egs).Type] == 0),...      % filters out non-inner nodes
                        {g.Node.Edges}');
                end
                if contains(opt.what,'q')                                       % filters out non-flow nodes
                    f = f & ~cellfun(@(egs)all(CData.Almost([g.Edge(egs)...
                        .Flow],0)),{g.Node.Edges}');
                end
                Draw('sph',Stack({g.Node(f).Location}),'r',rt*opt.radius,...    % draws sphere
                    'fc',Convert('color',[g.Node(f).Pressure],@jet));
            end
            if contains(opt.what,'e')                                           % if edges requested
                inr = contains(opt.what,'i');                                   % only inner edges?
                flw = contains(opt.what,'q');                                   % only flow edges?
                for i = 1:g.Size(2)                                             % loop over all edges
                    if (inr && (g.Edge(i).Type ~= 0)) ||...
                            (flw && CData.Almost(abs(g.Edge(i).Flow),0))        % if non-inner or non-flow
                        continue
                    end
                    Draw('cyl',Stack({g.Node([g.Edge(i).Nodes]).Location}),...  % draws cylinder
                        'r',rt*opt.radius,'cix',int32(Scale([g.Node(...
                        g.Edge(i).Nodes).Pressure],min(g.BV),max(g.BV),1,64)));
                end
            end
        end
    end
    if opt.clear
        if size(dfn.dfn.Center,2) == 2
            Axes('view','top');                                                 % adjusts for 2d
        elseif isempty(opt.light)                                               % no lights provided
            Axes;                                                               % sets axes
        else
            Axes('light',opt.light);                                            % sets axes and lights
        end
    end
    title(opt.title);                                                           % prints the title
    ax = gca;                                                                   % handle to current axis
    colormap(opt.cmap);                                                         % applies colormap
    Ticot;                                                                      % ends timing
end
