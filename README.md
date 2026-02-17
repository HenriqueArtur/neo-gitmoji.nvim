<div align="center">
 <a href="https://gitmoji.dev">
  <img src="https://cloud.githubusercontent.com/assets/7629661/20073135/4e3db2c2-a52b-11e6-85e1-661a8212045a.gif" width="456" alt="gitmoji">
 </a>
</div>
<div align="center">
  <a href="https://dotfyle.com/plugins/HenriqueArtur/neo-gitmoji.nvim">
    <img src="https://dotfyle.com/plugins/HenriqueArtur/neo-gitmoji.nvim/shield" />
  </a>
  <a href="https://gitmoji.dev">
    <img
      src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square"
      alt="Gitmoji"
    />
  </a>
</div>

# 🔭 Neo gitmoji

A Telescope integration for [gitmoji](https://gitmoji.dev/).

<!-- <video-link> -->

<!--toc:start-->
- [🔭 Neo gitmoji](#🔭-neo-gitmoji)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Commit history](#commit-history)
    - [Customize a keymap](#customize-a-keymap)
<!--toc:end-->

## Installation

Install the plugin with your preferred package manager:

<details>
  <summary>lazy.nvim</summary>

```lua
{
    'HenriqueArtur/neo-gitmoji.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'},
    opts = {}
}
```

</details>

<details>
  <summary>Packer</summary>

```lua
require("packer").startup(function()
  use({
    'HenriqueArtur/neo-gitmoji.nvim',
    config = function()
        require("neo-gitmoji").setup()
    end,
    requires = { {'nvim-telescope/telescope.nvim'} }
  })
end)
```

</details>

<details>
  <summary>vim-plug</summary>

```vim
Plug 'HenriqueArtur/neo-gitmoji.nvim'
Plug 'nvim-telescope/telescope.nvim'
lua << EOF
require("neo-gitmoji").setup()
EOF
```

</details>

## Usage

You can open floating menu with `<leader>gm` or using `:NeoGitmoji`

### Commit history

The last 5 commit messages are stored per session. While typing in the commit input, use:

| Key | Action |
|-----|--------|
| `<Up>` | Navigate to a previous commit message |
| `<Down>` | Navigate to a newer commit message |

Pressing `<Down>` after navigating restores whatever you had typed before browsing the history.

### Customize a keymap

```lua
local floating_menu = require("neo-gitmoji").open_floating
vim.keymap.set('n', '<your-keymap>', function() floating_menu() end, {})
```
