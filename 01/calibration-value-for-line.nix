{ pkgs }:
let
  stripChars = str:
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
let calibrationValueForLine = str:
      if (builtins.length (stripChars str)) == 0 then
        0
      else if (builtins.length (stripChars str)) == 1 then
        # return string toInt concatenated with itself
        pkgs.lib.strings.toInt
          (pkgs.lib.strings.concatStrings
            (pkgs.lib.lists.replicate 2
              (pkgs.lib.strings.concatStrings (stripChars str))))
      else if (builtins.length (stripChars str)) == 2 then
        # return string toInt unchanged
        pkgs.lib.strings.toInt
          (pkgs.lib.strings.concatStrings (stripChars str))
      else
        # return first and last element of list concatenated toInt
        pkgs.lib.strings.toInt
          (pkgs.lib.strings.concatStrings
            (pkgs.lib.lists.flatten
              [
                (builtins.head (stripChars str))
                (pkgs.lib.lists.last (stripChars str))
              ]
            )
          );
in
calibrationValueForLine
