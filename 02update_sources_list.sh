#!/bin/bash
source "$(dirname "$0")/bootstrap"

# We don't want to touch /etc/apt/sources.list in case it changes between
# distribution versions, so just assert that "contrib" and "non-free" are there
while ! grep -q -E "contrib|non-free" /etc/apt/sources.list ; do
    echo '!! The "contrib" and "non-free" components are missing from'\
         '/etc/apt/sources.list'
    echo "  [e] Edit"
    echo "  [v] View"
    echo "  [c] Continue"
    echo "  [a] Abort"
    case $(promptlist "evca" "e") in
        e)
            if installed nano ; then
                sudo nano /etc/apt/sources.list
            else
                sudo vi /etc/apt/sources.list
            fi
            ;;
        v)
            cat /etc/apt/sources.list
            ;;
        c)
            break
            ;;
        a)
            exit 1
            ;;
    esac
done
