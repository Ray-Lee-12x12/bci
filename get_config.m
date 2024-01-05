function config = get_config()
% get_config()获取一些常对象，在整个程序运行期间不会修改的配置
% @Return:
%   config struct() 配置项
%       fs: double,指定的采样率,笔者降采样为250Hz
%       Nh: double,参考频率信号的谐波个数
%       fref: [1,Nref]参考频率列表
%       chars: [1,Nref]参考频率对应的字符
%       label: [1,Nref]字符对应的标签值
%       stop_filter: desinfilter,50Hz工频噪声的陷波滤波器
%       bond_filter: struct{b, a},生成的带通滤波器

    config = struct();
    fs = 250; % 降采样后采样频率
    % 陷波滤波器，工频噪声50Hz
    stop_filter = designfilt('bandstopiir','FilterOrder',8, ...                              
                             'PassBandFrequency1',40, ...
                             'PassBandFrequency2',60, ...
                             'PassBandRipple', 0.0001, ...
                             'StopbandAttenuation',65,...
                             'DesignMethod','ellip','SampleRate',fs);
    % 带通滤波器
    Wp = [7/fs*2, 90/fs*2]; % 7, 90
    Ws = [4/fs*2, 100/fs*2]; % 4, 100
    [N, Wn]=cheb1ord(Wp, Ws, 0.1, 60); % 3, 60
    [b, a] = cheby1(N, 0.1, Wn); % 0.5
    bond_filter = struct('b',b,'a',a);
    
    % 参考频率
    fref = [8,    8.3,  8.6,   8.9,    9.2,...
            9.5,  9.8,  10.1,  10.4,   10.7,...
            11,   11.3, 11.6,  11.9,   12.2,...
            12.5, 12.8, 13.1,  13.4,   13.7];
    chars = ['(', ')', '.', '%', '<',...
             '7', '8', '9', '+', '÷',...
             '4', '5', '6', '-', '×',...
             '1', '2', '3', '0', '='];
    label = 1:20;

    config.Nh = 3;
    config.stop_filter = stop_filter;
    config.bond_filter = bond_filter;
    config.fs = 250;
    config.fref = fref;
    config.chars = chars;
    config.label = label;
end