{ pkgs, ... }:
{
  programs.niri.enable = true;
  # services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    brightnessctl
    gammastep
    dunst
    swaybg
    foot
    wl-clipboard
    cliphist

    # --- kde ---
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Character map
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # Color picker
    kdePackages.ksystemlog # System log viewer
    kdePackages.sddm-kcm # SDDM configuration module
    kdiff3 # File/directory comparison tool

    # Hardware/System Utilities (Optional)
    kdePackages.isoimagewriter # Write hybrid ISOs to USB
    kdePackages.partitionmanager # Disk and partition management
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support

  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      # settings = {
      #   Autologin = {
      #     Session = "plasma.desktop";
      #     User = "replica";
      #   };
      # };
    };
    # displayManager.gdm.enable = true;
    # displayManager.plasma-login-manager.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # --- То, что вы уже убрали ---
    elisa # Музыкальный плеер
    kdepim-runtime # Службы для контактов и почты (Akonadi)
    kmahjongg # Игры
    kmines # Игры
    konversation # IRC чат
    kpat # Пасьянс
    ksudoku # Игры
    ktorrent # Торренты

    # --- ЧТО ЕЩЕ МОЖНО СМЕЛО УБРАТЬ ---

    # 1. Магазин приложений (Самое важное для удаления!)
    discover # Центр приложений KDE. В NixOS он АБСОЛЮТНО бесполезен, так как вы ставите программы через конфиг, а Discover будет только висеть в фоне и выдавать ошибки.

    # 2. Лишние утилиты и медиа
    dragon # Базовый (и очень старый) видеоплеер. Если у вас есть mpv или vlc, dragon не нужен.
    khelpcenter # Локальная справка KDE (вы всё равно будете гуглить, если что-то сломается).
    merkuro # Приложение календаря и контактов.
    kweather # Виджет и приложение погоды.

    # 3. Индексатор файлов
    baloo-widgets # Baloo - это служба поиска файлов. Если вы не ищете файлы по их содержимому прямо в меню KDE, его виджеты можно убрать (сам поиск по названиям ломать не стоит).

    # 4. Текстовые редакторы (На ваш выбор)
    # Судя по вашим прошлым логам, вы используете Neovim (nvim).
    # KDE по умолчанию ставит и KWrite, и Kate. Можно убрать тяжелый Kate.
    kate
  ];
}
