%% Demo
% demonstrations of ADFNE1.5 package
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
%
% -- important note
% The results of this file are reported in the file "DFNE Practices with ADFNE".
% By setting the Matlab's "rng" function explicitly as below, you should be able to
% reproduce exactly the same results as in the book.
% REMEMBER: Remove the "rng(1234567890);" to allow random setups.

Globals;                                                                        % globals stuff
rng(1234567890);                                                                % for reproducibility purpose
switch 3
    case 1                                                                      % 2D DFN
        Draw('lin',Field(DFN,'Line'));
        Export(gcf,'dfn_2d_adfne1.5.png');
    case 2                                                                      % 2D DFN, Full, Sets
        set1 = Field(DFN('dim',2,'n',200,'dir',45,'ddir',-1e9,'minl',0.05,...
            'mu',0.07,'maxl',0.1,'bbx',[0,0,1,1]),'Line');
        set2 = Field(DFN('dim',2,'n',100,'dir',135,'ddir',-1e9,'minl',0.1,...
            'mu',0.3,'maxl',0.5,'bbx',[0.2,0.2,0.8,0.8]),'Line');
        Draw('lin',[set1;set2]);
        Export(gcf,'dfn_2d_sets_adfne1.5.png');
    case 3                                                                      % 2D DFN, Conditioned
        fnm = Field(DFN('dim',2,'n',100,'minl',0.02,'mu',0.2,'maxl',0.3,...
            'bbx',[0,0,1,1],'asep',0.1,'dsep',0.001,'mit',100),'Line');
        Draw('lin',fnm);
        Export(gcf,'dfn_2d_cnd_adfne1.5.png');
    case 4                                                                      % 3D DFN
        Draw('ply',Field(DFN('dim',3),'Poly'));
        Export(gcf,'dfn_3d_adfne1.5.png');
    case 5                                                                      % 3D DFN, Full, Sets
        set1 = Field(DFN('dim',3,'n',100,'dir',15,'ddir',-1e9,'minl',0.05,...
            'mu',0.1,'maxl',0.5,'bbx',[0,0,0,1,1,1],'dip',45,'ddip',-1e7),'Poly');
        set2 = Field(DFN('dim',3,'n',100,'dir',210,'ddir',-1e9,'minl',0.05,...
            'mu',0.1,'maxl',0.5,'bbx',[0,0,0,1,1,0.5],'dip',45,'ddip',-1e7,...
            'shape','e','q',4),'Poly');
        Draw('ply',[set1;set2]);
        Export(gcf,'dfn_3d_sets_adfne1.5.png');
    case 6                                                                      % 3D DFN, Large
        fnm = Field(DFN('dim',3,'n',10000,'dir',180,'ddir',10,'minl',0.02,...
            'mu',0.05,'maxl',0.15,'bbx',[0,0,0,1,1,1],'dip',45,'ddip',10),'Poly');
        Draw('ply',fnm);
        Export(gcf,'dfn_3d_large_adfne1.5.png');
    case 7                                                                      % 2D Flow, BC:noflow
        fnm = Field(DFN,'Line');
        be = [Line.Left;Line.Right];                                            % BE:{left+right,else:noflow}
        %dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve([1,0]);                 % solution (pressure+)
        dfn = Solve(Graph(Backbone(Pipe(be,fnm,'cnt'))),[1,0]);                 % ...R2015a
        Draw(dfn,'what','seniq');                                               % draws solution (clean)
        Export(gcf,'dfn_2d_pressure_adfne1.5.png');
    case 8                                                                      % 2D Flow, BC:linear
        fnm = Field(DFN,'Line');
        be = [Line.Left;Line.Right;Line.Top;Line.Bottom]; 						% BE:{left+right,else:linear}
        %dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve([1,0,nan,nan]);         % solution (pressure+)
        dfn = Solve(Graph(Backbone(Pipe(be,fnm,'cnt'))),[1,0,nan,nan]);         % ...R2015a
        Draw(dfn,'what','seniq','light',[0.5,2,2]); 							% draws solution (clean)
        Export(gcf,'dfn_2d_pressure_lin_adfne1.5.png');
    case 9                                                                      % 3D Flow, BC:{left+right}
        fnm = Field(DFN('dim',3,'n',200),'Poly');
        be = {Poly.Left;Poly.Right};                                            % BE
        %dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve([1,0]);                 % solution (pressure+)
        dfn = Solve(Graph(Backbone(Pipe(be,fnm,'cnt'))),[1,0]);                 % ...R2015a
        Draw(dfn,'what','seniq');
        Export(gcf,'dfn_3d_pressure_adfne1.5.png');
    case 10                                                                     % Geostatistics
        n = 150;
        [x,y] = meshgrid(1:n,1:n); w = peaks(n);                                % map with spatial correlation
        x = x(:); y = y(:); w = w(:); nn = randperm(n*n); f = nn(1:2*n);        % random sampling
        x = x(f); y = y(f); w = w(f);
        clf;
        subplot(231); scatter(x,y,30,w,'filled'); Axes(2,'p',5); title('data'); % sample data
        subplot(232); [d,g,v] = Variocloud([x,y],w,[],true);                    % variocloud
        subplot(233); Variogram(d,g,3,v,true);                                  % variogram
        subplot(234);                                                           % variomodels
        Variomodel({'name','sph','nugget',0,'sill',4,'range',40},...            % spherical model
            0:0.5*max(d),true); hold on
        Variomodel({'name','exp','nugget',0,'sill',4,'range',40},...            % exponential model
            0:0.5*max(d),true);
        Variomodel({'name','lin','nugget',0,'slope',0.1},...                    % linear model
            0:0.5*max(d),true);
        subplot(235);
        [krg,err] = Kriging([x,y],w,d,{'name','sph','nugget',0,'sill',4,...     % 2d kriging estimates & errors
            'range',50},[50,50],true);
        subplot(236);
        xyz = [x,y,Scale(rand(size(x)),0,150)];                                 % making 3d data
        [krg3,err3] = Kriging(xyz,w,d,{'name','sph','nugget',0,'sill',4,...     % 3d kriging estimates & errors
            'range',50},[20,20,20],true);
        Export(gcf,'geostatistics_adfne1.5.png');
    case 11                                                                     % Upscaling
        in = abs(peaks(2^5));
        subplot(221); imagesc(in); axis image                                   % original data
        subplot(222); imagesc(Upscaling(in,'a',2)); axis image; title('a');     % arithmetic
        subplot(223); imagesc(Upscaling(in,'h',2)); axis image; title('h');     % harmonic
        subplot(224); imagesc(Upscaling(in,'g',2)); axis image; title('g');     % geometric
        Export(gcf,'upscaling_ahg_adfne1.5.png');
    case 12                                                                     % Tensor
        % will be in the next update, see Preface in the book for details.
    case 13                                                                     % 3D DFN model, other way
        set1 = CData.Array(Rotate(Scale(Poly.Back,'ply',0.3),'y',0,'mov',...
            [0,0,0]),Scale(rand(30,3),0.1,0.9));
        set2 = CData.Array(Rotate(Scale(Poly.Left,'ply',0.3),'y',45,'mov',...
            [0,0,0]),Scale(rand(30,3),0.1,0.9));
        fnm = [set1;set2];                                                      % combined
        clf; Draw('ply',fnm,'axes',false);
        Axes;
        Export(gcf,'dfn_3d_other_adfne1.5.png');
    case 14                                                                     % 2D DFN, medium
        fnm = Field(DFN('dim',2,'n',500),'Line');
        be = [Line.Left;Line.Right];
        %dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve([1,0]);
        dfn = Solve(Graph(Backbone(Pipe(be,fnm,'cnt'))),[1,0]);                 % ...R2015a
        Draw(dfn,'what','seniq','r',0.005);
        Export(gcf,'flow_2d_500_adfne1.5.png');
    case 15                                                                     % 3D DFN, medium
        fnm = Field(DFN('dim',3,'n',200),'Poly');
        be = {Poly.Left;Poly.Right};
        %dfn = CPipe(be,fnm,'cnt').Backbone.Graph.Solve([1,0]);
        dfn = Solve(Graph(Backbone(Pipe(be,fnm,'cnt'))),[1,0]);                 % ...R2015a
        Draw(dfn,'what','seniq','r',0.007);
        Export(gcf,'flow_3d_500_adfne1.5.png');
    case 16                                                                     % 3D DFN, Pipe (hybrid)
        % will be in the next update, see Preface in the book for details.
    case 17                                                                     % Stereonet diagram
        fnm = Field(DFN('dim',3,'n',200),'Poly');
        o = Orientation(fnm);
        Stereonet([o.Dip],[o.Dir],'density',true,'marker','*','ndip',6,...
            'ndir',24,'cmap',@jet,'color','r');
        Export(gcf,'stereonet_adfne1.5.png');
    case 18                                                                     % misc
        clf;
        Draw('ply',Poly.Left,'fc','r','axes',false,'fa',0.3);
        Draw('ply',Poly.Right,'fc','b','axes',false,'fa',0.3);
        Draw('cyl',[-1,0.5,0.5;-0.501,0.5,0.5;-0.5,0.5,0.5;0,0.5,0.5],...
            'r',[0.05,0.05,0.2,0],'cix',[50,50,50,50]);
        Draw('cyl',[1,0.5,0.5;1.5,0.5,0.5;1.501,0.5,0.5;2,0.5,0.5],'r',...
            [0.05,0.05,0.2,0],'cix',[10,10,10,10]);
        Axes; grid off; axis off
    case 19                                                                     % misc:clusters
        fnm = Field(DFN('dim',3,'n',200,'dir',180,'ddir',-1e-7,'minl',0.05,...
            'mu',0.15,'maxl',0.5,'bbx',[0,0,0,1,1,1],'dip',45,'ddip',-1e-7),'Poly');
        [~,ids,La] = Intersect(fnm);
        Ra = Relabel(La);
        colors = Convert('color',1:max(Ra));
        for i = 1:max(Ra)
            Draw('ply',fnm(Ra == i),'axes',false,'fc',colors(i,:));             % colorized based on cluster size
        end
        Axes;
end
