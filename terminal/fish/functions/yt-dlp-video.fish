function yt-dlp-video
    set -l my_args

    set -a my_args --cookies-from-browser
    set -a my_args "chromium:$HOME/.var/.local/share/qutebrowser/webengine"

    set -a my_args -f
    set -a my_args "bestvideo[vcodec*=av01][height<=1080]+bestaudio[acodec=opus] / bestvideo[vcodec*=vp09][height<=1080]+bestaudio[acodec=opus] / bestvideo[height<=1080]+bestaudio / best"

    set -a my_args --merge-output-format
    set -a my_args mkv

    set -a my_args --write-subs
    set -a my_args --write-auto-subs

    set -a my_args --sub-langs
    set -a my_args "ru,en"

    set -a my_args --embed-subs

    set -a my_args --compat-options
    set -a my_args no-keep-subs

    set -a my_args --embed-thumbnail
    set -a my_args --embed-metadata
    set -a my_args --embed-chapters

    set -a my_args --sponsorblock-mark
    set -a my_args all

    set -a my_args --sponsorblock-mark
    set -a my_args poi_highlight

    set -a my_args --no-playlist

    set -a my_args -o
    set -a my_args "%(title)s [%(id)s].%(ext)s"

    command yt-dlp $my_args $argv
end
