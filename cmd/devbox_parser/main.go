package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/aaomidi/rules_devbox/parser"
)

var lockfilePath = flag.String("path", "", "Path to the lockfile to parse")

func main() {
	flag.Parse()
	if err := _main(); err != nil {
		log.Fatalf("Error occured: %q", err)
	}
}

func parseLockFile() (*parser.LockFile, error) {
	if *lockfilePath == "" {
		return nil, fmt.Errorf("lockfile path required")
	}
	file, err := os.OpenFile(*lockfilePath, os.O_RDONLY, 0)
	if err != nil {
		return nil, err
	}
	lockfile, err := parser.ParseLockFile(file)
	if err != nil {
		return nil, err
	}

	return lockfile, nil
}

func _main() error {
	subCommand := flag.Arg(0)

	var err error
	switch subCommand {
	case "commit":
		err = cmdCommit()
	}

	if err != nil {
		return err
	}

	return nil
}

var pkgName = flag.String("pkg", "", "Name of the packge to search for")

func cmdCommit() error {
	lf, err := parseLockFile()
	if err != nil {
		return err
	}

	pkg, ok := lf.Packages[*pkgName]
	if !ok {
		return fmt.Errorf("package not found: %s", *pkgName)
	}

	cmt, err := pkg.Resolved.Commit()
	if err != nil {
		return err
	}
	fmt.Println(cmt)
	return nil
}
