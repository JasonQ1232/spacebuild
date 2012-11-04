
TOOL.Category		= "Resource Distribution"
TOOL.Mode 			= "rd3_resdebug"
TOOL.Name			= "Res. Debuger"
TOOL.Command		= nil
TOOL.ConfigName		= nil
if (CLIENT and GetConVarNumber("CAF_UseTab") == 1) then TOOL.Tab = "Custom Addon Framework" end


if ( CLIENT ) then
	language.Add( "Tool_rd3_resdebug_name",	"RD Resource Debuger" )
	language.Add( "Tool_rd3_resdebug_desc",	"Spams teh ent's resource table to the console, Left Click = serverside, Right click = Clientside" )
	language.Add( "Tool_rd3_resdebugr_0", "Click an RD3 Ent" )
end

function TOOL:LeftClick( trace )
	if ( !trace.Entity:IsValid() ) then return false end
	if (CLIENT) then return true end
	CAF.GetAddon("Resource Distribution").PrintDebug(trace.Entity)
	return true
end

function TOOL:RightClick( trace )
	if ( !trace.Entity:IsValid() ) then return false end
	if (SERVER) then return true end
	CAF.GetAddon("Resource Distribution").PrintDebug(trace.Entity)
	return true
end

function TOOL:Reload( trace )
	if ( !trace.Entity:IsValid() ) then return false end
	if (CLIENT) then return true end
	--for something else
	return true
end