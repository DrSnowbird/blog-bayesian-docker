#!/bin/bash

set -e

whoami

env | sort

echo "Inputs: $*"

#### ------------------------------------------------------------------------
#### ---- Extra line added in the script to run all command line arguments
#### ---- To keep the docker process staying alive if needed.
#### ------------------------------------------------------------------------
set -v
if [ $# -gt 0 ]; then

    #### 1.) Setup needed stuffs, e.g., init db etc. ....
    #### (do something here for preparation)
    
    if [[ $1 =~ "sublime_text" ]]; then
        echo ">>>> Seen: sublime_text command... wait indefinitely ..."
        $*
        tail -f /dev/null
    else
        echo "Non sublime_text command... continue"
        $*
    fi

else
    /bin/bash
fi

#tail -f /dev/null
