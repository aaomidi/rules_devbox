package parser

import (
	"encoding/json"
	"fmt"
	"io"
	"regexp"
)

type LockFile struct {
	LockfileVersion string             `json:"lockfile_version"`
	Packages        map[string]Package `json:"packages"`
}

type Package struct {
	LastModified string   `json:"last_modified"`
	Resolved     Resolved `json:"resolved"`
	Source       string   `json:"source"`
	Version      string   `json:"version"`
	// TODO(aaomidi@): Consider changing this to an enum of platforms?
	Systems map[string]System `json:"systems"`
}

type System struct {
	Outputs   []Output `json:"outputs"`
	StorePath string   `json:"store_path"`
}

type Output struct {
	Name    string `json:"name"`
	Path    string `json:"path"`
	Default bool   `json:"default,omitempty"`
}

type Resolved string

var resolvedPattern = regexp.MustCompile(`^([^:]+):([^/]+)/([^/]+)/([^#]+)#(.+)$`)

func (r Resolved) Commit() (string, error) {
	s := string(r)
	matches := resolvedPattern.FindStringSubmatch(s)
	if len(matches) < 6 {
		return "", fmt.Errorf("incorrect regexp")
	}
	return matches[4], nil
}

func ParseLockFile(reader io.Reader) (*LockFile, error) {
	lockfile := LockFile{}
	if err := json.NewDecoder(reader).Decode(&lockfile); err != nil {
		return nil, err
	}
	return &lockfile, nil
}

////
// TODO(@aaomidi): consider if I care about making the user write out the package name as it appears in the lockfile
// For example, go@latest vs go.
////
// type SearchableLockFile struct {
// 	Lockfile LockFile

// 	pkgSearch map[string]Package
// }

// func NewSearchableLockFile(l *LockFile) (*SearchableLockFile, error) {
// 	sl := SearchableLockFile{
// 		pkgSearch: make(map[string]Package),
// 	}

// 	for pkgName, pkg := range l.Packages {
// 		splitPkgName := strings.Split(pkgName, "@")
// 		if len(splitPkgName) < 2 {
// 			return nil, fmt.Errorf("package name should be pkg@version, instead it was: %s", pkgName)
// 		}
// 		// Take out the version string.
// 		splitPkgName = splitPkgName[:len(splitPkgName)-1]

// 	}

// 	return &SearchableLockFile{}
// }
