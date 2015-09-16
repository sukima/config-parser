#!/usr/bin/env bats
# vim:set ft=sh sw=2 ts=2 et:

source "$BATS_TEST_DIRNAME/../config-parser.sh"

setup() {
  run parse_ini "$BATS_TEST_DIRNAME/fixtures/example.ini"
}

@test "Does not pollute environment on initial run" {
  [ -z "$foofoofoo" ]
}

@test "Assigns environment for a section" {
  eval "$output"
  config.section.dev
  [ "$foofoofoo" = "foo bar" ]
}

@test "Handles space sperated assignments" {
  eval "$output"
  config.section.prod
  [ "$foofoofoo" = "bar foo" ]
}

@test "Ignores comments" {
  eval "$output"
  config.section.prod
  [ -z "$baz" ]
}

@test "Is composable" {
  run cat "$BATS_TEST_DIRNAME/fixtures/example.ini" | parse_ini
  eval "$output"
  config.section.int
  [ "$foofoofoo" = "works" ]
}

@test "Offers a one-off command for convinience" {
  config_parser "$BATS_TEST_DIRNAME/fixtures/example.ini"
  config.section.test
  [ "$foofoofoo" = "works-again" ]
}
