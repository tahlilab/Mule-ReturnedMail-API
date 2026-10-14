%dw 2.0
output application/json
// TODO lift-and-shift: map drained ASB envelopes into the Melissa facade
// request shape { jobId, requestRecords: [...] }. Source: Mule-Jhindexing-API
// src/main/resources/dwl/rtnMailMelissaReq.dwl
---
{
	jobId: vars.jobId default "",
	requestRecords: (payload default []) map (rec) -> {
		recordId: rec.correlationId default "",
		correlationId: rec.correlationId default ""
		// TODO: map recipient name/address fields
	}
}
