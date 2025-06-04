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
    enable = false;
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

      # NOTE: no sha
      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/refs/heads/master/reddit_adblock.js";
      #   sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
      # })

      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/refs/heads/master/youtube_adblock.js";
      #   sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
      # })

      # WARN: скрипты не работают... ???
      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/Eject37/ReTube/refs/heads/main/ReTube.user.js";
      #   sha256 = "sha256-SEBaicGYrwOghANvjbvubf6hD09KKYcChayA5OQa53I=";
      # })

      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/ilyhalight/voice-over-translation/master/dist/vot.user.js";
      #   sha256 = "sha256-xHJ+2vMPepLQzm7U9sIwOVvFZTgOtXoi2kbK0UMmXAQ=";
      # })
    ];
    aliases = {
      # "q" = "tab-close";
    };
    keyBindings = {
      normal = {
        # "<Space>u" = "undo";
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
        "<Space>yo" = "yank inline [[{url:yank}][{title}]]";
        "<Space>yt" = "yank title";
        "<Ctrl-c>" = "tab-close";
        "<Ctrl-C>" = "tab-close -o";
        "<Space>i" = "config-cycle content.images true false";
        "<Space>j" = "config-cycle content.javascript.enabled true false";
        ";e" = "edit-text";
        "<Space>bl" = "cmd-set-text -s :bookmark-load";
        "<Space>bL" = "cmd-set-text -s :bookmark-load -t";
        "<Space>q" = "cmd-set-text -s :quickmark-load";
        "<Space>Q" = "cmd-set-text -s :quickmark-load -t";

        "J" = "tab-prev";
        "K" = "tab-next";

        "<Alt-j>" = "tab-move -";
        "<Alt-k>" = "tab-move +";

        "<Ctrl-V>" = "fake-key -g <Ctrl-v>";

        "<ctrl-alt-c>" = "config-cycle tabs.show always never";

        "г" = "undo";
        "а" = "hint";
        "А" = "hint";
        "о" = "scroll down";
        "л" = "scroll up";
        "д" = "scroll right";
        "р" = "scroll left";
        "ш" = "mode-enter insert";
        "т" = "search-next";
        "Т" = "search-prev";
        "м" = "mode-enter caret";
        "М" = "mode-enter caret ;; selection-toggle --line";
        "<Space>аа" = "cmd-set-text -s :open";
        "<Space>ац" = "cmd-set-text -s :open -t";
        "<Space>аи" = "cmd-set-text -s :tab-focus";
        "<Space>ащ" = "history -t";
        "<Space>ис" = "tab-clone";
        # "<Space>bs" = "tab-select";
        # "<Space>bd" = "tab-close";
        "<Space>иЯ" = "tab-only";
        "<Space>х" = "tab-pin";
        "<Space>к" = "reload";
        "<Space>нн" = "yank";
        "<Space>нв" = "yank domain";
        "<Space>нь" = "yank inline [{title}]({url:yank})";
        "<Space>нт" = "yank inline ({url:yank})[{title}]";
        "<Space>не" = "yank title";
        "<Ctrl-с>" = "tab-close";
        "<Ctrl-С>" = "tab-close -o";
        "<Space>ш" = "config-cycle content.images true false";
        "<Space>о" = "config-cycle content.javascript.enabled true false";
        ";у" = "edit-text";
        "." = "cmd-set-text /";
        "," = "cmd-set-text ?";
        "Ж" = "cmd-set-text :";
        "<Space>ид" = "cmd-set-text -s :bookmark-load";
        "<Space>иД" = "cmd-set-text -s :bookmark-load -t";
        "<Space>й" = "cmd-set-text -s :quickmark-load";
        "<Space>Й" = "cmd-set-text -s :quickmark-load -t";

        "О" = "tab-prev";
        "Л" = "tab-next";

        "<Alt-о>" = "tab-move -";
        "<Alt-л>" = "tab-move +";

        "<Ctrl-М>" = "fake-key -g <Ctrl-v>";

        "<ctrl-alt-с>" = "config-cycle tabs.show always never";
        ";l" = ''config-cycle spellcheck.languages ["ru-RU"] ["en-US"]'';
        ";д" = ''config-cycle spellcheck.languages ["ru-RU"] ["en-US"]'';
      };
      insert = {
        ";l" = ''config-cycle spellcheck.languages ["ru-RU"] ["en-US"]'';
        ";д" = ''config-cycle spellcheck.languages ["ru-RU"] ["en-US"]'';
        ";e" = "edit-text";
        ";у" = "edit-text";
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
      config.unbind('m')
      config.unbind('M')
      config.unbind('sf')
      config.unbind('gb')
      config.unbind('gB')
      config.unbind('wB')
      config.unbind('wb')
      config.unbind('sf')
      config.unbind('ss')
      config.unbind('sl')
      config.unbind('sk')

      config.unbind('gC')
      config.unbind('gt')
      config.unbind('d')
      config.unbind('D')
      config.unbind('co')
      # config.unbind('u')
      # config.unbind('U')
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
      c.tabs.position = 'top'
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
      config.set('content.javascript.enabled', True, 'https://github.com/*')
      config.set('content.javascript.enabled', True, 'https://budilki.ru/*')
      config.set('content.javascript.enabled', True, 'https://translate.google.com/*')
      config.set('content.javascript.enabled', True, 'https://www.reddit.com/*')
      config.set('content.javascript.enabled', True, 'https://nix-community.github.io/nixvim/*')

      c.content.images = False

      config.set('content.images', True, 'https://*.reddit.com/*')
      config.set('content.images', True, 'https://reddit.com/*')
      config.set('content.images', True, 'https://music.youtube.com/*')
      config.set('content.images', True, 'https://imgur.com/*')
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
      c.content.autoplay = False
      c.content.pdfjs = True
      c.colors.webpage.bg = '#000000'
      c.content.tls.certificate_errors = "block"
    '';
  };
}
# :set content.proxy http://f8eedd6d353a7c86c61a8d792bf66af1:f8eedd6d353a7c86c61a8d792bf66af1@103.75.119.40:5598

