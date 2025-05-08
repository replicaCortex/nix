{pkgs, ...}: {
  # programs.firefox = {
  #   enable = true;
  # };
  home.packages = with pkgs; [
    zotero
    qbittorrent-enhanced
    (callPackage ./zen.nix {})
  ];

  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    searchEngines = {
      DEFAULT = "https://www.google.com/search?hl=en&q={}";
    };
    keyMappings = {};
    greasemonkey = [
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1d1be041a65c251692ee082eda64d2637edf6444/youtube_sponsorblock.js";
        sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
      })

      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/Eject37/ReTube/refs/heads/main/ReTube.user.js";
      #   sha256 = "sha256-SEBaicGYrwOghANvjbvubf6hD09KKYcChayA5OQa53I=";
      # })
    ];
    aliases = {
      # "q" = "tab-close";
    };
    keyBindings = {
      normal = {
        "<Space>ff" = "cmd-set-text -s :open";
        "<Space>fw" = "cmd-set-text -s :open -t";
        "<Space>fb" = "cmd-set-text -s :tab-focus";
        "<Space>fo" = "history -t";
        "<Space><Return>" = "bookmark-list --jump";
        "<Space>bc" = "tab-clone";
        # "<Space>bs" = "tab-select";
        # "<Space>bd" = "tab-close";
        "<Space>bZ" = "tab-only";
        "<Space>p" = "tab-pin";
        "<Space>r" = "reload";
        "<Space>yy" = "yank";
        "<Space>yd" = "yank domain";
        "<Space>ym" = "yank inline [{title}]({url:yank})";
        "<Space>yn" = "yank inline ({url:yank})[{title}]";
        "<Space>yt" = "yank title";
        "<Ctrl-c>" = "tab-close";
        "<Ctrl-C>" = "tab-close -o";
        "<Space>i" = "config-cycle content.images true false";
        "<Space>j" = "config-cycle content.javascript.enabled true false";

        "<Alt-k>" = "tab-move -";
        "<Alt-j>" = "tab-move +";

        "<Ctrl-V>" = "fake-key -g <Ctrl-v>";

        "<ctrl-alt-c>" = "config-cycle tabs.show always never";
        # "<ctrl-s>" = "config-cycle tabs.show multiple never";
        # ",l" = ''config-cycle spellcheck.languages ["ru-RU"] ["en-US"]'';

        # "<Space>аа" = "cmd-set-text -s :open";
        # "<Space>ац" = "cmd-set-text -s :open -t";
        # "<Space>аи" = "cmd-set-text -s :tab-focus";
        # "<Space>ащ" = "history -t";
        # "<Space>ив" = "tab-clone";
        # "<Space>а" = "hint";
        # # "<Space>ис" = "tab-select";
        # # "<Space>ид" = "tab-close";
        # "<Space>иЯ" = "tab-only"; # Shift+Z = Я
        # "<Space>з" = "tab-pin";
        # "<Space>к" = "reload";
        # "<Space>нн" = "yank";
        # "<Space>нв" = "yank domain";
        # "<Space>нь" = "yank inline [{title}]({url:yank})";
        # "<Space>нт" = "yank inline ({url:yank})[{title}]";
        # "<Space>не" = "yank title";
        # "<Ctrl-с>" = "tab-close";
        # "<Ctrl-С>" = "tab-close -o";
        # "<Space>ш" = "config-cycle content.images true false";
        # "<Space>о" = "config-cycle content.javascript.enabled true false";
        #
        # "<Alt-л>" = "tab-move -";
        # "<Alt-о>" = "tab-move +";
        #
        # "<ctrl-alt-с>" = "config-cycle tabs.show multiple never";
        #
        # "<Ctrl-т>" = "completion-item-focus --history next";
        # "<Ctrl-з>" = "completion-item-focus --history prev";
      };
      command = {
        "<Ctrl-n>" = "completion-item-focus --history next";
        "<Ctrl-p>" = "completion-item-focus --history prev";
        # "<Ctrl-V>" = "fake-key -g <Ctrl-v>";
      };
    };
    extraConfig = ''
      config.set('downloads.location.prompt', True)
      # config.set('downloads.location.directory', '~/downloads/')

      config.unbind('r')

      config.unbind('yy')
      config.unbind('ym')
      config.unbind('yd')
      config.unbind('yt')

      config.unbind('gC')
      config.unbind('gt')
      config.unbind('d')
      config.unbind('D')
      config.unbind('co')
      config.unbind('<Ctrl-p>')
      config.unbind('T')
      config.unbind('q')
      config.unbind('Ss')
      config.unbind('Sb')
      config.unbind('Sq')
      config.unbind('Sh')

      config.unbind('<Space>', mode="caret")

      config.load_autoconfig()

      c.editor.command                = ["wezterm", "-e", "nvim", "{}"]
      c.editor.encoding               = "utf-8"

      c.url.start_pages               = ["https://google.com"]
      c.url.searchengines             = { "DEFAULT": "https://www.google.com/search?hl=en&q={}" }

      c.colors.webpage.darkmode.enabled = True

      c.fonts.completion.entry        = "14px Ubuntu Mono"
      c.fonts.completion.category     = "14px Ubuntu Mono"
      c.fonts.debug_console           = "14px Ubuntu Mono"
      c.fonts.downloads               = "14px Ubuntu Mono"
      c.fonts.hints                   = "14px Ubuntu Mono"
      c.fonts.keyhint                 = "14px Ubuntu Mono"
      c.fonts.messages.info           = "14px Ubuntu Mono"
      c.fonts.messages.error          = "14px Ubuntu Mono"
      c.fonts.prompts                 = "14px Ubuntu Mono"
      c.fonts.statusbar               = "14px Ubuntu Mono"
      c.fonts.tabs.selected           = "14px Ubuntu Mono"
      c.fonts.tabs.unselected         = "14px Ubuntu Mono"

      c.tabs.show = "always"
      c.tabs.last_close               = "startpage"
      c.auto_save.session             = True
      c.session.lazy_restore          = True
      c.tabs.position = 'left'
      c.content.blocking.method = "both"

      c.content.javascript.enabled = False

      config.set('content.javascript.enabled', True, '*://www.google.com/*')
      config.set('content.javascript.enabled', True, 'https://*.youtube.com/*')
      config.set('content.javascript.enabled', True, 'https://nix-community.github.io/*')
      config.set('content.javascript.enabled', True, 'https://mynixos.com/*')
      config.set('content.javascript.enabled', True, 'https://search.nixos.org/*')
      config.set('content.javascript.enabled', True, 'https://npi-tu.ru/*')
      config.set('content.javascript.enabled', True, 'https://vk.com/*')
      config.set('content.javascript.enabled', True, 'https://web.whatsapp.com/*')
      config.set('content.javascript.enabled', True, 'https://www.ozon.ru/*')
      config.set('content.javascript.enabled', True, 'https://github.com/*')
      config.set('content.javascript.enabled', True, 'https://budilki.ru/*')
      config.set('content.javascript.enabled', True, 'https://translate.google.com/*')
      config.set('content.javascript.enabled', True, 'https://web.telegram.org/*')
      config.set('content.javascript.enabled', True, 'https://www.reddit.com/*')

      c.content.images = False

      config.set('content.images', True, 'https://web.telegram.org/*')
      config.set('content.images', True, 'https://*.reddit.com/*')
      config.set('content.images', True, 'https://music.youtube.com/*')
      config.set('content.images', True, 'https://imgur.com/*')
      config.set('content.images', True, 'https://www.ozon.ru/*')
      config.set('content.images', True, 'https://web.whatsapp.com/*')
      config.set('content.images', True, 'https://*.wikipedia.org/*')

      with config.pattern('*'):
          c.content.user_stylesheets = [
              '/home/replica/nix/static/qutebrowser/css.css',
              # '/home/replica/nix/static/qutebrowser/catppucine.css'
          ]

      with config.pattern('*://accounts.google.com/*') as p:
          p.content.headers.user_agent = 'Mozilla/5.0 ({os_info}; rv:135.0) Gecko/20100101 Firefox/135'

      c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"],
                                                   "userscript:_qute_js": ["*TrustedHTML*"]}

      c.content.headers.accept_language = "en-US,en;q=0.5"
      c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
      c.content.canvas_reading = False
      c.content.webgl = False

      url_replacer = {
          "www.reddit.com" : {
              "out": "old.reddit.com",
              "force_https": True,
              "clean_queries": True
          },
          "reddit.com": {
              "out": "old.reddit.com",
              "force_https": True,
              "clean_queries": True
          },
      }
    '';
  };
}
