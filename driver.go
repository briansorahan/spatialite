// Package spatialite is a thin wrapper around https://github.com/mattn/go-sqlite3
// that automatically loads the mod_spatialite extension.
package spatialite

// #define SQLITE_ENABLE_RTREE 1
// #include <sqlite3.h>
// #include <spatialite.h>
import "C"

import (
	"database/sql"

	sqlite "github.com/mattn/go-sqlite3"
)

// Driver is the spatialite driver.Driver implementation.
type Driver struct {
	*sqlite.SQLiteDriver
}

func init() {
	sql.Register("spatialite", &Driver{
		SQLiteDriver: &sqlite.SQLiteDriver{
			Extensions: []string{
				"mod_spatialite", // https://groups.google.com/forum/#!topic/golang-nuts/Kj0WKQaLBqY
			},
		},
	})
}
