{ pkgs }:
let stripChars = str:
  let
    inherit pkgs;
    isConvertibleToInt = string:
      let r = builtins.tryEval (pkgs.lib.toInt string); in
      r.success;
  in
    builtins.filter
      (x: isConvertibleToInt x)
      (pkgs.lib.lists.flatten
        (builtins.split "([[:digit:]])" str));
in
stripChars
