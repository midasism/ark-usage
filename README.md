# 🔥 ark-usage

火山方舟套餐用量一键查询工具。一行命令安装，随时看 Coding Plan / Agent Plan 的 session、周、月用量。

```
╭──────────────────────────────────────────────╮
│  🔥 火山方舟 · 套餐用量                        │
│  你的账号名                                    │
╰──────────────────────────────────────────────╯

  💻 Coding Plan
  ────────────────────────────────────────────
   会话      ████░░░░░░░░░░░░░░░░  23.5%  ↻ 07/03 14:40 [3小时后重置]
   周       ███░░░░░░░░░░░░░░░░░  18.3%  ↻ 07/06 00:00 [2天后重置]
   月       ███████░░░░░░░░░░░░░  35.6%  ↻ 07/09 23:59 [6天后重置]
```

## 一键安装

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/midasism/ark-usage@master/install.sh | bash
```

脚本自动完成：
- ✅ 检测 Node.js
- ✅ 安装 arkcli（火山方舟 CLI）
- ✅ 下载 ark-usage 到 `~/.local/bin`
- ✅ 配置 PATH

首次运行 `ark-usage` 会自动弹出浏览器登录火山方舟，之后每次直接出结果。

## 使用

```bash
ark-usage          # 查看套餐额度（含重置倒计时）
ark-usage -w       # 持续刷新，每 30s（Ctrl+C 退出）
ark-usage -h       # 帮助
```

## 智能检测

每次运行自动检测：
- **arkcli 没装？** → 自动 `npm install -g`
- **没登录？** → 自动弹出浏览器扫码
- **登录过期？** → 自动提示重登

## 支持的套餐

| 套餐 | 周期 |
|------|------|
| Coding Plan 个人版 | session / 周 / 月 |
| Coding Plan 团队版 | session / 周 / 月 |
| Agent Plan 个人版 | 5h / 周 / 月 |
| Agent Plan 团队版 | 5h / 周 / 月 |

## 依赖

- [Node.js](https://nodejs.org)（LTS 版本）
- [arkcli](https://www.volcengine.com/product/ark)（火山方舟 CLI，自动安装）
- `jq`、`bc`（macOS 自带）

## 卸载

```bash
rm ~/.local/bin/ark-usage
npm uninstall -g @volcengine/ark-cli
```

## 常见问题

**Q: 显示"未找到有效订阅套餐"？**
确认已订阅 Coding Plan 或 Agent Plan：[订阅地址](https://console.volcengine.com/ark/region:cn-beijing/plans)

**Q: 百分比很久不变？**
用量数据有 5-30 分钟延迟，正常现象。

**Q: 为什么 Coding Plan 显示"会话"而不是"5h"？**
Coding Plan 的短期周期叫 session（会话），Agent Plan 才有 5h。你订什么就显示什么。

**Q: 登录过期了怎么办？**
下次运行 `ark-usage` 会自动弹出登录页，扫码即可。不需要重装。

**Q: 多账号怎么切换？**
```bash
arkcli profile list
arkcli profile use <profile名>
```

## License

MIT
