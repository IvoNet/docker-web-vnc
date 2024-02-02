#!/command/with-contenv bash
##############################################################################
# make sure the openbox config is copied to the user's home directory
# in case the home folder is mounted on a local volume
##############################################################################
if [[ ! -d /config/.config/openbox ]]; then
  chmod +x /etc/xdg/openbox/autostart
  chmod +x /startapp.sh
  cp /root/.xinitrc /config/.xinitrc
fi
