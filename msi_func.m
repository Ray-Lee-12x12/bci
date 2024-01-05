function S = msi_func(X, Y)
% msi_func()用于计算两组数据间的S-estimation,服务于msi算法
% @Input:
%   X: [ch, Time], trial数据
%   Y: [2Nh, Time], 特定参考频率的模板矩阵
% @Return:
%   S: double, 两组数据的相关性评分, 采用S-estimation

    % 获取通道数ch,采样点数Times,谐波数Nh
    [ch, Time] = size(X);
    [c, ~] = size(Y);
    Nh = c/2;

    % 构建C矩阵
    c11 = X*(X.'); % [ch, ch]
    c12 = X*(Y.'); % [ch, 2Nh]
    c21 = Y*(X.'); % [2Nh, ch]
    c22 = Y*(Y.'); % [2Nh, 2Nh]
    
    C = [c11, c12; c21, c22];
    C = C./Time; % [ch+2Nh]
    
    % 构建U矩阵
    % 由于c11和c22一定是对称矩阵,所以对角化还原用的是V*A*V.'
    [V, D] = eig(c11);
    c11_s = V*(sqrt(D^-1))*(V.');
    [V, D] = eig(c22);
    c22_s = V*(sqrt(D^-1))*(V.');

    U = [c11_s, zeros(size(c12)); zeros(size(c21)), c22_s]; %[ch+2Nh,ch+2Nh]
    
    % 计算R矩阵
    R = U*C*(U.'); % [ch+2Nh, ch+2Nh]
    
    % 计算S评分
    [~, D] = eig(R);
    D = diag(D); % [ch+2Nh, 1]
    Lamda = D/trace(R); % [ch+2Nh, 1]
    P = ch + 2*Nh;
    S = 1+sum(Lamda.*log2(Lamda))/log2(P);
end