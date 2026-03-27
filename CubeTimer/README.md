# CubeTimer - 魔方CFOP计时器

SwiftUI开发的iOS魔方计时器App，包含CFOP公式学习功能。

## 功能

- ✅ 计时器：精确到百分之一秒
- ✅ 打乱生成器：随机生成打乱步骤
- ✅ CFOP公式库：Cross/F2L/OLL/PLL分类
- 🚧 成绩统计：开发中

## 项目结构

```
CubeTimer/
├── Models/           # 数据模型
├── Views/            # 视图
├── ViewModels/       # 视图模型
└── Resources/        # 资源文件
```

## 如何在Xcode中运行

1. 打开Xcode
2. 创建新项目：File → New → Project
3. 选择 "App" 模板
4. 填写信息：
   - Product Name: `CubeTimer`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - 保存位置：选择当前目录的父目录
5. 删除Xcode自动生成的模板文件
6. 将项目中的所有Swift文件拖入Xcode项目
7. 连接iPhone，点击Run按钮

## 下一步开发

- [ ] 添加更多CFOP公式数据
- [ ] 实现成绩统计和图表
- [ ] 添加公式动画演示
- [ ] 优化UI设计
