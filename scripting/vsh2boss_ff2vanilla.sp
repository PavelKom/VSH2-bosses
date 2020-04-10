#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2_stocks>
#include <vsh2>

#undef REQUIRE_PLUGIN
#tryinclude <tf2attributes>
#define REQUIRE_PLUGIN

///Bosspack constructed on vsh2boss_template.sp
///VSH2 2.6.15

///Materials (only .bz2): https://yadi.sk/d/ASEDxuUPh9-tVw


/**
Default bosses from FF2:

Demopan
	+ Jump
	+ Weightdown
	+ Infinite shieldcharge
	+ Rage stun
	+ Rage tradespam

Gentle Spy
	+ Weightdown
	+ Rage uber
	+ Rage instant teleport
	+ Rage give weapon

Ninja Spy
	+ 3 lives
	+ Jump
	+ Weightdown
	+ Rage stun
	- Slow mo
	
Seeldier
	+ Jump
	+ Weightdown
	+ Rage stun
	+ Rage spawn clones
	+- DUO boss
	
Seeman
	+ Jump
	+ Weightdown
	+ Rage stun
	+ Rage explosive dance
	+- DUO boss

**/

///Demopan files

#define DemopanModel    "models/freak_fortress_2/demopan/demopan_v1.mdl"
#define DemopanGiantShako "models/freak_fortress_2/demopan/giant_shako.mdl"

char DemopanIntro[][] = {
	"freak_fortress_2/demopan/demopan_begin.wav"
};

char DemopanCharge[][] = {
	"weapons/demo_charge_windup1.wav",
	"weapons/demo_charge_windup2.wav",
	"weapons/demo_charge_windup3.wav"
};
char DemopanDeath[][] = {
	"vo/demoman_gibberish01.mp3",
	"vo/demoman_jeers05.mp3",
	"vo/demoman_paincrticialdeath02.mp3"
};

char DemopanLast[][] = {
	"vo/demoman_eyelandertaunt01.mp3",
	"vo/taunts/demoman_taunts04.mp3"
};

char DemopanRage[][] = {
	"ui/notification_alert.wav"
};

char DemopanKill[][] = {
	"vo/demoman_eyelandertaunt01.mp3",
	"weapons/pan/melee_frying_pan_01.wav"
};

char DemopanSpree[][] = {
	///Only precache:
	"vo/demoman_laughshort01.mp3",
	"vo/taunts/demoman_taunts05.mp3",
	"vo/demoman_specialcompleted08.mp3",
	///Download
	"freak_fortress_2/demopan/demopan_kspree.wav"
};

char DemopanWin[][] = {
	"freak_fortress_2/demopan/demopan_win.wav"
};

char DemopanMaterial[][] = {///*.vmt, *.vtf   PrepareMaterial
	"freak_fortress_2/demopan/trade_0",
	"freak_fortress_2/demopan/trade_1",
	"freak_fortress_2/demopan/trade_2",
	"freak_fortress_2/demopan/trade_3",
	"freak_fortress_2/demopan/trade_4",
	"freak_fortress_2/demopan/trade_5",
	"freak_fortress_2/demopan/trade_6",
	"freak_fortress_2/demopan/trade_7",
	"freak_fortress_2/demopan/trade_8",
	"freak_fortress_2/demopan/trade_9",
	"freak_fortress_2/demopan/trade_10",
	"freak_fortress_2/demopan/trade_11",
	"freak_fortress_2/demopan/trade_12"
};

///GentleSpy files

#define GentleSpyModel    "models/freak_fortress_2/gentlespy/the_gentlespy_v1.mdl"

char GentleSpyIntro[][] = {
	"vo/spy_revenge03.mp3",
	"vo/taunts/spy_taunts01.mp3",
	"vo/taunts/spy_taunts10.mp3",
	"vo/spy_mvm_resurrect01.mp3"
};

char GentleSpyTeleport[][] = {
	"vo/spy_specialcompleted01.mp3",
	"vo/spy_specialcompleted06.mp3"
};

char GentleSpyStab[][] = {
	"vo/spy_negativevocalization01.mp3",
	"vo/spy_negativevocalization03.mp3",
	"vo/spy_negativevocalization06.mp3",
	"vo/spy_negativevocalization09.mp3"
};

char GentleSpyDeath[][] = {
	"vo/spy_revenge03.mp3",
	"vo/taunts/spy_taunts10.mp3"
};

char GentleSpyLast[][] = {
	"vo/spy_meleedare01.mp3",
	"vo/spy_meleedare02.mp3"
};

char GentleSpyRage[][] = {
	"vo/spy_no01.mp3",
	"vo/spy_no02.mp3",
	"vo/spy_no03.mp3"
};

char GentleSpySpree[][] = {
	"vo/spy_specialcompleted11.mp3",
	"vo/taunts/spy_taunts06.mp3",
	"vo/spy_specialcompleted-assistedkill02.mp3"
};

char GentleSpyWin[][] = {
	"vo/taunts/spy_highfive_success03.mp3"
};

char GentleSpyThemes[][] = {
	"freak_fortress_2/gentlespy/gentle_music.mp3"
};

float GentleSpyThemesTime[] = {
	153.0
};

char GentleSpyMaterial[][] = {
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_blue.vtf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_blue.vmf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_blue_invun.vtf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_blue_invun.vmf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_red.vtf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_red.vmf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_red_invun.vtf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_red_invun.vmf",
	"materials/freak_fortress_2/gentlespy_tex/stylish_spy_normal.vtf"
};

///Ninja Spy files

#define NinjaSpyModel    "models/freak_fortress_2/ninjaspy/ninjaspy_v2_2.mdl"

char NinjaSpyIntro[][] = {
	"freak_fortress_2/ninjaspy/ninjaspy_begin.wav",
	"freak_fortress_2/ninjaspy/ninjaspy_begin2.wav",
	"freak_fortress_2/ninjaspy/ninjaspy_begin3.wav"
};

char NinjaSpyJump[][] = {
	"vo/spy_laughhappy02.mp3",
	"vo/spy_laughshort01.mp3",
	"vo/taunts/spy_taunts06.mp3",
	"vo/spy_laughevil01.mp3"
};
char NinjaSpyDeath[][] = {
	"vo/spy_jeers02.mp3",
	"vo/spy_negativevocalization02.mp3",
	"vo/spy_negativevocalization03.mp3",
	"vo/taunts/spy_taunts04.mp3"
};
char NinjaSpyLostLife[][] = {
	"freak_fortress_2/ninjaspy/fakedeath_1.wav",
	"freak_fortress_2/ninjaspy/fakedeath_2.wav",
	"freak_fortress_2/ninjaspy/fakedeath_3.wav",
	"freak_fortress_2/ninjaspy/fakedeath_4.wav",
	"freak_fortress_2/ninjaspy/fakedeath_5.wav",
	"freak_fortress_2/ninjaspy/fakedeath_6.wav",
	"freak_fortress_2/ninjaspy/fakedeath_7.wav"
};
char NinjaSpySpree[][] = {
	"freak_fortress_2/ninjaspy/kill_1.wav",
	"freak_fortress_2/ninjaspy/kill_2.wav",
	"freak_fortress_2/ninjaspy/kill_3.wav",
	"freak_fortress_2/ninjaspy/kill_4.wav"
};
char NinjaSpyKill[][] = {
	"freak_fortress_2/ninjaspy/kill_heavy.wav",
	"freak_fortress_2/ninjaspy/kill_pyro.wav",
	"freak_fortress_2/ninjaspy/kill_scout.wav",
	"freak_fortress_2/ninjaspy/kill_soldier.wav",
	"freak_fortress_2/ninjaspy/kill_demo.wav",
	///Kill engineer, only precache
	"vo/spy_dominationengineer02.mp3"
};
char NinjaSpyMaterial[][] = {
	"materials/freak_fortress_2/ninjaspy/spy_black",
	"materials/freak_fortress_2/ninjaspy/fez_red",
	"materials/freak_fortress_2/ninjaspy/spy_head_red"
};

///Seeldier and Seeman files

#define SeeldierModel    "models/freak_fortress_2/seeman/seeldier_v0.mdl"
#define SeemanModel    "models/freak_fortress_2/seeman/seeman_v0.mdl"

///Catch phrase, intro, killspree, death, win, lastman
char SeeldierSound[][] = {
	"freak_fortress_2/seeman/seeldier_see.wav"
};

///Catch phrase, killspree, death, win, lastman
char SeemanSound[][] = {
	"freak_fortress_2/seeman/seeman_see.wav"
};

char SeemanIntro[][] = {
	"freak_fortress_2/seeman/seecombo_begin.wav"
};

char SeemanExplosiveDance[][] = {
	"freak_fortress_2/seeman/seeman_rage.wav"
};


public Plugin myinfo = {
	name = "VSH2 FF2 legacy bosses",
	author = "PavelKom",
	description = "Good old bosses from FF2",
	version = "0.9",
	url = "bans.gamingfortress.ru"
};

int g_iDemopanID;
int g_iGentleSpyID;
int g_iNinjaSpyID;
int g_iSeeldierID;
int g_iSeemanID;

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
		
		g_iDemopanID = VSH2_RegisterPlugin("demopan");
		g_iGentleSpyID = VSH2_RegisterPlugin("gentlespy");
		g_iNinjaSpyID = VSH2_RegisterPlugin("ninjaspy");
		g_iSeeldierID = VSH2_RegisterPlugin("seeldier");
		g_iSeemanID = VSH2_RegisterPlugin("seeman");
		LoadVSH2Hooks();
	}
}

public void LoadVSH2Hooks()
{
	if( !VSH2_HookEx(OnCallDownloads, FF2Vanilla_OnCallDownloads) )
		LogError("Error loading OnCallDownloads forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossMenu, FF2Vanilla_OnBossMenu) )
		LogError("Error loading OnBossMenu forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossSelected, FF2Vanilla_OnBossSelected) )
		LogError("Error loading OnBossSelected forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossThink, FF2Vanilla_OnBossThink) )
		LogError("Error loading OnBossThink forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossModelTimer, FF2Vanilla_OnBossModelTimer) )
		LogError("Error loading OnBossModelTimer forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossEquipped, FF2Vanilla_OnBossEquipped) )
		LogError("Error loading OnBossEquipped forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossInitialized, FF2Vanilla_OnBossInitialized) )
		LogError("Error loading OnBossInitialized forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossPlayIntro, FF2Vanilla_OnBossPlayIntro) )
		LogError("Error loading OnBossPlayIntro forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnPlayerKilled, FF2Vanilla_OnPlayerKilled) )
		LogError("Error loading OnPlayerKilled forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnPlayerHurt, FF2Vanilla_OnPlayerHurt) )
		LogError("Error loading OnPlayerHurt forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnPlayerAirblasted, FF2Vanilla_OnPlayerAirblasted) )
		LogError("Error loading OnPlayerAirblasted forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossMedicCall, FF2Vanilla_OnBossMedicCall) )
		LogError("Error loading OnBossMedicCall forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossTaunt, FF2Vanilla_OnBossMedicCall) )
		LogError("Error loading OnBossTaunt forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossJarated, FF2Vanilla_OnBossJarated) )
		LogError("Error loading OnBossJarated forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnRoundEndInfo, FF2Vanilla_OnRoundEndInfo) )
		LogError("Error loading OnRoundEndInfo forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnMusic, FF2Vanilla_Music) )
		LogError("Error loading OnBossDealDamage forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossDeath, FF2Vanilla_OnBossDeath) )
		LogError("Error loading OnBossDeath forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnBossTakeDamage_OnStabbed, FF2Vanilla_OnStabbed) )
		LogError("Error loading OnBossTakeDamage_OnStabbed forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnLastPlayer, FF2Vanilla_OnLastPlayer) )
		LogError("Error loading OnLastPlayer forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnSoundHook, FF2Vanilla_OnSoundHook) )
		LogError("Error loading OnSoundHook forwards for FF2Vanilla subplugin.");
	
	if( !VSH2_HookEx(OnMinionInitialized, FF2Vanilla_OnMinionInitialized) )
		LogError("Error loading OnMinionInitialized forwards for FF2Vanilla subplugin.");
	
	///Custom Health calculation for boss
	if( !VSH2_HookEx(OnBossCalcHealth, FF2Vanilla_OnBossCalcHealth) )
		LogError("Error loading OnBossCalcHealth forwards for FF2Vanilla subplugin.");
	
	///HUD for multilive logic
	if( !VSH2_HookEx(OnMessageIntro, FF2Vanilla_OnMessageIntro) )
		LogError("Error loading OnMessageIntro forwards for FF2Vanilla subplugin.");
	if( !VSH2_HookEx(OnBossHealthCheck, FF2Vanilla_OnBossHealthCheck) )
		LogError("Error loading OnBossHealthCheck forwards for FF2Vanilla subplugin.");
	
	///Telefrag fix for multilive bosses
	//f( !VSH2_HookEx(OnBossTakeDamage_OnTelefragged, FF2Vanilla_OnTelefragged) )
	//	LogError("Error loading OnBossTakeDamage_OnTelefragged forwards for FF2Vanilla subplugin.");
}

stock bool IsBossFromPack(const VSH2Player player) {
	if( player.GetPropInt("iBossType") == g_iDemopanID ||
		player.GetPropInt("iBossType") == g_iGentleSpyID ||
		player.GetPropInt("iBossType") == g_iNinjaSpyID ||
		player.GetPropInt("iBossType") == g_iSeeldierID ||
		player.GetPropInt("iBossType") == g_iSeemanID)
		return true;
	return false;
}


public void FF2Vanilla_OnCallDownloads()
{
	///Demopan
	PrepareModel(DemopanModel);
	PrepareModel(DemopanGiantShako);
	
	DownloadSoundList(DemopanIntro, sizeof(DemopanIntro));
	DownloadSoundList(DemopanWin, sizeof(DemopanWin));
	
	PrepareSound(DemopanSpree[3]);
	
	PrecacheSoundList(DemopanCharge, sizeof(DemopanCharge));
	PrecacheSoundList(DemopanDeath, sizeof(DemopanDeath));
	PrecacheSoundList(DemopanLast, sizeof(DemopanLast));
	PrecacheSoundList(DemopanRage, sizeof(DemopanRage));
	PrecacheSoundList(DemopanKill, sizeof(DemopanKill));
	PrecacheSoundList(DemopanSpree, (sizeof(DemopanSpree)-1));
	
	char demopanMat[PLATFORM_MAX_PATH];
	for(int i; i<sizeof(DemopanMaterial);i++)
	{
		Format(demopanMat, sizeof(demopanMat), "materials/%s",DemopanMaterial[i]);
		PrepareMaterial(demopanMat);
	}
	
	///GentleSpy
	PrepareModel(GentleSpyModel);
	
	PrecacheSoundList(GentleSpyIntro, sizeof(GentleSpyIntro));
	PrecacheSoundList(GentleSpyTeleport, sizeof(GentleSpyTeleport));
	PrecacheSoundList(GentleSpyStab, sizeof(GentleSpyStab));
	PrecacheSoundList(GentleSpyDeath, sizeof(GentleSpyDeath));
	PrecacheSoundList(GentleSpyLast, sizeof(GentleSpyLast));
	PrecacheSoundList(GentleSpyRage, sizeof(GentleSpyRage));
	PrecacheSoundList(GentleSpySpree, sizeof(GentleSpySpree));
	PrecacheSoundList(GentleSpyWin, sizeof(GentleSpyWin));
	
	DownloadSoundList(GentleSpyThemes, sizeof(GentleSpyThemes));
	
	DownloadMaterialList(GentleSpyMaterial, sizeof(GentleSpyMaterial));
	
	///Ninja Spy
	PrepareModel(NinjaSpyModel);
	
	DownloadSoundList(NinjaSpyIntro, sizeof(NinjaSpyIntro));
	DownloadSoundList(NinjaSpySpree, sizeof(NinjaSpySpree));
	
	PrecacheSoundList(NinjaSpyJump, sizeof(NinjaSpyJump));
	PrecacheSoundList(NinjaSpyDeath, sizeof(NinjaSpyDeath));
	
	DownloadSoundList(NinjaSpyKill, (sizeof(NinjaSpyKill)-1));
	DownloadSoundList(NinjaSpyLostLife, sizeof(NinjaSpyLostLife));
	
	PrecacheSound(NinjaSpyKill[5], true);
	
	for(int i; i<sizeof(NinjaSpyMaterial);i++)
	{
		PrepareMaterial(NinjaSpyMaterial[i]);
	}
	
	///Seeldier and Seeman
	
	PrepareModel(SeeldierModel);
	PrepareModel(SeemanModel);
	
	DownloadSoundList(SeeldierSound, sizeof(SeeldierSound));
	DownloadSoundList(SeemanSound, sizeof(SeemanSound));
	DownloadSoundList(SeemanIntro, sizeof(SeemanIntro));
	DownloadSoundList(SeemanExplosiveDance, sizeof(SeemanExplosiveDance));
}

public void FF2Vanilla_OnBossMenu(Menu &menu)
{
	char tostr[10]; 
	IntToString(g_iDemopanID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Demopan");
	
	IntToString(g_iGentleSpyID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "GentleSpy");
	
	IntToString(g_iNinjaSpyID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Ninja Spy");
	
	IntToString(g_iSeeldierID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Seeldier");
	
	IntToString(g_iSeemanID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "Seeman");
}

public void FF2Vanilla_OnBossSelected(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	
	player.SetPropInt("iCustomProp", 0);
	player.SetPropFloat("flCustomProp", 0.0);
	player.SetPropAny("hCustomProp", player);
	
	Panel panel = new Panel();
	if(player.GetPropInt("iBossType") == g_iDemopanID)
		panel.SetTitle("Demopan:\n''Stout Shako for 2 refined!''\nSuper Jump: alt-fire, look up and stand up.\nWeigh-down: in midair, look down and crouch\nRage (low-distance stun + trade spam): call for medic when the Rage Meter is full.\nCharge of Targe: reload button.");
		/**Ru
		"Дэмопан:\n''Прочный Кивер за 2 очищенных!''\nСупер Прыжок: альт.огонь, посмотри наверх и встань.\nСупер-падение: в воздухе смотри вниз и присядь.\nЯрость (оглушение вблизи + спам торгами): сделай насмешку, когда Счетчик Ярости полон.\nРывок щита: кнопка перезарядки."
		**/
	else if(player.GetPropInt("iBossType") == g_iGentleSpyID)
		panel.SetTitle("Gentle Spy:\nSo Gentle :3\nNo super jump !\nRage (teleport + ambassador): call for medic when the Rage Meter is full.");
		/**Ru
		"Gentle Spy:\nSo Gentle :3\nБез супер прыжка !\nЯрость (Телепорт + Амбасаддор): насмешка при полной шкале ярости."
		**/
	else if(player.GetPropInt("iBossType") == g_iNinjaSpyID)
		panel.SetTitle("Ninja Spy:\n''Not so fast!''\nSuper Jump: alt-fire, look up and stand up.\nWeigh-down: in midair, look down and crouch.\nRage (stun): call for medic when the Rage Meter is full.\n3 lives - 2 slow motion attacks! Look at enemy and press fire button!");
		/**Ru
		"Шпион-Нидзя:\n''Не так быстро!''\nСупер Прыжок: альт.огонь, посмотри наверх и встань.\nСупер-падение: в воздухе смотри вниз и присядь.\nЯрость (оглушение): сделай насмешку, когда Счетчик Ярости полон.\n3 жизни - 2 атаки в замедленном времени! Прицелься во врага и нажми 'огонь'."
		**/
	else if(player.GetPropInt("iBossType") == g_iSeeldierID)
		panel.SetTitle("Seeldier:\n''See!''\nSuper Jump: alt-fire, look up and stand up.\nWeigh-down: in midair, look down and crouch.\nRage (low-distance stun + attack of the clones): call for medic when the Rage Meter is full.\nYour companion is Seeman!");
		/**Ru
		"Seeldier:\n''See!''\nСупер Прыжок: альт.огонь, посмотри наверх и встань.\nСупер-падение: в воздухе смотри вниз и присядь.\nЯрость (оглушение вблизи+ атака клонов): сделай насмешку, когда Счетчик Ярости полон.\nТвой компаньон - Seeman!"
		**/
	else if(player.GetPropInt("iBossType") == g_iSeemanID)
		panel.SetTitle("Seeman:\n''See?''\nSuper Jump: alt-fire, look up and stand up.\nWeigh-down: in midair, look down and crouch.\nRage (explosive dance): call for medic when the Rage Meter is full.\nYour companion is Seeldier!");
		/**Ru
		"Seeman:\n''See?''\nСупер Прыжок: альт.огонь, посмотри наверх и встань.\nСупер-падение: в воздухе смотри вниз и присядь.\nЯрость (взрывной танец): сделай насмешку, когда Счетчик Ярости полон.\nТвой компаньон - Seeldier!"
		**/
	panel.DrawItem("Exit");
	panel.Send(player.index, HintPanel, 50);
	delete panel;
	
	///DUO-boss logic
	if (player.GetPropInt("iBossType") == g_iSeeldierID || player.GetPropInt("iBossType") == g_iSeemanID)
	{
		VSH2Player secondBoss = VSH2GameMode_FindNextBoss();
		if(secondBoss == player)
		{
			LogError("[FF2Vanilla] Infinite OnBossSelected calling for DUO-bosses");
			return;
		}
		
		if(VSH2GameMode_GetTotalRedPlayers() > 6 && VSH2GameMode_CountBosses(true) < 2)
		{
			if (player.GetPropInt("iBossType") == g_iSeeldierID)
				secondBoss.MakeBossAndSwitch( g_iSeemanID, false);
			else if (player.GetPropInt("iBossType") == g_iSeemanID)
				secondBoss.MakeBossAndSwitch( g_iSeeldierID, false);
		}
	}
}

public void FF2Vanilla_OnBossThink(const VSH2Player player)
{
	int client = player.index;
	if( !IsPlayerAlive(client) || !IsBossFromPack(player) )
		return;
	///Dynamic speed calculation
	//VSH2_SpeedThink(player, 340.0);
	VSH2_GlowThink(player, 0.1);
	
	if(player.GetPropInt("iBossType") == g_iDemopanID)
	{
		SetEntPropFloat(player.index, Prop_Send, "m_flMaxspeed", 270.0);
		if( VSH2_SuperJumpThink(player, 2.5, 25.0) ) 
			player.SuperJump(player.GetPropFloat("flCharge"), -100.0);
		if( OnlyScoutsLeft(VSH2Team_Red) )
			player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + g_vsh2_cvars.scout_rage_gen.FloatValue);
			
		VSH2_WeighDownThink(player, 2.0, 0.1);
		
		///Infinite shieldcharge
		int buttons = GetClientButtons(player.index);
		if (buttons & IN_ATTACK2)
		{
			SetEntPropFloat(player.index, Prop_Send, "m_flChargeMeter", 100.0);
			TF2_AddCondition(player.index, TFCond_Charging, 0.25);
		}
		
		SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
		Handle hud = VSH2GameMode_GetHUDHandle();
		float jmp = player.GetPropFloat("flCharge");
		float rage = player.GetPropFloat("flRAGE");
		if( rage >= 100.0 )
			ShowSyncHudText(client, hud, "Jump: %i%% | Rage: FULL - Call Medic (default: E) to activate", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4);
		else ShowSyncHudText(client, hud, "Jump: %i%% | Rage: %0.1f", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4, rage);
	}
	else if(player.GetPropInt("iBossType") == g_iGentleSpyID)
	{
		SetEntPropFloat(player.index, Prop_Send, "m_flMaxspeed", 350.0);
		if( OnlyScoutsLeft(VSH2Team_Red) )
			player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + g_vsh2_cvars.scout_rage_gen.FloatValue);
		
		VSH2_WeighDownThink(player, 2.0, 0.1);
		
		SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
		Handle hud = VSH2GameMode_GetHUDHandle();
		float rage = player.GetPropFloat("flRAGE");
		if( rage >= 100.0 )
			ShowSyncHudText(client, hud, "Rage: FULL - Call Medic (default: E) to activate");
		else ShowSyncHudText(client, hud, "Rage: %0.1f", rage);
	}
	else if(player.GetPropInt("iBossType") == g_iNinjaSpyID || 
			player.GetPropInt("iBossType") == g_iSeeldierID || 
			player.GetPropInt("iBossType") == g_iSeemanID)
	{
		SetEntPropFloat(player.index, Prop_Send, "m_flMaxspeed", 340.0);
		if( VSH2_SuperJumpThink(player, 2.5, 25.0) ) 
			player.SuperJump(player.GetPropFloat("flCharge"), -100.0);
		if( OnlyScoutsLeft(VSH2Team_Red) )
			player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + g_vsh2_cvars.scout_rage_gen.FloatValue);
			
		VSH2_WeighDownThink(player, 2.0, 0.1);
		
		SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
		Handle hud = VSH2GameMode_GetHUDHandle();
		float jmp = player.GetPropFloat("flCharge");
		float rage = player.GetPropFloat("flRAGE");
		if( rage >= 100.0 )
			ShowSyncHudText(client, hud, "Jump: %i%% | Rage: FULL - Call Medic (default: E) to activate", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4);
		else ShowSyncHudText(client, hud, "Jump: %i%% | Rage: %0.1f", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4, rage);
	}
}

public void FF2Vanilla_OnBossModelTimer(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	int client = player.index;
	if (player.GetPropInt("iBossType") == g_iDemopanID)
	{
		SetVariantString(DemopanModel);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}
	else if (player.GetPropInt("iBossType") == g_iGentleSpyID)
	{
		SetVariantString(GentleSpyModel);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}
	else if (player.GetPropInt("iBossType") == g_iNinjaSpyID)
	{
		SetVariantString(NinjaSpyModel);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
	{
		SetVariantString(SeeldierModel);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}
	else if (player.GetPropInt("iBossType") == g_iSeemanID)
	{
		SetVariantString(SeemanModel);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}
}

public void FF2Vanilla_OnBossEquipped(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	
	
	player.RemoveAllItems();
	if (player.GetPropInt("iBossType") == g_iDemopanID)
	{
		player.SetName("Demopan");
		///68; 2.0	- Capture speed (+2)
		///2; 3.1	- Damage mult (*3.1) = 201.5
		///259; 1.0	- Boots stomp
		///214; random	- Strange counter
		char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 214; %d", GetRandomInt(999, 9999));
		int wep = player.SpawnWeapon("tf_weapon_bottle", 264, 100, 5, attribs);
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
	}
	else if (player.GetPropInt("iBossType") ==  g_iGentleSpyID)
	{
		player.SetName("GentleSpy");
		///252; 0.6	- Damage force reduction
		char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 252; 0.6; 214; %d", GetRandomInt(999, 9999));
		int wep = player.SpawnWeapon("tf_weapon_knife", 225, 100, 5, attribs);
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
	}
	else if (player.GetPropInt("iBossType") ==  g_iNinjaSpyID)
	{
		player.SetName("Ninja Spy");
		char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 252; 0.6; 214; %d", GetRandomInt(999, 9999));
		int wep = player.SpawnWeapon("tf_weapon_club", 401, 100, 5, attribs);
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
	}
	else if (player.GetPropInt("iBossType") ==  g_iSeeldierID)
	{
		player.SetName("Seeldier");
		char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 252; 0.6; 214; %d", GetRandomInt(999, 9999));
		int wep = player.SpawnWeapon("tf_weapon_shovel", 196, 100, 5, attribs);
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
	}
	else if (player.GetPropInt("iBossType") ==  g_iSeemanID)
	{
		player.SetName("Seeman");
		char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 252; 0.6; 214; %d", GetRandomInt(999, 9999));
		int wep = player.SpawnWeapon("tf_weapon_bottle", 191, 100, 5, attribs);
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
	}
}

public void FF2Vanilla_OnBossInitialized(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	if (player.GetPropInt("iBossType") == g_iDemopanID || player.GetPropInt("iBossType") == g_iSeemanID)
		SetEntProp(player.index, Prop_Send, "m_iClass", view_as<int>(TFClass_DemoMan));
	else if (player.GetPropInt("iBossType") == g_iGentleSpyID || player.GetPropInt("iBossType") == g_iNinjaSpyID)
		SetEntProp(player.index, Prop_Send, "m_iClass", view_as<int>(TFClass_Spy));
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
		SetEntProp(player.index, Prop_Send, "m_iClass", view_as<int>(TFClass_Soldier));
}

public Action FF2Vanilla_OnBossCalcHealth(const VSH2Player player, int& max_health, const int boss_count, const int red_players)
{
	if( !IsBossFromPack(player) )
		return Plugin_Continue;
	
	if(player.GetPropInt("iBossType") == g_iNinjaSpyID)
	{
		player.SetPropInt("iLives", 3);
	
		max_health = RoundFloat( Pow((((240.0)+red_players)*(red_players)), 1.0341)+1023 ) / (boss_count);
	
		if (max_health < 1000 && boss_count == 1)
			max_health = 1000;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public void FF2Vanilla_OnBossPlayIntro(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	if (player.GetPropInt("iBossType") == g_iDemopanID)
		player.PlayVoiceClip(DemopanIntro[GetRandomInt(0, sizeof(DemopanIntro)-1)], VSH2_VOICE_INTRO);
	else if (player.GetPropInt("iBossType") == g_iGentleSpyID)
		player.PlayVoiceClip(GentleSpyIntro[GetRandomInt(0, sizeof(GentleSpyIntro)-1)], VSH2_VOICE_INTRO);
	else if (player.GetPropInt("iBossType") == g_iNinjaSpyID)
		player.PlayVoiceClip(NinjaSpyIntro[GetRandomInt(0, sizeof(NinjaSpyIntro)-1)], VSH2_VOICE_INTRO);
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
		player.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_INTRO);
	else if (player.GetPropInt("iBossType") == g_iSeemanID)
		player.PlayVoiceClip(SeemanIntro[GetRandomInt(0, sizeof(SeemanIntro)-1)], VSH2_VOICE_INTRO);
}

public void FF2Vanilla_OnPlayerKilled(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	if( !IsBossFromPack(attacker) )
		return;
	
	float curtime = GetGameTime();
	if( curtime <= attacker.GetPropFloat("flKillSpree") )
		attacker.SetPropInt("iKills", attacker.GetPropInt("iKills") + 1);
	else attacker.SetPropInt("iKills", 0);
	
	if (attacker.GetPropInt("iBossType") == g_iDemopanID)
		attacker.PlayVoiceClip(DemopanKill[GetRandomInt(0, sizeof(DemopanKill)-1)], VSH2_VOICE_SPREE);
	else if(attacker.GetPropInt("iBossType") == g_iNinjaSpyID)
	{
		switch (TF2_GetPlayerClass(victim.index))
		{
			case TFClass_Scout:
				attacker.PlayVoiceClip(NinjaSpyKill[2], VSH2_VOICE_SPREE);
			case TFClass_Soldier:
				attacker.PlayVoiceClip(NinjaSpyKill[3], VSH2_VOICE_SPREE);
			case TFClass_Pyro:
				attacker.PlayVoiceClip(NinjaSpyKill[1], VSH2_VOICE_SPREE);
			case TFClass_DemoMan:
				attacker.PlayVoiceClip(NinjaSpyKill[4], VSH2_VOICE_SPREE);
			case TFClass_Heavy:
				attacker.PlayVoiceClip(NinjaSpyKill[0], VSH2_VOICE_SPREE);
			case TFClass_Engineer:
				attacker.PlayVoiceClip(NinjaSpyKill[5], VSH2_VOICE_SPREE);
		}
	}
	
	if( attacker.GetPropInt("iKills") == 3 && VSH2GameMode_GetTotalRedPlayers() != 1 )
	{
		if (attacker.GetPropInt("iBossType") == g_iDemopanID)
			attacker.PlayVoiceClip(DemopanSpree[GetRandomInt(0, sizeof(DemopanSpree)-1)], VSH2_VOICE_SPREE);
		else if (attacker.GetPropInt("iBossType") == g_iGentleSpyID)
			attacker.PlayVoiceClip(GentleSpySpree[GetRandomInt(0, sizeof(GentleSpySpree)-1)], VSH2_VOICE_SPREE);
		else if (attacker.GetPropInt("iBossType") == g_iNinjaSpyID)
			attacker.PlayVoiceClip(NinjaSpySpree[GetRandomInt(0, sizeof(NinjaSpySpree)-1)], VSH2_VOICE_SPREE);
		else if (attacker.GetPropInt("iBossType") == g_iSeeldierID)
			attacker.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_SPREE);
		else if (attacker.GetPropInt("iBossType") == g_iSeemanID)
			attacker.PlayVoiceClip(SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)], VSH2_VOICE_SPREE);
		
		attacker.SetPropInt("iKills", 0);
	}
	else attacker.SetPropFloat("flKillSpree", curtime+5.0);
}

public Action FF2Vanilla_OnPlayerHurt(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	if (!IsBossFromPack(victim))
		return Plugin_Continue;
	
	int damage = event.GetInt("damageamount");
	victim.GiveRage(damage);
	///Multilive telefrag fix
	int custom = event.GetInt("custom");
	if( custom == TF_CUSTOM_TELEFRAG && victim.GetPropInt("iLives") > 1)
	{
		damage = (victim.GetPropInt("iHealth") + victim.GetPropInt("iMaxHealth") * (victim.GetPropInt("iLives")-1) + 1);
		
		if (damage < 9001)
			damage = 9002;
		
		victim.SetPropInt("iLives",0);
		int attDamage = attacker.GetPropInt("iDamage") + damage;
		attacker.SetPropInt("iDamage", attDamage);
		
		SetVariantInt(damage);
		AcceptEntityInput(victim.index, "RemoveHealth");
		return Plugin_Handled;
	}		
	
	if (damage >= victim.GetPropInt("iHealth") && victim.GetPropInt("iLives") > 1)
	{
		if (victim.GetPropInt("iBossType") == g_iNinjaSpyID)
		{
			victim.PlayVoiceClip(NinjaSpyLostLife[GetRandomInt(0, sizeof(NinjaSpyLostLife)-1)], VSH2_VOICE_ALL);
			
			TF2_AddCondition(victim.index, TFCond_Ubercharged, 4.0);
			//TF2_AddCondition(victim.index, TFCond_DefenseBuffed, 4.0);
			//TF2_AddCondition(victim.index, TFCond_SpeedBuffAlly, 4.0);
			
			///How about slow mo?
			
			victim.SetPropInt("iLives", victim.GetPropInt("iLives") - 1);
			victim.SetPropInt("iHealth", victim.GetPropInt("iMaxHealth"));
		}
	}
	return Plugin_Continue;
}
public void FF2Vanilla_OnPlayerAirblasted(const VSH2Player airblaster, const VSH2Player airblasted, Event event)
{
	if( !IsBossFromPack(airblasted) )
		return;
	float rage = airblasted.GetPropFloat("flRAGE");
	airblasted.SetPropFloat("flRAGE", rage + g_vsh2_cvars.airblast_rage.FloatValue);
}
public void FF2Vanilla_OnBossMedicCall(const VSH2Player player)
{
	if( !IsBossFromPack(player) || player.GetPropFloat("flRAGE") < 100.0 )
		return;
	
	if (player.GetPropInt("iBossType") == g_iDemopanID)
	{
		player.DoGenericStun(600.0);
		SetPawnTimer(TradeSpam, 0.01, player.index, 1);
	}
	else if (player.GetPropInt("iBossType") == g_iGentleSpyID)
	{
		player.DoGenericStun(500.0);
		player.PlayVoiceClip(GentleSpyRage[GetRandomInt(0, sizeof(GentleSpyRage)-1)], VSH2_VOICE_RAGE);
		TF2_AddCondition(player.index, TFCond_Ubercharged, 4.0);
		///Instant teleport
		int target = -1;
		target = GetRandomClient(_, VSH2Team_Red);
		if( target != -1 ) {
			///From HHH code
			/// Chdata's HHH teleport rework
			if( TF2_GetPlayerClass(target) != TFClass_Scout && TF2_GetPlayerClass(target) != TFClass_Soldier ) {
				/// Makes HHH clipping go away for player and some projectiles
				SetEntProp(player.index, Prop_Send, "m_CollisionGroup", 2);
				SetPawnTimer(HHHTeleCollisionReset, 2.0, player.userid);
			}
			
			CreateTimer(3.0, RemoveEnt, EntIndexToEntRef(AttachParticle(player.index, "ghost_appearation", _, false)));
			float pos[3]; GetClientAbsOrigin(target, pos);
			SetEntPropFloat(player.index, Prop_Send, "m_flNextAttack", GetGameTime()+2.0);
			int flags = GetEntityFlags(player.index);
			if( GetEntProp(target, Prop_Send, "m_bDucked") ) {
				float collisionvec[3] = {24.0, 24.0, 62.0};
				SetEntPropVector(player.index, Prop_Send, "m_vecMaxs", collisionvec);
				SetEntProp(player.index, Prop_Send, "m_bDucked", 1);
				SetEntityFlags(player.index, flags|FL_DUCKING);
				SetPawnTimer(StunHHH, 0.2, player.userid, GetClientUserId(target));
			}
			else TF2_StunPlayer(player.index, 1.0, 0.0, TF_STUNFLAGS_GHOSTSCARE|TF_STUNFLAG_NOSOUNDOREFFECT, target);
			
			TeleportEntity(player.index, pos, NULL_VECTOR, NULL_VECTOR);
			SetEntProp(player.index, Prop_Send, "m_bGlowEnabled", 0);
			CreateTimer(3.0, RemoveEnt, EntIndexToEntRef(AttachParticle(player.index, "ghost_appearation")));
			CreateTimer(3.0, RemoveEnt, EntIndexToEntRef(AttachParticle(player.index, "ghost_appearation", _, false)));
			
			/// Chdata's HHH teleport rework
			float vPos[3];
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", vPos);
			
			EmitSoundToClient(player.index, "misc/halloween/spell_teleport.wav");
			EmitSoundToClient(target, "misc/halloween/spell_teleport.wav");
			//PrintCenterText(target, "You've been teleported!");
		}
		
		TF2_RemoveWeaponSlot(player.index, TFWeaponSlot_Primary);
		///25; 0.0	- Max ammo bonus (hidden)
		///2; 9 +800% damage
		///51; 1 Crits on headshot
		///309; 1 Crit kills will gib
		///391; 99 Reduces mystery solving time by up to 99%
		///3; 0.1	- Clip size mult
		int gentleGun = player.SpawnWeapon("tf_weapon_revolver", 61, 100, 5, "25 ; 0.0; 2 ; 9 ; 51 ; 1 ; 309 ; 1 ; 391 ; 99 ; 3 ; 0.1");
		SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", gentleGun);
		SetWeaponAmmo(gentleGun, 2);
	}
	else if (player.GetPropInt("iBossType") == g_iNinjaSpyID)
		player.DoGenericStun(700.0);
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
	{
		player.DoGenericStun(600.0);
		VSH2Player clone;
		for(int i=MaxClients;i;--i)
		{
			///Skip not valid, alive, specs, neutral and unassigned
			if(!IsValidClient(i))
				continue;
			if(IsPlayerAlive(i))
				continue;
			if(GetClientTeam(i) <= VSH2Team_Spectator)
				continue;
			
			clone = VSH2Player(i);
			clone.hOwnerBoss = player;
			clone.ConvertToMinion(0.2);
		}
	}
	else if (player.GetPropInt("iBossType") == g_iSeemanID)
	{
		player.DoGenericStun(500.0);
		SetPawnTimer(RageExplosiveDance, 0.13, player.userid, 0);
		
		player.PlayVoiceClip(SeemanExplosiveDance[GetRandomInt(0, sizeof(SeemanExplosiveDance)-1)], VSH2_VOICE_RAGE);
	}
	
	player.SetPropFloat("flRAGE", 0.0);
}

public void FF2Vanilla_OnBossJarated(const VSH2Player victim, const VSH2Player thrower)
{
	if( !IsBossFromPack(victim) )
		return;
	float rage = victim.GetPropFloat("flRAGE");
	victim.SetPropFloat("flRAGE", rage - g_vsh2_cvars.jarate_rage.FloatValue);
}


public Action FF2Vanilla_OnRoundEndInfo(const VSH2Player player, bool bossBool, char message[MAXMESSAGE])
{
	if( !IsBossFromPack(player) )
		return Plugin_Continue;
	else if( bossBool )
	{
		if (player.GetPropInt("iBossType") == g_iDemopanID)
			player.PlayVoiceClip(DemopanWin[GetRandomInt(0, sizeof(DemopanWin)-1)], VSH2_VOICE_WIN);
		else if (player.GetPropInt("iBossType") == g_iGentleSpyID)
			player.PlayVoiceClip(GentleSpyWin[GetRandomInt(0, sizeof(GentleSpyWin)-1)], VSH2_VOICE_WIN);
		else if (player.GetPropInt("iBossType") == g_iSeeldierID)
			player.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_WIN);
		else if (player.GetPropInt("iBossType") == g_iSeemanID)
			player.PlayVoiceClip(SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)], VSH2_VOICE_WIN);
	}
	
	if (player.GetPropInt("iBossType") == g_iNinjaSpyID && player.GetPropInt("iLives")> 1)
	{
		char name[MAX_BOSS_NAME_SIZE];
		player.GetName(name);
		if (player.GetPropInt("iHealth") == player.GetPropInt("iMaxHealth"))
			Format(message, MAXMESSAGE, "%s\n%s (%N) had %i x %i health left.", message, name, player.index, player.GetPropInt("iHealth"), player.GetPropInt("iLives"));
		else
			Format(message, MAXMESSAGE, "%s\n%s (%N) had %i (and %i x %i) health left.", message, name, player.index, player.GetPropInt("iHealth"), player.GetPropInt("iMaxHealth"), (player.GetPropInt("iLives")-1));
	
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void FF2Vanilla_Music(char song[PLATFORM_MAX_PATH], float &time, const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	
	if(player.GetPropInt("iBossType") == g_iGentleSpyID)
	{
		int theme = GetRandomInt(0, sizeof(GentleSpyThemes)-1);
		Format(song, sizeof(song), "%s", GentleSpyThemes[theme]);
		time = GentleSpyThemesTime[theme];
	}
}

public void FF2Vanilla_OnBossDeath(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	
	if (player.GetPropInt("iBossType") == g_iDemopanID)
		player.PlayVoiceClip(DemopanDeath[GetRandomInt(0, sizeof(DemopanDeath)-1)], VSH2_VOICE_LOSE);
	else if (player.GetPropInt("iBossType") == g_iGentleSpyID)
		player.PlayVoiceClip(GentleSpyDeath[GetRandomInt(0, sizeof(GentleSpyDeath)-1)], VSH2_VOICE_LOSE);
	else if (player.GetPropInt("iBossType") == g_iNinjaSpyID)
		player.PlayVoiceClip(NinjaSpyDeath[GetRandomInt(0, sizeof(NinjaSpyDeath)-1)], VSH2_VOICE_LOSE);
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
		player.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_LOSE);
	else if (player.GetPropInt("iBossType") == g_iSeemanID)
		player.PlayVoiceClip(SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)], VSH2_VOICE_LOSE);
}

public Action FF2Vanilla_OnStabbed(VSH2Player victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if( !IsBossFromPack(victim) )
		return Plugin_Continue;
	
	if (victim.GetPropInt("iBossType") == g_iGentleSpyID)
		victim.PlayVoiceClip(GentleSpyStab[GetRandomInt(0, sizeof(GentleSpyStab)-1)], VSH2_VOICE_STABBED);
	else if (victim.GetPropInt("iBossType") == g_iSeeldierID)
		victim.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_STABBED);
	else if (victim.GetPropInt("iBossType") == g_iSeemanID)
		victim.PlayVoiceClip(SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)], VSH2_VOICE_STABBED);
	
	return Plugin_Continue;
}

public void FF2Vanilla_OnLastPlayer(const VSH2Player player)
{
	if( !IsBossFromPack(player) )
		return;
	else if (player.GetPropInt("iBossType") == g_iDemopanID)
		player.PlayVoiceClip(DemopanLast[GetRandomInt(0, sizeof(DemopanLast)-1)], VSH2_VOICE_LASTGUY);
	else if (player.GetPropInt("iBossType") == g_iSeeldierID)
		player.PlayVoiceClip(SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)], VSH2_VOICE_LASTGUY);
	else if (player.GetPropInt("iBossType") == g_iSeemanID)
		player.PlayVoiceClip(SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)], VSH2_VOICE_LASTGUY);
}

public Action FF2Vanilla_OnSoundHook(const VSH2Player player, char sample[PLATFORM_MAX_PATH], int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if( !IsBossFromPack(player) )
		return Plugin_Continue;
	else if( IsVoiceLine(sample) )
	{
		if (player.GetPropInt("iBossType") == g_iSeeldierID)
		{
			strcopy(sample, PLATFORM_MAX_PATH, SeeldierSound[GetRandomInt(0, sizeof(SeeldierSound)-1)]);
			return Plugin_Changed;
		}
		else if (player.GetPropInt("iBossType") == g_iSeemanID)
		{
			strcopy(sample, PLATFORM_MAX_PATH, SeemanSound[GetRandomInt(0, sizeof(SeemanSound)-1)]);
			return Plugin_Changed;
		}
	}
	
	return Plugin_Continue;
}


///Multilive HUD
public Action FF2Vanilla_OnMessageIntro(const VSH2Player player, char message[MAXMESSAGE])
{
	if (!IsBossFromPack(player))
		return Plugin_Continue;
	///♥♥♥
	if (player.GetPropInt("iLives") <= 1)
		return Plugin_Continue;
	
	Format(message, MAXMESSAGE, "%s and %i Lives", message, player.GetPropInt("iLives"));
	
	return Plugin_Changed;
}

public Action FF2Vanilla_OnBossHealthCheck(const VSH2Player player, const bool isBoss, char message[MAXMESSAGE])
{
	if (!IsBossFromPack(player))
		return Plugin_Continue;
	
	///On last live used default HUD msg
	if (player.GetPropInt("iLives") <= 1)
		return Plugin_Continue;
	
	char name[MAX_BOSS_NAME_SIZE];
	player.GetName(name);
	
	if(isBoss) {
		if (player.GetPropInt("iHealth") == player.GetPropInt("iMaxHealth"))
			PrintCenterTextAll("%s showed his current HP: %i x %i", name , player.GetPropInt("iHealth"), player.GetPropInt("iLives"));
		else
			PrintCenterTextAll("%s showed his current HP: %i and (%i x %i)", name , player.GetPropInt("iHealth"), player.GetPropInt("iMaxHealth"), (player.GetPropInt("iLives")-1));
		return Plugin_Handled;
	}
	
	if (player.GetPropInt("iHealth") == player.GetPropInt("iMaxHealth"))
		Format(message, MAXMESSAGE, "%s\n%s's current health is: %i x %i", message, name, player.GetPropInt("iHealth"), player.GetPropInt("iLives"));
	else
		Format(message, MAXMESSAGE, "%s\n%s's current health is: %i and (%i x %i)", message, name, player.GetPropInt("iHealth"), player.GetPropInt("iMaxHealth"), (player.GetPropInt("iLives")-1));
	return Plugin_Handled;
}

public void FF2Vanilla_OnMinionInitialized(const VSH2Player player, const VSH2Player master)
{
	if( !IsBossFromPack(master) )
		return;
	if (master.GetPropInt("iBossType") == g_iSeeldierID)
		RecruitClone(player, master);
}

void RecruitClone(const VSH2Player base, const VSH2Player master)
{
	int client = base.index;
	TF2_SetPlayerClass(client, TFClass_Soldier, _, false);
	base.RemoveAllItems();
#if defined _tf2attributes_included
	if( VSH2GameMode_GetPropInt("bTF2Attribs") )
		TF2Attrib_RemoveAll(client);
#endif
	int weapon = base.SpawnWeapon("tf_weapon_bottle", 191, 100, 5, "68 ; -1");
	SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
	//TF2_AddCondition(client, TFCond_Ubercharged, 3.0);
	SetEntityHealth(client, 175);
	SetVariantString(SeeldierModel);
	AcceptEntityInput(client, "SetCustomModel");
	SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	SetEntProp(client, Prop_Send, "m_nBody", 0);
	//SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	//SetEntityRenderColor(client, 30, 160, 255, 255);
	
	float masterPosition[3];
	float cloneVelocity[3];
	GetEntPropVector(master.index, Prop_Send, "m_vecOrigin", masterPosition);
	
	cloneVelocity[0]=GetRandomFloat(300.0, 500.0)*(GetRandomInt(0, 1) ? 1.0:-1.0);
	cloneVelocity[1]=GetRandomFloat(300.0, 500.0)*(GetRandomInt(0, 1) ? 1.0:-1.0);
	cloneVelocity[2]=GetRandomFloat(300.0, 500.0);
	TeleportEntity(base.index, masterPosition, NULL_VECTOR, cloneVelocity);
}

///Telefrag fix for multilive bosses
/*
public Action FF2Vanilla_OnTelefragged(VSH2Player victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if( !IsBossFromPack(victim) )
		return Plugin_Continue;
	if(victim.GetPropInt("iLives") <= 1)
		return Plugin_Continue;
	
	damage = float(victim.GetPropInt("iHealth") + victim.GetPropInt("iMaxHealth") * (victim.GetPropInt("iLives")-1) + 1);
	victim.SetPropInt("iLives",0);
	return Plugin_Changed;
}
*/

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

public int HintPanel(Menu menu, MenuAction action, int param1, int param2)
{
	return;
}

///From VSH2
stock int GetRandomClient(bool balive=true, int team=0)
{
	int[] players = new int[MaxClients];
	int count;
	for( int i=MaxClients; i; --i ) {
		if( !IsValidClient(i) )
			continue;
		else if( balive && !IsPlayerAlive(i) )
			continue;
		else if( team && GetClientTeam(i) != team )
			continue;
		
		players[count++] = i;
	}
	return !count ? -1 : players[GetRandomInt(0, count-1)];
}

public void HHHTeleCollisionReset(const int userid)
{
	int client = GetClientOfUserId(userid);
	SetEntProp(client, Prop_Send, "m_CollisionGroup", 5); /// Fix HHH's clipping.
}

public Action RemoveEnt(Handle timer, any entid)
{
	int ent = EntRefToEntIndex(entid);
	if( ent > 0 && IsValidEntity(ent) )
		AcceptEntityInput(ent, "Kill");
	return Plugin_Continue;
}

stock int AttachParticle(const int ent, const char[] particleType, float offset = 0.0, bool battach = true)
{
	int particle = CreateEntityByName("info_particle_system");
	char tName[32];
	float pos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", pos);
	pos[2] += offset;
	TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
	Format(tName, sizeof(tName), "target%i", ent);
	DispatchKeyValue(ent, "targetname", tName);
	DispatchKeyValue(particle, "targetname", "tf2particle");
	DispatchKeyValue(particle, "parentname", tName);
	DispatchKeyValue(particle, "effect_name", particleType);
	DispatchSpawn(particle);
	SetVariantString(tName);
	if (battach) {
		AcceptEntityInput(particle, "SetParent", particle, particle, 0);
		SetEntPropEnt(particle, Prop_Send, "m_hOwnerEntity", ent);
	}
	ActivateEntity(particle);
	AcceptEntityInput(particle, "start");
	CreateTimer(3.0, RemoveEnt, EntIndexToEntRef(particle));
	return particle;
}

public void StunHHH(const int userid, const int targetid)
{
	int client = GetClientOfUserId(userid);
	if( !IsValidClient(client) || !IsPlayerAlive(client) )
		return;
	
	int target = GetClientOfUserId(targetid);
	if( !IsValidClient(target) || !IsPlayerAlive(target) )
		target = 0;
	TF2_StunPlayer(client, 2.0, 0.0, TF_STUNFLAGS_GHOSTSCARE|TF_STUNFLAG_NOSOUNDOREFFECT, target);
}

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

///From FF2 1st set abilities (rewrited)
public void RageExplosiveDance(const int userid, int count)
{
	int client = GetClientOfUserId(userid);
	if(count<=35 && IsPlayerAlive(client))
	{
		SetEntityMoveType(client, MOVETYPE_NONE);
		float bossPosition[3], explosionPosition[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", bossPosition);
		
		explosionPosition[2]=bossPosition[2];
		TF2_AddCondition(client, TFCond_Ubercharged, 0.2);
		//TF2_AddCondition(client, TFCond_BlastImmune, 0.2);
		for(int i; i<5; i++)
		{
			int explosion=CreateEntityByName("env_explosion");
			DispatchKeyValueFloat(explosion, "DamageForce", 180.0);
			
			SetEntProp(explosion, Prop_Data, "m_iMagnitude", 280, 4);
			SetEntProp(explosion, Prop_Data, "m_iRadiusOverride", 200, 4);
			SetEntPropEnt(explosion, Prop_Data, "m_hOwnerEntity", client);
			
			DispatchSpawn(explosion);
			
			explosionPosition[0]=bossPosition[0]+GetRandomFloat(-350.0, 350.0);
			explosionPosition[1]=bossPosition[1]+GetRandomFloat(-350.0, 350.0);
			
			if(!(GetEntityFlags(client) & FL_ONGROUND))
				explosionPosition[2]=bossPosition[2]+GetRandomFloat(-150.0, 150.0);
			else
				explosionPosition[2]=bossPosition[2]+GetRandomFloat(0.0,100.0);
			TeleportEntity(explosion, explosionPosition, NULL_VECTOR, NULL_VECTOR);
			AcceptEntityInput(explosion, "Explode");
			AcceptEntityInput(explosion, "kill");
			
			//SetVariantInt(BossTeam);
			//AcceptEntityInput(proj, "TeamNum", -1, -1, 0);
			//SetVariantInt(BossTeam);
			//AcceptEntityInput(proj, "SetTeam", -1, -1, 0);
			//SetEntPropEnt(proj, Prop_Send, "m_hOwnerEntity",boss);
		}
	}
	else
	{
		SetEntityMoveType(client, MOVETYPE_WALK);
		return;
	}
	SetPawnTimer(RageExplosiveDance, 0.13, userid, (count+1));
}

public void TradeSpam(int client, int count)
{
	if (count >= 13)///Rage has finished-reset it in 6 seconds (trade_0 is 100% transparent apparently)
		SetPawnTimer(TradeSpam, 6.0, client, 0);
	else
	{
		for(int i=MaxClients; i; --i)
		{
			if(!IsValidClient(i))
				continue;
			if(GetClientTeam(i) == GetClientTeam(client) || !IsPlayerAlive(i))
				continue;
			VSH2Player(i).SetOverlay(DemopanMaterial[count]);
		}
		if(count)
		{
			VSH2Player(client).PlayVoiceClip(DemopanRage[GetRandomInt(0, sizeof(DemopanRage)-1)], VSH2_VOICE_RAGE);
			///Give a longer delay between the first and second overlay for "smoothness"
			SetPawnTimer(TradeSpam, (count==1 ? 1.0 : 0.5/float(count)), client, (count+1));
		}
	}
}