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
        foreground = "#cdd1dc";
        frame_color = "#2d303c";
        highlight = "#2274d5, #82aad9";

        font = "Noto Sans CJK JP 10";
        markup = "full";
        format = "<small>%a</small>\n<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = -1;
      };
      urgency_low = {
        background = "#383c4af0";
        timeout = 3;
      };
      urgency_normal = {
        background = "#383c4af0";
        timeout = 5;
      };
      urgency_critical = {
        background = "#9b4d4bf0";
        frame_color = "#ab6d6b";
        highlight = "#eb4d4b";
        timeout = 0;
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
