{ pkgs, ... }:
let
  splitIntoLines = string: builtins.filter (v: ! builtins.isList v) (builtins.split "\n" string);
in
let
  replaceThingers = string: (builtins.replaceStrings [ "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" ] ["o1e" "t2o" "t3e" "f4r" "f5e" "s6x" "s7n" "e8t" "n9e"] string);
  handleLine = line:
  let
    replacedLine = replaceThingers (replaceThingers line);
  in
    (import ./calibration-value-for-line.nix {
      inherit pkgs;
    }) (pkgs.lib.traceVal replacedLine);

  handleLines = lines: builtins.foldl' (x: y: x + (pkgs.lib.traceVal (handleLine y))) 0 (splitIntoLines lines);
  file = builtins.readFile ./test.txt;
in
{
  result = handleLines file;
}
