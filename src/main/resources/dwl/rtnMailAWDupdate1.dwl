%dw 2.0
output application/json
// TODO lift-and-shift: build the AWD work-item update payload for the
// subscribe flow (exclusion decision). Source: Mule-Jhindexing-API
// src/main/resources/dwl/rtnMailAWDupdate1.dwl
---
{
	awdWorkItemId: vars.awdWorkItemId default "",
	excludedFromNcoaApi: vars.excluded default false,
	exclusionReason: vars.exclusionReason default ""
}
