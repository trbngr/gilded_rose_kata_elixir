{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = with pkgs; [
    git
    beam27Packages.elixir-ls
  ];

  languages.elixir.enable = true;

  enterShell = ''
    echo ------
    echo "Gilded Rose Kata in Elixir"
    echo ------
    elixir --version | awk 'NF' | tac
    git --version | sed 's/^\(.\)/\U\1/'
    echo ------
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    mix test
  '';

  # See full reference at https://devenv.sh/reference/options/
}
