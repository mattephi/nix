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
      value = "oculante.desktop";
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
in

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = imageDefaults // pdfDefaults;
  };
}
