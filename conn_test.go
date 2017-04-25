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
