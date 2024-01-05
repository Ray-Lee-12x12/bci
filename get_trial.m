function trial = get_trial(blk, id)
% get_trial()从block获取一个trial的数据,注意做了基线校正
% @Input:
%   blk: struct(),表示一个block的读取出的raw data,具体定义见get_block()
%   id: double,表示第id个trial,本项目中id=1...22
% @Return:
%   trial: [ch, Times], 一个trial的数据(经过基线校正)

    se_tbl = blk.se_tbl;
    data = blk.data;
    tspan = se_tbl.s(id):se_tbl.e(id);
    [channels, ~] = size(data);
    trial = data(1:channels-1, tspan);
    start = se_tbl.s(id);
    baseline = mean(data(1:channels-1, (start - 100):start), 2); % 收集前100ms的均值作为基线
    trial = trial - baseline; % 基线校正
end