{
  stdenv,
  pkgs,
  makeWrapper,
  python3Packages,
  fetchFromGitHub,
  lib,
}:

python3Packages.buildPythonPackage rec {
  pname = "mtprotoproxy";
  version = "latest";
  format = "other";

  nativeBuildInputs = [ makeWrapper ];
  dependencies = with python3Packages; [
    uvloop
    pycryptodome
  ];

  # no build step, just install files and wrap the script
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "alexbers";
    repo = "mtprotoproxy";
    rev = "bc841cff482a72472f15a36f86ca01aa11cac58b";
    sha256 = "4wBHjtI0UYzmzLi8cESt4pjN1SgI5fwke8iwuaIVEFk=";
  };

  installPhase = ''
    mkdir -p $out/bin
    rm Dockerfile
    cp -r ./pyaes $out/bin
    cp config.py $out/bin
    install -Dm755 mtprotoproxy.py $out/bin/mtprotoproxy
  '';
}
