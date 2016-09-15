if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};


// Get objective count
_objectiveCount = ["read", ["MilOpcom", "Object_Count", 0]] call NWR_DB;

// Are there any objectives saved?
if (_objectiveCount == 0) exitWith {["No objectives found"] call NWR_fnc_message;};

// Get a array in CBA Hash format
_allObjectivesCBA_Hash = [];

for [{_i = 0},{_i < _objectiveCount},{_i = _i+1}] do
{
    _key = format ["Objective-%1", _i];

    _data = ["read", ["MilOpcom", _key, nil]] call NWR_DB;
    _objectiveHash = ["#CBA_HASH#", _data select 0, _data select 1, nil];
    _allObjectivesCBA_Hash append [_objectiveHash];
};


{
    _opcom = _x;

    _opcomControlType = [_opcom,"controltype","invasion"] call ALiVE_fnc_HashGet;
    _opcomID = [_opcom,"opcomID",""] call ALiVE_fnc_HashGet;

    if ([_opcom,"persistent",false] call ALIVE_fnc_HashGet) then {

        // commented out because we can't start opcoms
        //_stopped = [_opcom, "stop"] call ALiVE_fnc_OPCOM;

        [format ["%1 %2", _opcomID, _stopped]] call NWR_fnc_message;

        _opcomObjectives = [];
        {

             _id = [_x,"opcomID",""] call ALiVE_fnc_HashGet;

            if (!isNil "_id") then
            {
                if (_id == _opcomID) then {

                    _rev = [_x,"_rev",""] call ALiVE_fnc_HashGet;

                    [_x, "_id"] call ALIVE_fnc_hashRem;
                    [_x, "_rev"] call ALIVE_fnc_hashRem;

                    [_x,"_rev",_rev] call ALiVE_fnc_HashSet;

                    _opcomObjectives pushback _x;
                };
            };

        } forEach (_allObjectivesCBA_Hash);


        _keys = [
            "objectiveID","center","size","type","priority","opcom_state","clusterID","opcomID",
            "opcom_orders","danger","sectionAssist","section","tacom_state",
            "factory","HQ","ambush","depot","sabotage","ied","suicide","roadblocks",
            "actionsFulfilled",
            "_rev"
        ];

        {
            _objective = _x;

            _target = [nil, "createhashobject"] call ALIVE_fnc_OPCOM;

            {
                _data = [_objective, _x] call ALiVE_fnc_HashGet;

                if !(isnil "_data") then {
                    [_target, _x, _data] call ALiVE_fnc_HashSet;
                } else {
                    [_target, _x] call ALiVE_fnc_HashRem;
                };
            } forEach _keys;

            _opcomObjectives set [_foreachIndex,_target];
        } forEach _opcomObjectives;

        [_opcom,"objectives",_opcomObjectives] call ALiVE_fnc_HashSet;
        [_opcom,"clusteroccupation",[]] call ALiVE_fnc_HashSet;

        _opcomObjectives = [_opcom,"objectives",[]] call ALiVE_fnc_HashGet;
        {
            private ["_oID","_section","_orders","_state"];

            _objective = _x;

            _oID = [_objective,"objectiveID",""] call ALiVE_fnc_HashGet;
            _section = [_objective,"section",[]] call ALiVE_fnc_HashGet;

            if !(isnil "_section") then {{[_opcom,"resetorders",_x] call ALiVE_fnc_OPCOM} foreach _section};

            if !(isnil "_oID") then {
                switch ([_opcom,"controltype","invasion"] call ALiVE_fnc_HashGet) do {
                    case ("asymmetric") : {
                        [_opcom,"initObjective",_oID] call ALiVE_fnc_OPCOM;
                    };

                    default {
                        [_opcom,"resetObjective",_oID] call ALiVE_fnc_OPCOM;
                    };
                };
            };
        } forEach _opcomObjectives;

        [_opcom,"objectives",_opcomObjectives] call ALiVE_fnc_HashSet;

        // Opcom can't be restarted due to errors - waiting for ALiVE  fix
        /*
        switch (_opcomControlType ) do {
            case ("occupation") : {

                    _OPCOM = [_opcom] execFSM "\x\alive\addons\mil_opcom\opcom.fsm";
                    _TACOM = [_opcom] execFSM "\x\alive\addons\mil_opcom\tacom.fsm";

                    [_opcom, "OPCOM_FSM",_OPCOM] call ALiVE_fnc_HashSet;
                    [_opcom, "TACOM_FSM",_TACOM] call ALiVE_fnc_HashSet;
            };
            case ("invasion") : {

                    _OPCOM = [_opcom] execFSM "\x\alive\addons\mil_opcom\opcom.fsm";
                    _TACOM = [_opcom] execFSM "\x\alive\addons\mil_opcom\tacom.fsm";

                    [_opcom, "OPCOM_FSM",_OPCOM] call ALiVE_fnc_HashSet;
                    [_opcom, "TACOM_FSM",_TACOM] call ALiVE_fnc_HashSet;
            };
            case ("asymmetric") : {
                _OPCOM = [_opcom] execFSM "\x\alive\addons\mil_opcom\insurgency.fsm";

                [_opcom, "OPCOM_FSM",_OPCOM] call ALiVE_fnc_HashSet;
                [_opcom, "TACOM_FSM",-1] call ALiVE_fnc_HashSet;
            };
        };*/
    };

} foreach OPCOM_INSTANCES;

["Objectives Loaded"] call NWR_fnc_message;
