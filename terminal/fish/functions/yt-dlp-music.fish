function yt-dlp-music
    set -l my_args

    set -a my_args --cookies-from-browser
    set -a my_args "chromium:$HOME/.var/.local/share/qutebrowser/webengine"

    set -a my_args -f
    set -a my_args "bestaudio[ext=m4a]/bestaudio"

    set -a my_args --extract-audio

    set -a my_args --audio-format
    set -a my_args m4a

    set -a my_args --embed-thumbnail

    set -a my_args --convert-thumbnails
    set -a my_args jpg

    set -a my_args --ppa
    set -a my_args "ThumbnailsConvertor+ffmpeg_o:-vf crop=ih:ih"

    set -a my_args --embed-metadata

    set -a my_args --sponsorblock-remove
    set -a my_args "music_offtopic,intro,outro"

    set -a my_args --no-playlist

    set -a my_args -o
    set -a my_args "%(artist|uploader)s - %(title)s.%(ext)s"

    command yt-dlp $my_args $argv
end
