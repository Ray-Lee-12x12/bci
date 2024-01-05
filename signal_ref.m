function [ y_ref ] = signal_ref(freqs_list, fs, Times, Nh)
% signal_ref()负责生成需要的参考信号，供cca和msi评价使用
% @Input:
%   freqs_list: [Nref,1],参考信号频率列表
%   fs: double,采样频率
%   Times:  double,trial中的采样点数
%   Nh: double,指定谐波数,人类一般不会有极高频信号,选择3-5即可
% @Return:
%   y_ref: [Nref, 2Nh, Times],生成的模板信号

    Nref = length(freqs_list);
    tspan = (1:Times)/fs;
    y_ref = zeros([Nref, 2*Nh, Times]);
    for freq_i = 1:1:Nref
        tmp = [];
        for harm_i = 1:1:Nh
            stim_f = freqs_list(freq_i);
            sc = [sin(2*pi*tspan*harm_i*stim_f);...
                  cos(2*pi*tspan*harm_i*stim_f)];
            tmp = cat(1, tmp, sc); % 垂直追加
        end
        y_ref(freq_i, :, :) = tmp;
    end
end