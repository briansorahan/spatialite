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
	"io/ioutil"
	"os"
	"path/filepath"

	sqlite "github.com/mattn/go-sqlite3"
)

const home = "/go/src/github.com/briansorahan/spatialite"

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
	conn, err := d.SQLiteDriver.Open(name)
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
	if err := loadEpsgTable(conn); err != nil {
		return nil, err
	}
	return &Conn{
		SQLiteConn: conn.(*sqlite.SQLiteConn),
	}, nil
}

func loadEpsgTable(conn driver.Conn) error {
	f, err := os.Open(filepath.Join(home, "epsg-sqlite.sql"))
	if err != nil {
		return err
	}
	epsgSQL, err := ioutil.ReadAll(f)
	if err != nil {
		return err
	}
	epsgStmt, err := conn.Prepare(string(epsgSQL))
	if err != nil {
		return err
	}
	defer func() { _ = epsgStmt.Close() }()

	if _, err := epsgStmt.Exec(nil); err != nil {
		return err
	}
	return nil
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
