%% 初始化
clc;
clear;
close;
ssvep_files = [
    "data/S1/block1.mat", "data/S1/block2.mat",...
    "data/S2/block1.mat", "data/S2/block2.mat",...
    "data/S3/block1.mat", "data/S3/block2.mat",...
    "data/S4/block1.mat", "data/S4/block2.mat",...
    "data/S5/block1.mat", "data/S5/block2.mat",...
];

config = get_config();
%% 无训练辨识ssvep
names = ["S1block1", "S1block2", "S2block1", "S2block2",...
         "S3block1", "S3block2", "S4block1", "S4block2",...
         "S5block1", "S5block2"];
types = [];
for i=1:10
    types = [types, "double"];
end
csv_tbl = table('VariableNames',names, 'Size', [22, 10], 'VariableTypes', types);
for i=1:length(ssvep_files)
    blk = get_block(ssvep_files(i));
    blk_answer = bench_block(blk, config, 'msi');
    csv_tbl{:, names(i)} = blk_answer.label;
end
%% 保存文件
% writetable(csv_tbl, "U202014939_李思宇.csv","WriteVariableNames", true);
%% 读取gt
real_s1 = readtable("real_labels.xlsx");
%% 测试错误率
my_s1 = csv_tbl(:, 1:2);
% my_s1 = readtable("U202014939_李思宇.csv");
fail = 0;
wrong = [];
gt = [];
for b=1:2
    for t=1:22
        if my_s1{t, b} ~= real_s1{t, b}
            fail = fail + 1;
            disp(string(b) + ","+string(t));
%             disp(join([string(my_s1{t,b}), string(real_s1{t,b})]));
        end
    end
end

disp("err:"+string(fail)+"/44"+","+ "rate:"+string(1-fail/(b*t)));
%%
function plots(trial)
    fig = figure(1);
    for i=1:9
        subplot(3,3,i);
        plot(trial(i,:));
    end
end