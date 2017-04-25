package spatialite_test

import (
	"database/sql"
	"testing"

	_ "github.com/briansorahan/spatialite" // Register the spatialite driver.
)

func TestOpen(t *testing.T) {
	if _, err := sql.Open("spatialite", "test.db"); err != nil {
		t.Fatal(err)
	}
}

func TestTable(t *testing.T) {
	db := testDB("test.db", t)

	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS spatialite_test (
                               test_geom ST_Geometry
                           )`); err != nil {
		t.Fatal(err)
	}
}

func TestBufferGeoJSON(t *testing.T) {
	db := testDB("test.db", t)

	rows, err := db.Query(`SELECT AsGeoJSON(GeomFromGeoJSON('{"type":"Point","coordinates":[0,0]}'));`)
	if err != nil {
		t.Fatal(err)
	}
	if !rows.Next() {
		t.Fatal("cannot iterate over rows")
	}
}

func testDB(db string, t *testing.T) *sql.DB {
	conn, err := sql.Open("spatialite", db)
	if err != nil {
		t.Fatal(err)
	}
	return conn
}
