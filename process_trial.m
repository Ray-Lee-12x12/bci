function tbl = process_trial(trial, method, config)
% process_trial()处理一个trial数据,得到和参考频率的相似度评价表格,另外处理过程中对trial做了降采样和滤波
% @Input:
%   trial: [ch, Times],一组trial数据
%   method: str in {'msi', 'cca'},枚举字符串,指定相似度评价方法
%   config: struct(), 配置项, 具体定义见get_config()
% @Return:
%   tbl：table() 相似度评价表格
%       f: 参考频率
%       chars: 字符
%       label: 标签值
%       score: 相似度评分

    % 初始化
    fs = config.fs;
    stop_filter = config.stop_filter;
    bond_filter = config.bond_filter;
    fref = config.fref;
    [channels, ~] = size(trial);
    % 对trial的数据降采样、去除工频噪声、带通滤波
    buffer = [];
    for ch=1:channels
        t1 = downsample(trial(ch,:),4);
        t2 = filtfilt(stop_filter, t1);
        t3 = filtfilt(bond_filter.b, bond_filter.a, t2);
        buffer(:,ch) = t3;
    end
    buffer = buffer.'; % [ch, times]
    [~, Times] = size(buffer);
    % 获取参考信号
    y_ref = signal_ref(fref, fs, Times, config.Nh); % [Nref, 2Nh, Time]
    % 与参考频率模板逐个比较,计算相关系数
    [Nh2, ~, ~] = size(y_ref);
    score = zeros([Nh2,1]);
    for i=1:Nh2
        template = y_ref(i,:,:);
        template = squeeze(template);
        if strcmp(method, 'msi')
            S = msi_func(buffer, template);
            score(i) = S;
        elseif strcmp(method, 'cca')
            [~, ~, r] = canoncorr(buffer.', template.');
            score(i) = r(1,1);
        end
    end
    % 综合结果表格
    tbl = table();
    tbl.f = fref.';
    tbl.score = score;
    tbl.label = config.label.';
    tbl.chars = config.chars.';
end