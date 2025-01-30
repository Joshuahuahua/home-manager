{ config, pkgs, ... }:
let
  supermaven-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "supermaven-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "supermaven-inc";
      repo = "supermaven-nvim";
      rev = "aecec7090f1da456ad5683f5c6c3640c2a745dc1";
      hash = "sha256-dYsu16uNsbZzI7QhXV3QBkvJy+0MndfGwcb1zQi5ic0=";
    };
  };
  sonarlint-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "sonarlint.nvim";
    src = pkgs.fetchFromGitLab {
      owner = "schrieveslaach";
      repo = "sonarlint.nvim";
      rev = "818f5b932b25df2b6395b40e59d975070f517af7";
      hash = "sha256-gkqt4rsH9VOy4JOWmcc65z70qejkCCaB7iKXRwIKeAY=";
    };
  };
  csvview-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "csvview-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "hat0uma";
      repo = "csvview.nvim";
      rev = "d9bd2efedb028bdb818fd18d1f3db9e0a1d01867";
      hash = "sha256-eI/Ck1ZxN3asp8VmoTzYWNtJX/PeLN/kJ9kVq7hNXEU=";
    };
  };
  semshi = pkgs.vimUtils.buildVimPlugin {
    name = "semshi";
    src = pkgs.fetchFromGitHub {
      owner = "numirias";
      repo = "semshi";
      rev = "252f07fd5f0ae9eb19d02bae979fd7c9152c1ccf";
      hash = "sha256-A/voYRhrihnA8GF03CCuEXhsqYTLwuSg2whM6OHMNmQ=";
    };
  };
in
{
  programs.neovim = {

    enable = true;
    extraLuaConfig = builtins.concatStringsSep "\n" (
      builtins.map builtins.readFile [
        ./config/nvim/settings.lua
        ./config/nvim/keybinds.lua
      ]
    );
    plugins = with pkgs.vimPlugins; [
      supermaven-nvim
      sonarlint-nvim
      csvview-nvim
      semshi
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      fidget-nvim
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-nvim-lua
      cmp-cmdline
      friendly-snippets
      undotree
      telescope-nvim
      plenary-nvim
      kommentary
      conform-nvim
      indent-blankline-nvim
      zen-mode-nvim
      gruvbox-material
      nvim-web-devicons
      nvim-colorizer-lua
      tokyonight-nvim
      noice-nvim
      lualine-nvim
      toggleterm-nvim
      tmux-nvim
      comment-nvim
      nvim-ts-context-commentstring
    ];
  };
}
