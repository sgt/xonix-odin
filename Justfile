set windows-shell := ["cmd.exe", "/c"]

filename := "xonix"
common_flags := "-out:build/" + filename + ".exe -pdb-name:build/" + filename + ".pdb"
debug_flags := "-debug"
release_flags := "-o:speed"

alias b := build
alias r := run

default: (build "debug")

buildOrRun cmd target:
    if not exist build mkdir build
    odin {{cmd}} . {{common_flags}} {{if target == "release" { release_flags } else { debug_flags } }}

build target="debug": (buildOrRun "build" target)

run target="debug": (buildOrRun "run" target)
