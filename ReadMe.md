## 主入口
main.m是项目的主入口

## 数据IO
get_block.m是获取一个block数据的函数
get_config.m是获取一些全局不再更改的配置项
get_trial.m是从一个block中获取一个trial的数据

## 模板生成
signal_ref.m是用于生成参考信号的函数

## 计算处理
process_trial.m是处理一个trial的主函数，得到相似度评分，可以选择msi或者cca
msi_func.m是计算msi的S-estimator的函数
bench_block.m是测试函数，获得对一个block的数据的频率识别