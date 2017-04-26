// Package spatialite is a thin wrapper around https://github.com/mattn/go-sqlite3
// that automatically loads the mod_spatialite extension.
package spatialite

// #define SQLITE_ENABLE_RTREE 1
// #include <sqlite3.h>
// #include <spatialite.h>
import "C"

import (
	"database/sql"
	"database/sql/driver"

	sqlite "github.com/mattn/go-sqlite3"
)

// Conn is a spatialite database connection.
type Conn struct {
	*sqlite.SQLiteConn
}

// Driver is the spatialite driver.Driver implementation.
type Driver struct {
	*sqlite.SQLiteDriver
}

// Open opens a new database connection.
func (d *Driver) Open(name string) (driver.Conn, error) {
	slconn, err := d.SQLiteDriver.Open(name)
	if err != nil {
		return nil, err
	}
	// https://www.gaia-gis.it/gaia-sins/spatialite-cookbook/html/metadata.html
	stmt, err := slconn.Prepare(`SELECT InitSpatialMetaData(1)`)
	if err != nil {
		return nil, err
	}
	defer func() { _ = stmt.Close() }()

	rows, err := stmt.Query(nil)
	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}
	defer func() { _ = rows.Close() }()

	if err != sql.ErrNoRows {
		if err := rows.Next(nil); err != nil {
			return nil, err
		}
	}
	return &Conn{
		SQLiteConn: slconn.(*sqlite.SQLiteConn),
	}, nil
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
