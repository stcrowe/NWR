if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};


//Delete old entry
["deleteSection", "MilOpcom"] call NWR_DB;

// Get all global objectives

_objectivesGlobal = [];
{
    if ([_x,"persistent",false] call ALIVE_fnc_HashGet) then {
        _objectivesGlobal = _objectivesGlobal + ([_x, "objectives",[]] call ALiVE_fnc_HashGet);
    };
} foreach OPCOM_INSTANCES;

// Lets setup a list of objectives to export


_blacklist = ["code","actions"];
_objectiveCount = 0;

{
    _objective = _x;

    _exportObjective = [_objective, [], _blacklist] call ALIVE_fnc_hashCopy;

    if([_exportObjective, "_rev"] call ALIVE_fnc_hashGet == "") then {
        [_exportObjective, "_rev"] call ALIVE_fnc_hashRem;
    };

    _data = [_exportObjective select 1, _exportObjective select 2];

    ["write", ["MilOpcom",format ["Objective-%1", _forEachIndex], _data]] call NWR_DB;
    _objectiveCount = _objectiveCount + 1;

} forEach _objectivesGlobal;


["write", ["MilOpcom", "Object_Count", _objectiveCount]] call NWR_DB;

["Saved Objectives"] call NWR_fnc_message;




