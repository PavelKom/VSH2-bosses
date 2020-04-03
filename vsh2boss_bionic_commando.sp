#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2_stocks>
#include <vsh2>

#undef REQUIRE_PLUGIN
#tryinclude <tf2attributes>
#define REQUIRE_PLUGIN

///Simple boss constructed on vsh2boss_template.sp
///VSH2 2.6.15

///Materials (only .bz2): https://yadi.sk/d/ASEDxuUPh9-tVw

#define BionicCommandoModel    "models/freak_fortress_2/bionic_commando/bionic.mdl"

/// voicelines
char BionicCommandoIntro[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_intro.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_intro2.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_intro3.mp3"
};

char BionicCommandoJump[][] = {
	"weapons/rocket_ll_shoot.wav"
};
/*
char BionicCommandoStab[][] = {
	"template_snd/stab1.mp3",
	"template_snd/stab2.mp3"
};
*/
char BionicCommandoDeath[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_fail.mp3"
};

char BionicCommandoLast[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_lastman.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_lastman2.mp3"
};

char BionicCommandoRage[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_rage.mp3"
};

char BionicCommandoKill[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_kill_scout.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_soldier.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_pyro.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_demo.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_heavy.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_engy.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_medic.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_sniper.mp3",
	"freak_fortress_2/bioniccommando/bionic_commando_kill_spy.mp3"
};

char BionicCommandoSpree[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_killingspree.mp3"
};

char BionicCommandoWin[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_win.mp3"
};

char BionicCommandoThemes[][] = {
	"freak_fortress_2/bioniccommando/bionic_commando_theme.mp3"
};

float BionicCommandoThemesTime[] = {
	76.0
};

char BionicCommandoMaterial[][] = {
	"materials/freak_fortress_2/bionic_commando/engineer_blue.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_blue.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_head_blue.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_head_blue.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_head_normal.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_head_red.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_head_red.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand_blue.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand_blue.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand_blue_invun.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_mech_hand_invun.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_normal.vtf",
	"materials/freak_fortress_2/bionic_commando/engineer_red.vmt",
	"materials/freak_fortress_2/bionic_commando/engineer_red.vtf"
};


public Plugin myinfo = {
	name = "VSH2 Bionic Commando",
	author = "FF2: Spectre143; VSH2: PavelKom",
	description = "Bionic Commando boss plugin (ported from FF2)",
	version = "1.0",
	url = "bans.gamingfortress.ru"
};

int g_iBionicCommandoID;

enum struct VSH2CVars {
	ConVar scout_rage_gen;
	ConVar airblast_rage;
	ConVar jarate_rage;
}

VSH2CVars g_vsh2_cvars;


public void OnLibraryAdded(const char[] name) {
	if( StrEqual(name, "VSH2") ) {
		g_vsh2_cvars.scout_rage_gen = FindConVar("vsh2_scout_rage_gen");
		g_vsh2_cvars.airblast_rage = FindConVar("vsh2_airblast_rage");
		g_vsh2_cvars.jarate_rage = FindConVar("vsh2_jarate_rage");
		g_iBionicCommandoID = VSH2_RegisterPlugin("bionic_commando");
		LoadVSH2Hooks();
	}
}

public void LoadVSH2Hooks()
{
	if( !VSH2_HookEx(OnCallDownloads, BionicCommando_OnCallDownloads) )
		LogError("Error loading OnCallDownloads forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossMenu, BionicCommando_OnBossMenu) )
		LogError("Error loading OnBossMenu forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossSelected, BionicCommando_OnBossSelected) )
		LogError("Error loading OnBossSelected forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossThink, BionicCommando_OnBossThink) )
		LogError("Error loading OnBossThink forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossModelTimer, BionicCommando_OnBossModelTimer) )
		LogError("Error loading OnBossModelTimer forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossEquipped, BionicCommando_OnBossEquipped) )
		LogError("Error loading OnBossEquipped forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossInitialized, BionicCommando_OnBossInitialized) )
		LogError("Error loading OnBossInitialized forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossPlayIntro, BionicCommando_OnBossPlayIntro) )
		LogError("Error loading OnBossPlayIntro forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnPlayerKilled, BionicCommando_OnPlayerKilled) )
		LogError("Error loading OnPlayerKilled forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnPlayerHurt, BionicCommando_OnPlayerHurt) )
		LogError("Error loading OnPlayerHurt forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnPlayerAirblasted, BionicCommando_OnPlayerAirblasted) )
		LogError("Error loading OnPlayerAirblasted forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossMedicCall, BionicCommando_OnBossMedicCall) )
		LogError("Error loading OnBossMedicCall forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossTaunt, BionicCommando_OnBossMedicCall) )
		LogError("Error loading OnBossTaunt forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossJarated, BionicCommando_OnBossJarated) )
		LogError("Error loading OnBossJarated forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnRoundEndInfo, BionicCommando_OnRoundEndInfo) )
		LogError("Error loading OnRoundEndInfo forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnMusic, BionicCommando_Music) )
		LogError("Error loading OnBossDealDamage forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnBossDeath, BionicCommando_OnBossDeath) )
		LogError("Error loading OnBossDeath forwards for BionicCommando subplugin.");
	
	//if( !VSH2_HookEx(OnBossTakeDamage_OnStabbed, BionicCommando_OnStabbed) )
	//	LogError("Error loading OnBossTakeDamage_OnStabbed forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnLastPlayer, BionicCommando_OnLastPlayer) )
		LogError("Error loading OnLastPlayer forwards for BionicCommando subplugin.");
	
	if( !VSH2_HookEx(OnSoundHook, BionicCommando_OnSoundHook) )
		LogError("Error loading OnSoundHook forwards for BionicCommando subplugin.");
}



stock bool IsBionicCommando(const VSH2Player player) {
	return player.GetPropInt("iBossType") == g_iBionicCommandoID;
}


public void BionicCommando_OnCallDownloads()
{
	PrepareModel(BionicCommandoModel);
	DownloadSoundList(BionicCommandoIntro, sizeof(BionicCommandoIntro));
	DownloadSoundList(BionicCommandoJump, sizeof(BionicCommandoJump));
	//DownloadSoundList(BionicCommandoStab, sizeof(BionicCommandoStab));
	DownloadSoundList(BionicCommandoDeath, sizeof(BionicCommandoDeath));
	DownloadSoundList(BionicCommandoLast, sizeof(BionicCommandoLast));
	DownloadSoundList(BionicCommandoRage, sizeof(BionicCommandoRage));
	DownloadSoundList(BionicCommandoKill, sizeof(BionicCommandoKill));
	DownloadSoundList(BionicCommandoSpree, sizeof(BionicCommandoSpree));
	DownloadSoundList(BionicCommandoWin, sizeof(BionicCommandoWin));
	DownloadSoundList(BionicCommandoThemes, sizeof(BionicCommandoThemes));
	
	DownloadMaterialList(BionicCommandoMaterial, sizeof(BionicCommandoMaterial));
}

public void BionicCommando_OnBossMenu(Menu &menu)
{
	char tostr[10]; IntToString(g_iBionicCommandoID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Bionic Commando");
}

public void BionicCommando_OnBossSelected(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	
	player.SetPropInt("iCustomProp", 0);
	player.SetPropFloat("flCustomProp", 0.0);
	player.SetPropAny("hCustomProp", player);
	
	Panel panel = new Panel();
	panel.SetTitle("Bionic Commando:\nTactical assessment: enemy victory... impossible.\nRocket boots(Super Jump): alt-fire, look up and stand up.\nWeigh-down: in midair, look down and crouch\nRage (Redeemer+low-distance stun): taunt when the Rage Meter is full.");
	panel.DrawItem("Exit");
	panel.Send(player.index, HintPanel, 50);
	delete panel;
}

public void BionicCommando_OnBossThink(const VSH2Player player)
{
	int client = player.index;
	if( !IsPlayerAlive(client) || !IsBionicCommando(player) )
		return;
	
	VSH2_SpeedThink(player, 340.0);
	VSH2_GlowThink(player, 0.1);
	if( VSH2_SuperJumpThink(player, 2.5, 25.0) ) {
		player.PlayVoiceClip(BionicCommandoJump[GetRandomInt(0, sizeof(BionicCommandoJump)-1)], VSH2_VOICE_ABILITY);
		player.SuperJump(player.GetPropFloat("flCharge"), -100.0);
	}
	
	if( OnlyScoutsLeft(VSH2Team_Red) )
		player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + g_vsh2_cvars.scout_rage_gen.FloatValue);
	
	VSH2_WeighDownThink(player, 2.0, 0.1);
	
	/// hud code
	SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
	Handle hud = VSH2GameMode_GetHUDHandle();
	float jmp = player.GetPropFloat("flCharge");
	float rage = player.GetPropFloat("flRAGE");
	if( rage >= 100.0 )
		ShowSyncHudText(client, hud, "Jump: %i%% | Rage: FULL - Call Medic (default: E) to activate", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4);
	else ShowSyncHudText(client, hud, "Jump: %i%% | Rage: %0.1f", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4, rage);
}

public void BionicCommando_OnBossModelTimer(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	int client = player.index;
	SetVariantString(BionicCommandoModel);
	AcceptEntityInput(client, "SetCustomModel");
	SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
}

public void BionicCommando_OnBossEquipped(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	
	player.SetName("Bionic Commando");
	player.RemoveAllItems();
	///68; 2.0	- Capture speed (+2)
	///2; 3.1	- Damage mult (*3.1) = 201.5
	///259; 1.0	- Boots stomp
	///81; 0.0	- Max metal mult (*0)
	///214; random	- Kill eater (?)
	char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 81; 0.0; 214; %d", GetRandomInt(999, 9999));
	int wep = player.SpawnWeapon("tf_weapon_robot_arm", 142, 100, 5, attribs);
	SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
}

public void BionicCommando_OnBossInitialized(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	SetEntProp(player.index, Prop_Send, "m_iClass", view_as<int>(TFClass_Engineer));
}

public void BionicCommando_OnBossPlayIntro(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	player.PlayVoiceClip(BionicCommandoIntro[GetRandomInt(0, sizeof(BionicCommandoIntro)-1)], VSH2_VOICE_INTRO);
}

public void BionicCommando_OnPlayerKilled(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	if( !IsBionicCommando(attacker) )
		return;
	
	float curtime = GetGameTime();
	if( curtime <= attacker.GetPropFloat("flKillSpree") )
		attacker.SetPropInt("iKills", attacker.GetPropInt("iKills") + 1);
	else attacker.SetPropInt("iKills", 0);
	//attacker.PlayVoiceClip(BionicCommandoKill[GetRandomInt(0, sizeof(BionicCommandoKill)-1)], VSH2_VOICE_SPREE);
	
	switch (TF2_GetPlayerClass(victim.index))
	{
		case TFClass_Scout:
			attacker.PlayVoiceClip(BionicCommandoKill[0], VSH2_VOICE_SPREE);
		case TFClass_Soldier:
			attacker.PlayVoiceClip(BionicCommandoKill[1], VSH2_VOICE_SPREE);
		case TFClass_Pyro:
			attacker.PlayVoiceClip(BionicCommandoKill[2], VSH2_VOICE_SPREE);
		case TFClass_DemoMan:
			attacker.PlayVoiceClip(BionicCommandoKill[3], VSH2_VOICE_SPREE);
		case TFClass_Heavy:
			attacker.PlayVoiceClip(BionicCommandoKill[4], VSH2_VOICE_SPREE);
		case TFClass_Engineer:
			attacker.PlayVoiceClip(BionicCommandoKill[5], VSH2_VOICE_SPREE);
		case TFClass_Medic:
			attacker.PlayVoiceClip(BionicCommandoKill[6], VSH2_VOICE_SPREE);
		case TFClass_Sniper:
			attacker.PlayVoiceClip(BionicCommandoKill[7], VSH2_VOICE_SPREE);
		case TFClass_Spy:
			attacker.PlayVoiceClip(BionicCommandoKill[8], VSH2_VOICE_SPREE);
	}
	
	if( attacker.GetPropInt("iKills") == 3 && VSH2GameMode_GetTotalRedPlayers() != 1 ) {
		attacker.PlayVoiceClip(BionicCommandoSpree[GetRandomInt(0, sizeof(BionicCommandoSpree)-1)], VSH2_VOICE_SPREE);
		attacker.SetPropInt("iKills", 0);
	}
	else attacker.SetPropFloat("flKillSpree", curtime+5.0);
}

public void BionicCommando_OnPlayerHurt(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	int damage = event.GetInt("damageamount");
	if( IsBionicCommando(victim) && victim.GetPropInt("bIsBoss") )
		victim.GiveRage(damage);
}
public void BionicCommando_OnPlayerAirblasted(const VSH2Player airblaster, const VSH2Player airblasted, Event event)
{
	if( !IsBionicCommando(airblasted) )
		return;
	float rage = airblasted.GetPropFloat("flRAGE");
	airblasted.SetPropFloat("flRAGE", rage + g_vsh2_cvars.airblast_rage.FloatValue);
}
public void BionicCommando_OnBossMedicCall(const VSH2Player player)
{
	if( !IsBionicCommando(player) || player.GetPropFloat("flRAGE") < 100.0 )
		return;
	
	player.DoGenericStun(320.0);
	/*VSH2Player[] players = new VSH2Player[MaxClients];
	int in_range = player.GetPlayersInRange(players, 320.0);
	for( int i; i<in_range; i++ ) {
		if( players[i].GetPropAny("bIsBoss") || players[i].GetPropAny("bIsMinion") )
			continue;
		/// do a distance based thing here.
	}*/
	player.PlayVoiceClip(BionicCommandoRage[GetRandomInt(0, sizeof(BionicCommandoRage)-1)], VSH2_VOICE_RAGE);
	
	TF2_RemoveWeaponSlot(player.index, TFWeaponSlot_Primary);
	///37; 0.0	- Max ammo bonus (hidden)
	///104; 0.2	- Projectile speed mult (*0.2)
	///99; 2.0	- Blast radius bonus (+200%)
	///1; 5.0	- Damage mult (*5.0) = 450 (non-crit)
	///3; 0.25	- Clip size mult (*0.25) = 1
	int bcrocket = player.SpawnWeapon("tf_weapon_rocketlauncher", 18, 100, 5, "37 ; 0.0 ; 104 ; 0.2 ; 99 ; 2.0 ; 1 ; 5.0 ; 3 ; 0.25");
	SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", bcrocket);
	SetWeaponAmmo(bcrocket, 1);
	
	player.SetPropFloat("flRAGE", 0.0);
}

public void BionicCommando_OnBossJarated(const VSH2Player victim, const VSH2Player thrower)
{
	if( !IsBionicCommando(victim) )
		return;
	float rage = victim.GetPropFloat("flRAGE");
	victim.SetPropFloat("flRAGE", rage - g_vsh2_cvars.jarate_rage.FloatValue);
}


public void BionicCommando_OnRoundEndInfo(const VSH2Player player, bool bossBool, char message[MAXMESSAGE])
{
	if( !IsBionicCommando(player) )
		return;
	else if( bossBool )
		player.PlayVoiceClip(BionicCommandoWin[GetRandomInt(0, sizeof(BionicCommandoWin)-1)], VSH2_VOICE_WIN);
}


public void BionicCommando_Music(char song[PLATFORM_MAX_PATH], float &time, const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	
	int theme = GetRandomInt(0, sizeof(BionicCommandoThemes)-1);
	Format(song, sizeof(song), "%s", BionicCommandoThemes[theme]);
	time = BionicCommandoThemesTime[theme];
}

public void BionicCommando_OnBossDeath(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	
	player.PlayVoiceClip(BionicCommandoDeath[GetRandomInt(0, sizeof(BionicCommandoDeath)-1)], VSH2_VOICE_LOSE);
}

/*public Action BionicCommando_OnStabbed(VSH2Player victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if( !IsBionicCommando(victim) )
		return Plugin_Continue;
	
	victim.PlayVoiceClip(BionicCommandoStab[GetRandomInt(0, sizeof(BionicCommandoStab)-1)], VSH2_VOICE_STABBED);
	return Plugin_Continue;
}*/

public void BionicCommando_OnLastPlayer(const VSH2Player player)
{
	if( !IsBionicCommando(player) )
		return;
	player.PlayVoiceClip(BionicCommandoLast[GetRandomInt(0, sizeof(BionicCommandoLast)-1)], VSH2_VOICE_LASTGUY);
}

public Action BionicCommando_OnSoundHook(const VSH2Player player, char sample[PLATFORM_MAX_PATH], int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if( !IsBionicCommando(player) )
		return Plugin_Continue;
	else if( IsVoiceLine(sample) )    /// this code: returning Plugin_Handled blocks the sound, a voiceline in this case.
		return Plugin_Handled;
	
	return Plugin_Continue;
}

/// Stocks =============================================
stock bool IsValidClient(const int client, bool nobots=false)
{ 
	if( client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)) )
		return false; 
	return IsClientInGame(client); 
}

stock int GetSlotFromWeapon(const int iClient, const int iWeapon)
{
	for( int i; i<5; i++ )
		if( iWeapon == GetPlayerWeaponSlot(iClient, i) )
			return i;
	
	return -1;
}

stock bool OnlyScoutsLeft(const int team)
{
	for( int i=MaxClients; i; --i ) {
		if( !IsValidClient(i) || !IsPlayerAlive(i) )
			continue;
		else if( GetClientTeam(i) == team && TF2_GetPlayerClass(i) != TFClass_Scout )
			return false;
	}
	return true;
}

stock void SetPawnTimer(Function func, float thinktime = 0.1, any param1 = -999, any param2 = -999)
{
	DataPack thinkpack = new DataPack();
	thinkpack.WriteFunction(func);
	thinkpack.WriteCell(param1);
	thinkpack.WriteCell(param2);
	CreateTimer(thinktime, DoThink, thinkpack, TIMER_DATA_HNDL_CLOSE);
}

public Action DoThink(Handle hTimer, DataPack hndl)
{
	hndl.Reset();
	
	Function pFunc = hndl.ReadFunction();
	Call_StartFunction(null, pFunc);
	
	any param1 = hndl.ReadCell();
	if( param1 != -999 )
		Call_PushCell(param1);
	
	any param2 = hndl.ReadCell();
	if( param2 != -999 )
		Call_PushCell(param2);
	
	Call_Finish();
	return Plugin_Continue;
}
stock int SetWeaponClip(const int weapon, const int ammo)
{
	if( IsValidEntity(weapon) ) {
		int iAmmoTable = FindSendPropInfo("CTFWeaponBase", "m_iClip1");
		SetEntData(weapon, iAmmoTable, ammo, 4, true);
	}
	return 0;
}

///From VHS2 (modules/stocks.inc)
stock int SetWeaponAmmo(const int weapon, const int ammo)
{
	int owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
	if (owner <= 0)
		return 0;
	if (IsValidEntity(weapon)) {
		int iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		int iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		SetEntData(owner, iAmmoTable+iOffset, ammo, 4, true);
	}
	return 0;
}

public int HintPanel(Menu menu, MenuAction action, int param1, int param2)
{
	return;
}
