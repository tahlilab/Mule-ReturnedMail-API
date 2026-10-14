%dw 2.0
output application/json
// TODO lift-and-shift: build the payload posted to mulegenai-address-lookup-req.
// Source: Mule-Jhindexing-API src/main/resources/dwl/rtnMailPostQueue1.dwl
---
{
	correlationId: correlationId default "",
	awdWorkItemId: vars.awdWorkItemId default "",
	alfrescoNodeId: vars.alfrescoNodeId default ""
	// TODO: include recipient name/address + business area
}
