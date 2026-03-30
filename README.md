# CubeTimer - 魔方CFOP计时器

SwiftUI + MVVM架构开发的iOS魔方计时器App，专为CFOP方法练习设计。

## ✨ 功能特性

### ⏱️ 计时器
- 精确计时到0.01秒
- 手动记录成绩（点击记录按钮保存）
- 随机打乱生成器（20步，避免连续同面操作）
- 点击打乱步骤即可生成新打乱
- 简洁的操作界面（开始/停止/记录）

### 📚 CFOP公式库
- **110个专业公式**：F2L(41) + OLL(48) + PLL(21)
- 算法来源：[CubeSkills](https://www.cubeskills.com/) 专业PDF
- 分类浏览和学习
- 公式图片演示（130张图片）
- 随时查看公式算法和描述

### 📊 成绩统计
- **PB**（Personal Best）：个人最佳成绩
- **Ao5**：最近5次平均（去掉最高和最低）
- **Ao12**：最近12次平均（去掉最高和最低）
- 按日期或用时排序
- 左滑删除成绩记录

### 🧠 公式练习模式
无需携带实体魔方，随时随地练习CFOP公式：
- **学习模式**：查看公式图片，显示/隐藏算法，标记掌握状态
- **答题模式**：根据魔方状态选择正确的公式（4选1）
- **交互模式**：点击虚拟按钮完成公式操作（R/L/U/D/F/B + 修饰符）

## 🏗️ 项目结构

```
CubeTimer/
├── Models/
│   ├── Formula.swift              # 公式数据模型（F2L/OLL/PLL）
│   ├── CompleteFormulaData.swift  # 110个CFOP公式数据
│   ├── Scramble.swift             # 打乱生成器
│   └── Solve.swift                # 成绩记录模型
│
├── Views/
│   ├── TimerView.swift            # 计时器界面（可点击打乱刷新）
│   ├── FormulaListView.swift      # 公式列表浏览（F2L/OLL/PLL）
│   ├── StatsView.swift            # 成绩统计页面
│   ├── FormulaPracticeView.swift  # 练习模式主视图
│   └── Practice/
│       ├── PracticeModeViews.swift # 学习/答题/交互三种模式视图
│       └── PracticeComponents.swift # 可复用组件
│
├── ViewModels/
│   ├── TimerViewModel.swift       # 计时器业务逻辑
│   └── PracticeViewModel.swift    # 练习模式业务逻辑
│
├── Assets.xcassets/               # 图片资源（按分类组织）
│   ├── F2L/                       # F2L公式图片 (65张)
│   ├── OLL/                       # OLL公式图片 (43张)
│   └── PLL/                       # PLL公式图片 (22张)
│
├── ContentView.swift              # TabView主界面
├── CubeTimerApp.swift             # App入口
└── README.md
```

## 🛠️ 技术栈

- **语言**：Swift 5.0+
- **框架**：SwiftUI
- **架构**：MVVM（Model-View-ViewModel）
- **存储**：UserDefaults
- **最低版本**：iOS 26.0+
- **工具**：Xcode

## 📱 部署到iPhone

### 免费签名方式（7天有效期）

1. **连接设备**
   ```bash
   # 使用USB连接iPhone到Mac
   # 在iPhone上信任此电脑
   ```

2. **Xcode设置**
   - 打开 `CubeTimer.xcodeproj`
   - 选择左侧项目导航器中的项目
   - 选择 "Signing & Capabilities"
   - 勾选 "Automatically manage signing"
   - 选择你的 Apple ID（Team）

3. **修改Bundle Identifier**
   - 将 `com.yourname.CubeTimer` 改为唯一标识符
   - 例如：`com.siyibajiu.CubeTimer`

4. **运行到设备**
   - 顶部选择你的iPhone设备
   - 点击 ▶️ Run按钮
   - 首次运行需要在iPhone上信任开发者证书

5. **保持App可用**
   - 7天后证书过期，需要重新运行Xcode刷新
   - 或使用 [AltStore](https://altstore.io/) 进行侧载

## 📈 统计算法

### Ao5（Average of 5）
```swift
取最近5次成绩，去掉最高和最低，计算平均值
```

### Ao12（Average of 12）
```swift
取最近12次成绩，去掉最高和最低，计算平均值
```

## 🚀 未来计划

- [ ] 成绩趋势图表可视化
- [ ] 云同步功能
- [ ] 自定义打乱长度
- [ ] 分段计时功能
- [ ] iPad适配
- [ ] 更多F2L/OLL/PLL公式变体

## 📄 许可证

MIT License

## 👨‍💻 作者

Siyibajiu - 845196557@qq.com

## 🙏 致谢

- [CubeSkills](https://www.cubeskills.com/) - CFOP公式参考
- Swift社区 - 技术支持
