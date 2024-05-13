{
  stdenv,
  fetchzip,
  jre8,
  ...
}:
stdenv.mkDerivation {
  pname = "tekkit-server";
  version = "0.0.1";
  src = fetchzip {
    url = "https://servers.technicpack.net/Technic/servers/tekkit/Tekkit_Server_3.1.2.zip";
    sha256 = "sha256-pIrlt7pTaihQO90qDNes7xKtBvse4qajtCK8NiaUr18=";
    stripRoot = false;
  };
  installPhase = ''
       mkdir -p $out/bin/ $out/lib/minecraft
     cp -rv $src/* $out/lib/minecraft/
     cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    exec ${jre8}/bin/java \$@ -jar $out/lib/minecraft/Tekkit.jar nogui
    EOF
     chmod +x $out/bin/minecraft-server
  '';
}
