if (!(Get-Command "docker" -ErrorAction SilentlyContinue)) { exit }

DEBUG_WRITE 'Loading Docker Functions'

function dps {
    & docker ps -a
}
