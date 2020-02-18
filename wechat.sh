#!/usr/bin/env bash
#
#   Author: Huan (李卓桓) <zixia@zixia.net>
#   Copyright (c) 2020-now
#
#   License: Apache-2.0
#   GitHub: https://github.com/huan/docker-wechat
#
set -eo pipefail

function hello () {
  cat <<'EOF'
       ____         ____ _           _
      |  _ \  ___  / ___| |__   __ _| |_
      | | | |/ _ \| |   | '_ \ / _` | __|
      | |_| | (_) | |___| | | | (_| | |_
      |____/ \___/ \____|_| |_|\__,_|\__|
   __________________________________________
  |\_________________________________________\
  | | http://github.com/huan/docker-wechat   |
   \|________________________________________|

      DoChat (Docker-weChat) is:

      📦 a Docker Image
      🤐 for Running PC Windows WeChat
      💻 on Your Linux Desktop
      💖 by One-Line command

EOF
}

function update () {
  echo '🚀 Pulling the latest docker image...'
  echo
  docker pull zixia/wechat
  echo
  echo '🚀 Pulling the latest docker image done.'
}

function main () {
  DEVICE_ARG=()
  for DEVICE in /dev/video* /dev/snd; do
    DEVICE_ARG+=('--device' "$DEVICE")
  done

  echo '🚀 Starting DoChat...'
  #
  # --privileged: For Sound (/dev/snd/ permission)
  # --ipc=host:   MIT_SHM (?)
  #
  docker run \
    "${DEVICE_ARG[@]}" \
    --name wechat \
    --rm \
    -i \
    \
    -v "$HOME/WeChatFiles:/WeChatFiles" \
    \
    -e DISPLAY="$DISPLAY" \
    -e DOCHAT_DEBUG="$DOCHAT_DEBUG" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    \
    -e XMODIFIERS=@im=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
    -e VIDEO_GID="$(getent group video | cut -d: -f3)" \
    -e GID="$(id -g)" \
    -e UID="$(id -u)" \
    \
    --privileged \
    zixia/wechat

    echo "🚀 DoChat Exited with code $?"
    echo
    echo '🐞 Bug Report: https://github.com/huan/docker-wechat/issues'
    echo

}

hello
update
main