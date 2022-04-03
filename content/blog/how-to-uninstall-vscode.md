---
title: "How to Uninstall VS Code"
img_url: how.png
img_alt: "Visual Studio Code being replaced with Neovim"
date: "2022-03-25"
seo_description: "How I Replaced VS Code with NeoVim (for JS Development)"
tags: ["neovim", "vscode", "vim"]
summary: How to replace Visual Studio Code with Neovim.
hidden: true
---
# How to Uninstall Visual Studio Code

*Or: How I Use Vim As A JavaScript Developer*

I've spent most of this year trying to convince my colleagues to ditch the wildly popular Visual Studio Code, and instead use Vim - the almost XXXX year old text editor that comes pre-installed on every UNIX machine.

My success rate has been higher than I expected, but I still can't quite pin down an elevator pitch for making the jump to full Vim. The best I can do is appeal to the romanticism of the tool, or with a 

*Visual Studio Code* is the sandwich you bought at the shop.
~~*Vim*~~ is the sandwich you made at home.
If you didn't put any love into it, you'll probably wish you went with the pre-made option.
But if you get it right, writing in Vim can be a breath of fresh air.

It feels almost natrual - how humans and machines were meant to communicate.

It's better for reasons that are hard to put into words, leading to much skepticism amongst the unconvinced.
This is something unusual for software engineers - I can't show you to prove this is the way.

I regard myself as a vim purist. For me, a big part of the Vim magic is ssh-ing into that 30 year old server or booting up a raspberry pi and feeling just at home as you would on your personal machine. I feel rebinding keys and having more lines in your vimrc than you can recall off-by-heart takes away from this experience - but sadly this isn't realistic if we are to compete with the Industry-Backed Full-Browser IDE-likes.

## Plugins, or How I Learned to Stop Worrying and Love the Bloat

The first few times I attempted to replace VS Code with Vim, I adamantly refused to install any plugins.

Like the developer downloading JQuery at the drop of a hat, I zealously shunned any notion of extending Vim with any functionality the preinstalled application didn't ship with.

*"There's no point turning Vim into VS Code, the point is to **use** Vim."* I'd think, as I struggled to remember the pathname to that one css file 10-folders deep in the project tree.

I've since come to admit defeat and have been proven entirely wrong. So here is my can't-live-without-it list of plugins that I've begrudgingly installed and allowed to stay.

 To get that VS Code Sidebar functionality you've come to live without
  use 'tpope/vim-fugitive'

For thee
  use 'neovim/nvim-lspconfig'

  use 'tpope/vim-commentary'

  use 'hrsh7th/nvim-cmp'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  use 'elixir-editors/vim-elixir'

### The plugin manager
  use 'wbthomason/packer.nvim'


## Was Vim bloated all along?

I mean, it __does__ have a lot of hotkeys.

## Microsoft Giveth, Microsoft Taketh Away

Is ditching vscode a solid idea even?

