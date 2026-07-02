{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  dotnetSdk ? pkgs.dotnetCorePackages.sdk_10_0,
  runtimeIdentifier ? "linux-x64",
}:

let
  consoleInteractive = pkgs.fetchFromGitHub {
    owner = "breadbyte";
    repo = "ConsoleInteractive";
    rev = "ff6d2129e9f1e0fc6c7032741bdc42a2f0fa263e";
    hash = "sha256-j/AO+Syt0W7Bi+Up0nwVRqJQCckrKzHqOGV8Kg2yk9o=";
  };
in
pkgs.stdenvNoCC.mkDerivation {
  name = "minecraft-client";

  src = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      let
        rel = lib.removePrefix (toString ./. + "/") (toString path);
      in
      lib.cleanSourceFilter path type
      && !lib.hasPrefix ".git/" rel
      && !lib.hasPrefix ".github/" rel
      && !lib.hasPrefix ".idea/" rel
      && !lib.hasPrefix ".vscode/" rel
      && !lib.hasPrefix "DebugTools/" rel
      && !lib.hasPrefix "Docker/" rel
      && !lib.hasPrefix "docs/" rel
      && !lib.hasPrefix "MinecraftClientGUI/" rel
      && !lib.hasPrefix "MinecraftOfficial/" rel
      && !lib.hasPrefix "tools/" rel;
  };

  nativeBuildInputs = [ dotnetSdk pkgs.makeWrapper ];

  buildInputs = dotnetSdk.packages ++ [ (pkgs.mkNugetDeps {
    name = "minecraft-client";
    nugetDeps = { fetchNuGet }: map fetchNuGet (builtins.fromJSON ''
[
  { "pname": "Avalonia", "version": "11.3.12", "hash": "sha256-T2y8aoKUSfXqmV2RL1QStytzJkc/SZYfIdJihB5UWR0=" },
  { "pname": "Avalonia.BuildServices", "version": "11.3.2", "hash": "sha256-6wx06tjSKWQOlX2czdp6Wh0nuwVapx5qf/s8Qj5we40=" },
  { "pname": "Avalonia.Remote.Protocol", "version": "11.3.12", "hash": "sha256-dF93nP1Cd7ZdzrO7ScGHchxYxCjWN45AjiqiO1J+cmU=" },
  { "pname": "Brigadier.NET", "version": "1.2.13", "hash": "sha256-yUsOd/+HXyjYCV6dyEn9GOjNKgSIW/AjRmpfPI6xINg=" },
  { "pname": "CommunityToolkit.Mvvm", "version": "8.4.0", "hash": "sha256-a0D550q+ffreU9Z+kQPdzJYPNaj1UjgyPofLzUg02ZI=" },
  { "pname": "Consolonia", "version": "11.3.12.3", "hash": "sha256-y786/IpIbt3ROPh6Dy158k/XL5aS1kroDQEwjzqzk4U=" },
  { "pname": "Consolonia.Controls", "version": "11.3.12.3", "hash": "sha256-iWUGvuh7dQ3vW6p1eAlkY0ZyO+YI+NkuoJOW3LL5a4E=" },
  { "pname": "Consolonia.Core", "version": "11.3.12.3", "hash": "sha256-DvzVSHGEqZJ/qEv6YEFFhfOFaQNP6NMpzbMdVhac6T0=" },
  { "pname": "Consolonia.PlatformSupport", "version": "11.3.12.3", "hash": "sha256-q2D1c0GMAG+M6+yPVpOZtq45LKB40YivFTFI3Z7LYek=" },
  { "pname": "Consolonia.Themes", "version": "11.3.12.3", "hash": "sha256-hmLsKguQzAh4be61i9sUtBKbxjNEKRHB9Yy26Jj4xLs=" },
  { "pname": "DiscordRichPresence", "version": "1.143.0", "hash": "sha256-wIVVsLnOJ8wy8UwZTXCzGFM0z3f0Ti+WxioEQqlFC0s=" },
  { "pname": "DnsClient", "version": "1.8.0", "hash": "sha256-Xc8BOCI9M8gSM5raVnPezA4yeO1eoyxXPPn9jh5/RaY=" },
  { "pname": "DSharpPlus", "version": "4.5.1", "hash": "sha256-mFSKUi7fBvg/TJp5x9PJ3Izk7y9u3Tp9D3sJERpC+Ow=" },
  { "pname": "DynamicExpresso.Core", "version": "2.19.3", "hash": "sha256-D5YI/n6sj0OKJU7VRH36+YaAbRzcRdHkpLnq62pI/dE=" },
  { "pname": "FuzzySharp", "version": "2.0.2", "hash": "sha256-GuWqVOo+AG8MSvIbusLPjKfJFQRJhSSJ9eGWljTBA/c=" },
  { "pname": "jinek.X11Clipboard.Fork", "version": "1.0.0", "hash": "sha256-SJefRaOOoIcOMKa865j+s1/KLB4BOFWIYTTp+PBJRYk=" },
  { "pname": "Magick.NET-Q16-AnyCPU", "version": "14.11.1", "hash": "sha256-GbCGSCB9iB9YA9Xmht0vPAlfJMY/tgGpNajorQv1fl4=" },
  { "pname": "Magick.NET.Core", "version": "14.11.1", "hash": "sha256-984jXKS/y2602DgaXsfDh9TFOhpyAF/gHZG8BGQXljA=" },
  { "pname": "MessagePack", "version": "3.1.4", "hash": "sha256-oju/hX+vwZFqSa9ORSa58ToM3cE7fF8x34i2oNLGNVo=" },
  { "pname": "MessagePack.Annotations", "version": "3.1.4", "hash": "sha256-YZGKa20siabb4VIQri5dMuFwnDxX19Htf51nGrIPx28=" },
  { "pname": "MessagePackAnalyzer", "version": "3.1.4", "hash": "sha256-qc+mzydfbZ/0O4j7pPDjp+x8aQ4KYqMeCDRIPhb1oe8=" },
  { "pname": "MicroCom.Runtime", "version": "0.11.0", "hash": "sha256-VdwpP5fsclvNqJuppaOvwEwv2ofnAI5ZSz2V+UEdLF0=" },
  { "pname": "Microsoft.AspNet.WebApi.Client", "version": "6.0.0", "hash": "sha256-lNL5C4W7/p8homWooO/3ZKDZQ2M0FUTDixJwqWBPVbo=" },
  { "pname": "Microsoft.CodeAnalysis.Analyzers", "version": "5.3.0-2.25625.1", "hash": "sha256-W2CaLe+fpnD2/2VL6jPW/Ct17qOt4lGZKK2X8HU7MLI=" },
  { "pname": "Microsoft.CodeAnalysis.Common", "version": "5.3.0", "hash": "sha256-O5RVbqAWXL2FcCNtn+dPAVJ/5aiaxc8nQWojJSsx61w=" },
  { "pname": "Microsoft.CodeAnalysis.CSharp", "version": "5.3.0", "hash": "sha256-A3jxlZEyfgEn9unhoQqbOsA0wd/mA8aak6dRlu5mHIU=" },
  { "pname": "Microsoft.Extensions.AI.Abstractions", "version": "10.4.1", "hash": "sha256-wXwrBjGyOafppiAwCr6sYcggkMwdDttzm25VzX3TLJE=" },
  { "pname": "Microsoft.Extensions.Caching.Abstractions", "version": "10.0.5", "hash": "sha256-3rW3DjoyIIgfeJOHvdZJSrtsZ76V3MNxH5RLICRXWv4=" },
  { "pname": "Microsoft.Extensions.Configuration.Abstractions", "version": "10.0.5", "hash": "sha256-DNK+lL2jeHFYyd43zfgVY32UskEfQ4YsTapztuQbYwo=" },
  { "pname": "Microsoft.Extensions.Configuration.Abstractions", "version": "8.0.0", "hash": "sha256-4eBpDkf7MJozTZnOwQvwcfgRKQGcNXe0K/kF+h5Rl8o=" },
  { "pname": "Microsoft.Extensions.Configuration.Binder", "version": "8.0.0", "hash": "sha256-GanfInGzzoN2bKeNwON8/Hnamr6l7RTpYLA49CNXD9Q=" },
  { "pname": "Microsoft.Extensions.DependencyInjection.Abstractions", "version": "10.0.5", "hash": "sha256-KrP+hE3gk7pATbJYZsJ1LHiXjzLA+ntHW7G/VGgHk2g=" },
  { "pname": "Microsoft.Extensions.DependencyInjection.Abstractions", "version": "8.0.0", "hash": "sha256-75KzEGWjbRELczJpCiJub+ltNUMMbz5A/1KQU+5dgP8=" },
  { "pname": "Microsoft.Extensions.Diagnostics.Abstractions", "version": "10.0.5", "hash": "sha256-pwQltVfaqx0jRpO0d9k/dYtyOpnGixK2MB3aHVVbo0E=" },
  { "pname": "Microsoft.Extensions.FileProviders.Abstractions", "version": "10.0.5", "hash": "sha256-6RwvzBQTJzbypUQAM9WNRkpn3gON63DLxY3gH0ZcrH4=" },
  { "pname": "Microsoft.Extensions.Hosting.Abstractions", "version": "10.0.5", "hash": "sha256-mqxu+PvqYP/J/9UWEbLIAfSNnsABhdl6m5wkZFf1DDM=" },
  { "pname": "Microsoft.Extensions.Logging.Abstractions", "version": "10.0.5", "hash": "sha256-e3A/l+II+n+D7/OPwjdyQM1IBtKHfHeIdlkJmuRw77w=" },
  { "pname": "Microsoft.Extensions.Logging.Abstractions", "version": "5.0.0", "hash": "sha256-jJtcchUS8Spt/GddcDtWa4lN1RAVQ2sxDnu1cgwa6vs=" },
  { "pname": "Microsoft.Extensions.ObjectPool", "version": "8.0.10", "hash": "sha256-uFDHjHlJ/FqSjBMlEZbSGX46M/ijrKEoKTcAEaRqaog=" },
  { "pname": "Microsoft.Extensions.Options", "version": "10.0.5", "hash": "sha256-nw+m6VWXjmaBqZ1aH/l9SR9Oy62N9dmiMKloJ78kxv8=" },
  { "pname": "Microsoft.Extensions.Options", "version": "8.0.0", "hash": "sha256-n2m4JSegQKUTlOsKLZUUHHKMq926eJ0w9N9G+I3FoFw=" },
  { "pname": "Microsoft.Extensions.Options.ConfigurationExtensions", "version": "8.0.0", "hash": "sha256-A5Bbzw1kiNkgirk5x8kyxwg9lLTcSngojeD+ocpG1RI=" },
  { "pname": "Microsoft.Extensions.Primitives", "version": "10.0.5", "hash": "sha256-uvrur+0dg4zAAQcpLkkhPA77ST0tA3+EpGdDlCckC+E=" },
  { "pname": "Microsoft.Extensions.Primitives", "version": "8.0.0", "hash": "sha256-FU8qj3DR8bDdc1c+WeGZx/PCZeqqndweZM9epcpXjSo=" },
  { "pname": "Microsoft.NET.StringTools", "version": "17.11.4", "hash": "sha256-lWfzY35WQ+iKS9TpuztDTljgF9CIORhFhFEm0p1dVBE=" },
  { "pname": "Microsoft.Win32.Registry.AccessControl", "version": "10.0.5", "hash": "sha256-pdJslIOA9mMYylLbfeRFGFc1iXGlsl1ohk43rIyvuiQ=" },
  { "pname": "Microsoft.Win32.SystemEvents", "version": "10.0.5", "hash": "sha256-+P58Oxl4W1oXE2a13MSA8dzX4oGm/4Ix9HDT6Z+yHlI=" },
  { "pname": "Microsoft.Windows.Compatibility", "version": "10.0.5", "hash": "sha256-+Ojq1wcryz8tNaaC4kPCfaJihcrSbarwPlbLMBI5tpg=" },
  { "pname": "ModelContextProtocol", "version": "1.2.0", "hash": "sha256-GuCuQbN7OFDlekWjDScLJiNyyT0XAtIGAMYP3vP8eYk=" },
  { "pname": "ModelContextProtocol.AspNetCore", "version": "1.2.0", "hash": "sha256-6a4rMkE7VnovwcJhx/HBshQfvZQAhp8Cg0zMzHX86I8=" },
  { "pname": "ModelContextProtocol.Core", "version": "1.2.0", "hash": "sha256-7cO2oqHrwNQOIAdcWrzux6C/hbMOPc4LjjVHoR02d+Y=" },
  { "pname": "Newtonsoft.Json", "version": "12.0.1", "hash": "sha256-4Xf3RZrJomAh3jaZrEAJX3oPmOowGV8yDB9Y3h0Dw4U=" },
  { "pname": "Newtonsoft.Json", "version": "12.0.2", "hash": "sha256-BW7sXT2LKpP3ylsCbTTZ1f6Mg1sR4yL68aJVHaJcTnA=" },
  { "pname": "Newtonsoft.Json", "version": "13.0.1", "hash": "sha256-K2tSVW4n4beRPzPu3rlVaBEMdGvWSv/3Q1fxaDh4Mjo=" },
  { "pname": "Newtonsoft.Json", "version": "13.0.2", "hash": "sha256-ESyjt/R7y9dDvvz5Sftozk+e/3Otn38bOcLGGh69Ot0=" },
  { "pname": "Newtonsoft.Json.Bson", "version": "1.0.2", "hash": "sha256-ZUj6YFSMZp5CZtXiamw49eZmbp1iYBuNsIKNnjxcRzA=" },
  { "pname": "PInvoke.Kernel32", "version": "0.7.124", "hash": "sha256-E65U364mp9V8SzkT2/oVg1f0Ts9Q1deRLeOUK3QhIlg=" },
  { "pname": "PInvoke.Windows.Core", "version": "0.7.124", "hash": "sha256-n/7Y6MkUVYr1bgT8OUkl0YpOd5AFgzHEUlEN+EKyE5s=" },
  { "pname": "runtime.android-arm.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-kjfhOJqECFcf8Z3wPaVVnhXB4brV2da2aDnggi2EqAk=" },
  { "pname": "runtime.android-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-1mAwmAKr78swVqBir4ceXsfN27T/oqHsRyLPt2K23+Y=" },
  { "pname": "runtime.android-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-Nbs/NCiHcYnVAvRSixlPWfjLozsFFY2wvMjpVCd9gxU=" },
  { "pname": "runtime.android-x86.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-qzvKgfPJQLjQqi2B6vE2iBgGrQWxsXjqp+b2lYZGjs4=" },
  { "pname": "runtime.linux-arm.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-t1HW9L/EeNhRuUY7rEakDBsCZlL/R0Wlgrl8SlAjrc8=" },
  { "pname": "runtime.linux-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-Bl0x6oGa+VJ3/AHMg8OuM+8rs2jkONsywwqOIUYcxVY=" },
  { "pname": "runtime.linux-bionic-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-cYnOhceDL5xwaJT0DUE5t6nJ5C55TM6MdjHTFOdIZCc=" },
  { "pname": "runtime.linux-bionic-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-fC6N3XMg+Viw4q/aZZ7kR6RVp2n43+RgX6LHYGdxfjw=" },
  { "pname": "runtime.linux-musl-arm.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-LE8zUX7JBldxrj19mKtgoM8N5XXMqIKOhj0nB/WpgFg=" },
  { "pname": "runtime.linux-musl-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-J0OapVoPupCTuu24/ze0WBZRR32LrTHbRq5B7dwQ4SI=" },
  { "pname": "runtime.linux-musl-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-ovh5m68zUHghhB+/UbeBPbI2aj+9TJFT10IW69F2cqs=" },
  { "pname": "runtime.linux-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-4eM56eviJ3F9LwwVDB4SSSndO0EKZpuMSAGD7x1QjTU=" },
  { "pname": "runtime.maccatalyst-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-/IMqbyVG5kONqAsX4WdqkyY1nnvrH+eFRU/0Xa8FY1k=" },
  { "pname": "runtime.maccatalyst-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-j0qUepSNG2XORH4Ybp4jXbeDtw7eStueBGzjC0qlP50=" },
  { "pname": "runtime.native.System.Data.SqlClient.sni", "version": "4.4.0", "hash": "sha256-fqYLXAyMXfKXKx1A+E62vt2fiJOyfR+m3wMbULy/lpc=" },
  { "pname": "runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-NEjcONPrhI6djYP67ce83ZyQAGrc/8PqjMpJLSL4QDY=" },
  { "pname": "runtime.osx-arm64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-OVzjHnbGSHCDl92jC5Bfzx8TxX466M+aVsJm0LSGsUc=" },
  { "pname": "runtime.osx-x64.runtime.native.System.IO.Ports", "version": "10.0.5", "hash": "sha256-hzZP1OLO4mf7s674qvFTTefZsckFNd79173SFbiKiyQ=" },
  { "pname": "runtime.win-arm64.runtime.native.System.Data.SqlClient.sni", "version": "4.4.0", "hash": "sha256-8xGiqk5g4kM79//SirozmDtDpqwVXH3CmvIs7GNwfh0=" },
  { "pname": "runtime.win-x64.runtime.native.System.Data.SqlClient.sni", "version": "4.4.0", "hash": "sha256-HoXKGBkue0RJT1SZxAliVmT5rbfU3xD8mH8hfCvRxwQ=" },
  { "pname": "runtime.win-x86.runtime.native.System.Data.SqlClient.sni", "version": "4.4.0", "hash": "sha256-jPnWzDcbufO51GLGjynWHy0b+5PBqNxM+VKmSrObeUw=" },
  { "pname": "Samboy063.Tomlet", "version": "6.2.0", "hash": "sha256-kVuz3w25flcNbr4t7eDRQvH9zTIsuVjsRF2K/lkVeH0=" },
  { "pname": "Sentry", "version": "6.3.1", "hash": "sha256-87cgyuD1Admv0msj1C2dm7IIOu6IRjDL4709Hlctplg=" },
  { "pname": "SingleFileExtractor.Core", "version": "2.3.0", "hash": "sha256-kP/aXyyg8FAu01ejIEhAPy+BMsM5/f+rl2GQL8aefLc=" },
  { "pname": "starksoft.aspen", "version": "1.1.8", "hash": "sha256-CoXL5K0Ph73ugKKKo9BRIFaIXbq4l7kDOYoBAD3eehQ=" },
  { "pname": "System.CodeDom", "version": "10.0.5", "hash": "sha256-6M1nx6MAtqLtoXqAZsDif+hUXC2aF4iGbmFzNhG41x4=" },
  { "pname": "System.ComponentModel.Composition", "version": "10.0.5", "hash": "sha256-CtYQQ82MF2HYT9BIvETiy7KmzZDCm37S9T78JTtLk5c=" },
  { "pname": "System.ComponentModel.Composition.Registration", "version": "10.0.5", "hash": "sha256-7uQYPje7dzq3W+L9j5V4Mt2oRi6ZQJGT8RYtbAj/Lqo=" },
  { "pname": "System.Configuration.ConfigurationManager", "version": "10.0.5", "hash": "sha256-3MOqk5vmgL9aXtptQUpVIM+oJg8Mgz4CVFx05Y4piQw=" },
  { "pname": "System.Data.Odbc", "version": "10.0.5", "hash": "sha256-OPUX/flaqZMKw/y7PpkMqXc0BwZ/I4jJtJFzpFWkbtg=" },
  { "pname": "System.Data.OleDb", "version": "10.0.5", "hash": "sha256-4BdS/jJyuUrybHqjj2ufwRnj39W6y/kk/yMCiLdFijg=" },
  { "pname": "System.Data.SqlClient", "version": "4.9.0", "hash": "sha256-hEMMJHH18mjEpbf7/aFV1fD+xHXRLH4JmYaQdXRKnzA=" },
  { "pname": "System.Diagnostics.EventLog", "version": "10.0.5", "hash": "sha256-SwmQif5X/T4cIPPNkVf6QsvA3oBLb85iJXNkb3GT+sU=" },
  { "pname": "System.Diagnostics.PerformanceCounter", "version": "10.0.5", "hash": "sha256-fn2HN8VrWPsjMWe1dnWMFT33YS24oayBCs3KRxdjHgc=" },
  { "pname": "System.DirectoryServices", "version": "10.0.5", "hash": "sha256-/B0PP/ZPtuyRkni69qXMtxZ9PVFZGesR6mvv077aJys=" },
  { "pname": "System.DirectoryServices.AccountManagement", "version": "10.0.5", "hash": "sha256-BTrZiAn7PYU8NTs5rRP+1SOfs1QD+lhIH986cQrx144=" },
  { "pname": "System.DirectoryServices.Protocols", "version": "10.0.5", "hash": "sha256-qXSzRQAJk4We+Z7qFnZuUMJqGUdUIhv4OUw1r0Etkys=" },
  { "pname": "System.Drawing.Common", "version": "10.0.5", "hash": "sha256-39eTfw3/FAIIJOPmDwgsM6soRJMGvU96MXo6vqbjJJk=" },
  { "pname": "System.IO.Packaging", "version": "10.0.5", "hash": "sha256-nR3shhnchCqZq//ypgn+/l2QDiiSbNKpSswqZ43rxoM=" },
  { "pname": "System.IO.Ports", "version": "10.0.5", "hash": "sha256-UybQEGCLUDKPPOgzSN4/FA97ntwrDm+vcvPpEx+icHI=" },
  { "pname": "System.Management", "version": "10.0.5", "hash": "sha256-mldk+64BzcepAkGDjHnHGOFSSd+Y4t7fcV95ld22iDc=" },
  { "pname": "System.Reflection.Context", "version": "10.0.5", "hash": "sha256-5T6o54ds5t7J3/fktNkUH02ePIJbjjCBL3PJJTyDki4=" },
  { "pname": "System.Runtime.Caching", "version": "10.0.5", "hash": "sha256-qju77MmlaMe472WlHzVZRdKRrmsTeFwycFbDHds34Ng=" },
  { "pname": "System.Security.Cryptography.Pkcs", "version": "10.0.5", "hash": "sha256-d7iz6dRRsxMPLtkQpD0OCbagVO/fHxSLtdoVuV/oC1k=" },
  { "pname": "System.Security.Cryptography.ProtectedData", "version": "10.0.5", "hash": "sha256-Zyqq70EacxdKIx78p49cZ2rveGLxzU9VZxJsPtB2bK0=" },
  { "pname": "System.Security.Cryptography.Xml", "version": "10.0.5", "hash": "sha256-2EVg0Gzv0WZ/Vm8TuSbP0bcFUeHPOe00s2X6mrrhB0g=" },
  { "pname": "System.Security.Cryptography.Xml", "version": "8.0.2", "hash": "sha256-9TCmVyMB4+By/ipU8vdYDtSnw1tkkebnXXVRdT78+28=" },
  { "pname": "System.Security.Permissions", "version": "10.0.5", "hash": "sha256-3zZoiY1xfVUSqOi+davs4iB2nCKUo96dIE1Wa9+x69I=" },
  { "pname": "System.ServiceModel.Http", "version": "8.1.2", "hash": "sha256-GxsvgZ0yPRnmDNefzGJ+kbkMdXhEQgfHW6HIm6a53nY=" },
  { "pname": "System.ServiceModel.NetFramingBase", "version": "8.1.2", "hash": "sha256-FN6BaQx5mazdKIZUfISSmBg9CJq+cWY7ouRi2dGT/rk=" },
  { "pname": "System.ServiceModel.NetTcp", "version": "8.1.2", "hash": "sha256-hv2Pnmu0ye7QGNMO7KRXuA1FwAcyzpENypV2l+cWcLE=" },
  { "pname": "System.ServiceModel.Primitives", "version": "8.1.2", "hash": "sha256-Jk3VmzD96gZElEjJZapM/ovJB8lK9hi+uglXwg/5U6Q=" },
  { "pname": "System.ServiceModel.Syndication", "version": "10.0.5", "hash": "sha256-DmZqyPKI8Vrs4/L+20juQ3ksZp1tkbQIiQoJVzocEmM=" },
  { "pname": "System.ServiceProcess.ServiceController", "version": "10.0.5", "hash": "sha256-g0tIDaeRwwLDCx5cUrzx8AncJmjJFSMU9S5eUhOB+hY=" },
  { "pname": "System.Speech", "version": "10.0.5", "hash": "sha256-RRujOvVaHjwwD08On+wsTEMMbmjalOjBSUF+QcTef4M=" },
  { "pname": "System.Web.Services.Description", "version": "8.1.2", "hash": "sha256-ki35jzv3V1cjAgKZVX+vxz0qPnpoGNmef8wQXKs3tUg=" },
  { "pname": "System.Windows.Extensions", "version": "10.0.5", "hash": "sha256-1juVKFLXHbJAJ8bC9D69yxcL0DXnvFL7JPBXKu2i+EU=" },
  { "pname": "Telegram.Bot", "version": "22.9.5.3", "hash": "sha256-pVMvuxP5XQOKCiI4fOCkcfh+gCE5SPTmMPH5t96bzzo=" },
  { "pname": "Unicode.net", "version": "2.0.0", "hash": "sha256-OkmaGayVPFHQj6XV4idY2MypeoYn/gmxs1IxsQkV8PU=" },
  { "pname": "Vanara.Core", "version": "4.0.4", "hash": "sha256-xyf93UCVRRD1LWW/F/ftjtEp9onP3ks7Mjzsrs44PIk=" },
  { "pname": "Vanara.PInvoke.Kernel32", "version": "4.0.4", "hash": "sha256-TZF47n727xFZmyij1dA+1bcmUpaIngz1VBlqsOi9/dE=" },
  { "pname": "Vanara.PInvoke.Shared", "version": "4.0.4", "hash": "sha256-TSFPS/k8XZSKkYuGq4YknqNrVPOyiYVYvaa/d+MbnR8=" },
  { "pname": "Wcwidth", "version": "1.0.0", "hash": "sha256-weNqGgpKcVMkTtaMV5npzbLRbCPyI0tgkN+qmzeqIwo=" },
  { "pname": "Wcwidth", "version": "3.0.0", "hash": "sha256-ZzmKUGtn2jwEel5xFMqKdbvmiuIREoS9nRkekYAXm/o=" }
]
    '');
  }) ];

  doCheck = false;
  keepNugetConfig = true;

  DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";

  postPatch = ''
    rm -rf ConsoleInteractive
    cp -R --no-preserve=mode,ownership ${consoleInteractive} ConsoleInteractive
  '';

  buildPhase = ''
    runHook preBuild

    dotnet restore MinecraftClient/MinecraftClient.csproj \
      --runtime ${runtimeIdentifier} \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SelfContained=true \
      -p:PublishReadyToRun=true \
      -p:NuGetAudit=false

    dotnet build MinecraftClient/MinecraftClient.csproj \
      --configuration Release \
      --runtime ${runtimeIdentifier} \
      --no-restore \
      -maxcpucount:$NIX_BUILD_CORES \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SelfContained=true \
      -p:DebugType=none \
      -p:DebugSymbols=false \
      -p:PublishReadyToRun=true \
      -p:EnableAvaloniaCompilationByDefault=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish MinecraftClient/MinecraftClient.csproj \
      --configuration Release \
      --runtime ${runtimeIdentifier} \
      --self-contained \
      --no-restore \
      --no-build \
      --output "$out/lib/minecraft-client" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:SelfContained=true \
      -p:DebugType=none \
      -p:DebugSymbols=false \
      -p:PublishSingleFile=true \
      -p:IncludeNativeLibrariesForSelfExtract=true \
      -p:PublishTrimmed=false \
      -p:PublishReadyToRun=true \
      -p:TieredCompilation=true \
      -p:TieredPGO=true \
      -p:EnableAvaloniaCompilationByDefault=false

    makeWrapper "$out/lib/minecraft-client/MinecraftClient" "$out/bin/minecraft-client" \
      --prefix LD_LIBRARY_PATH : ${dotnetSdk.icu}/lib

    runHook postInstall
  '';
}
