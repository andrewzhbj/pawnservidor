
#define FILTERSCRIPT

#include <a_samp>
#include <Dini>
#include <Dutils>
#include <Dudb>

#define savefolder "/save/%s.ini"

#pragma unused ret_memcpy

new Killz[MAX_PLAYERS];
new Deathz[MAX_PLAYERS];



public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}


public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    new pname[128];
	new file[128];
	GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), savefolder,pname);
    if(!dini_Exists(file)) {
        dini_Create(file);
        dini_IntSet(file, "Score", 0);
        dini_IntSet(file, "Money", 0);
        dini_IntSet(file, "Kills", Killz[playerid]);
        dini_IntSet(file, "Deaths", Deathz[playerid]);
        dini_IntSet(file, "Skin", 0);
        SetPlayerScore(playerid, dini_Int(file, "Score"));
        SetPlayerMoney(playerid, dini_Int(file, "Money"));
        SetPlayerSkin(playerid, dini_Int(file, "Skin"));

    }
    else {
        SetPlayerScore(playerid, dini_Int(file, "Score"));
        SetPlayerMoney(playerid, dini_Int(file, "Money"));
        SetPlayerSkin(playerid, dini_Int(file, "Skin"));
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new pname[128];
	new file[128];
	GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), savefolder,pname);
    if(!dini_Exists(file)) {
    }
    else {
        dini_IntSet(file, "Score", GetPlayerScore(playerid));
        dini_IntSet(file, "Money", GetPlayerMoney(playerid));
        dini_IntSet(file, "Kills", Killz[playerid]);
        dini_IntSet(file, "Deaths", Deathz[playerid]);
        dini_IntSet(file, "Skin", GetPlayerSkin(playerid));
    }
	return 1;
}



public OnPlayerDeath(playerid, killerid, reason)
{
	Killz[killerid] ++;
	Deathz[playerid] ++;
	return 1;
}

