#!/usr/bin/env bats
# vim:set ft=sh sw=2 ts=2 et:

source "$BATS_TEST_DIRNAME/../config-parser.sh"
config_parser "$BATS_TEST_DIRNAME/../example.ini"

@test "Does not pollute environment on initial run" {
  [ -z "$foofoofoo" ]
}

@test "Assigns environment for a section" {
  # eval "$output"
  config.section.dev
  [ "$foofoofoo" = "foo bar" ]
}

@test "Handles space sperated assignments" {
  # eval "$output"
  config.section.prod
  [ "$foofoofoo" = "bar foo" ]
}

@test "Ignores comments" {
  # eval "$output"
  config.section.prod
  [ -z "$baz" ]
}

@test "Is composable" {
  skip "Not implemented"
  run cat "$BATS_TEST_DIRNAME/fixtures/example.ini" | config_parser
  eval "$output"
  config.section.int
  [ "$foofoofoo" = "works" ]
}
