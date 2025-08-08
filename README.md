数据集是kaggle.com/datasets/caesarmario/our-world-in-data-covid19-dataset（由于数据量太大只筛选了2020年9月份到2021年4月份的数据，选了前三个地区总共727条数据）
遇到csv文件导入到mysql中遇到截断（truncated,数据超过了mysql允许的位数）问题可以先把数据都设置成text类型，导入成功后在数据库再修改数据类型
注意计算指标的时候，不推荐用text类型，建议直接更改为数值型或用cast进行转化：CAST(expression AS target_data_type)
数据可视化部分用到的数据表并不完全是sql_results中的结果，Tableau具体用到的数据查看视图
折线图部分需要创建计算字段平均感染率：AVG([Total Cases])/AVG([Population])*100
地图部分观测不到Aruba是因为面积太小了
