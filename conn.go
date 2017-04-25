package spatialite

// #include <sqlite3.h>
// #include <spatialite.h>
import "C"

import (
	"database/sql"
	"database/sql/driver"

	sqlite "github.com/mattn/go-sqlite3"
)

type Conn struct {
	*sqlite.SQLiteConn
}

type Driver struct {
	*sqlite.SQLiteDriver
}

func (d *Driver) Open(name string) (driver.Conn, error) {
	sqliteConn, err := d.SQLiteDriver.Open(name)
	if err != nil {
		return nil, err
	}
	return &Conn{
		SQLiteConn: sqliteConn.(*sqlite.SQLiteConn),
	}, nil
}

func init() {
	sql.Register("spatialite", &Driver{
		SQLiteDriver: &sqlite.SQLiteDriver{
			Extensions: []string{
				"libspatialite",
			},
		},
	})
}
