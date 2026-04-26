{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "oxlint";
  version = "1.61.0";

  src = fetchurl {
    url = "https://github.com/oxc-project/oxc/releases/download/apps_v${version}/oxlint-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-txuWV85zp1ZNizCER78u+rkJHW9o/Mh7hkCBfOynU/g=";
  };

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 oxlint-x86_64-unknown-linux-musl $out/bin/oxlint
    runHook postInstall
  '';

  meta = with lib; {
    description = "Collection of JavaScript tools written in Rust";
    homepage = "https://oxc.rs/docs/guide/usage/linter";
    mainProgram = "oxlint";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
  };
}
