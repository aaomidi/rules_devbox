package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/aaomidi/rules_devbox/parser"
)

var pathToParse = flag.String("path", "", "Path to the lockfile to parse")

func main() {
	flag.Parse()

	if *pathToParse == "" {
		panic("path flag is required")
	}

	file, err := os.OpenFile(*pathToParse, os.O_RDONLY, 0)
	if err != nil {
		panic(err)
	}

	lockfile, err := parser.ParseLockFile(file)
	if err != nil {
		panic(err)
	}

	fmt.Println(lockfile)
}
