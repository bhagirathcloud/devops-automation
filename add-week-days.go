package main

import (
	"fmt"
	"time"
)

//AddWeekDays : Add weeks days to a date excluding weekends (Saturday & Sunday)
func AddWeekDays(t time.Time, AddDays int) time.Time {
	additionalDays := 0
	calculatedDays := 0
	for i := 0; i <= AddDays; i++ {
		t2 := t.AddDate(0, 0, i)
		if t2.Weekday() == time.Saturday && i == AddDays {
			additionalDays += 2
		}
		if (t2.Weekday() == time.Sunday && i == AddDays) || ((t2.Weekday() == time.Saturday || t2.Weekday() == time.Sunday) && i != AddDays) {
			additionalDays++
		}
		calculatedDays = additionalDays + AddDays
	}
	//Make sure additional days doesn't fall in weekend
	t3 := t.AddDate(0, 0, calculatedDays)
	if t3.Weekday() == time.Saturday {
		calculatedDays += 2
		return t.AddDate(0, 0, calculatedDays)
	} else if t3.Weekday() == time.Sunday {
		calculatedDays++
		return t.AddDate(0, 0, calculatedDays)
	} else {
		return t.AddDate(0, 0, calculatedDays)
	}
}

func main() {
	now := time.Now()
	workDays := 3
	t := AddWeekDays(now, workDays)
	fmt.Println(now.Weekday(), now)
	fmt.Println(t.Weekday(), t)
}
