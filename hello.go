// 2>/dev/null || /usr/bin/env go build -o "${0/.go/}" "$0" && ${0/.go/} "$@"; exit "$?";
package main

import (
	"fmt"
	"os"
)

func main() {
	for _, arg := range os.Args[1:] {
		fmt.Println("Hello", arg)
	}
	os.Exit(42)
}
