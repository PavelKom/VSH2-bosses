#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <clientprefs>

#include <morecolors>
#include <vsh2>

char hostName[256];
char bossNames[128];

public Plugin myinfo = {
	name = "VSH2 server rename plugin",
	author = "PavelKom",
	description = "",
	version = "0.1",
	url = "bans.gamingfortress.ru"
};

enum struct VSH2ServerRenameCVars {
	ConVar server_name_pre; 
	ConVar bossNameMSG;
	ConVar bossCountMSG;
	ConVar maplenMSG;
	ConVar server_name_post;
	ConVar diffChar;
	ConVar bossNameShow;
	ConVar bossCountShow;
	ConVar maplenShow;
}
/**
Hostname structure (255 symbols max):

"server_name_pre | <bossNamePre> bossNameMSG <bossNamePost> | <bossCountPre> bossCountMSG <bossCountPost> |<maplistLengthPre> maplenMSG <maplistLengthPost> "
         diffchar^
		 
bossNameShow, bossCountShow, maplenShow:
0 - Not show
1 - Show <Pre> MSG
2 - Show MSG <Post>
**/

VSH2ServerRenameCVars g_sr_cvars;

public void OnLibraryAdded(const char[] name) {
	if( StrEqual(name, "VSH2") ) {
		CvarsInit();
		CMDInit();
		LoadVSH2Hooks();
	}
}

public void CvarsInit()
{
	g_sr_cvars.server_name_pre = CreateConVar("vsh2_hostname_pre", "Versus Saxton Hale 2", "1st part of hostname",FCVAR_NOTIFY);
	g_sr_cvars.diffChar = CreateConVar("vsh2_hostname_diffchar", " | ", "Separator character or string",FCVAR_NOTIFY);
	g_sr_cvars.server_name_post = CreateConVar("vsh2_hostname_post", "", "Last part of hostname",FCVAR_NOTIFY);
	
	g_sr_cvars.bossNameMSG = CreateConVar("vsh2_bossname_msg", "Current boss(es): ", "Bossname message",FCVAR_NOTIFY);
	g_sr_cvars.bossNameShow = CreateConVar("vsh2_bossname_pos", "2", "0 - disable bossname msg, 1 - <bossname> bossnameMSG, 2 - bossnameMSG <bossname>",FCVAR_NOTIFY, true, 0.0, true, 2.0);
	
	g_sr_cvars.bossCountMSG = CreateConVar("vsh2_bosscount_msg", "Bosses: ", "Bosscount message",FCVAR_NOTIFY);
	g_sr_cvars.bossCountShow = CreateConVar("vsh2_bosscount_pos", "2", "0 - disable bosscount msg, 1 - <bosscount> bosscountMSG, 2 - bosscountMSG <bosscount>",FCVAR_NOTIFY, true, 0.0, true, 2.0);
	
	g_sr_cvars.maplenMSG = CreateConVar("vsh2_mapcount_msg", "Maps: ", "Maplist length message",FCVAR_NOTIFY);
	g_sr_cvars.maplenShow = CreateConVar("vsh2_mapcount_pos", "2", "0 - disable mapcount msg, 1 - <mapcount> mapcountMSG, 2 - mapcountMSG <mapcount>",FCVAR_NOTIFY, true, 0.0, true, 2.0);
	
	AutoExecConfig(true, "VSH2_server_rename");
}

public void CMDInit()
{
	RegAdminCmd("sm_vsh2_server_rename", UpdateHostnameCMD, ADMFLAG_RCON);
	RegAdminCmd("sm_vsh2_hostname_rename", UpdateHostnameCMD, ADMFLAG_RCON);
}

public Action UpdateHostnameCMD(int client, int args)
{
	ServerCommand("exec sourcemod/VSH2_server_rename.cfg");
	//char bufString[256];
	
	g_sr_cvars.server_name_pre = FindConVar("vsh2_hostname_pre");
	g_sr_cvars.diffChar = FindConVar("vsh2_hostname_diffchar");
	g_sr_cvars.server_name_post = FindConVar("vsh2_hostname_post");
	
	g_sr_cvars.bossNameMSG = FindConVar("vsh2_bossname_msg");
	g_sr_cvars.bossNameShow = FindConVar("vsh2_bossname_pos");
	
	g_sr_cvars.bossCountMSG = FindConVar("vsh2_bosscount_msg");
	g_sr_cvars.bossCountShow = FindConVar("vsh2_bosscount_pos");
	
	g_sr_cvars.maplenMSG = FindConVar("vsh2_mapcount_msg");
	g_sr_cvars.maplenShow = FindConVar("vsh2_mapcount_pos");
	
	
	/*
	FindConVar("vsh2_hostname_pre").GetString(bufString, sizeof(bufString));
	g_sr_cvars.server_name_pre.SetSting(bufString);
	FindConVar("vsh2_hostname_diffchar").GetString(bufString, sizeof(bufString));
	g_sr_cvars.diffChar.SetSting(bufString);
	FindConVar("vsh2_hostname_post").GetString(bufString, sizeof(bufString));
	g_sr_cvars.server_name_post.SetSting(bufString);
	
	FindConVar("vsh2_bossname_msg").GetString(bufString, sizeof(bufString));
	g_sr_cvars.bossNameMSG.SetSting(bufString);
	g_sr_cvars.bossNameShow.IntValue = FindConVar("vsh2_bossname_pos").IntValue;
	
	FindConVar("vsh2_bosscount_msg").GetString(bufString, sizeof(bufString));
	g_sr_cvars.bossCountMSG.SetSting(bufString);
	g_sr_cvars.bossCountShow.IntValue = FindConVar("vsh2_bosscount_pos").IntValue;
	
	FindConVar("vsh2_mapcount_msg").GetString(bufString, sizeof(bufString));
	g_sr_cvars.maplenMSG.SetSting(bufString);
	g_sr_cvars.maplenShow.IntValue = FindConVar("vsh2_mapcount_pos").IntValue;
	*/
	
	PrintToServer("[VSH2 Server Renamer] Convars updated from cfg-file");
	ConstructHostname();
}

public void LoadVSH2Hooks()
{
	HookEvent("arena_round_start", ArenaRoundStart);
}

public Action ArenaRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	bossNames[0] = '\0';
	int bosscount = 0;
	char bossNameBuf[MAX_BOSS_NAME_SIZE];
	VSH2Player boss;
	for(int i=MaxClients; i; --i) {
		if( !IsValidClient(i) )
			continue;
		
		boss = VSH2Player(i);
		if( !boss.GetPropInt("bIsBoss") )
			continue;
		
		boss.GetName(bossNameBuf);
		if (!bosscount)
			Format(bossNames, sizeof(bossNames), "%s", bossNameBuf);
		else
			Format(bossNames, sizeof(bossNames), "%s, %s", bossNames, bossNameBuf);
		bosscount++;
	}
	if (!bosscount)
		Format(bossNames, sizeof(bossNames), "NONE");
	
	ConstructHostname();
}

ArrayList g_MapList = null;
int g_MapListSerial = -1;

public int CreateMaplistArray()
{
	ReadMapList(g_MapList, g_MapListSerial, "mapcyclefile", MAPLIST_FLAG_CLEARARRAY|MAPLIST_FLAG_NO_DEFAULT);
	
	return g_MapList.Length;
}

public void ConstructHostname()
{
	hostName[0] = '\0';
	
	char nameBuf[256];
	char diffChar[16];
	
	int bossCount = VSH2_GetMaxBosses() + 1;
	
	g_sr_cvars.diffChar.GetString(diffChar, sizeof(diffChar));
	
	g_sr_cvars.server_name_pre.GetString(nameBuf, sizeof(nameBuf));
	Format(hostName, sizeof(hostName),"%s", nameBuf);
	
	g_sr_cvars.bossNameMSG.GetString(nameBuf, sizeof(nameBuf));
	switch(g_sr_cvars.bossNameShow.IntValue)
	{
		case 1:
			Format(hostName, sizeof(hostName),"%s%s%s%s", hostName, diffChar, bossNames, nameBuf);
		case 2:
			Format(hostName, sizeof(hostName),"%s%s%s%s", hostName, diffChar, nameBuf, bossNames);
	}
	
	g_sr_cvars.bossCountMSG.GetString(nameBuf, sizeof(nameBuf));
	switch(g_sr_cvars.bossCountShow.IntValue)
	{
		case 1:
			Format(hostName, sizeof(hostName),"%s%s%i%s", hostName, diffChar, bossCount, nameBuf);
		case 2:
			Format(hostName, sizeof(hostName),"%s%s%s%i", hostName, diffChar, nameBuf, bossCount);
	}
	
	int mapCount = CreateMaplistArray();
	if(mapCount && g_sr_cvars.maplenShow.IntValue)
	{
		g_sr_cvars.maplenMSG.GetString(nameBuf, sizeof(nameBuf));
		switch(g_sr_cvars.maplenShow.IntValue)
		{
			case 1:
				Format(hostName, sizeof(hostName),"%s%s%i%s", hostName, diffChar, mapCount, nameBuf);
			case 2:
				Format(hostName, sizeof(hostName),"%s%s%s%i", hostName, diffChar, nameBuf, mapCount);
		}
	}
}

/// Stocks =============================================
stock bool IsValidClient(const int client, bool nobots=false)
{ 
	if( client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)) )
		return false; 
	return IsClientInGame(client); 
}
