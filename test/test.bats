setup() {
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/..:$PATH"
}

@test "script can be executed" {
  podmatrix --help
  podmatrix exec --help
}

@test "container can be launched and terminated, no tag" {
  run podmatrix exec "exit 0" --image alpine
  [ "$status" -eq 0 ]
  run podmatrix exec "exit 1" --image alpine
  [ "$status" -eq 1 ]
}

@test "container can be launched and terminated, one tag" {
  podmatrix exec "echo" --image alpine --tag latest
}

@test "container can be launched and terminated, multiple tags" {
  podmatrix exec "echo" --image alpine --tag latest --tag edge
}

@test "container can be launched and terminated, multiple images and tags" {
  run podmatrix exec "python3.8 --version" --image python --image docker.io/pypy --tag 3.8 --tag 3.9
  [ "$status" -eq 127 ]
}

@test "python app can be tested, multiple tags" {
  run podmatrix exec "git clone https://github.com/jfhovinne/gnrt.git && cd gnrt && ./test.sh" --image python --tag 3.9 --tag 3.10
  [ "$status" -eq 0 ]
}
