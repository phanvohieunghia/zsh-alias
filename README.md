# zsh-aliases 🚀

Bộ sưu tập alias cho macOS / zsh — tổ chức theo **tool** và **role**, cài đặt linh hoạt.

---

## Cài đặt nhanh

```zsh
git clone https://github.com/phanvohieunghia/zsh-aliases ~/zsh-alias
cd ~/zsh-alias
zsh install.zsh
```

Bạn sẽ thấy menu tương tác để chọn bộ nào muốn cài.

---

## Cách dùng installer

```zsh
zsh install.zsh           # Menu chọn từng bộ
zsh install.zsh --all     # Cài tất cả ngay
zsh install.zsh --list    # Xem danh sách & trạng thái
```

---

## Các bộ alias

### 🔧 Tools

| ID         | Mô tả                                           |
| ---------- | ----------------------------------------------- |
| `git`      | Git shortcuts, gpr (mở PR), gclean, gwip...     |
| `npm`      | npm / yarn / pnpm, auto-detect package manager  |
| `macos`    | Navigation, killport, network, Finder, serve... |
| `ssh-tmux` | SSH key gen/copy, tmux sessions, tdev layout    |

### 👤 Roles

| ID         | Mô tả                                                     |
| ---------- | --------------------------------------------------------- |
| `frontend` | Vite, React, Next, Vitest, Cypress, ESLint, Lighthouse    |
| `backend`  | Node/nvm, Python/venv, PostgreSQL, Redis, MongoDB, curl   |
| `devops`   | Docker, Docker Compose, Terraform, AWS CLI, gh CLI, nginx |

---

## Cấu trúc project

```
zsh-aliases/
├── install.zsh              ← Installer tương tác
├── README.md
├── tools/
│   ├── git/aliases.zsh
│   ├── npm/aliases.zsh
│   ├── macos/aliases.zsh
│   └── ssh-tmux/aliases.zsh
└── roles/
    ├── frontend/aliases.zsh
    ├── backend/aliases.zsh
    └── devops/aliases.zsh
```

---

## Cách hoạt động

`install.zsh` sẽ inject từng bộ vào `~/.zshrc` theo dạng:

```zsh
# >>> zsh-aliases:git
# Git shortcuts & PR opener
# Injected: 2026-04-16 10:00:00
source "/Users/you/zsh-aliases/tools/git/aliases.zsh"
# <<< zsh-aliases:git <<<
```

Mỗi bộ có marker riêng nên có thể cài / ghi đè độc lập.  
Luôn backup `~/.zshrc` trước khi thay đổi.

---

## Thêm bộ alias mới

1. Tạo file: `tools/<tên>/aliases.zsh` hoặc `roles/<tên>/aliases.zsh`
2. Thêm entry vào mảng `BUNDLES` trong `install.zsh`:

```zsh
"myalias|Mô tả ngắn|🔧 Tools|tools/myalias/aliases.zsh"
```

3. Chạy lại `zsh install.zsh`

---

## Cập nhật

```zsh
cd ~/zsh-aliases
git pull
zsh install.zsh      # hỏi xác nhận từng bộ đã cài trước
```
