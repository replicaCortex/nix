function distrobox-host-exec
    set -l real_cwd (pwd | sed 's|^/run/host||')
    pushd $real_cwd 2>/dev/null; or pushd /tmp
    host-spawn $argv
    set -l exit_code $status
    popd
    return $exit_code
end
