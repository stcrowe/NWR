// Open database
if (!isServer) exitWith {};

if(isNil "NWR_INI") then
{

	NWR_INI = true;

	private ["_missionName"];

	_missionName = [missionName, "%20","-"] call CBA_fnc_replace;

	NWR_DB = ["new", _missionName] call OO_INIDBI;

	publicVariableServer "NWR_INI";
	publicVariableServer "NWR_DB";

};