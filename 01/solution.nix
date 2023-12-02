{ pkgs, ... }:
let
  splitIntoLines = string: builtins.filter (v: ! builtins.isList v) (builtins.split "\n" string);
in
let
  handleLine = line:
    (import ./calibration-value-for-line.nix {
      inherit pkgs;
    }) line;

  handleLines = lines: builtins.foldl' (x: y: x + (handleLine y)) 0 (splitIntoLines lines);
  file = builtins.readFile ./test.txt;
in
{
  result = handleLines file;
}
