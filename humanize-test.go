package main

import (
    "fmt"
    "math"
)

var sizes = []string{"B", "KB", "MB", "GB", "TB", "PB"}

// FormatBytes outputs the given number of bytes "s" as a human-readable string,
// rounding to the nearest half within .01.
func FormatBytes(s uint64) string {
	var e float64
	if s == 0 {
		e = 0
	} else {
		e = math.Floor(log(float64(s), 1000))
	}

	unit := uint64(math.Pow(1000, e))
	suffix := sizes[int(e)]

	return fmt.Sprintf("%s %s",
		FormatBytesUnit(s, unit), suffix)
}

// FormatBytesUnit outputs the given number of bytes "s" as a quantity of the
// given units "u" to the nearest half within .01.
func FormatBytesUnit(s, u uint64) string {
	var rounded float64
	if s < 10 {
		rounded = float64(s)
	} else {
		rounded = math.Floor(float64(s)/float64(u)*10+.5) / 10
	}

	format := "%.0f"
	if rounded < 10 && u > 1 {
		format = "%.1f"
	}

	return fmt.Sprintf(format, rounded)
}


// log takes the log base "b" of "n" (\log_b{n})
func log(n, b float64) float64 {
	return math.Log(n) / math.Log(b)
}



func main() {
    fmt.Printf("%s\n", FormatBytes(0))
}
