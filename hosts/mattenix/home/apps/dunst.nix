{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";

        width = 350;
        gap_size = 12;
        padding = 12;
        horizontal_padding = 20;
        frame_width = 1;
        sort = "no";

        progress_bar_frame_width = 0;
        progress_bar_corner_radius = 3;
        corner_radius = 4;

        markup = "full";
        format = "<small>%a</small>\n<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = -1;
      };

      fullscreen_delay_everything = {
        fullscreen = "delay";
      };
      fullscreen_show_critical = {
        msg_urgency = "critical";
        fullscreen = "show";
      };
    };
  };
}
