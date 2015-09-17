#!/usr/bin/env bats
# vim:set ft=sh sw=2 ts=2 et:

source "$BATS_TEST_DIRNAME/../config-parser.sh"

setup() {
  run parse_ini "$BATS_TEST_DIRNAME/fixtures/example.ini"
  eval "$output"
}

@test "Does not pollute environment on initial run" {
  [ -z "$foofoofoo" ]
}

@test "Provides a default config.global section" {
  config.global
  [ "$foofoofoo" = "global variables" ]
}

@test "Assigns environment for a section" {
  config.section.dev
  [ "$foofoofoo" = "foo bar" ]
}

@test "Handles space sperated assignments" {
  config.section.prod
  [ "$foofoofoo" = "bar foo" ]
}

@test "Handles sections with no variables" {
  run config.section.empty_section
  [ "$status" = 0 ]
}

@test "Ignores comments" {
  config.section.prod
  [ -z "$baz" ]
}

@test "Gracefully handles missing files" {
  run parse_ini "$BATS_TEST_DIRNAME/fixtures/nonexistent.ini"
  [ "$status" -ne 0 ] # returns with an error code
  run eval "$output"
  [ "$status" -eq 0 ] # output can be parsed by eval
}

@test "Gracefully handles an empty file" {
  run parse_ini "$BATS_TEST_DIRNAME/fixtures/empty.ini"
  run eval "$output"
  [ "$status" -eq 0 ] # output can be parsed by eval
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
