{ config, pkgs, ... }:

let
  tmux-nvim = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux.nvim";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "aserowy";
      repo = "tmux.nvim";
      rev = "65ee9d6e6308afcd7d602e1320f727c5be63a947";
      sha256 = "sha256-zpg7XJky7PRa5sC7sPRsU2ZOjj0wcepITLAelPjEkSI=";
    };
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "josh";
  home.homeDirectory = "/home/josh";
  imports = [ ./nvim.nix ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nixfmt-rfc-style
    fnm
    cargo
    gcc
    just
    neofetch
    tree

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/josh/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      shellAliases = {
        lg = "lazygit";
        t = "tmux";
        p = "pwsh.exe";
        pwsh = "pwsh.exe";
        python = "python3";
        py = "python3";
      };
      initExtra = builtins.readFile ./config/zshrc;
    };
    eza = {
      enable = true;
      icons = true;
      git = true;
    };
    git = {
      enable = true;
      delta.enable = true;
    };
    lazygit.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    zellij.enable = true;
    gh.enable = true;
    tmux = {
      enable = true;
      terminal = "tmux-256color";
      shortcut = "a";
      mouse = true;
      historyLimit = 10000;
      escapeTime = 5;
      baseIndex = 1;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main'
          '';
        }
        tmux-nvim
      ];
      extraConfig = ''
        set -ag terminal-overrides ",xterm-256color:RGB"
        set -sg escape-time 5
        bind v split-window -h
        bind s split-window -v



        set -g mode-style "fg=#7aa2f7,bg=#3b4261"

        set -g message-style "fg=#7aa2f7,bg=#3b4261"
        set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

        set -g pane-border-style "fg=#3b4261"
        set -g pane-active-border-style "fg=#7aa2f7"

        set -g status "on"
        set -g status-justify "left"


        set -g status-style "fg=#7aa2f7,bg=#1f2335"

        set -g status-left-length "100"
        set -g status-right-length "100"

        set -g status-left-style NONE
        set -g status-right-style NONE

        set -g status-left "#[fg=#1d202f,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "
        if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
          set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "

        }


        setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"

        setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
        setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"

        # tmux-plugins/tmux-prefix-highlight support
        set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#1f2335]#[fg=#1f2335]#[bg=#e0af68]"
        set -g @prefix_highlight_output_suffix ""
      '';
    };
  };
}
