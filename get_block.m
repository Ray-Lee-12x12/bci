function blk = get_block(file)
% get_block()用于从文件读取出一个block的数据以及一些基本信息,去除了肌电伪迹（通道8）
% @Input:
%   file: path(string),用于指定ssvep数据文件的位置
% @Return:
%   blk: struct()
%       se_tbl: table,记录了每个trial的起点和终点,[trials, 2],s是起点,e是终点
%       data: [ch, Times],raw data,去除了肌电伪迹

    data = load(file, 'data');
    data = data.data;
    
    ch = data(11,:).';
    ch_tbl = table();
    ch_tbl.t = find(ch ~= 0);
    ch_tbl.val = ch(ch_tbl.t);
    
    se_tbl = table();
    se_tbl.s = ch_tbl{ch_tbl.val == 1, 't'};
    se_tbl.e = ch_tbl{ch_tbl.val == 241, 't'};

    blk = struct();
    blk.se_tbl = se_tbl;
    blk.data = data; % [ch, Times]

    blk.data(8,:) = []; % 去除肌电伪迹
end

