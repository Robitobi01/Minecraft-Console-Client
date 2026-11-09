{
  pkgs ? import <nixpkgs> { },
  dotnetSdk ? pkgs.dotnetCorePackages.sdk_10_0,
}:

let
  lib = pkgs.lib;
  consoleInteractive = pkgs.fetchFromGitHub {
    owner = "breadbyte";
    repo = "ConsoleInteractive";
    rev = "ff6d2129e9f1e0fc6c7032741bdc42a2f0fa263e";
    hash = "sha256-j/AO+Syt0W7Bi+Up0nwVRqJQCckrKzHqOGV8Kg2yk9o=";
  };
in
pkgs.buildDotnetModule {
  pname = "minecraft-client";
  version = "0.0.0-unstable";

  src = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let rel = lib.removePrefix (toString ./. + "/") (toString path);
      in lib.cleanSourceFilter path type
        && !(builtins.elem (baseNameOf path) [ "bin" "obj" ])
        && !(lib.any (dir: rel == dir || lib.hasPrefix "${dir}/" rel) [
          ".github" ".idea" ".vscode" ".skills" "ConsoleInteractive"
          "DebugTools" "Docker" "docs" "MinecraftClientGUI"
          "MinecraftClient.Tests" "MinecraftOfficial" "tools"
        ]);
  };

  projectFile = "MinecraftClient/MinecraftClient.csproj";
  nugetDeps = ./nuget-deps.json;
  dotnet-sdk = dotnetSdk;
  dotnet-runtime = pkgs.dotnetCorePackages.aspnetcore_10_0;
  runtimeId = "linux-x64";
  executables = [ "MinecraftClient" ];
  # Share Nix's runtime instead of embedding a second .NET runtime in the app.
  selfContainedBuild = false;
  dotnetFlags = [
    "-p:PublishSingleFile=false"
    "-p:PublishReadyToRun=true"
    "-p:DebugType=none"
    "-p:DebugSymbols=false"
  ];

  postPatch = ''
    cp -R --no-preserve=mode,ownership ${consoleInteractive} ConsoleInteractive
  '';
  postFixup = ''
    mv "$out/bin/MinecraftClient" "$out/bin/minecraft-client"
  '';

  meta = {
    description = "Text and terminal client for Minecraft Java Edition";
    homepage = "https://github.com/Robitobi01/Minecraft-Console-Client";
    license = lib.licenses.cddl;
    mainProgram = "minecraft-client";
    platforms = [ "x86_64-linux" ];
  };
}
