{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.josh = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "22.11";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = [ 
      pkgs.tmux 
      pkgs.fzf 
      pkgs.ripgrep 
      pkgs.gopls 
      pkgs.go 
      pkgs.tree
      pkgs.pinentry
      pkgs.gnupg
      pkgs.niv
    ];


    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };

    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
      enableBashIntegration = true;
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      historySize = 1000000;
      historyFileSize = 1000000;
      historyControl = ["erasedups"];

      shellOptions = [
        "histappend"
      ];

      shellAliases = 
      {
        l = "la -la";
      };

      sessionVariables = 
      {
        GPG_TTY="$(tty)";
      };
    };

    programs.git = {
      enable = true;
      userName  = "joshrosso";
      userEmail = "joshrosso@gmail.com";
      signing = {
        key = "B076918EE70E30CF98B2EB4AD5CD572310881E88";
        signByDefault = true;
      };
      extraConfig = {
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github" = {
          host = "github.com";
          user = "joshrosso";
          identityFile = "~/.ssh/joshrosso.pem";
        };
      };

    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      plugins = with pkgs; [ 
	    vimPlugins.telescope-nvim
	    vimPlugins.vim-fugitive
            vimPlugins.vim-airline
	    vimPlugins.vim-airline-themes
	    vimPlugins.vim-eunuch
	    vimPlugins.vim-gitgutter
	    vimPlugins.vim-markdown
	    vimPlugins.vim-nix
	    vimPlugins.typescript-vim
            vimPlugins.vim-monokai-pro
            vimPlugins.nvim-lspconfig
            vimPlugins.cmp-nvim-lsp
            vimPlugins.cmp-buffer
            vimPlugins.cmp-path
            vimPlugins.cmp-cmdline
            vimPlugins.nvim-cmp
            vimPlugins.cmp-vsnip
            vimPlugins.vim-vsnip
            vimPlugins.trouble-nvim
      ]; 

      extraLuaConfig = (builtins.readFile ./vim-lua.nix);
    };
  };
}
