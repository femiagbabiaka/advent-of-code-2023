{ pkgs ? import <nixpkgs> {} }:
let
  version = "v0.2.0";
  nix-parsec = import (builtins.fetchTarball {
    url = "https://github.com/nprindle/nix-parsec/archive/${version}.tar.gz";
    sha256 = "sha256:1v1krqzvpmb39s42m5gg2p7phhp4spd0vkb4wlhfkgbhi20dk5w7";
  });
  inherit (nix-parsec) lexer parsec;
  inherit (pkgs) lib;
in

let
  red = parsec.string " red";
  green = parsec.string " green";
  blue = parsec.string " blue";

  color = parsec.choice [ red green blue ];
  colors = parsec.sepBy
    (parsec.sequence [
      lexer.decimal
      color
    ])
    (parsec.string ", ");

  game = parsec.sequence [
    # in order
    # first, parse a string matching Game plus a space
    (parsec.string "Game ")
    lexer.decimal
    (parsec.string ": ")
    # then match, in order
    (parsec.many
      (parsec.sequence [
        (parsec.thenSkip
          # followed by a list of colors separated by a comma and a space
          colors
          # ignoring a semicolon with a space after it
          (parsec.optional (parsec.string "; ")))
      ]))
  ];

  games = parsec.sequence [
    # list games separated by newlines
    (parsec.thenSkip
      (parsec.sepBy1 game (parsec.string "\n"))
      (parsec.string "\n"))
    # until the end of the file
    parsec.eof
  ];
in
{
  parseGameFile = path: parsec.runParser games (builtins.readFile path);
}
