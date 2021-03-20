#!/usr/bin/env bats

readonly rant=$BATS_TEST_DIRNAME/../rant
readonly tmpdir=$BATS_TEST_DIRNAME/../tmp
readonly stdout=$BATS_TEST_DIRNAME/../tmp/stdout
readonly stderr=$BATS_TEST_DIRNAME/../tmp/stderr
readonly exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  if [[ $BATS_TEST_NUMBER == 1 ]]; then
    mkdir -p -- "$tmpdir"
  fi
}

teardown() {
  if [[ ${#BATS_TEST_NAMES[@]} == $BATS_TEST_NUMBER ]]; then
    rm -rf -- "$tmpdir"
  fi
}

check() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'rant: print \w{8} if no arguments passed' {
  check "$rant"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\w{8}$/') != "" ]]
}

@test 'rant: change count if "-c" passed' {
  check "$rant" -c5
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | wc -l) == 5 ]]
}

@test 'rant: change count if "--count" passed' {
  check "$rant" --count 5
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | wc -l) == 5 ]]
}

@test 'rant: change expression if "-e" passed' {
  check "$rant" -e'[Vv]im ?[sS]cript'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^[Vv]im ?[sS]cript$/') != "" ]]
}

@test 'rant: change expression if "--expression" passed' {
  check "$rant" --expression '[Vv]im ?[sS]cript'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^[Vv]im ?[sS]cript$/') != "" ]]
}

@test 'rant: change separator if "-s" passed' {
  check "$rant" -s:: -c3
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\w{8}::\w{8}::\w{8}$/') != "" ]]
}

@test 'rant: change separator if "--separator" passed' {
  check "$rant" --separator :: -c3
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\w{8}::\w{8}::\w{8}$/') != "" ]]
}

@test 'rant: print usage if "--help" passed' {
  check "$rant" --help
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^usage ]]
}

@test 'rant: change expression if argument passed' {
  check "$rant" 'Hello world'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^Hello world$/') != "" ]]
}

@test 'rant: skip first argument if "-e" passed' {
  check "$rant" -e'[Vv]im ?[sS]cript' 'Hello world'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^[Vv]im ?[sS]cript$/') != "" ]]
}

@test 'rant: skip first argument if "--expression" passed' {
  check "$rant" --expression '[Vv]im ?[sS]cript' 'Hello world'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^[Vv]im ?[sS]cript$/') != "" ]]
}

@test 'rant-expression: digit character works' {
  check "$rant" '\d'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\d$/') != "" ]]
}

@test 'rant-expression: word character works' {
  check "$rant" '\w'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\w$/') != "" ]]
}

@test 'rant-expression: control character works' {
  check "$rant" '\t\n'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\t$/') != "" ]]
  [[ $(cat "$stdout" | wc -l) == 2 ]]
}

@test 'rant-expression: character list works' {
  check "$rant" '[abc][a-z][a-zA-Z]'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^[abc][a-z][a-zA-Z]$/') != "" ]]
}

@test 'rant-expression: escape works' {
  check "$rant" '\\d\\w\\t\\n\[\-\]\{\}\?\(\|\)'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\\d\\w\\t\\n\[\-\]\{\}\?\(\|\)$/') != "" ]]
}

@test 'rant-expression: repeat works' {
  check "$rant" 'a{3},b{5,10},c?'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^a{3},b{5,10},c?$/') != "" ]]
}

@test 'rant-expression: group works' {
  check "$rant" '(aaa|bbb|ccc)'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^(aaa|bbb|ccc)$/') != "" ]]
}

@test 'rant-expression: nested group works' {
  check "$rant" '(aaa|(bbb|(ccc|ddd)))'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^(aaa|(bbb|(ccc|ddd)))$/') != "" ]]
}

@test 'rant-expression: repeated group works' {
  check "$rant" '(aaa|bbb|ccc){3,5}'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^(aaa|bbb|ccc){3,5}$/') != "" ]]
}

@test 'rant-expression: complex expression works' {
  check "$rant" '\d\w\t[abc][a-z][a-zA-Z]\\d\\w\\t\\n\[\-\]\{\}\?\(\|\)A{3}B{5,10}C?(aaa|bbb|ccc)(aaa|(bbb|(ccc|ddd)))(aaa|bbb|ccc){3,5}'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout" | perl -nle'print if /^\d\w\t[abc][a-z][a-zA-Z]\\d\\w\\t\\n\[\-\]\{\}\?\(\|\)A{3}B{5,10}C?(aaa|bbb|ccc)(aaa|(bbb|(ccc|ddd)))(aaa|bbb|ccc){3,5}$/') != "" ]]
}

# vim: ft=bash
