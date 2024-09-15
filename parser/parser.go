package parser

import (
	"encoding/json"
	"io"
)

type Lockfile struct {
	LockfileVersion string             `json:"lockfile_version"`
	Packages        map[string]Package `json:"packages"`
}

type Package struct {
	LastModified string `json:"last_modified"`
	Resolved     string `json:"resolved"`
	Source       string `json:"source"`
	Version      string `json:"version"`
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

func ParseLockFile(reader io.Reader) (*Lockfile, error) {
	lockfile := Lockfile{}
	if err := json.NewDecoder(reader).Decode(&lockfile); err != nil {
		return nil, err
	}
	return &lockfile, nil
}
