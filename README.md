# 工作台 Workbench —— 数据仓库（演示）

> 用 **Claude Code 作骨架、MCP 作通道、Skill 作驱动**，解决多人协作项目里
> 「AI 工具与团队配合脱节、项目数据库割裂」的问题。
>
> 本仓库扮演工作台的 **「服务器 / 数据库」**。在还没有自建服务器之前，用 GitHub 模拟：
> 文件即数据、Git 历史即版本、PR 即审批、Issue/Milestone 即团队协作与进度。

---

## 为什么用 GitHub 模拟服务器

| 能力 | GitHub 上的实现 |
|---|---|
| 登录服务器 | GitHub Token（PAT / App）认证 |
| 文件增删改查 | GitHub Contents API（经官方 GitHub MCP 调用） |
| 软删除 | 移动到 `.trash/`；且 Git 历史天然保留所有版本 |
| 权限管理 | GitHub 原生（CODEOWNERS + 分支保护）+ 自定义 [`permissions.yaml`](./permissions.yaml) |
| 拉取项目规范 | 读 [`standards/`](./standards/) |
| 团队配合 / 需求追踪 | **Issues**（需求单） |
| 项目进度 / 交付批次 | **Milestones** |

设计原则：**内容（文档 / 资源）放文件，保持可移植；协作元数据（Issue / Milestone）放 GitHub。**
将来迁到自建服务器时，内容平滑迁移，协作层单独重建即可。

---

## 目录结构（仓库即数据库）

```
workbench-data/
├─ standards/            # 项目规范（skill 出稿前对照）
├─ knowledge/            # 知识库（策划/原画 查这里）
├─ permissions.yaml      # 自定义角色权限表
├─ .github/
│  ├─ CODEOWNERS         # 由角色表生成，配合分支保护强制审批
│  └─ ISSUE_TEMPLATE/    # 三套需求模板：策划案 / 交互稿 / 原画
├─ documents/
│  ├─ pending/           # 待定文档（已入库、可查、等审批）
│  └─ published/         # 正式文档（已定稿）
├─ assets/
│  ├─ interaction/       # 交互稿（线稿 + 图 / HTML）
│  └─ concept-art/       # 原画
├─ .trash/               # 软删除归档
└─ scripts/              # 标签 / 里程碑初始化脚本
```

---

## 完整协作流程

整条链把 **需求 → 工作 → 产出 → 审批 → 进度** 串成一体，全程可追溯：

```
①立项 skill   口述/模糊需求 → 查知识库+规范 → 澄清反问 → 建结构化 Issue（选模板：策划/交互/原画）
                                                              │
                                                              ▼  进入「需求池」(open issues)，挂 Milestone
②执行 skill   认领 Issue → 查知识库/规范 → 产出草稿 → 确认 → 提交到 pending/（label: 待审核）
                                                              │
                                                              ▼
③审批         开晋级 PR（Closes #Issue，CODEOWNERS 指定审核人）→ reviewer 合并
                                                              │
                                                              ▼  进 published/ → Issue 自动关闭 → Milestone 进度 +1
```

- **第 0 环「立项」**：提需求本身就是流程一环，由独立 skill 把模糊想法澄清成结构化 Issue，
  天然支持「需求方 ≠ 执行方」。
- **待定可查 + PR 定稿**：待定稿直接进 `documents/pending/`（团队可查），晋级 PR 合并后才进 `published/`。
- **硬约束**：靠 `CODEOWNERS` + 分支保护，没有审核人批准就合并不了——光靠 skill 校验是能绕过的。

---

## 三个执行 Skill

| Skill | 输入（Issue） | 产出 | 落库位置 |
|---|---|---|---|
| 策划案 | 背景 / 目标 / 关联知识 | 结合知识库的文档 | `documents/` |
| 交互稿 | 参考文档 / 范围 / 风格 | 线稿 → 图 / HTML | `assets/interaction/` |
| 原画 | 题材 / 风格 / 构图 | 调文生图 MCP 出图 | `assets/concept-art/` |

> 「确认需求 / 明确需求」这段被统一抽到 **立项 skill**，三个执行 skill 因此只专注产出，逻辑不重复。

---

## 权限模型

见 [`permissions.yaml`](./permissions.yaml)。角色：`planner` 策划 / `artist` 美术 / `reviewer` 审核 / `admin` 管理员。

- GitHub 原生权限管「谁能进、谁能合并」；
- `permissions.yaml` 管「进来后能动哪个目录、能做什么」，由 skill 执行前校验。

---

## 状态约定（Issue 标签）

- 类型：`策划案` `交互稿` `原画`
- 状态：`待处理` → `生成中` → `待审核` → `已定稿`

初始化标签与示例里程碑：

```bash
bash scripts/setup-labels-milestones.sh guaner-334/workbench-data
```

---

> 这是演示骨架。接入方式：在 Claude Code 里挂官方 GitHub MCP，由各 Skill 驱动本仓库读写。
