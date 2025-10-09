{ pkgs, lib, ... }:

let
  imageTypes = [
    "image/gif"
    "image/jpeg"
    "image/png"
    "image/webp"
    "image/svg+xml"
  ];

  imageDefaults = lib.listToAttrs (
    map (mt: {
      name = mt;
      value = "nomacs.desktop";
    }) imageTypes
  );

  pdfTypes = [
    "application/pdf"
    "application/oxps"
    "application/epub+zip"
    "application/x-fictionbook"
  ];

  pdfDefaults = lib.listToAttrs (
    map (mt: {
      name = mt;
      value = "org.pwmt.zathura-pdf-mupdf.desktop";
    }) pdfTypes
  );

  browserTypes = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  broswerDefaults = lib.listToAttrs (
    map (mt: {
      name = mt;
      value = "google-chrome.desktop";
    }) browserTypes
  );
in

{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = imageDefaults // pdfDefaults // broswerDefaults;
  };
}
