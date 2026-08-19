function kb
    switch "$argv[1]"
        case on
            systemctl --user start keybase.service
            and echo "keybase + kbfs up — files at /run/user/1000/keybase/kbfs"
        case off
            systemctl --user stop keybase.service
            and echo "keybase + kbfs stopped, mount cleanly removed"
        case '' status
            systemctl --user is-active keybase.service kbfs.service | paste -d' ' - - | read -l kbs kfs
            echo "keybase: $kbs  kbfs: $kfs"
        case '*'
            echo "usage: kb [on|off|status]"
    end
end
