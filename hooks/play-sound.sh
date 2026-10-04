#!/usr/bin/env bash
# Claude Code 이벤트마다 1초 이내의 짧은 소리를 낸다. 인자: done | ask | error
# SURVIVAL_KIT_SOUND=off 이면 소리를 내지 않는다. 소리를 못 내는 환경에서도 항상 exit 0.
[ "${SURVIVAL_KIT_SOUND:-on}" = off ] && exit 0

case "$1" in
  done)  mac=Tink;  win='[console]::Beep(880,120);[console]::Beep(1175,160)' ;;
  ask)   mac=Morse; win='[console]::Beep(988,250)' ;;
  error) mac=Frog;  win='[console]::Beep(220,450)' ;;
  *) exit 0 ;;
esac

case "$(uname -s)" in
  Darwin) afplay -t 0.8 "/System/Library/Sounds/$mac.aiff" >/dev/null 2>&1 ;;
  MINGW*|MSYS*|CYGWIN*) powershell.exe -NoProfile -NonInteractive -Command "$win" >/dev/null 2>&1 ;;
esac
exit 0
