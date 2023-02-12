# Go Shebang

## Searching for an easy way to run a go file as a script

After searching multiple times for a way to run a go file with a shebang,
there were quite a few that give a `//` workaround.
However, most of these do not work after the `gofmt` code formatter, inserts
a space after the comment `//` on the first line.

I ran across this article 
["Story: Writing Scripts with Go"](https://gist.github.com/posener/73ffd326d88483df6b1cb66e8ed1e0bd)
which has a great writeup on the different ways to run a go file as a script.

In the article [@posener](https://gist.github.com/posener) ends up
recommending [`gorun`](https://github.com/erning/gorun)
or using the following shebang:

```go
//usr/bin/env go run "$0" "$@"; exit "$?"

package main
```

I found that the following shebang works better for me:

```go
// 2>/dev/null || /usr/bin/env go build -o "${0/.go/}" "$0" && ${0/.go/} "$@"; exit "$?";

package main
```
The cons of this shebang is that it:
* is rather long
* leaves an executable in the directory,

The remaining executable could be fixed, making the line slightly longer.
However, this does not cause any issues for me, so I left it.
It also works even after `gofmt` does its thing.

This actually solves the missing checkbox in @posener's table:

| Type | Exit Code | Executable | Compilable | Standard |
|------|-----------|------------|------------|----------|
| `go run` | ✘     | ✘          | ✔          | ✔        |
| `gorun`  | ✔     | ✔          | ✘          | ✘        |
| `//` Workaround | ✔ | ✔       | ✔          | ✔        |

## Other Functions

Two other functions that I have found useful are found in the [`golang-shell-functions.sh`](golang-shell-functions.sh) file.

These work with any go file, with a main function in the current directory.
It also works with any go files in the standard `cmd/<command>` directories.

### go-cmd

```bash
Usage: go-cmd <command>
```

Use this to run a go command which could be in the current directory 
or in the `cmd/` directory.

example:

```bash
$ go-cmd hello world
Hello world
$ echo $?
42
```

### go-build-cmds

```bash
Usage: go-build-cmds
```

Use this to build all the commands in the `cmd/` directory, and
any .go files in the current directory that have a main function.
