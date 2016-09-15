if (!isServer) exitWith {};

if (isNil "NWR_DEBUG") exitWith {};

params [["_message", nil]];

if (isNil "_message") exitWith {};

[player, Format["%1", _message]] remoteExecCall ['sideChat',[0,-2] select (isMultiplayer && isDedicated)];

