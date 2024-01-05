function tbl_answer = bench_block(blk, config, method)
% bench_block()是对整个block数据做相似度评价
% @Input:
%   blk: struct(), 包含一个block的数据和相关的信息,具体见get_block()
%   config: struct()，包含滤波器、参考频率等不改变的信息,具体见get_config()
%   method: string in {'msi', 'cca'}, 评分选择算法
% @Return:
%   tbl_answer: 表格,[num, 3],其中num是trial的个数,包含频率、字符和标签值

    [n, ~] = size(blk.se_tbl);
    tbl_answer = table('VariableNames',{'f','chars','label'},'Size',[n,3],...
                       'VariableTypes', ["double", "string", "double"]);
   
    for i=1:n
        trial = get_trial(blk, i);
        tbl = process_trial(trial, method, config);
        answer = tbl(tbl.score == max(tbl.score), {'f','chars','label'});
        tbl_answer(i, :) = answer;
    end
end