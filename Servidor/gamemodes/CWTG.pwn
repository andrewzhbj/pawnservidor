/*
<===========================================>

- Desarrollado por: [WTx]Andrew_Manu
- Creado por: QWER
- Mapeos por: [WTx]ScorPioN
- Versión: 4.2b
- Fecha: 25/01/19

<===========================================>
*/

#include <a_samp>
#include <a_actor>
#include <foreach>
#include <geolocation>

#pragma tabsize 0

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#define NOMBRE_EQUIPO_NARANJA 	"WTx"
#define NOMBRE_EQUIPO_VERDE 	"Otro"

#define ARMA_PORDEFECTO 		26
#define RONDAS_PORDEFECTO 		1
#define PUNTAJE_PORDEFECTO 		15
#define IPFILE "ip/%s.txt"
#define CLANES "clanes/%s.txt"
#define CLANES_REGISTRADOS      4
#define PARAMETROS              22*CLANES_REGISTRADOS

#define EQUIPO_NARANJA 0
#define EQUIPO_VERDE 1
#define EQUIPO_SPEC 2
#define EQUIPO_DERBY 3


#define TOP 256
#define LISTA_CLANES 569
#define STAT_CLAN    670
#define MUSICAC 157
#define LECHERO 40
#define CAMBIAR_MAPA 343
#define CUENTA_LOGEADA 30
#define CUENTA_REGISTRAR 31
#define CUENTA_CAMBIAR_NICK 51
#define ADMINS_CONECTADOS 550
#define RANKEDSC 242
#define RANKEDSG 243

#define CLAN_TOP_KILLS 244

#define BLANCO 0xF8F8FFFF
#define COLOR_PM 0x007F8793
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_WHITE 0x70FBFFFF
#define COLOR_RED 0x810000FF
#define COLOR_GREEN 0x007C0EFF
#define COLOR_DERBY 0x00FF6060
#define COLOR_BLUE 0x0000FFFF
#define COLOR_NARANJA 0xF69521AA

#define QCMD:%1()          \
                        forward cmd_%1(playerid,params[],bool:help); \
                        public cmd_%1(playerid,params[],bool:help)
#define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#define ForPlayers(%0) for(new %0; %0 <= Connects;%0++) if(IsPlayerConnected(%0))
new bool:FALSE=false;
#define SCMF(%0,%1,%2,%3) do{new _string[128]; format(_string,sizeof(_string),%2,%3); SendClientMessage(%0,%1,_string);} while(FALSE)
#define SCMTAF(%0,%1,%2) do{new _string[128]; format(_string,sizeof(_string),%1,%2); SendClientMessageToAll(%0,_string);} while(FALSE)
#define SCM SendClientMessage
#define SCMTA SendClientMessageToAll

new Connects;
new Mapa_servidor;

new Float:Jugador_pos[8][3][8] =
{
	{{1136.34, 1206.73, 11.14},{1139.53, 1353.59, 10.83},{1173.8146,1360.5886,14.4720}},									/* Las venturas */
    {{1617.4435, 1629.5537, 11.5618},{1497.5476, 1501.1267, 10.3481},{1599.2198, 1512.4071, 22.0793}},						/* Aeropuerto LV */
    {{-1313.0103, -55.3676, 13.4844},{-1186.4745,-182.0161,14.1484,44.5505},{-1227.1295, -76.7832, 29.0887}},				/* Aeropuerto SF */
    {{-2047.4285,-117.2283,35.2487,178.9484},{-2051.0955,-267.9533,35.3203,358.7801},{-2092.7380, -107.3132, 44.5237}},		/* Auto-escuela */
    {{425.5687, -2780.2439, 17.3731},{205.6855, -2779.9207, 17.3731},{291.7016, -2723.0449, 23.2539}},						/* Omega */
    //{{843.9710,-2835.3689,12.79},{760.48,-2720.81,12.79},{733.13,-2775.95,25.3693}},	Jardín-mágico */
    {{-1259.0441, -584.8804, 13.5902},{-1463.8308, -600.6301, 14.4929},{-1335.3401, -647.8824, 29.6768}},					/* Aeropuerto LV2 */
    {{2071.0554, -2284.8943, 13.5469, 84.4657},{1865.7639,-2299.0803,13.5469,288.4241},{1921.2411, -2209.7275, 29.3730}},	/* Aeropuerto LS */
    {{-2216.2900,498.2071,35.1719,48.8015},{-2288.8696,580.3350,35.1641,228.6565},{-2297.5000,531.4240,44.7344,296.2342}} 	/* Woozy */
};

/*¨
{{843.9710,-2835.3689,12.79},{760.48,-2720.81,12.79},{733.13,-2775.95,25.3693}}, Jardín-mágico
{{-1259.0441, -584.8804, 13.5902},{-1463.8308, -600.6301, 14.4929},{-1335.3401, -647.8824, 29.6768}}  Aeropuerto LV2
{{2071.2000, -2285.0835, 13.2342},{1865.5839, -2299.2966, 12.7969},{1921.2411, -2209.7275, 29.3730}}  Aeropuerto LS
*/


new Ad_fps[MAX_PLAYERS];
new TDraws[MAX_PLAYERS];
new Armas_rw[MAX_PLAYERS];
new Armas_ww[MAX_PLAYERS];
new Congelado[MAX_PLAYERS];
new Sospechoso[MAX_PLAYERS];

new FPS[MAX_PLAYERS], FPSS[MAX_PLAYERS];

new Cambiar_nombre[MAX_PLAYERS];
new Elegir_Personaje[MAX_PLAYERS];
new EstaEnDerby[MAX_PLAYERS], dArena1, MAX_DERBY, derbycerrado, dcontador;

new naranja, verde;
new fpslimit, pinglimit, MAX_PING, MIN_FPS;
new Texto[170];

new Text:Textdraw0;
new Text:Textdraw1[MAX_PLAYERS];
new Text:TextdrawFondo;
new Text:Textdraw01;
new Text:Textdraw100;
new Text:Textdraw101;
new Text:Textdraw2;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11;
new Text:Textdraw12;
new Text:Textdraw13;
new Text:Textdraw14;
new Text:Textdraw15;
new Text:TextdrawWTx;
new Text:TextdrawD3x;
new Text:Frames[MAX_PLAYERS];
new Text:FONDOENTRADA1;
new Text:FONDOENTRADA2;
new Text:LATERAL1;
new Text:LATERAL2;
new Text:TOXICWARRIORS;
new Text:SERVERCWTG;



new txdAlpha[2][MAX_PLAYERS];
new Text:txd[2][MAX_PLAYERS];
new Float:currentHpLoss[2][MAX_PLAYERS][MAX_PLAYERS];


new Float:Clan_top[4][5];
new Clan_id[][] =
{
	{0,1,2,3,4},
	{0,1,2,3,4},
	{0,1,2,3,4},
	{0,1,2,3,4}
};
new Clan_kills[CLANES_REGISTRADOS];
new Clan_muertes[CLANES_REGISTRADOS];
new Float:Clan_ratio[CLANES_REGISTRADOS];
new Clan_Cganadas[CLANES_REGISTRADOS];
new Clan_Cperdidas[CLANES_REGISTRADOS];
new Clan_n[MAX_PLAYERS];
new Clanes[4][CLANES_REGISTRADOS] =
{
	{"WTx"},
	{"KDs"},
	{"DcP"},
	{"R$x"}
};
enum Datos{ Nombre_clan[32], Creacion_clan, Dueno_clan[32] }
new Clanes_descripcion[][Datos] =
{
	{"Toxic Warriors", 			2011, 	"[WTx]Andrew_Manu"},
	{"Death's King's Squad", 	0, 		"Null"},
	{"Dicaprios Family", 		0, 		"Null"},
	{"Rebelion Street Xtreme", 	0, 		"Null"}
};

new nombreArma[][] =
{
    {"Pene"},
    {"Brass Knuckles"},
    {"Golf Club"},
    {"Nite Stick"},
    {"Knife"},
    {"Baseball"},
    {"Shovel"},
    {"Pool Cue"},
    {"Katana"},
    {"Chainsaw"},
    {"Dildo"},
    {"Dildo"},
    {"Dildo"},
    {"Dildo"},
    {"Flowers"},
    {"Cane"},
    {"Grenade"},
    {"Tear Gas"},
    {"Molotov"},
    {"C4"},
    {""},
    {""},
    {"Pistola"},
    {"Silencer"},
    {"Deagle"},
    {"Shotgun"},
    {"SawnOff"},
    {"Spas12"},
    {"Tec9"},
    {"MP5"},
    {"Ak47"},
    {"M4"},
    {"Tec9"},
    {"Rifle"},
    {"Sniper"},
    {"Rocket Launcher"},
    {"HS Rocket Launcher"},
    {"Flamethrower"},
    {"Minigun"},
    {"C4"},
    {"Detonator"},
    {"Spray"},
    {"Fire Extinguisher"},
    {"Camera"},
    {"Nightvision"},
    {"Infrared Vision"},
    {"Parachute"},
    {"Defuseal Kit"}
};

new Nick_top[5][50];
new Float:Score_top[5] = {0.00,0.00,0.00,0.00,0.00};
new Float:Puntaje_ranked[MAX_PLAYERS], Float:rankp[MAX_PLAYERS];
new idelegido[MAX_PLAYERS];

new lecheroact;
new Text3D:lecherotext;
new lecheroaccion;
new lecherobot;
new lecherogod;

new Equipo[MAX_PLAYERS] = {-1,...};
new Equipo_kills[MAX_PLAYERS];
new Muertes[MAX_PLAYERS];
new Kills2[MAX_PLAYERS];
new Kills[MAX_PLAYERS];
new Nombre_equipo[2][50];
new Equipo_puntaje[2];
new Equipo_rondas[2];
new Equipos_bloq;
new Ronda_maxima;
new Puntaje_maximo;
new Puntaje_total[2];
new Modo_juego;
new Owned[2];

new Objectos[12];
new Contra_servidor[50];
new Voz[128];
new Pausa;
new Arma;
new Count = -1;

new EstaEnX1[MAX_PLAYERS];
new X1_Ganados[MAX_PLAYERS];
new X1_Perdidos[MAX_PLAYERS];
new X1_cerrado;
new X1W_Arena1, X1W_Arena2;
new X1_Arena1, X1_Arena2, X1_Arena3;


new pDrunkLevelLast[MAX_PLAYERS];
new pFPS[MAX_PLAYERS];
new Spec[MAX_PLAYERS] = {-1,...};
new Admin[MAX_PLAYERS];
new PlayerSkin[MAX_PLAYERS];


new Vehiculos[50];
new Vehiculos_derby[50];
new Cont_vehiculos;
new Cont_derby;

new iString[256];

forward CountDownDerbyPublic();
forward CountDownPublic();
forward HideWin();
forward LockedServerKick(playerid);
forward PosRefresh();
forward Test(playerid,Float:x,Float:y,Float:z,type);

new Float:Objects[11][4] ={
 {320.31, -2833.04, 21.24, -180.0},    	/* Omega */
 {1098.42, 1281.47, 12.5,90.0},      	/* Las Venturas */
 {751.61, -2777.31, 15.5, 90.0},     	/* Jardin Mágico */
 {1590.75, 1522.60, 12.91,-140.0},   	/* Aero LV */
 {-1335.29, -636.29, 16.17, 180.0},
 {-1396.88, -636.29, 16.17, 180.0},
 {-1234.09, -84.41, 16.39,-44.94},
 {2007.66, -2230.02, 16.15,0.00},  /* LS */
 {1921.54, -2231.34, 16.15,0.00},  /* LS */
 {-2096.01, -188.82, 37.45,90.04},
 {-2011.62, -189.27, 37.45,-90.04}
};

new Float:Derby_spawns[][] ={
	{637.8331,3176.8477,77.2824},
	{656.5710,3178.2256,77.2894},
	{765.5673,3269.2732,55.5953},
	{691.3903,3286.3284,55.5953},
	{634.0861,3259.9646,55.5953},
	{547.3107,3191.0906,55.5953},
	{514.9573,3112.2605,55.6153},
	{639.2745,3087.7207,55.5753},
	{689.2029,3138.7468,55.5953}
};

new Float:x1spawns[][] ={
	{1361.3468, -46.1324, 1000.9240},
	{1408.0518, -34.1221, 1001.1148},
	{1414.5874, 1.0335, 1002.1307},
	{1363.0325, 0.7593, 1001.6202},
	{1392.8837, -25.6937, 1000.2111}
};

new Float:x1a2spawns[][] ={
	{-1379.6559, 1279.2454, 1039.4048},
	{-1406.1509, 1241.1178, 1039.3011},
	{-1430.2312, 1261.7163, 1039.5590},
	{-1366.7761, 1223.9978, 1039.1738},
	{-1370.0677, 1248.2391, 1039.263}
};

new Float:x1a3spawns[][] ={
	{-3310.4426, 1734.1752, 217.8864},
	{-3355.6599, 1729.7410, 217.1869},
	{-3347.3665, 1692.7094, 217.4681},
	{-3309.2285, 1728.6978, 217.3069},
	{-3363.1924, 1726.7935, 217.2867}
};

main()
{
        print("\n");
        print(" GameMode: Modo CW/TG");
        print(" Developer: Andrew_Manu");
        print(" Creador: QWER");
        print("	Version: 4.2b");
        print(" Fecha: 25.01.2019");
        print(" Clan: Toxic Warriors");
        print("\n");
}


stock Guardar(){
	new topg[128];
	format(topg,128,"top.txt");
	if(fexist(topg)){
		new File:f = fopen(topg,io_write);
		format(topg,128,"%s\r\n%.3f\r\n%s\r\n%.3f\r\n%s\r\n%.3f",
		Nick_top[0], Score_top[0], Nick_top[1], Score_top[1], Nick_top[2], Score_top[2], Nick_top[3], Score_top[3], Nick_top[4], Score_top[4]);
		fwrite(f,topg);
		fclose(f);
  	}
}

stock OrdenarGLOBAL2(){
	new i = 0, buscar = 0, maximo = MAX_PLAYERS;
 	do{
 	    if(IsPlayerConnected(i)){
  			if(!strcmp(Nick_top[buscar], nombre(i))){
    			//printf("%s es igual a %s, i:%d buscar: %d", Nick_top[buscar], nombre(i), i, buscar);
				Nick_top[buscar] = nombre(i);
				Score_top[buscar] = Puntaje_ranked[i];
				Guardar();
				i++;
				buscar = 0;
				printf("%d encontrado1", i);
			}else if(strcmp(Nick_top[buscar], nombre(i))){
				if(Puntaje_ranked[i] > Score_top[buscar]){
					Nick_top[buscar] = nombre(i);
					Score_top[buscar] = Puntaje_ranked[i];
					Guardar();
  					i++;
  					buscar = 0;
					printf("%d encontrado2", i);
				}else{
            		buscar++;
					if(buscar == 5){
            			buscar = 0;
            			i++;
						printf("salteado");
					}
				}
			}
 	    }
   }while(i != maximo);
}

stock Ordenar(){
	new Float:aux, auxs;
	ForPlayers(i){
	    //if(IsPlayerConnected(i)){
			rankp[i] = Puntaje_ranked[i];
			idelegido[i] = i;
		//}
	}
	for(new x=0;x<MAX_PLAYERS;x++){
		for(new y=x+1;y<MAX_PLAYERS;y++){
 			if(rankp[x] < rankp[y]){
				aux = rankp[x];
				rankp[x] = rankp[y];
				rankp[y] = aux;
				auxs = idelegido[x];
				idelegido[x] = idelegido[y];
				idelegido[y] = auxs;
			}
  		}
   	}
}

stock Ordenar_c(s){
	new Local[100], Clan[100], File:c, aux;
	for(new a=0;a<CLANES_REGISTRADOS;a++){
		format(Clan, 50, "%s.txt", Clanes[a]);
		format(Local, 50, CLANES, Clan);
  		if(fexist(Local)){
    		c = fopen(Local,io_read);
    		fread(c,Local); Clan_top[a][0] = strval(Local);
			fread(c,Local); Clan_top[a][1] = strval(Local);
			fread(c,Local); Clan_top[a][2] = floatstr(Local);
			fread(c,Local); Clan_top[a][3] = strval(Local);
			fread(c,Local); Clan_top[a][4] = strval(Local);
		}
	}
	fclose(c);
	printf("hola");
	switch(s){
	    case 0:
	    {
		for(new x=0;x<CLANES_REGISTRADOS;x++){
	            for(new y=x+1;y<CLANES_REGISTRADOS;y++){
	                if(Clan_top[x][0] < Clan_top[y][0]){
	                    aux = Clan_id[0][x];
						Clan_id[0][x] = Clan_id[0][y];
						Clan_id[0][y] = aux;
						printf("x:%d < y:%d", Clan_id[0][x],Clan_id[0][y]);
	 				}
     			}
     		}
		}
		case 1:
	    {
		for(new x=0;x<CLANES_REGISTRADOS;x++){
	            for(new y=x+1;y<CLANES_REGISTRADOS;y++){
	                if(Clan_top[x][1] < Clan_top[y][1]){
	                    aux = Clan_id[1][x];
						Clan_id[1][x] = Clan_id[1][y];
						Clan_id[1][y] = aux;
						printf("x:%d < y:%d", Clan_id[1][x],Clan_id[1][y]);
	 				}
     			}
     		}
		}
	}
}
stock PlayerSpectatePlayerEx(playerid,id){
	new str[100];
 	if(EstaEnDerby[id] > 0){
 		format(str, 100, "~y~Auto de: ~g~%s ~w~(%d)", nombre(id),id);
   		new autoid = GetPlayerVehicleID(id);
    	PlayerSpectateVehicle(playerid,autoid);
	}else{
		format(str, 100, "~g~%s ~w~(%d)", nombre(id),id);
		PlayerSpectatePlayer(playerid,id,0);
	}
	GameTextForPlayer(playerid, str, 10000, 6);
}

public OnGameModeInit()
{
        Mapa_servidor = 2;
        lecheroact = -1;
        lecherogod = 1;
		lecheroaccion = 0;
        SetWorldTime(15);
        SetWeather(7);
        Estadisticas();
		fpslimit = 0;
		pinglimit = 0;
		MAX_PING = 400;
		MIN_FPS = 35;
		naranja = 0;
		verde = 0;
		dArena1 = 0;
		derbycerrado = 0;
		dcontador = 0;
		MAX_DERBY = 3;
		 		
		new Local[100], Clan[50], datos[128];
		new File:c;
		for(new x=0;x<CLANES_REGISTRADOS;x++){
			format(Clan, 50, "%s.txt", Clanes[x]);
			format(Local, 50, CLANES, Clan);
		    if(!fexist(Local)){
   				fcreate(Local);
      			c = fopen(Local,io_write);
            	format(datos, 128,"0\r\n0\r\n0.000\r\n0\r\n0\r\n");
           		fwrite(c, datos);
		    }else{
		        c = fopen(Local,io_read);
        		fread(c,Local); Clan_kills[x] 	= strval(Local);
  				fread(c,Local); Clan_muertes[x] = strval(Local);
		 		fread(c,Local); Clan_ratio[x] 	= floatstr(Local);
		        //DelChar(Local);
		        //format(datos, 128,"%d\r\n%d\r\n0.000\r\n0\r\n0\r\n", Clan_kills[x], Clan_muertes[x], Clan_ratio[x], Clan_Cganadas[x], Clan_Cperdidas[x]);
		        //fread(c, Local);
		        printf("clankills %d, kills:%d, muertes:%d, ratio:%.3f", x, Clan_kills[x], Clan_muertes[x], Clan_ratio[x]);
		    }
		}
		fclose(c);
  		new topg[128];
		format(topg,128,"top.txt");
		new File:f = fopen(topg,io_read);
		for(new p=0;p<5;p++){
			fread(f,topg);
			DelChar(topg);
			format(Nick_top[p],50,"%s",topg);
			fread(f,topg);
			Score_top[p] = floatstr(topg);
		}
		fclose(f);

        format(Nombre_equipo[0],50,"%s", NOMBRE_EQUIPO_NARANJA);
        format(Nombre_equipo[1],50,"%s", NOMBRE_EQUIPO_VERDE);
        Arma = ARMA_PORDEFECTO;
        Ronda_maxima = RONDAS_PORDEFECTO;
        Puntaje_maximo = PUNTAJE_PORDEFECTO;

        DisableInteriorEnterExits();
        UsePlayerPedAnims();
        RefreshObject();
        Crear_lista();
        SetTimer("PosRefresh",1500,true);

        //230 115 122 106 107 108 114 137 174 261
        AddPlayerClass(230,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(115,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(122,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(106,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(107,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(108,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(114,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(144,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(185,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(261,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);
        AddPlayerClass(126,-1247.2589,-91.8672,14.1484,203.8234,0,0,0,0,0,0);

/*							[Derby arena 1 por Lechero]                                 */
		CreateObject(6959, 646.93134, 3185.60693, 54.60812,   0.00000, 0.00000, 356.13412);
		CreateObject(8558, 683.88568, 3217.23120, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 688.83655, 3200.42822, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 631.92523, 3226.74658, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 714.26080, 3243.81128, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 709.18384, 3210.69775, 53.06680,   0.00000, 0.00000, 322.86954);
		CreateObject(8558, 728.87347, 3198.10205, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 680.63702, 3242.33179, 53.06680,   0.00000, 0.00000, 301.42056);
		CreateObject(8558, 670.44757, 3264.49146, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 742.62323, 3238.40674, 53.06680,   0.00000, 0.00000, 131.59615);
		CreateObject(8558, 712.39441, 3272.39282, 53.06680,   0.00000, 0.00000, 131.59615);
		CreateObject(8558, 680.86932, 3286.05005, 53.06680,   0.00000, 0.00000, 181.54901);
		CreateObject(8558, 752.33716, 3205.41211, 53.06680,   0.00000, 0.00000, 81.23486);
		CreateObject(8558, 690.45514, 3267.84912, 53.06680,   0.00000, 0.00000, 200.54831);
		CreateObject(8558, 730.48151, 3282.89038, 53.06680,   0.00000, 0.00000, 200.54831);
		CreateObject(8558, 734.81567, 3218.19678, 53.06680,   0.00000, 0.00000, 243.65169);
		CreateObject(8558, 753.74817, 3256.30298, 53.06680,   0.00000, 0.00000, 243.65169);
		CreateObject(8558, 754.03162, 3282.15234, 53.06680,   0.00000, 0.00000, 310.75430);
		CreateObject(8558, 667.56702, 3224.36523, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 607.69598, 3205.50952, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 686.49573, 3165.81128, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 662.15674, 3144.42285, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 626.27576, 3146.71802, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 604.97089, 3170.66089, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 610.07959, 3153.75342, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 679.90131, 3149.43042, 53.06680,   0.00000, 0.00000, 132.96899);
		CreateObject(8558, 614.62494, 3221.29761, 53.06680,   0.00000, 0.00000, 132.96899);
		CreateObject(8558, 634.85333, 3266.96094, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 623.86285, 3291.76343, 53.06680,   0.00000, 0.00000, 167.58681);
		CreateObject(8558, 587.22467, 3250.68945, 53.06680,   0.00000, 0.00000, 132.96899);
		CreateObject(8558, 567.28809, 3207.77734, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 614.15649, 3249.96680, 53.06680,   0.00000, 0.00000, 200.54831);
		CreateObject(8558, 585.68256, 3224.93628, 53.06680,   0.00000, 0.00000, 243.65169);
		CreateObject(8558, 615.69543, 3271.47388, 53.06680,   0.00000, 0.00000, 329.73709);
		CreateObject(8558, 590.67987, 3282.90649, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 560.18964, 3256.51416, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 547.13391, 3224.58447, 53.06680,   0.00000, 0.00000, 273.19794);
		CreateObject(8558, 653.65210, 3286.62061, 53.04680,   0.00000, 0.00000, 174.24770);
		CreateObject(8558, 580.77643, 3291.82690, 53.06680,   0.00000, 0.00000, 329.73709);
		CreateObject(8558, 566.43542, 3226.06909, 53.06680,   0.00000, 0.00000, 293.96243);
		CreateObject(8558, 550.14465, 3262.95996, 53.06680,   0.00000, 0.00000, 293.96243);
		CreateObject(8558, 551.63977, 3292.53223, 53.06680,   0.00000, 0.00000, 227.30208);
		CreateObject(8558, 564.71753, 3173.03149, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 579.73535, 3127.28516, 53.06680,   0.00000, 0.00000, 41.17263);
		CreateObject(8558, 623.18243, 3106.78662, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 613.00574, 3127.74121, 53.06680,   0.00000, 0.00000, 301.42056);
		CreateObject(8558, 583.75500, 3160.17456, 53.06680,   0.00000, 0.00000, 322.86954);
		CreateObject(8558, 555.36493, 3109.83374, 53.06680,   0.00000, 0.00000, 309.06393);
		CreateObject(8558, 547.03687, 3184.78857, 53.06680,   0.00000, 0.00000, 266.78961);
		CreateObject(8558, 544.59424, 3144.54028, 53.06680,   0.00000, 0.00000, 266.78961);
		CreateObject(8558, 586.41400, 3092.88892, 53.04680,   0.00000, 0.00000, 353.33041);
		CreateObject(8558, 599.28381, 3091.49927, 53.06680,   0.00000, 0.00000, 353.33041);
		CreateObject(8558, 605.58350, 3097.89502, 53.06680,   0.00000, 0.00000, 31.50041);
		CreateObject(8558, 556.13580, 3152.67261, 53.04680,   0.00000, 0.00000, 59.45616);
		CreateObject(8558, 570.61920, 3119.37769, 53.04680,   0.00000, 0.00000, 41.17260);
		CreateObject(8558, 535.63135, 3118.12720, 53.04680,   0.00000, 0.00000, 59.45616);
		CreateObject(8558, 571.10730, 3076.79761, 53.06680,   0.00000, 0.00000, 31.50041);
		CreateObject(8558, 524.90271, 3100.13086, 53.08680,   0.00000, 0.00000, 309.06390);
		CreateObject(8558, 550.33020, 3068.78125, 53.08680,   0.00000, 0.00000, 309.06390);
		CreateObject(8558, 707.39081, 3119.91016, 53.06680,   0.00000, 0.00000, 132.96899);
		CreateObject(8558, 659.29492, 3104.14526, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 726.55334, 3163.41455, 53.06680,   0.00000, 0.00000, 356.67819);
		CreateObject(8558, 707.30347, 3151.79346, 53.06680,   0.00000, 0.00000, 32.78149);
		CreateObject(8558, 674.37720, 3124.37085, 53.06680,   0.00000, 0.00000, 46.16108);
		CreateObject(8558, 640.02289, 3087.82080, 53.04680,   0.00000, 0.00000, 356.20471);
		CreateObject(8558, 680.67633, 3085.13965, 53.04680,   0.00000, 0.00000, 356.20471);
		CreateObject(8558, 742.56714, 3139.65503, 53.06680,   0.00000, 0.00000, 85.84429);
		CreateObject(8558, 727.43304, 3106.49976, 53.06680,   0.00000, 0.00000, 46.16108);
		CreateObject(8558, 686.53333, 3084.75171, 53.02680,   0.00000, 0.00000, 356.20471);
		CreateObject(8558, 718.73932, 3097.43994, 53.04680,   0.00000, 0.00000, 46.16110);
		CreateObject(8558, 708.17157, 3119.05713, 53.04680,   0.00000, 0.00000, 132.96899);
		CreateObject(8558, 675.49799, 3093.99683, 53.02680,   0.00000, 0.00000, 141.87370);
		CreateObject(8558, 707.26337, 3069.07178, 53.02680,   0.00000, 0.00000, 141.87370);
		CreateObject(8558, 737.60071, 3146.87036, 53.02680,   0.00000, 0.00000, 122.95086);
		CreateObject(8558, 759.48706, 3113.04321, 53.02680,   0.00000, 0.00000, 122.95086);
		CreateObject(8558, 736.06818, 3067.88428, 53.06680,   0.00000, 0.00000, 39.04698);
		CreateObject(8558, 756.96442, 3084.87231, 53.06680,   0.00000, 0.00000, 39.04698);
		CreateObject(8558, 746.25989, 3166.03296, 53.04680,   0.00000, 0.00000, 81.23490);
		CreateObject(13607, 645.77539, 3186.29102, 79.82150,   0.00000, 0.00000, 0.00000);
		CreateObject(8558, 703.21075, 3109.48535, 63.98903,   0.00000, 33.00000, 313.13239);
		CreateObject(8558, 716.90369, 3124.08203, 63.98903,   0.00000, 33.00000, 316.60751);
		CreateObject(8558, 691.10144, 3149.56958, 74.73390,   0.00000, 0.00000, 134.64676);
		CreateObject(8558, 678.39465, 3135.96313, 74.73390,   0.00000, 0.00000, 133.08136);
		CreateObject(8558, 720.28253, 3234.28687, 63.98903,   0.00000, 33.00000, 42.22890);
		CreateObject(8558, 706.58545, 3249.70459, 63.98903,   0.00000, 33.00000, 41.41270);
		CreateObject(8558, 693.13019, 3210.23145, 74.73390,   0.00000, 0.00000, 221.31268);
		CreateObject(8558, 679.28735, 3225.74097, 74.73390,   0.00000, 0.00000, 221.31268);
		CreateObject(8558, 595.50372, 3261.18286, 63.98903,   0.00000, 33.00000, 129.94464);
		CreateObject(8558, 576.76746, 3245.29321, 63.98903,   0.00000, 33.00000, 129.94464);
		CreateObject(8558, 618.82861, 3233.33569, 74.73390,   0.00000, 0.00000, 310.04614);
		CreateObject(8558, 600.10602, 3217.48511, 74.73390,   0.00000, 0.00000, 310.04614);
		CreateObject(8558, 565.46832, 3128.50732, 63.98903,   0.00000, 33.00000, 217.39917);
		CreateObject(8558, 594.20416, 3150.69409, 74.73390,   0.00000, 0.00000, 37.86940);
		CreateObject(8558, 577.55450, 3113.49658, 63.98903,   0.00000, 33.00000, 217.39917);
		CreateObject(8558, 625.82501, 3175.26636, 74.73390,   0.00000, 0.00000, 37.86940);
		CreateObject(8558, 606.40631, 3135.52686, 74.73390,   0.00000, 0.00000, 37.35930);
		CreateObject(8558, 638.43121, 3159.95361, 74.73390,   0.00000, 0.00000, 37.35930);
		CreateObject(8558, 702.08691, 3160.74072, 74.73390,   0.00000, 0.00000, 265.59583);
		CreateObject(8558, 705.12085, 3200.94604, 74.73390,   0.00000, 0.00000, 265.59583);
		CreateObject(8558, 588.57477, 3165.76660, 74.73390,   0.00000, 0.00000, 265.59583);
		CreateObject(8558, 591.68054, 3205.85815, 74.73390,   0.00000, 0.00000, 265.59583);
		CreateObject(8558, 630.07416, 3242.41113, 74.73390,   0.00000, 0.00000, 354.20551);
		CreateObject(8558, 670.28070, 3238.36157, 74.73390,   0.00000, 0.00000, 354.20551);
		CreateObject(8558, 661.39484, 3133.19556, 74.73390,   0.00000, 0.00000, 357.70016);
		CreateObject(8558, 625.83124, 3134.66577, 74.73390,   0.00000, 0.00000, 357.70016);
		CreateObject(1633, 675.62262, 3209.72412, 76.63651,   0.00000, 0.00000, 310.40854);
		CreateObject(1633, 670.09247, 3158.02905, 76.63651,   0.00000, 0.00000, 224.59763);
		CreateObject(1633, 619.37012, 3160.31030, 76.63651,   0.00000, 0.00000, 131.61861);
		CreateObject(1633, 621.05865, 3213.95117, 76.63651,   0.00000, 0.00000, 42.40464);
		CreateObject(9166, 646.79169, 3186.72339, 73.57780,   0.00000, 0.00000, 0.00000);
		CreateObject(9166, 646.77008, 3186.75757, 73.57580,   0.00000, 0.00000, 88.84410);
		CreateObject(13599, 796.58057, 3255.00415, 76.21790,   90.00000, 0.00000, 98.00000);
		CreateObject(13599, 591.86853, 3326.96826, 76.21790,   90.00000, 0.00000, 179.97429);
		CreateObject(13599, 495.19302, 3131.25635, 76.21790,   90.00000, 0.00000, -91.00000);
		CreateObject(13599, 738.63025, 3030.82739, 76.21790,   90.00000, 0.00000, 0.79588);
		CreateObject(13599, 750.47821, 3080.62305, 114.96354,   0.00000, 0.00000, 1.00000);
		CreateObject(13599, 745.84467, 3281.55835, 114.96354,   0.00000, 0.00000, 1.00000);

/*							[Derby arena 1 por Scorpion]                                 */

		CreateObject(3458, -2147.25903, 1888.11475, 4.33557,   0.00000, 0.00000, 95.35550);
		CreateObject(3458, -2134.77710, 1889.26270, 4.33557,   0.00000, 0.00000, 275.32834);
		CreateObject(8558, -2135.08398, 1947.46387, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2127.58643, 1867.07251, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(9076, -2091.36890, 1893.39294, 14.99061,   0.00000, 0.00000, 5.29594);
		CreateObject(8558, -2103.29004, 1851.59485, 4.33683,   0.00000, 0.00000, 95.45142);
		CreateObject(8558, -2110.88745, 1931.98071, 4.33683,   0.00000, 0.00000, 95.45142);
		CreateObject(8558, -2131.81641, 1912.34570, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2124.22559, 1831.93604, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(8558, -2167.78076, 1863.38892, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(8558, -2172.02783, 1908.68677, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(1632, -2105.54028, 1876.55127, 6.95079,   0.00000, 0.00000, 5.22000);
		CreateObject(1632, -2108.57080, 1907.03430, 6.95079,   0.00000, 0.00000, -174.72015);
		CreateObject(8557, -2187.47388, 1884.43201, 4.32536,   0.00000, 0.00000, 275.40887);
		CreateObject(8558, -2163.30273, 1828.35742, 12.31549,   0.00000, 22.98000, 5.21925);
		CreateObject(8558, -2174.08691, 1943.89209, 12.31549,   0.00000, 22.98000, 5.21925);
		CreateObject(8806, -2199.41382, 1805.68787, 21.90748,   0.00000, 0.00000, 95.17940);
		CreateObject(8558, -2158.37036, 1773.66711, 12.31549,   0.00000, 22.98000, 5.21925);
		CreateObject(8806, -2215.13501, 1975.92578, 21.90748,   0.00000, 0.00000, 95.17940);
		CreateObject(8558, -2119.20239, 1777.25793, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(3458, -2143.38184, 1847.89282, 4.33557,   0.00000, 0.00000, 95.53551);
		CreateObject(3458, -2151.00098, 1928.34338, 4.33557,   0.00000, 0.00000, 95.35550);
		CreateObject(8558, -2098.23730, 1796.90210, 4.33683,   0.00000, 0.00000, 95.45142);
		CreateObject(8558, -2179.04102, 1998.57373, 12.31549,   0.00000, 22.98000, 5.21925);
		CreateObject(8558, -2139.85425, 2002.15613, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2115.52905, 1986.67883, 4.33683,   0.00000, 0.00000, 95.45142);
		CreateObject(8558, -2138.41821, 1793.22266, 4.33212,   0.00000, 0.00000, 95.33143);
		CreateObject(8558, -2122.53979, 1812.38501, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(8558, -2155.26392, 1977.94165, 4.33683,   0.00000, 0.00000, 95.45142);
		CreateObject(8558, -2130.95361, 1962.45642, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2129.88403, 1955.22400, 4.33683,   0.00000, 0.00000, 25.85925);
		CreateObject(8557, -2191.74292, 1929.73401, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(8557, -2183.23022, 1839.17773, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(8558, -2174.61987, 1953.80835, 4.33683,   0.00000, 0.00000, 19.13925);
		CreateObject(8558, -2117.21436, 1822.77319, 4.33683,   0.00000, 0.00000, -22.97875);
		CreateObject(8558, -2160.85938, 1815.97656, 4.33683,   0.00000, 0.00000, -17.15875);
		CreateObject(8558, -2216.03320, 1945.20068, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2204.17749, 1819.53662, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(8557, -2240.31128, 1960.68176, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(8557, -2225.15723, 1799.90613, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(8558, -2261.27783, 1941.04041, 4.33683,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2249.40869, 1815.38013, 4.33683,   0.00000, 0.00000, 5.22126);
		CreateObject(8558, -2276.82153, 1917.84778, 12.31549,   0.00000, 22.98000, 95.33921);
		CreateObject(8558, -2268.95215, 1835.40393, 12.33413,   0.00000, 22.98000, -84.78078);
		CreateObject(8558, -2257.36670, 1898.97815, 20.08322,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2253.25903, 1857.47583, 20.09333,   0.00000, 0.00000, 5.21925);
		CreateObject(8557, -2232.64136, 1879.96777, 20.06743,   0.00000, 0.00000, 275.64886);
		CreateObject(8558, -2217.16650, 1902.64673, 20.08322,   0.00000, 0.00000, 5.21925);
		CreateObject(8558, -2213.09058, 1861.13647, 20.09333,   0.00000, 0.00000, 5.21925);
		CreateObject(8557, -2197.69702, 1884.58887, 20.06743,   0.00000, 0.00000, 275.64886);
		CreateObject(3261, -2199.08057, 1898.67908, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2198.79590, 1895.67236, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2198.49390, 1892.61523, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2198.21704, 1889.55945, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2197.91821, 1886.50305, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2197.62500, 1883.49902, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2197.33179, 1880.48962, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2197.03540, 1877.48242, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2196.76294, 1874.45386, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2196.46191, 1871.42834, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2196.18945, 1868.39954, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(3261, -2195.84912, 1865.37634, 21.54619,   0.00000, 0.00000, 5.53821);
		CreateObject(1633, -2194.51367, 1855.45215, 22.69612,   0.00000, 0.00000, 184.07585);
		CreateObject(1633, -2199.79541, 1911.67822, 22.69549,   0.00000, 0.00000, 5.40000);
		CreateObject(8557, -2280.99976, 1962.06726, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(8557, -2264.85181, 1791.21008, 4.34535,   0.00000, 0.00000, 275.40887);
		CreateObject(3877, -2236.57422, 1995.51453, 23.27377,   0.00000, 0.00000, 4.50000);
		CreateObject(3877, -2231.22412, 1936.58691, 23.27377,   0.00000, 0.00000, 4.50000);
		CreateObject(3877, -2220.81860, 1825.23669, 23.27377,   0.00000, 0.00000, 4.50000);
		CreateObject(3877, -2215.51050, 1766.33557, 23.27377,   0.00000, 0.00000, 4.50000);


/*									[X1 ARENA 3]                                 			*/

        CreateObject(13657, -3405.43921, 1677.99548, 220.20219,   0.00000, 0.00000, 0.00000);

/*									 [AERO LS]                                 				*/
        CreateObject(3629, 2007.3500, -2205.5403, 18.9428,   -360.00000, 0.00000, -179.00000);
        CreateObject(955, 1916.67798, -2217.22241, 25.71510,   -1.92000, 3.90000, 184.55998); /* Maquina de bebidas */

/*								[Omega por Scorpion]                                 		*/
       CreateObject(19531, 247.88205, -2779.95288, 16.05708, 0.00000, 0.00000, 0.00000);
        CreateObject(19529, 785.58331, -2776.71045, 11.79929, 0.00000, 0.00000, 0.00000);
        CreateObject(8172, 354.38086, -2718.65527, 29.50463, -0.24000, 90.96005, -89.93999);
        CreateObject(8172, 434.00574, -2786.44580, 29.50463, -0.24000, 90.96005, 179.88008);
        CreateObject(19531, 372.85333, -2779.94458, 16.05709, 0.00000, 0.00000, 0.00000);
        CreateObject(8172, 266.47418, -2718.73779, 29.50463, -0.24000, 90.96005, -89.93999);
        CreateObject(8172, 192.84618, -2781.26440, 29.50463, -0.24000, 90.96005, 0.12001);
        CreateObject(8172, 272.21512, -2841.26782, 29.50463, -0.24000, 90.96005, 90.00001);
        CreateObject(8172, 378.83224, -2841.29419, 29.50463, -0.24000, 90.96005, 90.00001);
        CreateObject(11014, 419.79080, -2722.73511, 18.62748, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 304.62515, -2722.68018, 18.63053, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 343.06750, -2722.71899, 18.62546, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 266.33710, -2722.72705, 18.63375, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 228.05930, -2722.72437, 18.62876, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 381.40283, -2722.74634, 18.63224, 0.00000, 0.00000, 0.00000);
        CreateObject(11014, 415.70483, -2837.54663, 18.61677, 0.00000, 0.00000, 180.03424);
        CreateObject(11014, 377.33841, -2837.57324, 18.61318, 0.00000, 0.00000, 180.03424);
        CreateObject(11014, 339.00848, -2837.60938, 18.61021, 0.00000, 0.00000, 180.03424);
        CreateObject(11014, 300.81122, -2837.67114, 18.61222, 0.00000, 0.00000, 180.03424);
        CreateObject(11014, 262.43900, -2837.73975, 18.59097, 0.00000, 0.00000, 180.03424);
        CreateObject(11014, 224.12215, -2837.80884, 18.56133, 0.00000, 0.00000, 180.03424);
        CreateObject(8171, 847.30615, -2776.66895, 28.91597, 0.24000, 88.56002, 359.95108);
        CreateObject(8171, 787.77039, -2838.38770, 31.11776, 0.00000, 88.50002, 270.09143);
        CreateObject(8171, 786.81549, -2714.79590, 30.14437, 0.90000, 88.98000, 90.06915);
        CreateObject(8171, 723.98199, -2776.44263, 31.11776, 0.00000, 88.50002, 179.88565);
        CreateObject(3814, 729.19269, -2777.00000, 17.89954, 0.00000, 0.00000, 359.90002);
        CreateObject(3814, 729.20770, -2739.67065, 17.99954, 0.00000, 0.00000, 0.00000);
        CreateObject(3814, 729.11505, -2814.10229, 17.99954, 0.00000, 0.00000, 0.00000);


/*							[Jardin Mágico por Scorpion]
		CreateObject(7416, -2314.69312, 1755.64099, 213.11606, 0.00000, 0.00000, 0.00000);
        CreateObject(8171, -2315.81226, 1712.79382, 203.66956, -0.30000, -92.63991, 269.91315);
        CreateObject(8171, -2271.94287, 1758.06824, 203.51208, 0.12000, -91.49994, 0.21297);
        CreateObject(8171, -2321.97266, 1798.32617, 203.69435, 0.12000, -91.49994, 90.12236);
        CreateObject(8171, -2363.87183, 1749.51929, 203.81813, 0.12000, -91.49994, 179.98572);
        CreateObject(8958, -2364.50269, 1797.36890, 215.82448, 0.00000, 0.00000, 0.00000);
        CreateObject(8958, -2364.43945, 1725.21448, 215.82448, 0.00000, 0.00000, 0.00000);
        CreateObject(8958, -2364.46094, 1749.22021, 215.82448, 0.00000, 0.00000, 0.00000);
        CreateObject(8958, -2364.49292, 1773.29150, 215.82448, 0.00000, 0.00000, 0.00000);

        Object[0] = CreateObject(7914, 1337.74, 2094.88, 20.58, 0.00, 0.00, 180.00);
        Object[1] = CreateObject(7914, 1292.11, 2143.55, 20.14, 0.00, 0.00, 90.00);
        Object[2] = CreateObject(7914, 1663.00, 8293.00, 734.00, 0.00, 0.00, 0.00);
        Object[3] = CreateObject(7914, 1664.21, 734.22, 13.11, 0.00, 0.00, 0.00);
        Object[4] = CreateObject(7914, 1663.94, 706.63, 13.11, 0.00, 0.00, 180.04);
        Object[5] = CreateObject(7914, -1234.09, -84.41, 16.39, 0.00, 0.00, -44.94);
        Object[6] = CreateObject(7914, -1195.23, -131.88, 16.39, 0.00, 0.00, -44.94);
        Object[7] = CreateObject(7914, -2096.01, -188.82, 37.45, 0.00, 0.00, 90.04);
        Object[8] = CreateObject(7914, -2011.62, -189.27, 37.45, 0.00, 0.00, -90.04);
*/

        Textdraw0 = TextDrawCreate(1.000000, 430.000000, "~n~");
        TextDrawBackgroundColor(Textdraw0, 255);
        TextDrawFont(Textdraw0, 1);
        TextDrawLetterSize(Textdraw0, 0.350000, 1.000000);
        TextDrawColor(Textdraw0, 0x00091988);
        TextDrawSetOutline(Textdraw0, 0);
        TextDrawSetProportional(Textdraw0, 1);
        TextDrawSetShadow(Textdraw0, 1);
        TextDrawUseBox(Textdraw0, 1);
        TextDrawBoxColor(Textdraw0, 102);
        TextDrawTextSize(Textdraw0, 675.000000, 0.000000);

		SetTimer("dmgTdUpdate", 50, true);

		for(new i=0, j = GetMaxPlayers(); i<j; i++){
		txd[0][i] = TextDrawCreate(200.0, 370.0, " ");
		TextDrawLetterSize(txd[0][i], 0.24, 1.1);
		TextDrawColor(txd[0][i], COLOR_WHITE);
		TextDrawFont(txd[0][i], 1);
		TextDrawSetShadow(txd[0][i], 0);
		TextDrawAlignment(txd[0][i], 2);
		TextDrawSetOutline(txd[0][i], 1);
		TextDrawBackgroundColor(txd[0][i], 0x0000000F);

		txd[1][i] = TextDrawCreate(440.0, 370.0, " ");
		TextDrawLetterSize(txd[1][i], 0.24, 1.1);
		TextDrawColor(txd[1][i], COLOR_WHITE);
		TextDrawFont(txd[1][i], 1);
		TextDrawSetShadow(txd[1][i], 0);
		TextDrawAlignment(txd[1][i], 2);
		TextDrawSetOutline(txd[1][i], 1);
		TextDrawBackgroundColor(txd[1][i], 0x0000000F);
		}

        for(new i; i < MAX_PLAYERS;i++){
        Textdraw1[i] = TextDrawCreate(313.000000, 430.000000, "~w~WTx ~w~vs ~g~D3x ~w~I Puntaje: ~r~01~w~:~g~02 ~w~I Ronda: ~b~~h~~h~~h~02~w~:~b~~h~~h~~h~02 ~w~I  Kills: ~b~~h~~h~~h~05 ~w~I Muertes: ~b~~h~~h~~h~07 I Ratio: ~b~~h~~h~~h~1.20 ~w~I Modo CW-TG De: 3x10 Mapa: Las venturas omega jardin");
        TextDrawAlignment(Textdraw1[i], 2);
        TextDrawBackgroundColor(Textdraw1[i], 255);
        TextDrawFont(Textdraw1[i], 2);
        TextDrawLetterSize(Textdraw1[i], 0.215000, 1.000000);
        TextDrawColor(Textdraw1[i], -1);
        TextDrawSetOutline(Textdraw1[i], 0);
        TextDrawSetProportional(Textdraw1[i], 1);
        TextDrawSetShadow(Textdraw1[i], 1);

        TextdrawFondo = TextDrawCreate(260.000000, 442.000000, "~n~");
        TextDrawBackgroundColor(TextdrawFondo, 0x00091988);
        TextDrawFont(TextdrawFondo, 1);
        TextDrawLetterSize(TextdrawFondo, 0.350000, 1.000000);
        TextDrawColor(TextdrawFondo, 0x00091988);
        TextDrawSetOutline(TextdrawFondo, 0);
        TextDrawSetProportional(TextdrawFondo, 1);
        TextDrawSetShadow(TextdrawFondo, 1);
        TextDrawUseBox(TextdrawFondo, 1);
        TextDrawBoxColor(TextdrawFondo, 0x00091988);
        TextDrawTextSize(TextdrawFondo, 364.000000, 0.000000);
        }

//      Textdraw01 = TextDrawCreate(-10.000000, 110.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
        Textdraw01 = TextDrawCreate(-10.000000, 110.000000, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
        TextDrawBackgroundColor(Textdraw01, 255);
        TextDrawFont(Textdraw01, 1);
        TextDrawLetterSize(Textdraw01, 0.500000, 1.000000);
        TextDrawColor(Textdraw01, -1);
        TextDrawSetOutline(Textdraw01, 0);
        TextDrawSetProportional(Textdraw01, 1);
        TextDrawSetShadow(Textdraw01, 1);
        TextDrawUseBox(Textdraw01, 1);
        TextDrawBoxColor(Textdraw01, 170);
        TextDrawTextSize(Textdraw01, 650.000000, 0.000000);

        Textdraw100 = TextDrawCreate(190.000000, 83.000000, "    Resultados totales");
        TextDrawBackgroundColor(Textdraw100, -1);
        TextDrawFont(Textdraw100, 2);
        TextDrawLetterSize(Textdraw100, 0.449999, 1.600000);
        TextDrawColor(Textdraw100, 255);
        TextDrawSetOutline(Textdraw100, 1);
        TextDrawSetProportional(Textdraw100, 1);

        Textdraw101 = TextDrawCreate(190.000000, 83.000000, "         1v1 RESULTADOS");
        TextDrawBackgroundColor(Textdraw101, -1);
        TextDrawFont(Textdraw101, 2);
        TextDrawLetterSize(Textdraw101, 0.449999, 1.600000);
        TextDrawColor(Textdraw101, 255);
        TextDrawSetOutline(Textdraw101, 1);
        TextDrawSetProportional(Textdraw101, 1);

        Textdraw2 = TextDrawCreate(180.000000, 70.000000, "~n~~n~~n~"); //este va
        TextDrawBackgroundColor(Textdraw2, 168430130);
        TextDrawFont(Textdraw2, 1);
        TextDrawLetterSize(Textdraw2, 10.500000, 10.000000);
        TextDrawColor(Textdraw2, 0x00091999);
        TextDrawSetOutline(Textdraw2, 0);
        TextDrawSetProportional(Textdraw2, 1);
        TextDrawSetShadow(Textdraw2, 1);
        TextDrawUseBox(Textdraw2, 1);
        TextDrawBoxColor(Textdraw2, 168430130);
        TextDrawTextSize(Textdraw2, 480.000000, 200.000000);

        Textdraw4 = TextDrawCreate(190.000000, 108.000000, "~y~Nick:                            Kills - Muertes - Ratio"); //este va
        TextDrawBackgroundColor(Textdraw4, 255);
        TextDrawFont(Textdraw4, 2);
        TextDrawLetterSize(Textdraw4, 0.280000, 1.000000);
        TextDrawColor(Textdraw4, 8130303);
        TextDrawSetOutline(Textdraw4, 0);
        TextDrawSetProportional(Textdraw4, 1);
        TextDrawSetShadow(Textdraw4, 1);

        Textdraw5 = TextDrawCreate(190.000000, 220.000000, "~g~Nick:                            Kills - Muertes - Ratio"); //este va
        TextDrawBackgroundColor(Textdraw5, 255);
        TextDrawFont(Textdraw5, 2);
        TextDrawLetterSize(Textdraw5, 0.280000, 1.000000);
        TextDrawColor(Textdraw5, 8130303);
        TextDrawSetOutline(Textdraw5, 0);
        TextDrawSetProportional(Textdraw5, 1);
        TextDrawSetShadow(Textdraw5, 1);

        Textdraw6 = TextDrawCreate(180.000000, 343.000000, "Partida: WTx vs D3x~n~Ganador: D3x~n~Rondas: 01:02~n~Total: 78:172~n~De: 3x30"); //este va
        TextDrawBackgroundColor(Textdraw6,168430130);
        TextDrawFont(Textdraw6, 2);
        TextDrawLetterSize(Textdraw6, 0.230000, 1.000000);
        TextDrawColor(Textdraw6, -1);
        TextDrawSetOutline(Textdraw6, 0);
        TextDrawSetProportional(Textdraw6, 1);
        TextDrawSetShadow(Textdraw6, 1);
        TextDrawUseBox(Textdraw6, 1);
        TextDrawBoxColor(Textdraw6, 168430130);
        TextDrawTextSize(Textdraw6, 480.000000, 190.000000);

        Textdraw7 = TextDrawCreate(190.000000, 120.000000, "Name~n~Name"); // WTx
        TextDrawBackgroundColor(Textdraw7, 255);
        TextDrawFont(Textdraw7, 1);
        TextDrawLetterSize(Textdraw7, 0.260000, 1.000000);
        TextDrawColor(Textdraw7, -1);
        TextDrawSetOutline(Textdraw7, 0);
        TextDrawSetProportional(Textdraw7, 1);
        TextDrawSetShadow(Textdraw7, 1);

        Textdraw8 = TextDrawCreate(323.000000, 120.000000, "08~n~07");// WTx
        TextDrawBackgroundColor(Textdraw8, 255);
        TextDrawFont(Textdraw8, 1);
        TextDrawLetterSize(Textdraw8, 0.260000, 1.000000);
        TextDrawColor(Textdraw8, -1);
        TextDrawSetOutline(Textdraw8, 0);
        TextDrawSetProportional(Textdraw8, 1);
        TextDrawSetShadow(Textdraw8, 1);

        Textdraw9 = TextDrawCreate(367.000000, 120.000000, "08~n~07");// HOME
        TextDrawBackgroundColor(Textdraw9, 255);
        TextDrawFont(Textdraw9, 1);
        TextDrawLetterSize(Textdraw9, 0.260000, 1.000000);
        TextDrawColor(Textdraw9, -1);
        TextDrawSetOutline(Textdraw9, 0);
        TextDrawSetProportional(Textdraw9, 1);
        TextDrawSetShadow(Textdraw9, 1);

        Textdraw10 = TextDrawCreate(415.000000, 120.000000, "1.14~n~2.99");// HOME
        TextDrawBackgroundColor(Textdraw10, 255);
        TextDrawFont(Textdraw10, 1);
        TextDrawLetterSize(Textdraw10, 0.260000, 1.000000);
        TextDrawColor(Textdraw10, -1);
        TextDrawSetOutline(Textdraw10, 0);
        TextDrawSetProportional(Textdraw10, 1);
        TextDrawSetShadow(Textdraw10, 1);

        Textdraw11 = TextDrawCreate(190.000000, 234.000000, "Name~n~Name");
        TextDrawBackgroundColor(Textdraw11, 255);
        TextDrawFont(Textdraw11, 1);
        TextDrawLetterSize(Textdraw11, 0.260000, 1.000000);
        TextDrawColor(Textdraw11, -1);
        TextDrawSetOutline(Textdraw11, 0);
        TextDrawSetProportional(Textdraw11, 1);
        TextDrawSetShadow(Textdraw11, 1);

        Textdraw12 = TextDrawCreate(323.000000, 234.000000, "08~n~07");
        TextDrawBackgroundColor(Textdraw12, 255);
        TextDrawFont(Textdraw12, 1);
        TextDrawLetterSize(Textdraw12, 0.260000, 1.000000);
        TextDrawColor(Textdraw12, -1);
        TextDrawSetOutline(Textdraw12, 0);
        TextDrawSetProportional(Textdraw12, 1);
        TextDrawSetShadow(Textdraw12, 1);

        Textdraw13 = TextDrawCreate(367.000000, 234.000000, "08~n~07");
        TextDrawBackgroundColor(Textdraw13, 255);
        TextDrawFont(Textdraw13, 1);
        TextDrawLetterSize(Textdraw13, 0.260000, 1.000000);
        TextDrawColor(Textdraw13, -1);
        TextDrawSetOutline(Textdraw13, 0);
        TextDrawSetProportional(Textdraw13, 1);
        TextDrawSetShadow(Textdraw13, 1);

        Textdraw14 = TextDrawCreate(415.000000, 234.000000, "1.14~n~2.99");
        TextDrawBackgroundColor(Textdraw14, 255);
        TextDrawFont(Textdraw14, 1);
        TextDrawLetterSize(Textdraw14, 0.260000, 1.000000);
        TextDrawColor(Textdraw14, -1);
        TextDrawSetOutline(Textdraw14, 0);
        TextDrawSetProportional(Textdraw14, 1);
        TextDrawSetShadow(Textdraw14, 1);

		TextdrawWTx = TextDrawCreate(134.333358, 409.422149, "Toxic Warriors");
		TextDrawLetterSize(TextdrawWTx, 0.449999, 1.600000);
		TextDrawAlignment(TextdrawWTx, 1);
		TextDrawColor(TextdrawWTx, 0xF69521AA);
		TextDrawSetShadow(TextdrawWTx, 0);
		TextDrawSetOutline(TextdrawWTx, 1);
		TextDrawBackgroundColor(TextdrawWTx, 51);
		TextDrawFont(TextdrawWTx, 2);
		TextDrawSetProportional(TextdrawWTx, 1);

		Textdraw15 = TextDrawCreate(270.333358, 409.422149, "    ~b~~h~~h~~h~/");
		TextDrawLetterSize(Textdraw15, 0.449999, 1.600000);
		TextDrawAlignment(Textdraw15, 1);
		TextDrawColor(Textdraw15, 8130303);
		TextDrawSetShadow(Textdraw15, 0);
		TextDrawSetOutline(Textdraw15, 1);
		TextDrawBackgroundColor(Textdraw15, 51);
		TextDrawFont(Textdraw15, 2);
		TextDrawSetProportional(Textdraw15, 1);

		TextdrawD3x = TextDrawCreate(300.333358, 409.422149, " Server 19");
		TextDrawLetterSize(TextdrawD3x, 0.449999, 1.600000);
		TextDrawAlignment(TextdrawD3x, 1);
		TextDrawColor(TextdrawD3x, 8130303);
		TextDrawSetShadow(TextdrawD3x, 0);
		TextDrawSetOutline(TextdrawD3x, 1);
		TextDrawBackgroundColor(TextdrawD3x, 51);
		TextDrawFont(TextdrawD3x, 2);
		TextDrawSetProportional(TextdrawD3x, 1);

		FONDOENTRADA1 = TextDrawCreate(1591.000000, 134.655563, "usebox");
		TextDrawLetterSize(FONDOENTRADA1, 0.000000, 0.839298);
		TextDrawTextSize(FONDOENTRADA1, -1.666666, 0.000000);
		TextDrawAlignment(FONDOENTRADA1, 1);
		TextDrawColor(FONDOENTRADA1, 0);
		TextDrawUseBox(FONDOENTRADA1, true);
		TextDrawBoxColor(FONDOENTRADA1, -157998678);
		TextDrawSetShadow(FONDOENTRADA1, 0);
		TextDrawSetOutline(FONDOENTRADA1, 0);
		TextDrawFont(FONDOENTRADA1, 0);

		FONDOENTRADA2 = TextDrawCreate(641.666687, 1.500000, "usebox");
		TextDrawLetterSize(FONDOENTRADA2, 0.000000, 14.432304);
		TextDrawTextSize(FONDOENTRADA2, -2.000000, 0.000000);
		TextDrawAlignment(FONDOENTRADA2, 1);
		TextDrawColor(FONDOENTRADA2, 0);
		TextDrawUseBox(FONDOENTRADA2, true);
		TextDrawBoxColor(FONDOENTRADA2, 102);
		TextDrawSetShadow(FONDOENTRADA2, 0);
		TextDrawSetOutline(FONDOENTRADA2, 0);
		TextDrawFont(FONDOENTRADA2, 0);

		LATERAL1 = TextDrawCreate(641.666687, 339.988891, "usebox");
		TextDrawLetterSize(LATERAL1, 0.000000, 11.805146);
		TextDrawTextSize(LATERAL1, -2.000000, 0.000000);
		TextDrawAlignment(LATERAL1, 1);
		TextDrawColor(LATERAL1, 0);
		TextDrawUseBox(LATERAL1, true);
		TextDrawBoxColor(LATERAL1, 102);
		TextDrawSetShadow(LATERAL1, 0);
		TextDrawSetOutline(LATERAL1, 0);
		TextDrawFont(LATERAL1, 0);

		LATERAL2 = TextDrawCreate(-1262.666625, 328.374084, "usebox");
		TextDrawLetterSize(LATERAL2, 0.000000, 1.062755);
		TextDrawTextSize(LATERAL2, 637.666687, 0.000000);
		TextDrawAlignment(LATERAL2, 1);
		TextDrawColor(LATERAL2, 0);
		TextDrawUseBox(LATERAL2, true);
		TextDrawBoxColor(LATERAL2, -157998678);
		TextDrawSetShadow(LATERAL2, 0);
		TextDrawSetOutline(LATERAL2, 0);
		TextDrawFont(LATERAL2, 0);

		TOXICWARRIORS = TextDrawCreate(216.000091, 51.022209, "Toxic-WARRIORS");
		TextDrawLetterSize(TOXICWARRIORS, 0.619666, 2.491851);
		TextDrawAlignment(TOXICWARRIORS, 1);
		TextDrawColor(TOXICWARRIORS, -157998678);
		TextDrawSetShadow(TOXICWARRIORS, 0);
		TextDrawSetOutline(TOXICWARRIORS, 1);
		TextDrawBackgroundColor(TOXICWARRIORS, 51);
		TextDrawFont(TOXICWARRIORS, 2);
		TextDrawSetProportional(TOXICWARRIORS, 1);

		SERVERCWTG = TextDrawCreate(248.000000, 74.666580, "SERVER CW/TG");
		TextDrawLetterSize(SERVERCWTG, 0.449999, 1.600000);
		TextDrawAlignment(SERVERCWTG, 1);
		TextDrawColor(SERVERCWTG, 8130303);
		TextDrawSetShadow(SERVERCWTG, 0);
		TextDrawSetOutline(SERVERCWTG, 1);
		TextDrawBackgroundColor(SERVERCWTG, 51);
		TextDrawFont(SERVERCWTG, 2);
		TextDrawSetProportional(SERVERCWTG, 1);
	return 1;
}

public PosRefresh(){
	ForPlayers(playerid){
		if(Equipo[playerid] == EQUIPO_SPEC){
			if(Spec[playerid] != -1) continue;
				new Float:Z;
				GetPlayerPos(playerid, Z,Z,Z);
			if(Mapa_servidor != 1){
				if(Z < Jugador_pos[Mapa_servidor][EQUIPO_NARANJA][2]+1) SpawnPlayer(playerid);
			}else{
		if(Z < 12){
			SpawnPlayer(playerid);
		}
	}
}
if(Equipo[playerid] == EQUIPO_DERBY){
	if(Spec[playerid] != -1) continue;
		new Float:Z;
		GetPlayerPos(playerid, Z,Z,Z);
		if(Mapa_servidor != 1) {
			if(Z < Jugador_pos[Mapa_servidor][EQUIPO_NARANJA][2]-8) SpawnPlayer(playerid);
		}else{
			if(Z < 10){
				SpawnPlayer(playerid);
			}
		}
	}
}
return true;
}

public OnGameModeExit()
{
        return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 2193.1243,-2324.0867,43.9261);
	SetPlayerFacingAngle(playerid, 314.0555);
	SetPlayerCameraPos(playerid, 2194.7441,-2322.5422,43.9261);
	SetPlayerCameraLookAt(playerid, 2193.0043,-2324.2867,43.9261);

return 1;
}

public OnPlayerConnect(playerid)
{
	new Pais[30], s[128], str[128], cesta[50], File:a, name[MAX_PLAYER_NAME], nasiel;

	GetPlayerCountry(playerid, Pais, sizeof(Pais));
	format(s, 128,"%s.txt", nombre(playerid));
	format(cesta, 50, IPFILE, Ip(playerid));
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	fcreate(cesta);
	a = fopen(cesta, io_read);
	while(fread(a, str)){
		DelChar(str);
		if(!strcmp(name, str, false)){
			nasiel = 1;
			break;
		}
	}
	fclose(a);
	if(nasiel == 0){
		a = fopen(cesta, io_append);
		format(str,128,"%s\r\n", nombre(playerid));
		fwrite(a, str);
		fclose(a);
	}
	Clan_n[playerid] = -1;
	new p = 0;
 	do{
		if(strfind(nombre(playerid), Clanes[p], true) != -1){
			Clan_n[playerid] = p;
			printf("Jugador %s, clan: %d-%s", nombre(playerid), p, Clanes[p]);
			p = 4;
		}else p++;
 	}while(p != 4);
 	
	Admin[playerid] = 0;
	Muertes[playerid] = 0;
	X1_Ganados[playerid] = 0;
	X1_Perdidos[playerid] = 0;
	Puntaje_ranked[playerid] = 1.000;
	Equipo_kills[playerid] = 0;
	PlayerSkin[playerid] = -1;
	Cambiar_nombre[playerid] = 1;
	Elegir_Personaje[playerid] = 1;
	
	//new nickfake[24], fkmanu[24];
	//strcat(nickfake, nombre(playerid));
	//strcat(fkmanu, "pene");

	SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}se conectó al servidor ({FF7B00}%s{B8B8B8})", nombre(playerid), Pais);

	TextDrawShowForPlayer(playerid, FONDOENTRADA1);
	TextDrawShowForPlayer(playerid, FONDOENTRADA2);
	TextDrawShowForPlayer(playerid, LATERAL1);
	TextDrawShowForPlayer(playerid, LATERAL2);
	TextDrawShowForPlayer(playerid, TOXICWARRIORS);
	TextDrawShowForPlayer(playerid, SERVERCWTG);

	Ad_fps[playerid] 			= 0;
    pDrunkLevelLast[playerid]   = 100;
    pFPS[playerid]      		= 0;
    Equipo[playerid]      		= -1;
    EstaEnX1[playerid]  		= 0;
    Congelado[playerid] 		= 0;
    X1_cerrado           		= 0;
    TDraws[playerid] 			= -1;
   	Armas_rw[playerid] 			= -1;
	Armas_ww[playerid] 			= -1;

	if(playerid > Connects) Connects = playerid;
	if(!Contra_servidor[1]){
		if(fexist(s)){
			ShowPlayerDialog(playerid, CUENTA_LOGEADA, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta registrada", "{FFFFFF}Este nick está {FF7B00}registrado{FFFFFF}, ingresa la contraseña.", "Log.", "Salir");
		}else{
			ShowPlayerDialog(playerid, CUENTA_REGISTRAR, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta no registrado", "{FFFFFF}Este nick no está registrado, ingresa una {FF7B00}contraseña {FFFFFF}si quieres registrarte con esta cuenta.\nSí esta cuenta será temporal, {F60000}no te registres{FFFFFF}!", "Regis.", "No");
		}
	}else{
		ShowPlayerDialog(playerid,2,1,"Servidor bloqueado:","{B8B8B8}Un administrador bloqueó el servidor con una contraseña,\nTienes {830000}10{B8B8B8} segundos para ingresar correctamente la contraseña o serás kickeado del servidor","Ok","");
		SetTimerEx("LockedServerKick",10000,false,"i",playerid);
	}
        Frames[playerid] = TextDrawCreate(520, 412, "~y~Fps: ~w~100 ~y~Ms: ~w~100 ~y~PL: ~w~1000");
        TextDrawLetterSize(Frames[playerid], 0.215000, 1.000000);
        TextDrawAlignment(Frames[playerid], 1);
        TextDrawColor(Frames[playerid], -2130706177);
        TextDrawSetShadow(Frames[playerid], 0);
        TextDrawSetOutline(Frames[playerid], 1);
        TextDrawBackgroundColor(Frames[playerid], 255);
        TextDrawFont(Frames[playerid], 2);
        TextDrawSetProportional(Frames[playerid], 1);

		/* [Faros de Las Venturas] */
        RemoveBuildingForPlayer(playerid, 1278, 1099.2656, 1283.3438, 23.9375, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1175.7656, 1283.3438, 23.9375, 0.25);

		/* [SF Barco y Aeropuerto] */
        RemoveBuildingForPlayer(playerid, 3814, -1178.1016, -114.8281, 19.7656, 0.25);
        RemoveBuildingForPlayer(playerid, 3815, -1178.1016, -114.8281, 19.7656, 0.25);

		/* [San Fierro 2] */
		RemoveBuildingForPlayer(playerid, 10813, -1687.4141, -623.0234, 18.1484, 0.25);
		RemoveBuildingForPlayer(playerid, 10815, -1608.8906, -494.8359, 13.4297, 0.25);
		RemoveBuildingForPlayer(playerid, 3816, -1438.4141, -529.6328, 21.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3816, -1362.9844, -491.4922, 21.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3817, -1438.4141, -529.6328, 21.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3817, -1362.9844, -491.4922, 21.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 11373, -1608.8906, -494.8359, 13.4297, 0.25);
		RemoveBuildingForPlayer(playerid, 1682, -1691.5859, -619.6953, 29.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 10810, -1687.4141, -623.0234, 18.1484, 0.25);

		/* [Los santos] */
		RemoveBuildingForPlayer(playerid, 5011, 1874.2109, -2286.5313, 17.9297, 0.25);
		RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2249.0234, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2315.4297, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3672, 2030.0547, -2382.1406, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 3744, 2061.5313, -2209.8125, 14.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 3744, 2082.4063, -2269.6563, 14.9609, 0.25);
		RemoveBuildingForPlayer(playerid, 3744, 2082.4375, -2298.2266, 14.9609, 0.25);
		RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2305.9609, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 3769, 2060.6875, -2371.8828, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 3663, 1882.2656, -2395.7813, 14.4688, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2422.1719, 18.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2350.7344, 18.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2382.1406, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3664, 2042.7734, -2442.1875, 19.2813, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 2057.7344, -2402.9922, 12.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2371.8828, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 5006, 1874.2109, -2286.5313, 17.9297, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2328.1406, 18.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 1899.4219, -2244.5078, 18.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1215, 1983.8594, -2281.7109, 13.0625, 0.25);
		RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 2003.4531, -2281.3984, 18.3828, 0.25);
		RemoveBuildingForPlayer(playerid, 5031, 2037.0469, -2313.5469, 18.7109, 0.25);
		RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2315.4297, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3629, 2030.0547, -2249.0234, 18.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 2057.0547, -2315.4688, 12.7422, 0.25);
		RemoveBuildingForPlayer(playerid, 3625, 2060.6875, -2305.9609, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 2057.5391, -2270.0703, 12.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 3574, 2082.4063, -2269.6563, 14.9609, 0.25);
		RemoveBuildingForPlayer(playerid, 3574, 2082.4375, -2298.2266, 14.9609, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1949.3438, -2227.5156, 13.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1944.0625, -2227.5156, 13.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1954.6172, -2227.4844, 13.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1965.1719, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1959.8984, -2227.4453, 13.7266, 0.25);
		RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1975.7266, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1970.4453, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1981.0000, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1996.8281, -2227.3828, 13.7891, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1991.5547, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 1986.2813, -2227.4141, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 1983.8047, -2224.1641, 12.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2002.1094, -2227.3438, 13.8281, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 2018.0313, -2224.1641, 12.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, 2010.3984, -2207.6172, 18.4219, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2224.3828, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2055.0547, -2219.1094, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 2056.8281, -2224.1641, 12.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2054.9844, -2213.7891, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2208.4609, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2054.9219, -2203.1875, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 3574, 2061.5313, -2209.8125, 14.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2181.3594, 13.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 1412, 2054.9297, -2186.6328, 13.7578, 0.25);

		/* [Barco hijo de puta] */
		RemoveBuildingForPlayer(playerid, 9583, -2475.1328, 1559.0703, 31.3125, 0.25);
		RemoveBuildingForPlayer(playerid, 9584, -2485.0781, 1544.9453, 26.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 9585, -2409.8438, 1544.9453, 7.0000, 0.25);
		RemoveBuildingForPlayer(playerid, 9586, -2412.1250, 1544.9453, 17.0469, 0.25);
		RemoveBuildingForPlayer(playerid, 9587, -2401.1406, 1544.9375, 23.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 9588, -2404.2109, 1544.9375, 7.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 9589, -2389.3984, 1544.8828, 4.0313, 0.25);
		RemoveBuildingForPlayer(playerid, 9590, -2403.5078, 1544.9453, 8.7188, 0.25);
		RemoveBuildingForPlayer(playerid, 9604, -2392.5938, 1545.9063, 24.8594, 0.25);
		RemoveBuildingForPlayer(playerid, 9619, -2409.8438, 1544.9453, 7.0000, 0.25);
		RemoveBuildingForPlayer(playerid, 9620, -2485.0781, 1544.9453, 26.1953, 0.25);
		RemoveBuildingForPlayer(playerid, 9621, -2401.1406, 1544.9375, 23.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 9684, -2681.4922, 1529.1094, 112.7891, 0.25);
		RemoveBuildingForPlayer(playerid, 9685, -2681.4922, 1529.1094, 112.7891, 0.25);
		RemoveBuildingForPlayer(playerid, 9686, -2681.4922, 1595.0078, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 9687, -2681.4922, 1684.4609, 120.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 9688, -2681.5000, 1764.8438, 113.1172, 0.25);
		RemoveBuildingForPlayer(playerid, 9689, -2681.4922, 1684.4609, 120.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 9690, -2681.4922, 1595.0078, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 9691, -2681.4922, 1847.9375, 120.0859, 0.25);
		RemoveBuildingForPlayer(playerid, 9692, -2681.4922, 1933.8672, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 9693, -2681.4922, 1847.9375, 120.0859, 0.25);
		RemoveBuildingForPlayer(playerid, 9694, -2681.4922, 1933.8672, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 9695, -2681.4922, 2042.1563, 86.7188, 0.25);
		RemoveBuildingForPlayer(playerid, 9696, -2681.4922, 2042.1563, 86.7188, 0.25);
		RemoveBuildingForPlayer(playerid, 9761, -2411.3906, 1544.9453, 27.0781, 0.25);
		RemoveBuildingForPlayer(playerid, 9837, -2681.4922, 1933.8672, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 9838, -2681.4922, 1595.0078, 109.4375, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1609.8828, 70.0938, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1860.7500, 72.1719, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1798.0313, 73.3281, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1923.4688, 69.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1986.1875, 66.5234, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 2111.6172, 60.7891, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 2048.9063, 62.0938, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1547.1641, 66.8047, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1484.4453, 62.3594, 0.25);
		RemoveBuildingForPlayer(playerid, 1290, -2681.5859, 1672.6016, 72.3047, 0.25);
		RemoveBuildingForPlayer(playerid, 9766, -2659.1563, 1494.9766, 51.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 9820, -2474.6250, 1545.0859, 33.0625, 0.25);
		RemoveBuildingForPlayer(playerid, 9698, -2473.5859, 1543.7734, 29.0781, 0.25);
		RemoveBuildingForPlayer(playerid, 9821, -2474.3594, 1547.2422, 24.7500, 0.25);
		RemoveBuildingForPlayer(playerid, 9822, -2470.9375, 1550.7500, 32.9063, 0.25);
		RemoveBuildingForPlayer(playerid, 9818, -2470.2656, 1544.9609, 33.8672, 0.25);
		RemoveBuildingForPlayer(playerid, 9819, -2470.4531, 1551.1172, 33.1406, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2462.5078, 1547.1563, 20.5391, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2455.9453, 1541.0391, 22.7031, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2450.0781, 1547.1563, 22.7031, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2439.9219, 1549.7969, 4.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2439.9219, 1552.9219, 1.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2438.7969, 1540.4766, 7.9688, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2438.7969, 1537.3672, 11.3281, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2438.9141, 1549.7969, 4.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2438.9141, 1552.9219, 1.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2437.7656, 1537.3672, 11.3281, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2432.0078, 1540.4609, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2429.5234, 1534.4297, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2430.4766, 1534.4297, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2428.4453, 1534.4297, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2428.9766, 1534.4297, 2.6719, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2427.6953, 1550.9219, 25.6328, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2425.0078, 1549.1250, 22.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2423.2500, 1549.4375, 1.7031, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2421.7344, 1550.7656, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2417.8203, 1546.8203, 1.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2406.2109, 1545.5703, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2406.3125, 1538.8281, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2400.1484, 1535.9688, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2399.5625, 1544.2734, 1.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2391.9766, 1549.3984, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2394.6172, 1551.1172, 1.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2395.4453, 1536.8281, 1.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2385.9766, 1545.6875, 25.6250, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2386.0078, 1552.3125, 25.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2384.5313, 1540.7344, 25.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2384.5313, 1539.4688, 25.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2377.6875, 1539.8047, 19.7969, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2377.6875, 1542.9063, 22.6875, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2370.5156, 1539.2344, 16.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2356.1172, 1550.6641, 25.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2355.8828, 1535.7188, 25.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2352.3906, 1543.0859, 25.6172, 0.25);
		RemoveBuildingForPlayer(playerid, 1558, -2352.2422, 1548.2422, 22.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 4510, -2676.3047, 1541.3438, 64.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 4511, -2687.0000, 2058.2031, 59.7344, 0.25);

		/* [No me acuerdo xD] */
        RemoveBuildingForPlayer(playerid, 8087, 1667.7422, 723.2266, 21.0938, 0.25);
        RemoveBuildingForPlayer(playerid, 712, 1555.4844, 710.5000, 19.3359, 0.25);
        RemoveBuildingForPlayer(playerid, 3459, 1577.1953, 725.0156, 17.2188, 0.25);
        RemoveBuildingForPlayer(playerid, 674, 1756.0234, 723.0078, 9.7656, 0.25);
        RemoveBuildingForPlayer(playerid, 674, 1756.0234, 719.5781, 9.7656, 0.25);
        RemoveBuildingForPlayer(playerid, 3459, 1758.2344, 725.6641, 17.1641, 0.25);
        RemoveBuildingForPlayer(playerid, 7617, 1333.3828, 2075.9297, 22.8359, 0.25);
        RemoveBuildingForPlayer(playerid, 645, 1323.4766, 2094.1797, 10.8750, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1349.7031, 2103.8516, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1302.8984, 2105.6953, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1396.5625, 2103.8516, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1301.8906, 2154.2344, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1301.8906, 2197.9688, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1351.7891, 2197.9688, 24.0078, 0.25);
        RemoveBuildingForPlayer(playerid, 1278, 1396.5625, 2154.2422, 24.0078, 0.25);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Ordenar();
	Cambiar_nombre[playerid] = 1;
	Ad_fps[playerid] = 0;
	Armas_rw[playerid] = -1;
	Armas_ww[playerid] = -1;
	TDraws[playerid] = -1;
	Congelado[playerid] = 0;
	PlayerSkin[playerid] = -1;

	naranja = 0;
	verde = 0;

	ForPlayers(i){
		if(Equipo[i] == EQUIPO_NARANJA) naranja++;
		else if(Equipo[i] == EQUIPO_VERDE) verde++;
	}
		
	if(GetPVarInt(playerid,"Logged") != 1){
		X1_Ganados[playerid] = 0;
		Puntaje_ranked[playerid] = 1.000;
		X1_Perdidos[playerid] = 0;
	}else{
		new s[128],get[128];
		GetPVarString(playerid,"Pass", get, 128);
		format(s,128,"%s.txt",nombre(playerid));
		if(fexist(s)){
			new File:f = fopen(s,io_write);
			format(s,128,"%s\r\n%d\r\n%d\r\n%d\r\n%.3f", get, Admin[playerid], X1_Ganados[playerid], X1_Perdidos[playerid], Puntaje_ranked[playerid]);
			fwrite(f,s);
			fclose(f);
 		}
 		if(Clan_n[playerid] != -1){
			new Local[100], Clan[50], datos[128];
			new File:c;
			printf("Datos guardados");
			for(new x=0;x<CLANES_REGISTRADOS;x++){
				format(Clan, 50, "%s.txt", Clanes[x]);
				format(Local, 50, CLANES, Clan);
				if(fexist(Local)){
		        	c = fopen(Local, io_write);
                    format(datos, 128,"%d\r\n%d\r\n%.3f\r\n%d\r\n%d\r\n", Clan_kills[x], Clan_muertes[x], Clan_ratio[x], Clan_Cganadas[x], Clan_Cperdidas[x]);
                    printf("clankills %d, kills:%d, muertes:%d, ratio:%.3f", x, Clan_kills[x], Clan_muertes[x], Clan_ratio[x]);
         			fwrite(c, datos);
         			fclose(c);
				}
 			}
		}
	}
	if(EstaEnDerby[playerid] == 1){
		EstaEnDerby[playerid] = 0;
		dcontador = dcontador-1;
		new pos = dcontador;
		UpdateScoreBar();
		if(dArena1 == 1) SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}ha terminado en la posición {F69521}%d {FFFFFF}de la arena > {F69521}Surtidor de waska {FFFFFF}<", nombre(playerid), pos);
		else{
			SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}ha salido de la arena > {F69521}Surtidor de waska {FFFFFF}<", nombre(playerid));
			ForPlayers(i){
			if(EstaEnDerby[playerid] == 1){
				SCMF(i,COLOR_WHITE,"{B8B8B8}Jugadores actuales: {70FBFF}%d/{F69521}%d",pos,MAX_DERBY);
			}
		}
	}
return 1;
}

	if(Sospechoso[playerid] == 1){
		Sospechoso[playerid] = 0;
		SCMTAF(BLANCO,"{FFFFFF}El jugador {B8B8B8}%s {FFFFFF}a sido {FF7B00}baneado {FFFFFF}por salir del juego en revisión.", nombre(playerid));
		Ban(playerid);
	}

	if(EstaEnX1[playerid] == 1) { X1_Arena1  = X1_Arena1-1;  EstaEnX1[playerid] = 0; }
	if(EstaEnX1[playerid] == 2) { X1_Arena2  = X1_Arena2-1;  EstaEnX1[playerid] = 0; }
	if(EstaEnX1[playerid] == 3) { X1_Arena3  = X1_Arena3-1;  EstaEnX1[playerid] = 0; }
	if(EstaEnX1[playerid] == 4) { X1W_Arena1 = X1W_Arena1-1; EstaEnX1[playerid] = 0; }
	if(EstaEnX1[playerid] == 5) { X1W_Arena2 = X1W_Arena2-1; EstaEnX1[playerid] = 0; }
	if(playerid == Connects){
		warp:
		Connects--;
		if(!IsPlayerConnected(Connects) && Connects > 0) goto warp;
	}

	if(reason == 0) SCMTAF(BLANCO ,"{B8B8B8}%s {FFFFFF}se desconectó del servidor.", nombre(playerid));
	else if(reason == 1) SCMTAF(BLANCO ,"{B8B8B8}%s {FFFFFF}se desconectó del servidor{FF7B00} (salió)", nombre(playerid));
	else SCMTAF(BLANCO ,"{B8B8B8}%s {FFFFFF}se desconectó del servidor{FF7B00} (kick/ban)", nombre(playerid));

return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid){

	new PlayerName[MAX_PLAYER_NAME], PlayerName2[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	GetPlayerName(playerid, PlayerName2, MAX_PLAYER_NAME);
	if(issuerid != INVALID_PLAYER_ID){
		currentHpLoss[0][issuerid][playerid] = amount;
		currentHpLoss[1][playerid][issuerid] = amount;
		new buffer[128];
		format(buffer, 128, "%s~n~-%i (%s)", PlayerName, floatround(currentHpLoss[0][issuerid][playerid]), nombreArma[weaponid]);
		TextDrawSetString(txd[0][issuerid], buffer);
		format(buffer, 128, "%s~n~-%i (%s)", PlayerName2, floatround(currentHpLoss[1][playerid][issuerid]), nombreArma[weaponid]);
		TextDrawSetString(txd[1][playerid], buffer);
		txdAlpha[0][issuerid] = 0xFF;
		txdAlpha[1][playerid] = 0xFF;
	}
return 1;
}

public OnPlayerSpawn(playerid){
	if(Elegir_Personaje[playerid] == 1){
		Elegir_Personaje[playerid] = 0;
		TextDrawShowForPlayer(playerid, Frames[playerid]);
		TextDrawShowForPlayer(playerid, TextdrawWTx);
 		TextDrawShowForPlayer(playerid, TextdrawD3x);
		TextDrawShowForPlayer(playerid, Textdraw15);
		TextDrawShowForPlayer(playerid, Textdraw0);
		TextDrawShowForPlayer(playerid, Textdraw1[playerid]);
	}
	Kills2[playerid] = 0;
	if(EstaEnDerby[playerid] == 1){
		Equipo[playerid] = EQUIPO_SPEC;
		SetPlayerColor(playerid, COLOR_WHITE);
		EstaEnDerby[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		dcontador = dcontador-1;
		UpdateScoreBar();
		new pos = dcontador;
		if(dArena1 == 1)
		{
			if(dcontador == 1)
			{
				ForPlayers(i)
				{
					if(EstaEnDerby[i] == 1)
					{
						SCMTAF(BLANCO,"{B8B8B8}%s es el ganador del derby de la arena > {F69521}Surtidor de waska {FFFFFF}", nombre(i));
						EstaEnDerby[i] = 0;
		 				Equipo[i] = EQUIPO_SPEC;
						SetPlayerColor(i,COLOR_WHITE);
						SpawnPlayer(i);
						//new id = GetPlayerVehicleID(i);
						//DestroyVehicle(id);
						SetPlayerVirtualWorld(i,0);
						SetPlayerInterior(i,0);
						dcontador = 0;
						dArena1 = 0;
	 					for(new j; j < Cont_derby;j++){
						DestroyVehicle(Vehiculos_derby[j]);
					}
					Cont_derby = 0;
				}
			}
 		}else SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}ha terminado en la posición {F69521}%d {FFFFFF}de la arena > {F69521}Surtidor de waska {FFFFFF}<", nombre(playerid), pos+1);
	}
	else if (dArena1 == 0){
		SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}ha salido de la arena > {F69521}Surtidor de waska {FFFFFF}<", nombre(playerid));
	}
}

	if(X1_cerrado == 1){
		EstaEnX1[playerid] = 0;
		X1_Arena1 = 2;
		X1_Arena2 = 2;
		X1_Arena3 = 2;
		X1W_Arena1 = 2;
		X1W_Arena2 = 2;
	}else if (X1_cerrado == 0){
		if(EstaEnX1[playerid] == 1){
		X1_Arena1 = X1_Arena1-1;
		EstaEnX1[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}

	if(EstaEnX1[playerid] == 2){
		X1_Arena2 = X1_Arena2-1;
		EstaEnX1[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
	if(EstaEnX1[playerid] == 3){
		X1_Arena3 = X1_Arena3-1;
		EstaEnX1[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}

	if(EstaEnX1[playerid] == 4){
		X1W_Arena1 = X1W_Arena1-1;EstaEnX1[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
	if(EstaEnX1[playerid] == 5){
		X1W_Arena2 = X1W_Arena2-1;EstaEnX1[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
}

	if(Congelado[playerid] == 1) TogglePlayerControllable(playerid, 0);

	if(Sospechoso[playerid] == 1){
		SetPlayerVirtualWorld(playerid, 11);
		SetPlayerInterior(playerid, 11);
	}else{
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}

	if(PlayerSkin[playerid] != -1) SetPlayerSkin(playerid, PlayerSkin[playerid]);
	SetPlayerHealth(playerid,100);
	ResetPlayerWeapons(playerid);
	SetPlayerPos(playerid, Jugador_pos[Mapa_servidor][Equipo[playerid]][0], Jugador_pos[Mapa_servidor][Equipo[playerid]][1], Jugador_pos[Mapa_servidor][Equipo[playerid]][2]);
	SetPlayerFacingAngle(playerid, Jugador_pos[Mapa_servidor][Equipo[playerid]][3]);
	if(Equipo[playerid] != EQUIPO_SPEC){
		if(Armas_rw[playerid] == 1){
			GivePlayerWeapon(playerid, 22, 9999);
			GivePlayerWeapon(playerid, 28, 9999);
			GivePlayerWeapon(playerid, 26, 9999);
		}else if(Armas_ww[playerid] == 1){
			GivePlayerWeapon(playerid, 24, 9999);
			GivePlayerWeapon(playerid, 25, 9999);
			GivePlayerWeapon(playerid, 34, 9999);
		}else{
			GivePlayerWeapon(playerid, Arma, 9998);
		}
	}else if(Equipo[playerid] == EQUIPO_SPEC){
		if(Armas_rw[playerid] == 1){
			GivePlayerWeapon(playerid, 22, 9999);
			GivePlayerWeapon(playerid, 28, 9999);
			GivePlayerWeapon(playerid, 26, 9999);
		}else if(Armas_ww[playerid] == 1){
			GivePlayerWeapon(playerid, 24, 9999);
			GivePlayerWeapon(playerid, 25, 9999);
			GivePlayerWeapon(playerid, 34, 9999);
	}else{
		ResetPlayerWeapons(playerid);
	}
}
return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid){
	if(EstaEnDerby[playerid] == 1){
		new id = GetPlayerVehicleID(playerid);
		DestroyVehicle(vehicleid);
		DestroyVehicle(id);
		SpawnPlayer(playerid);
	}
return 1;
}

public OnPlayerUpdate(playerid) {

	new string[156];
	new PlayerName[16];
 		GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
   		if(GetPlayerPing(playerid) >= MAX_PING && pinglimit == 1)
        {
        	format(string, sizeof(string), "{B8B8B8}%s {FFFFFF}ha sido kickeado del servidor por tener ping alto {B8B8B8}({FF7B00}%d{B8B8B8})", PlayerName, GetPlayerPing(playerid));
        	printf("%s ha sido kickeado del servidor por tener ping alto (%d)", nombre(playerid), GetPlayerPing(playerid));
        	SendClientMessageToAll(COLOR_GREEN, string);
        	Kick(playerid);
        }
	new String[128];
	new FPSSS = GetPlayerDrunkLevel(playerid), fps;
	if(FPSSS < 100){
		SetPlayerDrunkLevel(playerid, 2000);
	}else{
		if(FPSSS != FPSS[playerid]){
			fps = FPSS[playerid] - FPSSS;
			if(fps > 0 && fps < 200) FPS[playerid] = fps;
			FPSS[playerid] = FPSSS;
		}
	}
	format(String, sizeof(String), "~y~Fps: ~w~%d ~y~Ms: ~w~%d ~y~PL: ~w~%.1f", FPS[playerid], GetPlayerPing(playerid), NetStats_PacketLossPercent(playerid));
	TextDrawSetString(Frames[playerid], String);
    new drunknew;
    drunknew = GetPlayerDrunkLevel(playerid);
    if(drunknew < 100){
        SetPlayerDrunkLevel(playerid, 2000);
    }else{
        if(pDrunkLevelLast[playerid] != drunknew){
            new wfps = pDrunkLevelLast[playerid] - drunknew;
            if((wfps > 0) && (wfps < 200))
                pFPS[playerid] = wfps;
            	pDrunkLevelLast[playerid] = drunknew;
         	if((wfps > 0 ) && (wfps < MIN_FPS) && fpslimit == 1){
         		Ad_fps[playerid]++;
         		if((Ad_fps[playerid] > 0) && (Ad_fps[playerid] < 3)){
         			pFPS[playerid]= wfps;
					new strg1[256];
   	       	 		format(strg1, sizeof(strg1), "{B8B8B8}%s {FFFFFF}ha sido advertido por tener fps bajos {B8B8B8}({007C0E}%d{B8B8B8} fps)", nombre(playerid), pFPS);
   	        		printf("%s ha sido advertido %d/3 por tener fps bajos (%d fps)", nombre(playerid), Ad_fps, pFPS);
            		SendClientMessageToAll(BLANCO, strg1);
                }else if(Ad_fps[playerid] >= 3){
					new strg1[256], strg2[256];
  	       	 		format(strg1, sizeof(strg1), "{B8B8B8}%s {FFFFFF}ha sido kickeado por tener fps bajos {B8B8B8}({007C0E}%d{B8B8B8} fps)", nombre(playerid), pFPS);
            		SendClientMessageToAll(BLANCO, strg1);
		            format(strg2, sizeof(strg2), "Has sido kickeado del servidor por tener fps bajos del minimo {FF0000}%d{B8B8B8}/{FF7B00}%d", pFPS, MIN_FPS);
            		SendClientMessage(playerid, BLANCO, strg2);
   	        		printf("%s ha sido kickeado %d/3 por tener fps bajos (%d fps)", nombre(playerid), Ad_fps, pFPS);
                	Kick(playerid);
                }
        	}
        }
    }
return 1;
}

public OnPlayerText(playerid,text[]){
	if(IsPlayerConnected(playerid)){
		if(lecheroact == 1){
			if(strfind(text, "V,:", true) != -1 || strfind(text, "v,:", true) != -1 || strfind(text, ":,V", true) != -1 || strfind(text, ":,v", true) != -1 ||	strfind(text, ";V  ", true) != -1 ||	strfind(text, ";v ", true) != -1 ||	strfind(text, ";V", true) != -1 || strfind(text, ";v", true) != -1 || strfind(text, "V: ", true) != -1 || strfind(text, "V:", true) != -1 || strfind(text, "v:", true) != -1 || strfind(text, ": v", true) != -1 || strfind(text, ":v", true) != -1 || strfind(text, ":V", true) != -1)
			{
				SCMTAF(COLOR_WHITE,"[WTx][L]eChe[R]Oo_. {FF0000}2.0 {FFFFFF}kickeó a {B8B8B8}%s {FFFFFF}por usar: {70FBFF}:v", nombre(playerid));
				ApplyActorAnimation(lecherobot, "KISSING", "BD_GF_Wave", 4.0, 0, 0, 0, 1, 0);
				Kick(playerid);
				SCMTA(COLOR_WHITE,"{70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {C3C3C3}[-1]{FFFFFF}: otro mogolico menos.");
				return 0;
			}
		}
	if(text[0] == '!'){
		new Name[25];
		GetPlayerName(playerid, Name, 25);
		ForPlayers(i){
			if(Equipo[playerid] == Equipo[i]){
			SCMF(i,COLOR_WHITE,"{B8B8B8}[EQUIPO] {004444}%s:{C3C3C3} %s", Name, text[1]);
		}
	}
return 0;
}

	if(GetPVarInt(playerid,"Muted") == 1){
		SCM(playerid,0xFF0000FF,"Te encuentras muteado, pidele a un admin que te desmuteé.");
		return 0;
	}
	if(text[0] == '$' && Admin[playerid] >= 1){
	    new string[200]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string),"> {B8B8B8}[CHAT-ADMIN] {004444}%s {FFFFFF}[{B8B8B8}N-{70FBFF}%d{FFFFFF}]: {C3C3C3}%s", string, Admin[playerid], text[1]);
		MessageToAdmins(GetPlayerColor(playerid), string);
		return 0;
	}

	new Name[25], string[256];
		GetPlayerName(playerid,Name,25);
		format(string, sizeof(string), "{B8B8B8}(%.1fk) {FFFFFF}- {%06x}%s {C3C3C3}[%d]{FFFFFF}: %s", Puntaje_ranked[playerid], GetPlayerColor(playerid) >>> 8, Name, playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
		SetPlayerChatBubble(playerid, text, COLOR_GREY, 50, 5000);
		return 0;
	}
return true;
}

forward SpecRefresh(playerid,specid);
public SpecRefresh(playerid,specid){
	PlayerSpectatePlayerEx(specid, playerid);
return true;
}

forward KickT(playerid);
public KickT(playerid){
	Kick(playerid);
return true;
}

forward MessageToAdmins(color,const string[]);
public MessageToAdmins(color,const string[])
{
	ForPlayers(i){
		if(IsPlayerConnected(i) == 1) if (Admin[i] >= 1) SendClientMessage(i, color, string);
	}
	return 1;
}

forward dmgTdUpdate();
public dmgTdUpdate()
{
    foreach(new playerid : Player)
    {
        if(!IsPlayerConnected(playerid)) continue;
       	if(txdAlpha[0][playerid] > 0)
        {
            TextDrawColor(txd[0][playerid], COLOR_GREEN);
            TextDrawBackgroundColor(txd[0][playerid], 255);
            TextDrawShowForPlayer(playerid, txd[0][playerid]);
			txdAlpha[0][playerid] -= 0x6;
        }
        else if(txdAlpha[0][playerid] < 0)
        {
            TextDrawHideForPlayer(playerid, txd[0][playerid]);
            txdAlpha[0][playerid] = 0;

            for(new a = 0; a < MAX_PLAYERS; a++)
                currentHpLoss[0][playerid][a] = 0.0;
        }
        if(txdAlpha[1][playerid] > 0)
        {
            TextDrawColor(txd[1][playerid], COLOR_NARANJA);
            TextDrawBackgroundColor(txd[1][playerid], 255);

            TextDrawShowForPlayer(playerid, txd[1][playerid]);

            txdAlpha[1][playerid] -= 0x6;
        }
        else if(txdAlpha[1][playerid] < 0)
        {
            TextDrawHideForPlayer(playerid, txd[1][playerid]);
            txdAlpha[1][playerid] = 0;

             for(new a = 0; playerid < MAX_PLAYERS; a++)
                currentHpLoss[1][playerid][a] = 0.0;
        }
    }
}


public OnPlayerDeath(playerid, killerid, reason)
{

	/*ForPlayers(i){
	    if(Spec[i] == playerid){
			SetPlayerVirtualWorld(i,0);
			SetPlayerInterior(i,0);
			Spec[i] = -1;
			TogglePlayerSpectating(i, 0);
			SpawnPlayer(i);
	    }
	}
	*/
	ForPlayers(i) {
		if(Spec[i] == playerid){
			SetTimerEx("SpecRefresh",2000,false,"ii",playerid,i);
			break;
		}
	}
	if(EstaEnDerby[playerid] == 1){
		new id = GetPlayerVehicleID(playerid);
		DestroyVehicle(id);
		SpawnPlayer(playerid);
	}

	if(Modo_juego == 1) {
		Kills2[killerid]++;
		if(Kills2[killerid] == 3){
			if(Equipo[killerid] != EQUIPO_SPEC){
				if(Equipo[killerid] == EQUIPO_NARANJA) format(Texto,256,"{F69521}%s {FFFFFF}mató a {007C0E}3 {FFFFFF}jugadores seguidos.", nombre(killerid));
				else format(Texto,256,"{007C0E}%s {FFFFFF}mató a {F69521}3 {FFFFFF}jugadores seguidos.", nombre(killerid));
				SendClientMessageToAll(BLANCO,Texto);
			}
		}
		if(Kills2[killerid] == 5){
			if(Equipo[killerid] != EQUIPO_SPEC){
				if(Equipo[killerid] == EQUIPO_NARANJA) format(Texto,256,"{F69521}%s {FFFFFF}mató a {007C0E}5 {FFFFFF}jugadores seguidos.", nombre(killerid));
				else format(Texto,256,"{007C0E}%s {FFFFFF}mató a {F69521}5 {FFFFFF}jugadores seguidos.", nombre(killerid));
				SendClientMessageToAll(BLANCO,Texto);
			}
		}
	}

	if(EstaEnX1[playerid] != 0){
		new Float:Vida, Float:Armor;
		GetPlayerHealth(killerid, Vida);
		GetPlayerArmour(killerid, Armor);
		format(iString, 256, "{B8B8B8}%s {FFFFFF}ganó un duelo contra {B8B8B8}%s{FFFFFF}: {007C0E}[{FFFFFF}V: %.2f/C: %.2f{007C0E}]", nombre(killerid), nombre(playerid),Vida, Armor);
		SendClientMessageToAll(COLOR_WHITE, iString);
		X1_Ganados[killerid]++;
		X1_Perdidos[playerid]++;
		SpawnPlayer(killerid);
		SpawnPlayer(playerid);
		if((GetPVarInt(playerid,"Logged") == 1) && (GetPVarInt(killerid,"Logged") == 1)){
		    if(Clan_n[playerid] != -1 && Clan_n[killerid] != -1){
		        Clan_kills[Clan_n[killerid]]++;
		        Clan_muertes[Clan_n[playerid]]--;
		    }
		}
	}

	if(Sospechoso[playerid] == 1){
		SetPlayerVirtualWorld(playerid,11);
		SetPlayerInterior(playerid,11);
	}else if(Sospechoso[playerid] == 0){
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerInterior(playerid,0);
	}
	
	if(killerid == INVALID_PLAYER_ID) return SpawnPlayer(playerid);
	if(Equipo[playerid] == EQUIPO_SPEC) return SpawnPlayer(playerid);
	Kills[killerid]++;
	Muertes[playerid]++;
	if(Equipo[playerid] == Equipo[killerid]) Equipo_kills[killerid]++;
	SpawnPlayer(playerid);
	SendDeathMessage(killerid,playerid,reason);
	SetPlayerScore(killerid,Kills[killerid]);
	if(Modo_juego == 1) {
		TeamScoreUpdate(playerid,killerid);
		if((GetPVarInt(playerid,"Logged") == 1) && (GetPVarInt(killerid,"Logged") == 1)){
		    if(Clan_n[playerid] != 1 && Clan_n[killerid] != 1){
		        Clan_kills[Clan_n[killerid]]++;
		        Clan_muertes[Clan_n[playerid]]--;
		    }
		}
	}else{
		UpdateScoreBar();
	}
return 1;
}

stock TeamScoreUpdate(playerid,killerid){
	new team;
	if(Equipo[playerid] == Equipo[killerid]){
		if(Equipo[playerid] == EQUIPO_NARANJA) team = EQUIPO_VERDE;
		else team = EQUIPO_NARANJA;
			if(Equipo[killerid] == EQUIPO_NARANJA){
				SCMTAF(COLOR_WHITE,"{B8B8B8}El equipo {F69521}%s{B8B8B8} ha hecho teamkill.",Nombre_equipo[Equipo[killerid]]);
			}else{
				SCMTAF(COLOR_WHITE,"{B8B8B8}El equipo {007C0E}%s{B8B8B8} ha hecho teamkill.",Nombre_equipo[Equipo[killerid]]);
			}
			Equipo_puntaje[team]++;
			if(Equipo_puntaje[team] == Puntaje_maximo){
				Equipo_rondas[team]++;
				SCMTA(BLANCO,"");
				if(naranja > 1 && verde > 1){
				    new cc_n = 0, cc_v = 0;
				    ForPlayers(i){
				        if(Equipo[i] == EQUIPO_NARANJA){
							if(strcmp(Clanes[Clan_n[i]], Nombre_equipo[EQUIPO_NARANJA], true) == 0){
								cc_n++;
							}
				        }else if(Equipo[i] == EQUIPO_VERDE){
							if(strcmp(Clanes[Clan_n[i]], Nombre_equipo[EQUIPO_VERDE], true) == 0){
								cc_v++;
							}
				        }
				    }
					if(team == EQUIPO_NARANJA){
						SCMTAF(0x670000F6A,"{FFFFFF}- {B8B8B8}¡Equipo {F69521}%s{B8B8B8} ha ganado!",Nombre_equipo[team]);
						if(cc_n == naranja && cc_v == verde){
							new n_clan = -1, v_clan = -1, pos = 0, c[2] = {-1,-1};
							do{
          						if(strcmp(Clanes[pos], Nombre_equipo[EQUIPO_NARANJA], true) == 0){
									n_clan = pos;
									c[0] = 1;
          						}else if(strcmp(Clanes[pos], Nombre_equipo[EQUIPO_NARANJA], true) == 0){
									v_clan = pos;
									c[1] = 1;
          						}
          						if(pos == 4) pos = 0;
							}while(c[0] != 1 && c[1] != 1);
							Clan_Cganadas[n_clan]++;
							Clan_Cperdidas[v_clan]--;
						}
					}else{
						SCMTAF(0x670000F6A,"{FFFFFF}- {B8B8B8}¡Equipo {007C0E}%s{B8B8B8} ha ganado!",Nombre_equipo[team]);
						if(cc_n == naranja && cc_v == verde){
							new n_clan = -1, v_clan = -1, pos = 0, c[2] = {-1,-1};
							do{
          						if(strcmp(Clanes[pos], Nombre_equipo[EQUIPO_NARANJA], true) == 0){
									n_clan = pos;
									c[0] = 1;
          						}else if(strcmp(Clanes[pos], Nombre_equipo[EQUIPO_NARANJA], true) == 0){
									v_clan = pos;
									c[1] = 1;
          						}
          						if(pos == 4) pos = 0;
							}while(c[0] != 1 && c[1] != 1);
							Clan_Cganadas[v_clan]++;
							Clan_Cperdidas[n_clan]--;
						}
					}
				}else if(naranja == 1 && verde == 1){
					new name1[50],name2[50];
						ForPlayers(i){
							if(Equipo[i] == EQUIPO_NARANJA){
								name1 = nombre(i);
							}else if(Equipo[i] == EQUIPO_VERDE){
								name2 = nombre(i);
							}
						}
					if(team == EQUIPO_NARANJA){
						SCMTAF(0x670000F6A,"{FFFFFF}- {B8B8B8}¡{F69521}%s{B8B8B8} ha ganado contra {007C0E}%s{B8B8B8}!",name1,name2);
					}else{
						SCMTAF(0x670000F6A,"{FFFFFF}- {B8B8B8}¡{007C0E}%s{B8B8B8} ha ganado contra {F69521}%s{B8B8B8}!",name2,name1);
					}
				}
				SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}Puntajes: {F69521}%s {B8B8B8} » {F69521}[%d] {FFFFFF}: {007C0E}[%d]{B8B8B8} « {007C0E}%s",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE]);
				Puntaje_total[EQUIPO_NARANJA] += Equipo_puntaje[EQUIPO_NARANJA];
				Puntaje_total[EQUIPO_VERDE] += Equipo_puntaje[EQUIPO_VERDE];
				Equipo_puntaje[EQUIPO_NARANJA] = 0;
				Equipo_puntaje[EQUIPO_VERDE] = 0;
				Estadisticas();
				if(Equipo_rondas[team] == Ronda_maxima || (Equipo_rondas[team]+Equipo_rondas[Equipo[playerid]]) == Ronda_maxima){
				}else{
					CountDown(5);
					ForPlayers(i){
						if(Equipo[i] == EQUIPO_NARANJA || Equipo[i] == EQUIPO_VERDE)
						SetPlayerHealth(i,100);
						SpawnPlayer(i);
						//odpocet
					}
				}
			}
		if(Equipo_rondas[team] == Ronda_maxima || (Equipo_rondas[team]+Equipo_rondas[Equipo[playerid]]) == Ronda_maxima){
			TeamWinClanWar();
			Estadisticas();
			Ordenar();
		}else{

		}
	}else{
		Owned[Equipo[playerid]] = 0;
		Owned[Equipo[killerid]]++;
		if(Owned[Equipo[killerid]] == 5){
			if(naranja > 1 && verde > 1){
				new str[128];
				if(Equipo[killerid] == EQUIPO_NARANJA){
					format(str,128,"~y~%s ~w~acaba de hacer owned al equipo ~g~%s",Nombre_equipo[Equipo[killerid]],Nombre_equipo[Equipo[playerid]]);
					SCMTAF(COLOR_WHITE,"{FFFFFF}El equipo {F69521}%s{FFFFFF} ha hecho <owned> al equipo {007C0E}%s{FFFFFF}.",Nombre_equipo[Equipo[killerid]],Nombre_equipo[Equipo[playerid]]);
				}else{
					format(str,128,"~g~%s ~w~acaba de hacer owned al equipo ~y~%s",Nombre_equipo[Equipo[killerid]],Nombre_equipo[Equipo[playerid]]);
					SCMTAF(COLOR_WHITE,"{FFFFFF}El equipo {007C0E}%s{FFFFFF} ha hecho <owned> al equipo {F69521}%s{FFFFFF}.",Nombre_equipo[Equipo[killerid]],Nombre_equipo[Equipo[playerid]]);
				}
				GameTextForAll(str, 7000,3);
			}else if(naranja == 1 && verde == 1){
				new name1[50],name2[50];
				ForPlayers(i){
					if(Equipo[i] == EQUIPO_NARANJA){
						name1 = nombre(i);
					}else if(Equipo[i] == EQUIPO_VERDE){
						name2 = nombre(i);
					}
				}
				if(team == EQUIPO_NARANJA) SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡{F69521}%s{FFFFFF} ha hecho <owned> a {F69521}{007C0E}%s{B8B8B8}!",name1,name2);
				else SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡{007C0E}%s ha hecho <owned> a {F69521}%s{B8B8B8}!",name2,name1);
			}
		}
		team = Equipo[killerid];
		Equipo_puntaje[team]++;
		if(Equipo_puntaje[team] == Puntaje_maximo){
			Equipo_rondas[team]++;
			SCMTA(0x670000F6A,"");
			if(naranja > 1 && verde > 1){
				if(team == EQUIPO_NARANJA) SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡Equipo {F69521}%s{B8B8B8} ha ganado esta ronda!",Nombre_equipo[team]);
				else SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡Equipo {007C0E}%s{B8B8B8} ha ganado esta ronda!",Nombre_equipo[team]);
			}else if(naranja == 1 && verde == 1){
				new name1[50],name2[50], id, id2;
				ForPlayers(i){
					if(Equipo[i] == EQUIPO_NARANJA){
						name1 = nombre(i);
						id = i;
					}else if(Equipo[i] == EQUIPO_VERDE){
						name2 = nombre(i);
						id2 = i;
					}
				}
				if(team == EQUIPO_NARANJA){
					SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡{F69521}%s{B8B8B8} ha ganado esta ronda contra {007C0E}%s{B8B8B8}!",name1,name2);
					if(Puntaje_maximo >= 10){
						if(Puntaje_ranked[id2] > (Puntaje_ranked[id]+0.100)){ /* Jugador gano contra nivel mayor */
        					Puntaje_ranked[id]  = Puntaje_ranked[id] + 0.008; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked +8 puntos: %.3f p", Puntaje_ranked[id]);
        					Puntaje_ranked[id2] = Puntaje_ranked[id2] - 0.008; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked -8 puntos: %.3f p", Puntaje_ranked[id2]);
    					}else if(Puntaje_ranked[id2] < (Puntaje_ranked[id]-0.100)){ /* Jugador gano contra nivel menor */
    						Puntaje_ranked[id] = Puntaje_ranked[id] + 0.001; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked +1 punto: %.3f p", Puntaje_ranked[id]);
    						Puntaje_ranked[id2] = Puntaje_ranked[id2] - 0.001; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked -1 punto: %.3f p", Puntaje_ranked[id2]);
    					}else if(Puntaje_ranked[id2] < (Puntaje_ranked[id]+0.100) && Puntaje_ranked[id2] > (Puntaje_ranked[id]-0.100)){
        					Puntaje_ranked[id] = Puntaje_ranked[id] + 0.005; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked +5 puntos: %.3f p", Puntaje_ranked[id]);
        					Puntaje_ranked[id2] = Puntaje_ranked[id2] - 0.004; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked -4 puntos: %.3f p", Puntaje_ranked[id2]);
						}
					}
				}else{
					SCMTAF(BLANCO,"{FFFFFF}- {B8B8B8}¡{007C0E}%s{B8B8B8} ha ganado esta ronda contra {F69521}%s{B8B8B8}!",name2,name1);
					if(Puntaje_maximo >= 10){
    					if(Puntaje_ranked[id] > (Puntaje_ranked[id2]+0.100)){ 		//Jugador gano contra nivel mayor
        					Puntaje_ranked[id2]  = Puntaje_ranked[id2] + 0.008; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked +8 puntos: %.3f p", Puntaje_ranked[id2]);
        					Puntaje_ranked[id] = Puntaje_ranked[id] - 0.008; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked -8 puntos: %.3f p", Puntaje_ranked[id]);
    					}else if(Puntaje_ranked[id] < (Puntaje_ranked[id2]-0.100)){ 	//Jugador gano contra nivel menor
    						Puntaje_ranked[id2] = Puntaje_ranked[id2] + 0.001; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked +1 punto: %.3f p", Puntaje_ranked[id2]);
    						Puntaje_ranked[id] = Puntaje_ranked[id] - 0.001; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked -1 puntos: %.3f p", Puntaje_ranked[id]);
    					}else if(Puntaje_ranked[id] < (Puntaje_ranked[id2]+0.100) && Puntaje_ranked[id2] > (Puntaje_ranked[id]-0.100)){
        					Puntaje_ranked[id2] = Puntaje_ranked[id2] + 0.005; SCMF(id2,COLOR_WHITE,"{B8B8B8}- Ranked +5 puntos: %.3f p", Puntaje_ranked[id2]);
        					Puntaje_ranked[id] = Puntaje_ranked[id] - 0.004; SCMF(id,COLOR_WHITE,"{B8B8B8}- Ranked -4 puntos: %.3f p", Puntaje_ranked[id]);
    					}
					}
				}
			}
			SCMTAF(0x670000F6A,"{FFFFFF}- {B8B8B8}Rondas y puntaje: {F69521}%s {B8B8B8}» {F69521}(%d) [%d] {B8B8B8}: {007C0E}[%d] (%d){B8B8B8} « {007C0E}%s",Nombre_equipo[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE],Equipo_rondas[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE]);
			//SCMTA(0x670000F6A,"");
			Puntaje_total[EQUIPO_NARANJA] += Equipo_puntaje[EQUIPO_NARANJA];
			Puntaje_total[EQUIPO_VERDE] += Equipo_puntaje[EQUIPO_VERDE];
			Equipo_puntaje[EQUIPO_NARANJA] = 0;
			Equipo_puntaje[EQUIPO_VERDE] = 0;
			Estadisticas();
			if(Equipo_rondas[team] == Ronda_maxima || (Equipo_rondas[team]+Equipo_rondas[Equipo[playerid]]) == Ronda_maxima){

			}else{
				ForPlayers(i){
					if(Equipo[i] == EQUIPO_NARANJA || Equipo[i] == EQUIPO_VERDE){
						SetPlayerHealth(i,100);
						SpawnPlayer(i);
						Ordenar();
					//odpocet
					}
				}
			CountDown(5);
			}
		}
		if(Equipo_rondas[team] == Ronda_maxima || (Equipo_rondas[team]+Equipo_rondas[Equipo[playerid]]) == Ronda_maxima){
			TeamWinClanWar();
		}
	}
UpdateScoreBar();
}

stock TeamWinClanWar(){
	ForPlayers(i){
		if(Equipo[i] == EQUIPO_NARANJA || Equipo[i] == EQUIPO_VERDE){
			SetPlayerHealth(i,100);
			SetPlayerPos(i,Jugador_pos[Mapa_servidor][Equipo[i]][0],Jugador_pos[Mapa_servidor][Equipo[i]][1],Jugador_pos[Mapa_servidor][Equipo[i]][2]);
			SetPlayerFacingAngle(i,Jugador_pos[Mapa_servidor][Equipo[i]][3]);
			TogglePlayerControllable(i,0);
		}
	}
	new win;
	if(Equipo_rondas[EQUIPO_NARANJA] > Equipo_rondas[EQUIPO_VERDE]) win = EQUIPO_NARANJA;
	else win = EQUIPO_VERDE;
	TeamWin(win);
	SCMTAF(COLOR_WHITE,"{FFFFFF}- {B8B8B8}Puntaje total: {F69521}%s {B8B8B8}» {F69521}[%d]{FFFFFF} : {007C0E}[%d]{B8B8B8} « {007C0E}%s",Nombre_equipo[EQUIPO_NARANJA],Puntaje_total[EQUIPO_NARANJA],Puntaje_total[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE]);
	//SCMTA(COLOR_WHITE,"");
	Puntaje_total[EQUIPO_NARANJA] = 0;
	Puntaje_total[EQUIPO_VERDE] = 0;
	Equipo_rondas[EQUIPO_NARANJA] = 0;
	Equipo_rondas[EQUIPO_VERDE] = 0;
	Estadisticas();
	SetTimer("HideWin",30000,false);
}
stock TeamWin(win){
	ClearKillList();
	if(naranja == 1 && verde == 1){
    	TextDrawShowForAll(Textdraw101);
	}else{
		TextDrawShowForAll(Textdraw100);
	}
	TextDrawShowForAll(Textdraw2);
	TextDrawShowForAll(Textdraw4);
	TextDrawShowForAll(Textdraw5);
	new NameString[2][MAX_PLAYER_NAME*10];
	new KillString[2][MAX_PLAYER_NAME*10];
	new DeathString[2][MAX_PLAYER_NAME*10];
	new RatioString[2][MAX_PLAYER_NAME*10];
	new idmejorJugador;
	new Float:maxpuntos = 0.00;
	ForPlayers(i){
		if(Equipo[i] == EQUIPO_NARANJA || Equipo[i] == EQUIPO_VERDE){
			format(NameString[Equipo[i]],300,"%s%s~n~",NameString[Equipo[i]],nombre(i));
			format(KillString[Equipo[i]],300,"%s%d~n~",KillString[Equipo[i]],Kills[i]);
			format(DeathString[Equipo[i]],300,"%s%d~n~",DeathString[Equipo[i]],Muertes[i]);
			new Float:ratio;
			if(Muertes[i] == 0) ratio = Kills[i];
			else ratio = float(Kills[i])/float(Muertes[i]);
			format(RatioString[Equipo[i]],300,"%s%0.2f~n~",RatioString[Equipo[i]],ratio);
			if(naranja > 1 && verde > 1){
				if(ratio > maxpuntos){
					maxpuntos = ratio;
					idmejorJugador = i;
				}
			}
		}
	}
	if(naranja > 1 && verde > 1){
		if(Equipo[idmejorJugador] == EQUIPO_NARANJA) SCMTAF(COLOR_WHITE,"{B8B8B8}- {F69521}%s {B8B8B8}fue el mejor jugador ({F69521}%0.2f {B8B8B8}ratio) de la partida.", nombre(idmejorJugador), maxpuntos);
		else SCMTAF(COLOR_WHITE,"{B8B8B8}- {007C0E}%s {B8B8B8}fue el mejor jugador ({007C0E}%0.2f {B8B8B8}ratio) de la partida.", nombre(idmejorJugador), maxpuntos);
	}
	TextDrawSetString(Textdraw7,NameString[0]);
	TextDrawSetString(Textdraw8,KillString[0]);
	TextDrawSetString(Textdraw9,DeathString[0]);
	TextDrawSetString(Textdraw10,RatioString[0]);
	TextDrawSetString(Textdraw11,NameString[1]);
	TextDrawSetString(Textdraw12,KillString[1]);
	TextDrawSetString(Textdraw13,DeathString[1]);
	TextDrawSetString(Textdraw14,RatioString[1]);
	TextDrawShowForAll(Textdraw7);
	TextDrawShowForAll(Textdraw8);
	TextDrawShowForAll(Textdraw9);
	TextDrawShowForAll(Textdraw10);
	TextDrawShowForAll(Textdraw11);
	TextDrawShowForAll(Textdraw12);
	TextDrawShowForAll(Textdraw13);
	TextDrawShowForAll(Textdraw14);
	Ordenar();
	new winstr[5];
	if(win == 0) format(winstr,5,"~y~");
	else format(winstr,5,"~g~");
	new BigStr[1][1500];
	new name1[24], name2[24], ganador[24];
	if(naranja == 1 && verde == 1){
		ForPlayers(i){
			if(Equipo[i] == EQUIPO_NARANJA) name1 = nombre(i);
			else name2 = nombre(i);
			if(Equipo[i] == win) ganador = nombre(i);
		}
		if(win == EQUIPO_NARANJA) format(BigStr[0],1500,"- Partida: ~y~%s ~w~vs ~g~%s~n~~w~- Ganador: ~y~%s~n~~w~- Rondas ganadas: ~y~%02d:~g~%02d~n~~w~- Puntaje total: ~y~%d~w~:~g~%d~n~~w~- Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d ~w~- ~y~%d ~w~vs ~g~%d~n~~w~- Mapa: ~b~%s",name1,name2,ganador,Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Puntaje_total[EQUIPO_NARANJA],Puntaje_total[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,naranja,verde,Nombre_mapa(Mapa_servidor));
		else format(BigStr[0],1500,"- Partida: ~y~%s ~w~vs ~g~%s~n~~w~- Ganador: ~g~%s~n~~w~- Rondas ganadas: ~y~%02d:~g~%02d~n~~w~- Puntaje total: ~y~%d~w~:~g~%d~n~~w~- Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d ~w~- ~y~%d ~w~vs ~g~%d~n~~w~- Mapa: ~b~%s",name1,name2,ganador,Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Puntaje_total[EQUIPO_NARANJA],Puntaje_total[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,naranja,verde,Nombre_mapa(Mapa_servidor));
	}else{
		if(win == EQUIPO_NARANJA){
			format(BigStr[0],1500,"- Partida: ~y~%s ~w~vs ~g~%s~n~~w~- Ganador: ~y~%s%s~n~~w~- Rondas ganadas: ~y~%02d:~g~%02d~n~~w~- Puntaje total: ~y~%d~w~:~g~%d~n~~w~- Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d ~w~- ~y~%d ~w~vs ~g~%d~n~~w~- Mapa: ~b~%s",
			Nombre_equipo[EQUIPO_NARANJA],Nombre_equipo[EQUIPO_VERDE],winstr,Nombre_equipo[win],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Puntaje_total[EQUIPO_NARANJA],Puntaje_total[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,naranja,verde,Nombre_mapa(Mapa_servidor));
		}else{
		format(BigStr[0],1500,"- Partida: ~y~%s ~w~vs ~g~%s~n~~w~- Ganador: ~g~%s%s~n~~w~- Rondas ganadas: ~y~%02d:~g~%02d~n~~w~- Puntaje total: ~y~%d~w~:~g~%d~n~~w~- Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d ~w~- ~y~%d ~w~vs ~g~%d~n~~w~- Mapa: ~b~%s",
		Nombre_equipo[EQUIPO_NARANJA],Nombre_equipo[EQUIPO_VERDE],winstr,Nombre_equipo[win],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Puntaje_total[EQUIPO_NARANJA],Puntaje_total[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,naranja,verde,Nombre_mapa(Mapa_servidor));
		}
	}
	TextDrawSetString(Textdraw6,BigStr[0]);
	TextDrawShowForAll(Textdraw6);
	if(lecheroact == 1){
		SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}celebra la victoria con una paja!");
		ApplyActorAnimation(lecherobot, "PAULNMAC", "wank_loop", 4.0, 0, 0, 0, 1, 0);
	}
}

stock CountDownDerby(time){
	new str[10];
	format(str,10,"%d",time);
	GameTextForAll(str, 1000, 5);
	Count = time-1;
	SetTimer("CountDownDerbyPublic",700,false);
}

public CountDownDerbyPublic(){
	if(Pausa == 1) return 0;
		if(Count > 0){
			new str[10];
			format(str,10,"%d",Count);
			ForPlayers(i){
				if(EstaEnDerby[i] == 1){
					GameTextForPlayer(i,str,1000,5);
				}
			}
			Count--;
			ForPlayers(i){
				if(EstaEnDerby[i] == 1) PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
			}
			SetTimer("CountDownDerbyPublic",1000,false);
		}else{
			SendClientMessageToAll(BLANCO,"Ha comenzado el derby en la arena {B8B8B8}<{F69521}Surtidor de waska{B8B8B8}>");
			ForPlayers(i){
				if(EstaEnDerby[i] == 1){
					TogglePlayerControllable(i,1);
				}
			}
			Count = -1;
		}
	return true;
}


stock CountDown(time){
	new str[10];
	format(str,10,"%d",time);
	GameTextForAll(str, 1000, 5);
	Count = time-1;
	ForPlayers(i){
		if(Equipo[i] != EQUIPO_SPEC){
			//SpawnPlayer(i);
		}
	}
	SetTimer("CountDownPublic",700,false);
}

public CountDownPublic(){
	if(Pausa == 1) return 0;
		if(Count > 0){
			new str[10];
			format(str,10,"%d",Count);
			GameTextForAll(str, 1000, 5);
			Count--;
			ForPlayers(i){ PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0); }
			SetTimer("CountDownPublic",1000,false);
		}else{
			GameTextForAll("~b~~h~~h~~h~ GO!", 1000, 5);
			ForPlayers(i){
				SetPlayerHealth(i,100);
			}
		RecreateObject();
		RefreshObject();
		Count = -1;
	}
return true;
}

/*
stock UpdateScoreBar(){
new str[300];
ForPlayers(i){
if(Modo_juego == 1){
		format(str,300,"~r~CW~w~) - Partida: ~r~%s : ~w~(~r~%02d~w~) ~r~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~: %s ~w~/ Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~ - ~r~%d~w~ vs ~g~%d~w~",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,naranja,verde);
		new Float:ratio;
		if(Deaths[i] == 0) ratio = Kills[i];
		ratio = float(Kills[i])/float(Deaths[i]);
		format(str,300,"%s ~w~/ Kills: ~b~~h~~h~~h~%d~w~ ~w~/ Muertes: ~b~~h~~h~~h~%d~w~ / Ratio: ~b~~h~~h~~h~%0.2f~w~ ~w~/ Mapa: ~b~~h~~h~~h~%s~w~",str,Kills[i],Deaths[i],ratio,Nombre_mapa(Mapa_servidor));
		TextDrawSetString(Textdraw1[i],str);
}else{
	format(str,300,"~w~(~g~TG~w~) - Mapa: ~b~~h~~h~~h~%s",Nombre_mapa(Mapa_servidor));
	TextDrawSetString(Textdraw1[i],str);
}
}
RefreshObject();
}
*/
stock UpdateScoreBar(){
new str[300];
ForPlayers(i){
if(Modo_juego == 1){
	if(Equipo[i] == EQUIPO_VERDE || Equipo[i] == EQUIPO_NARANJA){
		format(str,300,"~w~(MODO ~y~CW~w~) / ~y~%s  ~w~(~y~%02d~w~) ~y~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~ %s ~w~/ Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~ - ~y~%d~w~ vs ~g~%d~r~",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo, naranja,verde);
		new Float:ratio;
		if(Muertes[i] == 0) ratio = Kills[i];
		else ratio = float(Kills[i])/float(Muertes[i]);
		format(str,300,"%s ~w~/ Kills: ~b~~h~~h~~h~%d~w~ ~w~/ Muertes: ~b~~h~~h~~h~%d~w~ / Ratio: ~b~~h~~h~~h~%0.2f~w~ ~w~/ Rank: ~b~~h~~h~~h~%0.3f~w~",str,Kills[i],Muertes[i],ratio,Puntaje_ranked[i]);
	}else if(Equipo[i] == EQUIPO_DERBY) format(str,300,"~w~(MODO ~y~DERBY~w~) / Mapa: ~b~~h~~h~~h~Surtidor de waska~w~ / Jugadores: ~b~~h~~h~~h~%d ~w~/ En cw: ~y~%s  ~w~(~y~%02d~w~) ~y~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~ %s", dcontador, Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE]);
	else format(str,300,"~w~(MODO ~y~CW~w~) / ~y~%s  ~w~(~y~%02d~w~) ~y~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~ %s ~w~/ Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~ - ~y~%d~w~ vs ~g~%d~w~ / Mapa: ~b~~h~~h~~h~%s~w~",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo, naranja,verde,Nombre_mapa(Mapa_servidor));
}else{
    if(Equipo[i] != EQUIPO_DERBY) format(str,300,"~w~(MODO ~g~TG~w~) / Mapa: ~b~~h~~h~~h~%s~w~ / Ip: ~y~85.190.153.224:25600", Nombre_mapa(Mapa_servidor));
	else format(str,300,"~w~(MODO ~y~DERBY~w~) / Mapa: ~b~~h~~h~~h~Surtidor de waska~w~ / Jugadores: ~b~~h~~h~~h~%d", dcontador);
}
TextDrawSetString(Textdraw1[i],str);
}
RefreshObject();
}
//format(str,300,"~r~%s ~w~vs ~g~%s ~w~/ Puntaje: ~r~%02d~w~:~g~%02d ~w~/ Rondas: ~r~%02d~w~:~g~%02d ~w~/ De: (~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~) / Modo: (~b~~h~~h~~h~%s~w~)",Nombre_equipo[EQUIPO_NARANJA],Nombre_equipo[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo,CWTG(Modo_juego));
//new Float:ratio;
//if(Deaths[i] == 0) ratio = Kills[i];
//else ratio = float(Kills[i])/float(Deaths[i]);
//format(str,300,"%s ~w~/ Kills: (~b~~h~~h~~h~%d~w~) ~w~/ Muertes: (~b~~h~~h~~h~%d~w~) / Ratio: (~b~~h~~h~~h~%0.2f) ~w~/ Mapa: (~b~~h~~h~~h~%s~w~)",str,Kills[i],Deaths[i],ratio,Nombre_mapa(Mapa_servidor));
//TextDrawSetString(Textdraw1[i],str);
//}

stock UpdatePlayerScoreBar(i){
new str[300];
if(Modo_juego == 1){
	if(Equipo[i] == EQUIPO_VERDE || Equipo[i] == EQUIPO_NARANJA){
		format(str,300,"~w~(MODO ~y~CW~w~) / ~y~%s  ~w~(~y~%02d~w~) ~y~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~ %s ~w~/ Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~ - ~y~%d~w~ vs ~g~%d~r~",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo, naranja,verde);
		new Float:ratio;
		if(Muertes[i] == 0) ratio = Kills[i];
		else ratio = float(Kills[i])/float(Muertes[i]);
		format(str,300,"%s ~w~/ Kills: ~b~~h~~h~~h~%d~w~ ~w~/ Muertes: ~b~~h~~h~~h~%d~w~ / Ratio: ~b~~h~~h~~h~%0.2f~w~ ~w~/ Rank: ~b~~h~~h~~h~%0.3f~w~",str,Kills[i],Muertes[i],ratio,Puntaje_ranked[i]);
	}else if(Equipo[i] == EQUIPO_DERBY) format(str,300,"~w~(MODO ~y~DERBY~w~) / Mapa: ~b~~h~~h~~h~Surtidor de waska~w~ / Jugadores: ~b~~h~~h~~h~%d", dcontador);
	else format(str,300,"~w~(MODO ~y~CW~w~) / ~y~%s  ~w~(~y~%02d~w~) ~y~%d ~w~vs ~g~%d ~w~(~g~%02d~w~) ~g~ %s ~w~/ Tipo: ~b~~h~~h~~h~%d~w~x~b~~h~~h~~h~%02d~w~ - ~y~%d~w~ vs ~g~%d~w~ / Mapa: ~b~~h~~h~~h~%s~w~",Nombre_equipo[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Equipo_puntaje[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],Ronda_maxima,Puntaje_maximo, naranja,verde,Nombre_mapa(Mapa_servidor));
}else{
    if(Equipo[i] != EQUIPO_DERBY) format(str,300,"~w~(MODO ~g~TG~w~) / Mapa: ~b~~h~~h~~h~%s~w~ / Ip: ~y~85.190.153.224:25600", Nombre_mapa(Mapa_servidor));
	else format(str,300,"~w~(MODO ~y~DERBY~w~) / Mapa: ~b~~h~~h~~h~Surtidor de waska~w~ / Jugadores: ~b~~h~~h~~h~%d", dcontador);
}
TextDrawSetString(Textdraw1[i],str);
}
// Mapa: ~b~~h~~h~~h~%s Nombre_mapa(Mapa_servidor)
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == CAMBIAR_MAPA)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: Mapa_servidor = 0;
				case 1: Mapa_servidor = 1;
				case 2: Mapa_servidor = 2;
				case 3: Mapa_servidor = 3;
				case 4: Mapa_servidor = 4;
                case 5: Mapa_servidor = 5;
                case 6: Mapa_servidor = 6;
    			case 7: Mapa_servidor = 7;
            }
			if(Mapa_servidor == 4){
				SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}ha cambiado el mapa a {007C0E}%s {FFFFFF}(mapeado por {B8B8B8}[WTx]Scorz{FFFFFF})",nombre(playerid),Nombre_mapa(Mapa_servidor));
			}else{
				SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha cambiado el mapa a {007C0E}%s",nombre(playerid),Nombre_mapa(Mapa_servidor));
			}
			ForPlayers(i){
				if(Equipo[i] == EQUIPO_NARANJA || Equipo[i] == EQUIPO_VERDE){
					SpawnPlayer(i);
					SetPlayerHealth(i,100);
				}else if(Equipo[i] == EQUIPO_SPEC){
					if(EstaEnX1[i] > 0) SendClientMessage(i, COLOR_WHITE,"{B8B8B8}Cuando termines el duelo se te respawneará en el mapa que elegió el admin.");
					else{
						SpawnPlayer(i);
						SetPlayerHealth(i,100);
					}
				}else SendClientMessage(i, COLOR_WHITE,"{B8B8B8}Cuando termines el derby se te respawneará en el mapa que elegió el admin.");
			}
			UpdateScoreBar();
        }else{
	}
return 1;
}
    if(dialogid == TOP)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                	//if(Connects > 0) OrdenarGLOBAL2();
					SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}El top global no actualiza al momento.");
					new strprincipal2[2500];
					format(strprincipal2, sizeof(strprincipal2), "{7C7C7C}p.\t{7C7C7C}Nick\t{7C7C7C}Puntaje\n{7C7C7C}1.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%.3f p\n{7C7C7C}2.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%.3f p\n{7C7C7C}3.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%.3f p\n{7C7C7C}4.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%.3f p\n{7C7C7C}5.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%.3f p",
					Nick_top[0], Score_top[0], Nick_top[1], Score_top[1], Nick_top[2], Score_top[2], Nick_top[3], Score_top[3], Nick_top[4], Score_top[4]);
					ShowPlayerDialog(playerid, RANKEDSG, DIALOG_STYLE_TABLIST_HEADERS, "{F69521}Ranked general:", strprincipal2 , "Ok", "");
                }
                case 1:
                {
                	Ordenar();
               		new strprincipal[1500], posicion = 1; //string[128];
					ForPlayers(i){
						if(IsPlayerConnected(i)){ format(strprincipal, sizeof(strprincipal), "%s{7C7C7C}%d.{FFFFFF}> {B8B8B8}%s {F69521}%.3f p\n", strprincipal, posicion, nombre(idelegido[i]), rankp[i]);}
							posicion++;
					}
					ShowPlayerDialog(playerid, RANKEDSC, DIALOG_STYLE_LIST, "{F69521}Ranked conectados:", strprincipal, "Ok", "");
    			}
    			case 2:
    			{
    				Ordenar_c(0);
					new str[2500];
					format(str, sizeof(str), "{7C7C7C}p.\t{7C7C7C}Clan\t{7C7C7C}Kills\n{7C7C7C}1.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}2.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}3.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}4.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d",
					Clanes[Clan_id[0][0]], Clan_kills[Clan_id[0][0]], Clanes[Clan_id[0][1]], Clan_kills[Clan_id[0][1]], Clanes[Clan_id[0][2]], Clan_kills[Clan_id[0][2]], Clanes[Clan_id[0][3]], Clan_kills[Clan_id[0][3]]);
					ShowPlayerDialog(playerid, CLAN_TOP_KILLS, DIALOG_STYLE_TABLIST_HEADERS, "{F69521}Top clan kills:", str , "Ok", "");
    			}
    	 	}
           	 	
     	}else{

 }
return 1;
}
    if(dialogid == LISTA_CLANES)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
    				new str[700];
					Clan_ratio[0] = float(Clan_kills[0])/float(Clan_muertes[0]);
					format(str, sizeof(str), "{FFFFFF}Nombre: {F69521}%s\n{FFFFFF}Creación: {F69521}%d\n{FFFFFF}Dueño: {F69521}%s\n\n{FFFFFF}Kills: {F69521}%d\n{FFFFFF}Muertes: {F69521}%d\n{FFFFFF}Ratio: {F69521}%.3f\n\n{FFFFFF}CW's ganadas: {FFFFFF}%d\n{FFFFFF}CW's perdidas: {F69521}%d",
					Clanes_descripcion[0][Nombre_clan], Clanes_descripcion[0][Creacion_clan], Clanes_descripcion[0][Dueno_clan], Clan_kills[0], Clan_muertes[0], Clan_ratio[0], Clan_Cganadas[0], Clan_Cperdidas[0]);
					ShowPlayerDialog(playerid, STAT_CLAN, 0, "Estadística:", str , "Ok", "");
                }
                case 1:
                {
                	new str[700];
                	Clan_ratio[1] = float(Clan_kills[1])/float(Clan_muertes[1]);
					format(str, sizeof(str), "{FFFFFF}Nombre: {F69521}%s\n{FFFFFF}Creación: {F69521}%d\n{FFFFFF}Dueño: {F69521}%s\n\n{FFFFFF}Kills: {F69521}%d\n{FFFFFF}Muertes: {F69521}%d\n{FFFFFF}Ratio: {F69521}%.3f\n\n{FFFFFF}CW's ganadas: {FFFFFF}%d\n{FFFFFF}CW's perdidas: {F69521}%d",
					Clanes_descripcion[1][Nombre_clan], Clanes_descripcion[1][Creacion_clan], Clanes_descripcion[1][Dueno_clan], Clan_kills[1], Clan_muertes[1], Clan_ratio[1], Clan_Cganadas[1], Clan_Cperdidas[1]);
					ShowPlayerDialog(playerid, STAT_CLAN, 0, "Estadística:", str , "Ok", "");
    			}
    			case 2:
    			{
    				new str[700];
    				Clan_ratio[2] = float(Clan_kills[2])/float(Clan_muertes[2]);
					format(str, sizeof(str), "{FFFFFF}Nombre: {F69521}%s\n{FFFFFF}Creación: {F69521}%d\n{FFFFFF}Dueño: {F69521}%s\n\n{FFFFFF}Kills: {F69521}%d\n{FFFFFF}Muertes: {F69521}%d\n{FFFFFF}Ratio: {F69521}%.3f\n\n{FFFFFF}CW's ganadas: {FFFFFF}%d\n{FFFFFF}CW's perdidas: {F69521}%d",
					Clanes_descripcion[2][Nombre_clan], Clanes_descripcion[2][Creacion_clan], Clanes_descripcion[2][Dueno_clan], Clan_kills[2], Clan_muertes[2], Clan_ratio[2], Clan_Cganadas[2], Clan_Cperdidas[2]);
					ShowPlayerDialog(playerid, STAT_CLAN, 0, "Estadística:", str , "Ok", "");
    			}
    			case 3:
    			{
    				new str[700];
    				Clan_ratio[3] = float(Clan_kills[3])/float(Clan_muertes[3]);
					format(str, sizeof(str), "{FFFFFF}Nombre: {F69521}%s\n{FFFFFF}Creación: {F69521}%d\n{FFFFFF}Dueño: {F69521}%s\n\n{FFFFFF}Kills: {F69521}%d\n{FFFFFF}Muertes: {F69521}%d\n{FFFFFF}Ratio: {F69521}%.3f\n\n{FFFFFF}CW's ganadas: {FFFFFF}%d\n{FFFFFF}CW's perdidas: {F69521}%d",
					Clanes_descripcion[3][Nombre_clan], Clanes_descripcion[3][Creacion_clan], Clanes_descripcion[3][Dueno_clan], Clan_kills[3], Clan_muertes[3], Clan_ratio[3], Clan_Cganadas[3], Clan_Cperdidas[3]);
					ShowPlayerDialog(playerid, STAT_CLAN, 0, "Estadística:", str , "Ok", "");
    			}
    	 	}

     	}else{

 }
return 1;
}

    if(dialogid == CUENTA_CAMBIAR_NICK)
    {
        if(response)
        {
        	new ruta[128],ruta2[128], nuevonick[24], viejonick[24], pass[128];
        	strcat(viejonick, nombre(playerid));
			format(ruta,128,"%s.txt",nombre(playerid));
			GetPVarString(playerid,"Pass",pass,128);
			if(fexist(ruta)){
            	fremove(ruta);
			}
        	//if(strcmp(nombre(playerid),inputtext)) return ShowPlayerDialog(playerid, CUENTA_CAMBIAR_NICK, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}El {FF7B00}nick {FFFFFF}que ingresaste es {FF0000}igual{FFFFFF}al que tienes ahora, intentalo devuelta.", "Ok", "");
        	if(isnull(inputtext) || !strcmp(inputtext, "0")) return ShowPlayerDialog(playerid, CUENTA_CAMBIAR_NICK, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}El {FF7B00}nick {FFFFFF}que ingresaste es {FF0000}érroneo{FFFFFF}, intentalo devuelta.", "Ok", "");
        	if(strlen(inputtext) < 4) return ShowPlayerDialog(playerid, CUENTA_CAMBIAR_NICK, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}El {FF7B00}nombre {FFFFFF}que ingresaste es {FF0000}corto{FFFFFF} (como tu pene), intentalo devuelta.", "Ok", "");
			strcat(nuevonick, inputtext);
			format(ruta2,128,"%s.txt",nuevonick);
			if(fexist(ruta2)){
			return ShowPlayerDialog(playerid, CUENTA_CAMBIAR_NICK, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}El {FF7B00}nombre {FFFFFF}que ingresaste ya {FF0000}existe{FFFFFF}, intentalo devuelta.", "Ok", "");
			}else{
				SetPlayerName(playerid, nuevonick);
				new File:f = fopen(ruta2,io_write);
				format(ruta2,128,"%s\r\n%d\r\n%d\r\n%d\r\n%.3f",pass,Admin[playerid],X1_Ganados[playerid],X1_Perdidos[playerid],Puntaje_ranked[playerid]);
				fwrite(f,ruta2);
				fclose(f);
				SCMTAF(BLANCO,"[INFO] - {FF7B00}%s{FFFFFF} ha cambiado su nick por {FF7B00}%s", viejonick, nuevonick);
				SCMF(playerid,COLOR_WHITE,"{B8B8B8}Has cambiado tu nick, desde ahora podrás logear con tu nuevo nick: {FF7B00}%s",nuevonick);
				Cambiar_nombre[playerid] = 1;
			}
		}else{
	}
return 1;
}
    if(dialogid == CUENTA_LOGEADA)
    {
        if(response)
        {
        new s[128],str[128];//scw[128];
		format(s,128,"%s.txt",nombre(playerid));
		new File:f = fopen(s,io_read);
		new Float:rank;
		fread(f,s);
		DelChar(s);
		if(strval(s) != num_hash(inputtext)) return ShowPlayerDialog(playerid, CUENTA_LOGEADA, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}La {FF7B00}contraseña {FFFFFF}que ingresaste es {FF0000}errónea{FFFFFF}, intentalo devuelta.", "Ok", "Salir");
        if(isnull(inputtext) || !strcmp(inputtext, "0")) return ShowPlayerDialog(playerid, CUENTA_LOGEADA, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}Por favor ingrese una {FF7B00}contraseña {FFFFFF}válida y que exista para logearte.", "Ok", "Salir");
		SetPVarString(playerid,"Pass",s);
		fread(f,s);
		Admin[playerid] = strval(s);
		fread(f,s);
		X1_Ganados[playerid] = strval(s);
		fread(f,s);
		X1_Perdidos[playerid] = strval(s);
		fread(f,s);
		rank = floatstr(s);
		fread(f,s);
		fclose(f);
		
	
		Puntaje_ranked[playerid] = rank;
		if(Puntaje_ranked[playerid] == 0.000) Puntaje_ranked[playerid] = 1.000;
		format(str,128,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
	  	ShowPlayerDialog(playerid,1,2,"{FFFFFF}Elije algún equipo:",str,"Aceptar","");
		SetPVarInt(playerid,"Logged",1);
		if(Admin[playerid] > 0) SCMF(playerid,COLOR_WHITE,"{B8B8B8}Te has logeado correctamente con nivel de administrador: {007C0E}%d",Admin[playerid]);
		else SCMF(playerid,COLOR_WHITE,"{B8B8B8}Te has logeado correctamente.",Admin[playerid]);
		SCMF(playerid,COLOR_WHITE,"{B8B8B8}- Tu puntaje ranked es: {007C0E}%.3f",Puntaje_ranked[playerid]);
        }else{
        SCMTAF(-1,"{830000}%s{B8B8B8} fue kickeado por no introducir bien la contraseña de su cuenta.", nombre(playerid));
        Kick(playerid);
	}
return 1;
}
    if(dialogid == CUENTA_REGISTRAR)
    {
        if(response)
        {
        	if(isnull(inputtext) || !strcmp(inputtext, "0")) return ShowPlayerDialog(playerid, CUENTA_REGISTRAR, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta del jugador", "{FFFFFF}Por favor ingrese una {FF0000}contraseña {FFFFFF}válida y que exista para registrarte.", "Ok", "Salir");
			new str[128],s[128], x1, x1p;
			format(s,128,"%s.txt",nombre(playerid));
			x1 = X1_Ganados[playerid];
			x1p = X1_Perdidos[playerid];
			new File:f = fopen(s,io_write);
			format(s,128,"%s\r\n0\r\n%d\r\n%d\r\n%.3f",qhash(inputtext),x1,x1p,Puntaje_ranked[playerid]);
			SetPVarString(playerid,"Pass",qhash(inputtext));
			fwrite(f,s);
			fclose(f);
			SetPVarInt(playerid,"Logged",1);
 			format(str,128,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
	  		ShowPlayerDialog(playerid,1,2,"{FFFFFF}Elije algún equipo:",str,"Aceptar","");
			SCMF(playerid,COLOR_WHITE,"{B8B8B8}Te has registrado correctamente con la contraseña: {007C0E}%s",inputtext);
        }else{
        	new str[128];
 			format(str,128,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
	  		ShowPlayerDialog(playerid,1,2,"{FFFFFF}Elije algún equipo:",str,"Aceptar","");
	  		Puntaje_ranked[playerid] = 0.100;
			SCM(playerid,COLOR_WHITE,"{B8B8B8}Esta cuenta no se ha registrado, puedes jugar libremente pero no se te guardaran los stats.");
	}
return 1;
}
    if(dialogid == LECHERO)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                if(lecheroaccion == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se está pajeando.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se está pajeando!");
				ApplyActorAnimation(lecherobot, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 1, 0);
				lecheroaccion = 1;
                }
                case 1:
                {
                if(lecheroaccion == 2) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se está arrestado.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se hace el arrestado pelotudo!");
                ApplyActorAnimation(lecherobot, "POLICE", "crm_drgbst_01", 4.0, 1, 0, 0, 1, 0);
				lecheroaccion = 2;
                }
                case 2:
                {
                if(lecheroaccion == 3) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se está drogando.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}empieza a fumar.. ");
				ApplyActorAnimation(lecherobot, "SMOKING", "M_smk_drag", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 3;
                }
                case 3:
                {
                if(lecheroaccion == 4) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya está dando polvito.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}se puso a traficar merca (/comprarmerca)");
				ApplyActorAnimation(lecherobot, "DEALER", "DEALER_DEAL", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 4;
                }
                case 4:
                {
                if(lecheroaccion == 5) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se está meando.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se puso a mear{B8B8B8}!");
				ApplyActorAnimation(lecherobot, "PAULNMAC", "Piss_in", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 5;
                }
                case 5:
                {
                if(lecheroaccion == 6) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se puso agresivo.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se puso agresivo{B8B8B8}!");
				ApplyActorAnimation(lecherobot, "ped", "fucku", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 6;
                }
                case 6:
                {
                if(lecheroaccion == 7) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se puso puta.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se puso en modo prostituta{B8B8B8}!");
				ApplyActorAnimation(lecherobot, "STRIP","strip_B", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 7;
                }
                case 7:
                {
                if(lecheroaccion == 8) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya se puse sexy.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}se puso sexy para todos{B8B8B8}!");
				ApplyActorAnimation(lecherobot, "SUNBATHE","ParkSit_W_idleA", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 8;
                }
                case 8:
                {
                if(lecheroaccion == 9) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Lechero ya esta bailando.");
                ClearActorAnimations(lecherobot);
                SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}empezó a bailar{B8B8B8}!");
				ApplyActorAnimation(lecherobot, "DANCING","DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
				lecheroaccion = 9;
                }
                case 9:
                {
                if(lecheroaccion == 1) SCMTA(COLOR_WHITE,"{FFFFFF}- {B8B8B8}¡{70FBFF}Lechero {B8B8B8}dejó de pajearse!");
				else if(lecheroaccion == 2) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}dejó de autoarrestarse como pelotudo.");
                else if(lecheroaccion == 3) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}paró de fumar.. ");
                else if(lecheroaccion == 4) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}paró de traficar merca.");
                else if(lecheroaccion == 5) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}dejó de mear..");
                else if(lecheroaccion == 6) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}ya se puso tranquilo..");
                else if(lecheroaccion == 7) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}se hizo hombre devuelta!");
                else if(lecheroaccion == 8) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}dejó de estar sexy..");
                else if(lecheroaccion == 9) SCMTA(COLOR_WHITE,"{FFFFFF}- {70FBFF}Lechero {B8B8B8}paró de bailar.");
                ClearActorAnimations(lecherobot);
				lecheroaccion = 0;
                }
            }
        }else{

	}
return 1;
}
    if(dialogid == 7)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Infernus = CreateVehicle(411, x, y, z, az, -1, -1, 180);
                Vehiculos_derby[Cont_derby] = Infernus;
				Cont_derby++;
                LinkVehicleToInterior(Infernus,1);
                SetVehicleVirtualWorld(Infernus,3);
                PutPlayerInVehicle(playerid, Infernus, 0);
				UpdateScoreBar();
                }
                case 1:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Cheetah = CreateVehicle(415, x, y, z, az, -1, -1, 180);
                Vehiculos_derby[Cont_derby] = Cheetah;
				Cont_derby++;
                LinkVehicleToInterior(Cheetah,1);
                SetVehicleVirtualWorld(Cheetah,3);
                PutPlayerInVehicle(playerid, Cheetah, 0);
                UpdateScoreBar();
                }
                case 2:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Buffalo = CreateVehicle(402, x, y, z, az, -1, -1, 180);
                Vehiculos_derby[Cont_derby] = Buffalo;
				Cont_derby++;
                LinkVehicleToInterior(Buffalo,1);
                SetVehicleVirtualWorld(Buffalo,3);
                PutPlayerInVehicle(playerid, Buffalo, 0);
                UpdateScoreBar();
                }
                case 3:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Ambu = CreateVehicle(416, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Ambu;
				Cont_derby++;
                LinkVehicleToInterior(Ambu,1);
                SetVehicleVirtualWorld(Ambu,3);
                PutPlayerInVehicle(playerid, Ambu, 0);
                UpdateScoreBar();
                }
                case 4:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Injection = CreateVehicle(424, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Injection;
				Cont_derby++;
                LinkVehicleToInterior(Injection,1);
                SetVehicleVirtualWorld(Injection,3);
                PutPlayerInVehicle(playerid, Injection, 0);
                UpdateScoreBar();
                }
                case 5:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Turismo = CreateVehicle(451, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Turismo;
				Cont_derby++;
                LinkVehicleToInterior(Turismo,1);
                SetVehicleVirtualWorld(Turismo,3);
                PutPlayerInVehicle(playerid, Turismo, 0);
                UpdateScoreBar();
                }
                case 6:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Faggio = CreateVehicle(462, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Faggio;
				Cont_derby++;
                LinkVehicleToInterior(Faggio,1);
                SetVehicleVirtualWorld(Faggio,3);
                PutPlayerInVehicle(playerid, Faggio, 0);
                UpdateScoreBar();
                }
                case 7:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Comet = CreateVehicle(480, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Comet;
				Cont_derby++;
                LinkVehicleToInterior(Comet,1);
                SetVehicleVirtualWorld(Comet,3);
                PutPlayerInVehicle(playerid, Comet, 0);
                UpdateScoreBar();
                }
                case 8:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Hotring = CreateVehicle(502, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Hotring;
				Cont_derby++;
                LinkVehicleToInterior(Hotring,1);
                SetVehicleVirtualWorld(Hotring,3);
                PutPlayerInVehicle(playerid, Hotring, 0);
                UpdateScoreBar();
                }
                case 9:
                {
                new Float:x, Float:y, Float:z, Float:az = 178.7565;
				GetPlayerPos(playerid, x, y, z);
  				GetPlayerFacingAngle(playerid, az);
                new Bandito = CreateVehicle(568, x, y, z, az, -1, -1, 180);
				Vehiculos_derby[Cont_derby] = Bandito;
				Cont_derby++;
                LinkVehicleToInterior(Bandito,1);
                SetVehicleVirtualWorld(Bandito,3);
                PutPlayerInVehicle(playerid, Bandito, 0);
                UpdateScoreBar();
                }
            }
        }else{
        SpawnPlayer(playerid);
	}
return 1;
}
    if(dialogid == 6)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(dArena1 == 1){
                   		new devolver[60];
						format(devolver, sizeof(devolver), "{FFFFFF}Ésta arena esta en progreso {F69521}(%d/%d)", dcontador, MAX_DERBY);
						SendClientMessage(playerid, BLANCO, devolver);
						return 1;
					}
					Equipo[playerid] = EQUIPO_DERBY;
                	SetPlayerColor(playerid,COLOR_DERBY);
                    SetPlayerVirtualWorld(playerid,3);
                    SetPlayerInterior(playerid,1);
                    EstaEnDerby[playerid] = 1;
                    TogglePlayerControllable(playerid,0);
                    dcontador++;
					new jugadores = dcontador;
					switch(jugadores){
						case 1:
					    SetPlayerPos(playerid, Derby_spawns[1][0], Derby_spawns[1][1], Derby_spawns[1][2]);
					    case 2:
					    SetPlayerPos(playerid, Derby_spawns[2][0], Derby_spawns[2][1], Derby_spawns[2][2]);
					    case 3:
					    SetPlayerPos(playerid, Derby_spawns[3][0], Derby_spawns[3][1], Derby_spawns[3][2]);
					    case 4:
					    SetPlayerPos(playerid, Derby_spawns[4][0], Derby_spawns[4][1], Derby_spawns[4][2]);
					    case 5:
					    SetPlayerPos(playerid, Derby_spawns[5][0], Derby_spawns[5][1], Derby_spawns[5][2]);
	    				case 6:
					    SetPlayerPos(playerid, Derby_spawns[6][0], Derby_spawns[6][1], Derby_spawns[6][2]);
	    				case 7:
					    SetPlayerPos(playerid, Derby_spawns[7][0], Derby_spawns[7][1], Derby_spawns[7][2]);
	    				case 8:
					    SetPlayerPos(playerid, Derby_spawns[8][0], Derby_spawns[8][1], Derby_spawns[8][2]);
					}
                    ResetPlayerWeapons(playerid);
                    SCMTAF(BLANCO,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{F69521}Surtidor de waska{B8B8B8}> {FFFFFF}: {F69521}( > /derby < )", nombre(playerid));
                  	ForPlayers(i){
			  			if(EstaEnDerby[i] == 1){
							SCMF(i,COLOR_WHITE,"{B8B8B8}Jugadores actuales: {70FBFF}%d/{F69521}%d",jugadores,MAX_DERBY);
						}
					}
					if(dcontador == MAX_DERBY){
						dArena1 = 1;
						CountDownDerby(5);
					}
                    ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "{F69521}Elija un auto:", "{B8B8B8}Infernus\n{B8B8B8}Cheetah\n{B8B8B8}Buffalo\n{B8B8B8}Ambulancia\n{B8B8B8}BF Injection\n{B8B8B8}Turismo\n{B8B8B8}Lamborghini Reventon\n{B8B8B8}Comet\n{B8B8B8}Hotring", "Selec.", "Salir");
			    return 1;
                }
            }
        }
return 1;
}
    if(dialogid == 4)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(X1_Arena1 > 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}En esta arena ya hay un duelo en progreso, intentelo más tarde.");
                    SetPlayerVirtualWorld(playerid,3);
                    SetPlayerInterior(playerid,1);
                    EstaEnX1[playerid] = 1;
                    X1_Arena1 = X1_Arena1+1;
                    new Random = random(sizeof(x1spawns)); {
                    SetPlayerPos(playerid, x1spawns[Random][0], x1spawns[Random][1], x1spawns[Random][2]);}
                      ResetPlayerWeapons(playerid);
                      GivePlayerWeapon(playerid, 22, 9999);
                      GivePlayerWeapon(playerid, 28, 9999);
                      GivePlayerWeapon(playerid, 26, 9999);
                      SetPlayerHealth(playerid, 100);
                      SetPlayerArmour(playerid, 100);
                    SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{007C0E}Warehouse{B8B8B8}> {FFFFFF}: {007C0E}( > /x1 < )", nombre(playerid));
			    return 1;
                }
                case 1:
                {
                 if(X1_Arena2 > 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}En esta arena ya hay un duelo en progreso, intentelo más tarde.");
                    SetPlayerVirtualWorld(playerid,3);
                    SetPlayerInterior(playerid,16);
                    EstaEnX1[playerid] = 2;
                    X1_Arena2 = X1_Arena2+1;
                    new Random = random(sizeof(x1a2spawns)); {
                    SetPlayerPos(playerid, x1a2spawns[Random][0], x1a2spawns[Random][1], x1a2spawns[Random][2]);}
                      ResetPlayerWeapons(playerid);
                      GivePlayerWeapon(playerid, 22, 9999);
                      GivePlayerWeapon(playerid, 28, 9999);
                      GivePlayerWeapon(playerid, 26, 9999);
                      SetPlayerHealth(playerid, 100);
                      SetPlayerArmour(playerid, 100);
                    SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{007C0E}Kursk{B8B8B8}> {FFFFFF}: {007C0E}( > /x1 < )", nombre(playerid));
			    return 1;
                }
                case 2:
                {
                 if(X1_Arena3 > 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}En esta arena ya hay un duelo en progreso, intentelo más tarde.");
                    SetPlayerVirtualWorld(playerid,3);
                    SetPlayerInterior(playerid,1);
                    EstaEnX1[playerid] = 3;
                    X1_Arena3 = X1_Arena3+1;
                    new Random = random(sizeof(x1a3spawns)); {
                    SetPlayerPos(playerid, x1a3spawns[Random][0], x1a3spawns[Random][1], x1a3spawns[Random][2]);}
                      ResetPlayerWeapons(playerid);
                      GivePlayerWeapon(playerid, 22, 9999);
                      GivePlayerWeapon(playerid, 28, 9999);
                      GivePlayerWeapon(playerid, 26, 9999);
                      SetPlayerHealth(playerid, 100);
                      SetPlayerArmour(playerid, 100);
                    SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{007C0E}Estadio{B8B8B8}> {FFFFFF}: {007C0E}( > /x1 < )", nombre(playerid));

			    return 1;
                }
            }
        }
return 1;
}
    if(dialogid == 5)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                 if(X1W_Arena1 > 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}En esta arena ya hay un duelo en progreso, intentelo más tarde.");
                    SetPlayerVirtualWorld(playerid,4);
                    SetPlayerInterior(playerid,1);
                    EstaEnX1[playerid] = 4;
                    X1W_Arena1 = X1W_Arena1+1;
                    new Random = random(sizeof(x1spawns)); {
                    SetPlayerPos(playerid, x1spawns[Random][0], x1spawns[Random][1], x1spawns[Random][2]);}
                      ResetPlayerWeapons(playerid);
                      GivePlayerWeapon(playerid, 24, 9999);
                      GivePlayerWeapon(playerid, 25, 9999);
                      GivePlayerWeapon(playerid, 34, 9999);
                      SetPlayerHealth(playerid, 100);
                      SetPlayerArmour(playerid, 100);
                    SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{007C0E}Warehouse{B8B8B8}> {FFFFFF}: {007C0E}( > /x1w < )", nombre(playerid));
			    return 1;
                }
                case 1:
                {
                 if(X1W_Arena2 > 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}En esta arena ya hay un duelo en progreso, intentelo más tarde.");
                    SetPlayerVirtualWorld(playerid,4);
                    SetPlayerInterior(playerid,16);
                    EstaEnX1[playerid] = 5;
                    X1W_Arena2 = X1W_Arena2+1;
                    new Random = random(sizeof(x1a2spawns)); {
                    SetPlayerPos(playerid, x1a2spawns[Random][0], x1a2spawns[Random][1], x1a2spawns[Random][2]);}
                      ResetPlayerWeapons(playerid);
                      GivePlayerWeapon(playerid, 24, 9999);
                      GivePlayerWeapon(playerid, 25, 9999);
                      GivePlayerWeapon(playerid, 34, 9999);
                      SetPlayerHealth(playerid, 100);
                      SetPlayerArmour(playerid, 100);
                    SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}fue a la arena {B8B8B8}<{007C0E}Kursk{B8B8B8}> {FFFFFF}: {007C0E}( > /x1w < )", nombre(playerid));
			    return 1;
                }
            }
        }
return 1;
}
	if(dialogid == MUSICAC)
    {
    	if(response)
        {
            new String[120],Nombre[60];
            GetPlayerName(playerid,Nombre,sizeof(Nombre));
            format(String,sizeof(String),"{B8B8B8}%s {FFFFFF} ha puesto una canción para todos los usuarios.",Nombre);
            SendClientMessageToAll(0x7B7D81FF,String);
            for(new i = 0; i < MAX_PLAYERS; i++)PlayAudioStreamForPlayer(i,inputtext);
            }
            else
				{
		}
	}
    if(dialogid == 1)
    {
        if(response) {
                switch(listitem){
                case 0:{
                if(Equipos_bloq == 1){
                new str[100];
                format(str,100,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
                return ShowPlayerDialog(playerid,1,2,"{E60026}Los equipos están bloqueados.",str,"Aceptar","");
                }
                SCMTAF(COLOR_NARANJA,"{B8B8B8}%s {FFFFFF}se integró al equipo {F69521}%s",nombre(playerid),Nombre_equipo[0]);
                Equipo[playerid] = EQUIPO_NARANJA;
                SetPlayerColor(playerid,COLOR_NARANJA);
                }
                case 3:{
                if(Equipos_bloq == 1){
                new str[100];
                format(str,100,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
                return ShowPlayerDialog(playerid,1,2,"{E60026}Los equipos están bloqueados.",str,"Aceptar","");
                }
                SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}se integró al equipo {70FBFF}Espectador",nombre(playerid));
                Equipo[playerid] = EQUIPO_SPEC;
                SetPlayerColor(playerid,COLOR_WHITE);
                }
                case 1:{
                if(Equipos_bloq == 1){
                new str[100];
                format(str,100,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
                return ShowPlayerDialog(playerid,1,2,"{E60026}Los equipos están bloqueados.",str,"Aceptar","");
                }
                SCMTAF(COLOR_GREEN,"{B8B8B8}%s {FFFFFF}se integró al equipo {007C0E}%s",nombre(playerid),Nombre_equipo[1]);
                Equipo[playerid] = EQUIPO_VERDE;
                SetPlayerColor(playerid,COLOR_GREEN);
                }
                case 2:{
                SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}se integró al equipo {70FBFF}Espectador",nombre(playerid));
                Equipo[playerid] = EQUIPO_SPEC;
                SetPlayerColor(playerid,COLOR_WHITE);
                }}
        		naranja = 0;
                verde = 0;
				ForPlayers(i){
					if(Equipo[i] == EQUIPO_NARANJA) naranja++;
                	else if(Equipo[i] == EQUIPO_VERDE) verde++;
                }
   			  	TextDrawHideForPlayer(playerid, FONDOENTRADA1);
				TextDrawHideForPlayer(playerid, FONDOENTRADA2);
				TextDrawHideForPlayer(playerid, LATERAL1);
				TextDrawHideForPlayer(playerid, LATERAL2);
				TextDrawHideForPlayer(playerid, TOXICWARRIORS);
				TextDrawHideForPlayer(playerid, SERVERCWTG);
				if(Elegir_Personaje[playerid] == 0){
                if(TDraws[playerid] == 0 || TDraws[playerid] == -1){
                	TextDrawShowForPlayer(playerid, Frames[playerid]);
   	 				TextDrawShowForPlayer(playerid, TextdrawWTx);
                	TextDrawShowForPlayer(playerid, TextdrawD3x);
                	TextDrawShowForPlayer(playerid, Textdraw15);
     				TextDrawShowForPlayer(playerid,Textdraw0);
   					TextDrawShowForPlayer(playerid,Textdraw1[playerid]);
                }
                }else{
        			new string[2000];
   					strcat(string,"\n");
					strcat(string,"{B8B8B8}Información del jugador: {007C0E}/{F69521}stats {B8B8B8}[id].\n");
					strcat(string,"{B8B8B8}Oculta los textos con: {007C0E}/{F69521}texts{B8B8B8}.\n");
					strcat(string,"{B8B8B8}Información del servidor: {007C0E}/{F69521}info{B8B8B8}.\n");
					strcat(string,"{B8B8B8}Comandos delservidor: {007C0E}/{F69521}cmds {B8B8B8}, {007C0E}/{F69521}acmds{B8B8B8} y {007C0E}/{F69521}acmds2{B8B8B8}.\n");
					strcat(string,"\n");
					strcat(string,"{F69521}SISTEMA DE CLANES EN BETA\n");
					strcat(string,"\n");
					ShowPlayerDialog(playerid,1003,0,"{B8B8B8}Servidor {F69521}CW{B8B8B8}/{007C0E}TG {B8B8B8}de [WTx]",string,"Ok","");
                }
 				UpdatePlayerScoreBar(playerid);
                if(GetPVarInt(playerid,"ClassSelected") == 1) SpawnPlayer(playerid);
        }else{
                new str[100];
                format(str,100,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
                ShowPlayerDialog(playerid,1,2,"{FFFFFF}Elije algún equipo:",str,"Aceptar","");
                }
                return 1;
    }
if(dialogid == 2){
if(response){
if(strcmp(Contra_servidor,inputtext,false)){
return ShowPlayerDialog(playerid,2,1,"Servidor bloqueado","{830000}Contraseña errónea:\n{B8B8B8}Por favor ingrese bien la contraseña, en caso de que no lo sepas has clic en '{007C0E}salir{B8B8B8}'.","Aceptar","Salir"); // este sistema se descarta.
}if(isnull(inputtext) || !strcmp(inputtext, "0")){
return ShowPlayerDialog(playerid,2,1,"Servidor bloqueado","{830000}Contraseña errónea:\n{B8B8B8}Por favor ingrese bien la contraseña, en caso de que no lo sepas has clic en '{007C0E}salir{B8B8B8}'.","Aceptar","Salir"); // este sistema se descarta.
}else{
new s[128];
format(s,128,"%s.txt",nombre(playerid));
if(fexist(s)){
ShowPlayerDialog(playerid, CUENTA_LOGEADA, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta registrada", "{FFFFFF}Este nick está {FF7B00}registrado{FFFFFF}, ingresa la contraseña.", "Log.", "Salir");
}else{
ShowPlayerDialog(playerid, CUENTA_REGISTRAR, DIALOG_STYLE_INPUT, "{B8B8B8}Cuenta no registrado", "{FFFFFF}Este nick no está registrado, ingresa una {FF7B00}contraseña {FFFFFF}si quieres registrarte con esta cuenta.\nSí esta cuenta será temporal, {F60000}no te registres{FFFFFF}!", "Regis.", "No");
}
}
}else{
SCMTAF(-1,"{830000}%s{B8B8B8} fue kickeado por no introducir bien la contraseña.", nombre(playerid));
 Kick(playerid);
}
}
    return 0;
}
public LockedServerKick(playerid){
if(!IsPlayerConnected(playerid)) return 0;
if(Equipo[playerid] == -1){
SCMTAF(COLOR_WHITE,"{830000}%s{B8B8B8} fue kickeado por no introducir bien la contraseña.",nombre(playerid));
Kick(playerid);

}
return true;
}

QCMD:musica(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes acceso a este comando.");
ShowPlayerDialog(playerid, MUSICAC, DIALOG_STYLE_INPUT, "{FF7B00}Reproductor de Música:","{B8B8B8}Pega aquí la {20FCE2}URL{B8B8B8} de la canción que quieras poner.\nTiene que ser un {20FCE2}MP3{B8B8B8}, usa la página {20FCE2}onlinevideoconverter.com{B8B8B8}.","Reproducir","Salir");
return 1;
}

QCMD:nomusica(){
StopAudioStreamForPlayer(playerid);
SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Has parado la música.");
return 1;
}

QCMD:lecherocmds(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
new string[1500];
strcat(string,"{B8B8B8}Comandos para el bot {70FBFF}Lechero{B8B8B8}:\n");
strcat(string,"\n");
strcat(string,"{70FBFF}/{FFFFFF}lecherobot {70FBFF}- {C3C3C3}activas o desactivar a lechero.\n");
strcat(string,"{70FBFF}/{FFFFFF}lecherosay {B8B8B8}[texto] {70FBFF}- {C3C3C3}haces hablar a lechero.\n");
strcat(string,"{70FBFF}/{FFFFFF}traerlechero {70FBFF}- {C3C3C3}traes a lechero a tu posición.\n");
strcat(string,"{70FBFF}/{FFFFFF}lecheroacc {70FBFF}- {C3C3C3}lista de animaciones de lechero.\n");
strcat(string,"{70FBFF}/{FFFFFF}lecheroskin {B8B8B8}[id] {70FBFF}- {C3C3C3}cambias el skin de lechero.\n");
strcat(string,"{70FBFF}/{FFFFFF}comprarmerca {70FBFF}- {C3C3C3}le compras merca a lechero.\n");
ShowPlayerDialog(playerid,3,0,"{FFFFFF}Comandos de Lechero:",string,"Salir","");
return true;
}

QCMD:lecheroskin(){
new skinid;
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden manipular a lechero.");
if(lecheroact < 1) return SCM(playerid,BLANCO,"{FFFFFF}No puedes cambiarle el skin a lechero si {70FBFF}Lechero {FFFFFF}no está activado.");
if(sscanf(params, "d", skinid)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/lecheroskin [1:311]");
else if(skinid < 0 || skinid > 311) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Por favor: {007C0E}/lecheroskin [1:311]");
else{
new Float:x, Float:y, Float:z, Float:ang;
GetActorPos(lecherobot, x, y, z);
GetActorFacingAngle(lecherobot,ang);
DestroyActor(lecherobot);
lecherobot = CreateActor(skinid,x, y, z, ang);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}le ha cambiado el skin a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0", nombre(playerid));
}
return 1;
}
QCMD:traerlechero(){
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden manipular a lechero.");
if(lecheroact < 1) return SCM(playerid,BLANCO,"{FFFFFF}No puedes traer a {70FBFF}Lechero {FFFFFF}si no está activado.");
new Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
SetActorPos(lecherobot,x+1,y,z);
Delete3DTextLabel(lecherotext);
lecherotext = Create3DTextLabel("{70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {70FBFF}(-1)",COLOR_WHITE, x+1, y, z+1.3000, 27.0, 0, 1);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha traido a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {FFFFFF}a su posición.", nombre(playerid));
return 1;
}

QCMD:lecherosay(){
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo lechero puede manipular a lechero (xD).");
if(lecheroact < 1) return SCM(playerid,BLANCO,"{FFFFFF}No puedes usar este comando si {70FBFF}Lechero {FFFFFF} no está activado.");
if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "{FFFFFF}Uso correcto del comando: {007C0E}/lecherodice [mensaje]");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/lecherodice [mensaje]");
ClearActorAnimations(lecherobot);
lecheroaccion = 0;
SCMTAF(COLOR_WHITE,"{70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {C3C3C3}[-1]{FFFFFF}: %s", params);
ApplyActorAnimation(lecherobot,"PED","IDLE_chat",4.1, 0, 0, 0, 0, 2000);
if(strfind(params, ":,v", true) != -1 ||	strfind(params, ";V  ", true) != -1 ||	strfind(params, ";v ", true) != -1 ||	strfind(params, ";V", true) != -1 || strfind(params, ";v", true) != -1 || strfind(params, "V: ", true) != -1 || strfind(params, "V:", true) != -1 || strfind(params, "v:", true) != -1 || strfind(params, ": v", true) != -1 || strfind(params, ":v", true) != -1 || strfind(params, ":V", true) != -1){
new Float:x, Float:y, Float:z;
GetActorPos(lecherobot,x,y,z);
CreateExplosion(x, y , z, 12 ,10.0);
ForPlayers(i){
if(IsPlayerInRangeOfPoint(i,30.0,x, y, z)) PlayerPlaySound(i, 1159, 0, 0, 0);
}
Delete3DTextLabel(lecherotext);
DestroyActor(lecherobot);
lecheroact = 0;
SCMTA(COLOR_WHITE,"{70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0{FFFFFF} se autodestruyó por escribir: {70FBFF}:v");
}
return 1;
}

QCMD:lecherogod(){
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden manipular a lechero.");
if(lecheroact < 1) return SCM(playerid,BLANCO,"{FFFFFF}No puedes darle god a {70FBFF}Lechero {FFFFFF}si no está activado.");
if(lecherogod == -1 || lecheroact == 1){
SetActorInvulnerable(lecherobot, 0);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}hizó a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {FFFFFF}vulerable.", nombre(playerid));
SetActorHealth(lecherobot,100);
lecherogod = 0;
}else if(lecherogod == 0){
SetActorInvulnerable(lecherobot, 1);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}hizó a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {FFFFFF}invulerable.", nombre(playerid));
lecherogod = 1;
}
return 1;
}

QCMD:lecherobot(){
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden manipular a lechero.");
if(lecheroact == -1 || lecheroact == 0){
lecherotext = Create3DTextLabel("{70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0 {70FBFF}(-1)",COLOR_WHITE, -1199.6335, -51.3970, 28.5000, 27.0, 0, 1);
lecherobot = CreateActor(72,-1199.6335, -51.3970, 27.3350, 138.1213);
SetActorInvulnerable(lecherobot, 1);
lecheroact = 1;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha activado a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0", nombre(playerid));
}else if(lecheroact == 1){
Delete3DTextLabel(lecherotext);
DestroyActor(lecherobot);
lecheroact = 0;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha desactivado a {70FBFF}[WTx][L]eChe[R]Oo_. {FF0000}2.0", nombre(playerid));
}
return 1;
}

QCMD:comprarmerca(){
if(lecheroact < 1) return SCM(playerid,BLANCO,"{FFFFFF}No puedes comprar merca si {70FBFF}Lechero {FFFFFF}no está activado.");
if(lecheroaccion != 4) return SCM(playerid,BLANCO,"{FFFFFF}No puedes comprar merca si {70FBFF}Lechero {FFFFFF}no está vendiendola.");
if(!IsPlayerInRangeOfPoint(playerid,2.0,-1199.6335, -51.3970, 27.3350)) return SCM(playerid,BLANCO,"{FFFFFF}Tienes que estar cerca de Lechero para comprarle la merca.");
SetPlayerArmour(playerid,80);
SetPlayerHealth(playerid,100);
X1_Ganados[playerid] = X1_Ganados[playerid]-5;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}le ha comprado merca a {70FBFF}Lechero", nombre(playerid));
SCM(playerid,BLANCO,"{FFFFFF}Se te descontó {FF0000}-5 {FFFFFF}score {F69521}x1 {FFFFFF}por comprarle esa mierda.");
return 1;
}

QCMD:lecheroacc(){
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden manipular a lechero.");
if(lecheroact < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}El lechero bot tiene que estar activado para darle animación.");
ShowPlayerDialog(playerid, LECHERO, DIALOG_STYLE_LIST, "{F69521}Elija una acción para lechero:", "{B8B8B8}Pajearse\n{B8B8B8}Auto-arrestarse\n{B8B8B8}Fumar\n{B8B8B8}Traficar\n{B8B8B8}Mear\n{B8B8B8}Agresivo\n{B8B8B8}Putear\n{B8B8B8}Ponerse sexy\n{B8B8B8}Bailar\n{F69521}Parar animación", "Selec.", "Salir");
return 1;
}

QCMD:abrirx1(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(X1_cerrado == 0) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas x1 ya están abiertas, para cerrarlas /cerrarx1");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} reabrió todas las arenas de {B8B8B8}x1",nombre(playerid));
X1_cerrado = 0;
X1_Arena1= 0;
X1_Arena2 = 0;
X1_Arena3 = 0;
X1W_Arena1 = 0;
X1W_Arena2 = 0;
return 1;
}

QCMD:cerrarx1(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(X1_cerrado == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas x1 ya están cerradas.");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} cerró todas las arenas de {B8B8B8}x1",nombre(playerid));
X1_cerrado = 1;
ForPlayers(i){
if(Equipo[i] != EQUIPO_NARANJA || Equipo[i] != EQUIPO_VERDE)
SpawnPlayer(i);
}
X1_Arena1 = 2;
X1_Arena2 = 2;
X1_Arena3 = 2;
X1W_Arena1 = 2;
X1W_Arena2 = 2;
return 1;
}

QCMD:maxderby(){
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/maxderby [2-8");
new id = strval(params);
if(id > 8 || id < 2) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/maxderby [2-8]");
MAX_DERBY = id;
if(dcontador == MAX_DERBY){
	dArena1 = 1;
	CountDownDerby(5);
}
SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} estableció como limite {F69521}%d{FFFFFF} jugadores derby.",nombre(playerid),MAX_DERBY);
return true;
}

QCMD:abrirderby(){
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(derbycerrado == 0) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas de derby ya están abiertas, para cerrarlas {007C0E}/cerrarderby");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} abrió todas las arenas de {F69521}derby",nombre(playerid));
derbycerrado = 0;
return 1;
}

QCMD:cerrarderby(){
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(derbycerrado == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas de derby ya están cerradas, para activarlas {007C0E}/abrirderby");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} cerró todas las arenas de {F69521}derby",nombre(playerid));
ForPlayers(i){
	if(EstaEnDerby[playerid] == 1){
	new id = GetPlayerVehicleID(i);
	DestroyVehicle(id);
	TogglePlayerControllable(i,1);
	EstaEnDerby[i] = 0;
	SetPlayerVirtualWorld(i,0);
	SetPlayerInterior(i,0);
	SpawnPlayer(i);
	}
}
dcontador = 0;
derbycerrado = 1;
return 1;
}

QCMD:cambiarauto(){
if(Equipo[playerid] != EQUIPO_DERBY) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este comando es solo para jugadores {F69521}Derby.");
if(dArena1 == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}No puedes cambiar de auto si el derby ya comenzo.");
new id = GetPlayerVehicleID(playerid);
DestroyVehicle(id);
ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "{F69521}Elige tu nuevo auto:", "{B8B8B8}Infernus\n{B8B8B8}Cheetah\n{B8B8B8}Buffalo\n{B8B8B8}Ambulancia\n{B8B8B8}BF Injection\n{B8B8B8}Turismo\n{B8B8B8}Lamborghini Reventon\n{B8B8B8}Comet\n{B8B8B8}Hotring" , "Selec.", "Salir");
return 1;
}

QCMD:tp(){
SetPlayerPos(playerid, 621.1508,3213.8945,77.6969);
return 1;
}

QCMD:derby(){
if(derbycerrado == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas están cerradas, espera a que un admin nivel 3 los vuelva a abrir.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Equipo[playerid] != EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este comando es solo para {70FBFF}Espectadores.");
if(EstaEnX1[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salir");
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salirderby");
new str[128];
if(dArena1 == 1){
	format(str, sizeof(str), "{B8B8B8}Surtidor de waska ({F69521}en progeso %d/%d{B8B8B8})\n{B8B8B8}Pronto..\n{B8B8B8}Pronto..", dcontador, MAX_DERBY);
}else{
	format(str, sizeof(str), "{B8B8B8}Surtidor de waska ({F69521}%d/%d{B8B8B8})\n{B8B8B8}Pronto..\n{B8B8B8}Pronto..", dcontador, MAX_DERBY);
}
ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "{F69521}Derby:", str , "Selec.", "Salir");
//else if(dArena2 == 0) ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "{007C0E}Derby: {B8B8B8}Arenas{007C0E}:", "{B8B8B8}Pene\n{B8B8B8}Pene2(cerrado)\n{B8B8B8}Pene3", "Selec.", "Salir");
//else if(dArena2 == 0) ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "{007C0E}Derby: {B8B8B8}Arenas{007C0E}:", "{B8B8B8}Pene\n{B8B8B8}Pene2\n{B8B8B8}Pene3(cerrado)", "Selec.", "Salir");
return 1;
}

QCMD:salirderby(){
if(EstaEnDerby[playerid] == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No te encuentras en una arena derby.");
if(EstaEnDerby[playerid] > 0){
	new id = GetPlayerVehicleID(playerid);
	DestroyVehicle(id);
	TogglePlayerControllable(playerid,1);
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerInterior(playerid,0);
	SpawnPlayer(playerid);
}
return 1;
}


QCMD:x1(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(X1_cerrado == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas están cerradas, espera a que un admin nivel 3 los vuelva a abrir.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Equipo[playerid] != EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este comando es solo para {70FBFF}Espectadores.");
if(EstaEnX1[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salir");
ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "{007C0E}Arenas {B8B8B8}RW{007C0E}:", "{B8B8B8}Warehouse\n{B8B8B8}Kursk\n{B8B8B8}Estadio", "Selec.", "Salir");
return 1;
}

QCMD:x1w(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(X1_cerrado == 1) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Las arenas están cerradas, espera a que un admin nivel 3 los vuelva a abrir.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Equipo[playerid] != EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este comando es solo para {70FBFF}Espectadores.");
if(EstaEnX1[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salir");
ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "{007C0E}Arenas {B8B8B8}WW{007C0E}:", "{B8B8B8}Warehouse\n{B8B8B8}Kursk\n", "Selec.", "Salir");
return 1;
}

QCMD:salir(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No te encuentras en una arena.");

//if(EstaEnX1[playerid] == 2){
//ResetPlayerWeapons(playerid);
//SetPlayerHealth(playerid, 100);
//SetPlayerArmour(playerid, 0);
//X1_Arena1w = X1_Arena1w-1;
//EstaEnX1[playerid] = 0;
//printf("%d", X1_Arena1w);
//SpawnPlayer(playerid);
//SetPlayerVirtualWorld(playerid,0);
//SetPlayerInterior(playerid,0);
//SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}x1w", nombre(playerid));
//}
if(EstaEnX1[playerid] == 1){
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
ResetPlayerWeapons(playerid);
X1_Arena1 = X1_Arena1-1;
EstaEnX1[playerid] = 0;
printf("%d", X1_Arena1);
SpawnPlayer(playerid);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}Warehouse", nombre(playerid));
}
if(EstaEnX1[playerid] == 2){
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
ResetPlayerWeapons(playerid);
X1_Arena2 = X1_Arena2-1;
EstaEnX1[playerid] = 0;
printf("%d arena2", X1_Arena2);
SpawnPlayer(playerid);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}Kursk", nombre(playerid));
}
if(EstaEnX1[playerid] == 3){
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
ResetPlayerWeapons(playerid);
X1_Arena3 = X1_Arena3-1;
EstaEnX1[playerid] = 0;
printf("%d arena3", X1_Arena3);
SpawnPlayer(playerid);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}Estadio", nombre(playerid));
}
if(EstaEnX1[playerid] == 4){
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
ResetPlayerWeapons(playerid);
X1W_Arena1 = X1W_Arena1-1;
EstaEnX1[playerid] = 0;
SpawnPlayer(playerid);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}Warehouse (x1w)", nombre(playerid));
}
if(EstaEnX1[playerid] == 5){
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
ResetPlayerWeapons(playerid);
X1W_Arena2 = X1W_Arena2-1;
EstaEnX1[playerid] = 0;
printf("%d x1w arena2", X1W_Arena2);
SpawnPlayer(playerid);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SCMTAF(0x99B4D1FF,"{B8B8B8}%s {FFFFFF}salió de la arena {B8B8B8}Kursk (x1w)", nombre(playerid));
}
return 1;
}

    QCMD:setscore(){
    if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
    if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
    if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
	new id; // "defines" the targets id.
	new score; // Gets the targets score ( was added to prevent an error.)
	new name[MAX_PLAYER_NAME+1], string[24+MAX_PLAYER_NAME+1];
	GetPlayerName(playerid, name, sizeof(name));
	if(Admin[playerid] < 3) return SendClientMessage(playerid, COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando."); //If the player who typed the command isn't logged in via the RCON, he will receive this "error" message.
	if(sscanf(params, "ui", id, score)) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/setscore [id] [score]"); //If there aren't enough params typed in(ex - /setscore ID)
	if(score < 1) return SendClientMessage(playerid, COLOR_WHITE, "No puedes dar -1 score."); //This isn't really needed, but it "forces" the admin to give the player more than 1 score.
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}El jugador no está {0CE705}on."); //If the targets id isn't "valid", the admin will receive this "error" message, cause there was no ID found.
	SetPlayerScore(id, score);  //Sets the targets score. COLOR_WHITE
    SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha cambiado el score de un jugador.", nombre(playerid)); //Target receives this message.
	SendClientMessage(id, COLOR_WHITE, string);
	return 1;
}

QCMD:fakechat(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new tmp[256];
new id = strval(params);
if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(sscanf(params,"is",id,strlen(tmp)+1)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/fakechat [id] [mensaje]");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"{FFFFFF}El jugador no está {0CE705}on.");
{
SendPlayerMessageToAll(id, params[strlen(tmp)+1]);
}
return 1;
}

QCMD:slap(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 2) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}No tienes {007C0E}nivel.");
new id,Float:x, Float:y, Float:z, Float:Health;
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(sscanf(params, "u", id)) return SendClientMessage(playerid,COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/slap [id]");
if (id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}El jugador no está {0CE705}on.");
GetPlayerPos(id, x, y, z);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} slapeó a {B8B8B8}%s",nombre(playerid),nombre(id));
GetPlayerHealth(id,Health);
SetPlayerHealth(id,Health-15);
GetPlayerPos(id, x, y, z);
SetPlayerPos(id,x,y,z+6);
return 1;
}
QCMD:explotar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 2) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
new id,Float:x, Float:y, Float:z;
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(sscanf(params, "u", id)) return SendClientMessage(playerid,COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/explotar [id]");
if (id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}El jugador no está {0CE705}on.");
GetPlayerPos(id, x, y, z);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} explotó a {B8B8B8}%s",nombre(playerid),nombre(id));
CreateExplosion(x, y , z, 4,10.0), PlayerPlaySound(playerid, 1159, 0, 0, 0);
return 1;
}

QCMD:skin(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
new skinnumber, skinid, string[128];
if(sscanf(params, "d", skinid)) SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/skin [1:311]");
else if(skinid < 0 || skinid > 311) SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Por favor: {007C0E}/skin [1:311]");
else
{
SetPlayerSkin(playerid, skinid);
skinnumber = GetPlayerSkin(playerid);
format(string, sizeof(string), "{FFFFFF}Te has puesto el skin: {007C0E}%d", skinnumber);
SendClientMessage(playerid, COLOR_WHITE, string);
PlayerSkin[playerid] = GetPlayerSkin(playerid);
}
return 1;
}

QCMD:clima(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
new climanumber, climaid, string[128];
if(sscanf(params, "d", climaid)) SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/clima [id]");
else if(climaid < 0 || climaid > 50000) SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Por favor: {007C0E}/clima [0:50000]");
else
{
SetPlayerWeather(playerid, climaid);
climanumber = climaid;
format(string, sizeof(string), "{FFFFFF}Tú clima ha sido cambiando: {007C0E}%d", climanumber);
SendClientMessage(playerid, COLOR_WHITE, string);
}
return 1;
}

QCMD:hora(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
new climanumber, climaid, string[128];
if(sscanf(params, "d", climaid)) SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/hora [id]");
else if(climaid < 0 || climaid > 24) SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Por favor: {007C0E}/hora [1:24]");
else
{
SetPlayerTime(playerid, climaid,0);
climanumber = climaid;
format(string, sizeof(string), "{FFFFFF}Tú hora ha sido cambiando: {007C0E}%d", climanumber);
SendClientMessage(playerid, COLOR_WHITE, string);
}
return 1;
}

QCMD:pm(){
	new str[128], str2[128], id, Name1[MAX_PLAYER_NAME], Name2[MAX_PLAYER_NAME];
	if(sscanf(params, "us", id, str2))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/pm [id]");
	    return 1;
	}
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}El jugador no está {0CE705}on.");
    if(playerid == id) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}No puedes enviarte un pm a ti mismo.");
	{
		GetPlayerName(playerid, Name1, sizeof(Name1));
		GetPlayerName(id, Name2, sizeof(Name2));
		format(str, sizeof(str), "Mensaje privado remitido a %s[%d]: %s", Name2, id, str2);PlayerPlaySound(id, 1085, 0.0, 0.0, 0.0);
		SendClientMessage(playerid, COLOR_GREY, str);
		format(str, sizeof(str), "Mensaje privado recibido de %s[%d]: %s", Name1, playerid, str2);PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		SendClientMessage(id, COLOR_GREY, str);
		ForPlayers(i){
		    if(Admin[i] >= 3){
		        format(str, sizeof(str), "PM de %s[%d] a %s[%d]:{FFFFFF} %s", Name1, playerid, Name2, id, str2);
		        SendClientMessage(i, COLOR_PM, str);
		    }
		}
    }
	return 1;
}
QCMD:ir(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

     if(Admin[playerid] < 2) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
     new ID;
     new pn[MAX_PLAYER_NAME];
     new an[MAX_PLAYER_NAME];
     new str[128];
     if(sscanf(params, "u", ID)) return SendClientMessage(playerid, COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/ir [id]");
     if(EstaEnX1[ID] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
     if(!IsPlayerConnected(ID)) return  SCM(playerid,COLOR_WHITE,"{FFFFFF}El jugador no está {0CE705}on.");
     GetPlayerName(playerid, an, MAX_PLAYER_NAME);
     GetPlayerName(ID, pn, MAX_PLAYER_NAME);
     new Float:x;
     new Float:y;
     new Float:z;
     GetPlayerPos(ID, x, y, z);
     SetPlayerPos(playerid, x+1, y+1, z);
     format(str, sizeof(str), "{FFFFFF}Te trasladaste cerca de {B8B8B8}%s", pn);
     SendClientMessage(playerid, COLOR_WHITE, str);
     if(IsPlayerInAnyVehicle(playerid))
     {
          GetPlayerPos(ID, x, y, z);
          SetVehiclePos(playerid, x+1, y+1, z);
     }
     return 1;
}
QCMD:traer(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

new id;
new str[128];
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(Admin[playerid] < 2) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(sscanf(params, "d", id)) return SendClientMessage(playerid, 0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/traer [id]");
if (!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"{FFFFFF}El jugador no está {0CE705}on.");
new Float:x, Float:y, Float:z;
new PlayerName[MAX_PLAYER_NAME];
GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
new GPlayerName[MAX_PLAYER_NAME];
GetPlayerName(id, GPlayerName, sizeof(GPlayerName));
GetPlayerPos(playerid, x, y, z);
SetPlayerPos(id, x, y, z);
format(str, sizeof(str), "{FFFFFF}Has traido al jugador {B8B8B8}%s{FFFFFF} a tú posición", GPlayerName);
SendClientMessage(playerid, 0x00FF00AA, str);
return 1;
}

/*QCMD:admins(){
new string[256],string2[256], strbox[700], count_adminr = 0; //variables para detectar al adminstrador y para hacer ls Formatos
new Nombre[250];//variable Nombre
for(new i, j = GetPlayerPoolSize(); i <= j; i++){//define (i)
GetPlayerName(i, Nombre, sizeof(Nombre));//obtiene el nombre del usuario ADMIN
if(IsPlayerConnected(i)) if(Admin[i] > 0) count_adminr++;} //define y esta Conectado el administrador, //define el conteo de admins
if(count_adminr == 0) return SendClientMessage(playerid,BLANCO,"En este momento no hay administradores conectados/logeados"); //ADMIN ON
format(string, sizeof(string), "{FFFFFF}> {830000}%s {B8B8B8}con nivel: {007C0E}%d\n", Nombre, Admin); //Unos box para ver los admins
strcat(strbox, string);//strcat para hacer el formato y poder mostrar el dialog
format(string2, sizeof(string2), "{FFFFFF}Administradores conectados: {007C0E}%d\n", count_adminr);//ADMIN ON
ShowPlayerDialog(playerid, ADMINSC, DIALOG_STYLE_TABLIST, string2, strbox, "Ok", ""); //Muestra el dialog
return 1;
}
*/


QCMD:maxplayers(){
	printf("%d maxplayers", MAX_PLAYERS);
	return 1;
}
QCMD:top3(){
	new str[128];
	format(str, sizeof(str), "%s tiene %.3f\n%s tiene %.3f\n%s tiene %.3f", Nick_top[0], Score_top[0], Nick_top[1], Score_top[1],Nick_top[2], Score_top[2]);
	ShowPlayerDialog(playerid, 425, DIALOG_STYLE_LIST, "{F69521}Top:", str , "Selec.", "Salir");
	return 1;
}

QCMD:top(){
	if(EstaEnX1[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salir");
	if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salirderby");
	new str[600];
	format(str, sizeof(str), "{7C7C7C}> {B8B8B8}Jugadores\n{7C7C7C}> {B8B8B8}Jugadores conectados\n{7C7C7C}> {B8B8B8}Clan kills\n{7C7C7C}> {B8B8B8}Clan muertes\n{7C7C7C}> {B8B8B8}CW's ganadas\n{7C7C7C}> {B8B8B8}CW's perdidas");
	ShowPlayerDialog(playerid, TOP, DIALOG_STYLE_LIST, "{F69521}Top:", str , "Selec.", "Salir");
	return 1;
}

QCMD:clanes(){
	if(EstaEnX1[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salir");
	if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya te encuentras en una arena, para salir usa {007C0E}/salirderby");
	new str[PARAMETROS];
	new strnu[PARAMETROS];
	for(new x=0;x<CLANES_REGISTRADOS;x++){
        format(str, sizeof(str),"{7C7C7C}> {B8B8B8}%s\n", Clanes[x]);
        strcat(strnu, str, sizeof(str));
	}
	printf("%s", strnu);
	ShowPlayerDialog(playerid, LISTA_CLANES, DIALOG_STYLE_LIST, "{F69521}Clanes:", strnu , "Selec.", "Salir");
	return 1;
}

QCMD:top2(){
	new strprincipal[1500], posicion = 1; //string[128];
   	ForPlayers(i){
		if(IsPlayerConnected(i)){ format(strprincipal, sizeof(strprincipal), "%s{7C7C7C}%d.{FFFFFF}> {B8B8B8}%s {F69521}%.3f p\n", strprincipal, posicion, nombre(idelegido[i]), rankp[i]);}
        posicion++;
	}
	ShowPlayerDialog(playerid, RANKEDSC, DIALOG_STYLE_LIST, "Ranked conectados:", strprincipal, "Ok", "");
	return 1;
}

QCMD:admins(){
	new string[2000], name[MAX_PLAYER_NAME], count_admin = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i)){
	count_admin++;
	if(count_admin == 0) return SendClientMessage(playerid,BLANCO,"En este momento no hay administradores conectados/logeados");
	if (Admin[i] >= 1){
	GetPlayerName(i, name, sizeof(name));
	format(string, sizeof(string), "%s {FFFFFF}> {F69521}%s {B8B8B8}con nivel: {007C0E}%d\n", string, name, Admin[i]);
	ShowPlayerDialog(playerid, ADMINS_CONECTADOS, DIALOG_STYLE_TABLIST, "Administradores conectados:", string, "Ok", "");
	}
	}
	}
	return 1;
}

QCMD:cc(){
if(Admin[playerid] < 2) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
for( new i = 0; i <= 100; i ++ ) SCMTA(COLOR_WHITE, "" );
SCMTAF(0x99B4D1FF,"{B8B8B8}%s{FFFFFF} ha borrado el log del chat.",nombre(playerid));
return true;
}

QCMD:equipo(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

new str[100];
format(str,100,"{F69521}%s {B8B8B8}(%d)\n{007C0E}%s {B8B8B8}(%d)\n{70FBFF}Espectador",Nombre_equipo[0],naranja,Nombre_equipo[1],verde);
ShowPlayerDialog(playerid,1,2,"{FFFFFF}Elije algún equipo:",str,"Aceptar","");
SetPVarInt(playerid,"ClassSelected",1);
return true;
}

QCMD:cambiarmapa(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(Modo_juego == 1){
	if(naranja > 0 && verde > 0){
		if(Ronda_maxima > 0 || Puntaje_maximo > 0){
			return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando si hay una cw en progreso.");
		}
	}
}
	new string[1500];
		strcat(string,"{70FBFF}- {FFFFFF}Las venturas\n");
		strcat(string,"{70FBFF}- {FFFFFF}Aeropuerto LV\n");
		strcat(string,"{70FBFF}- {FFFFFF}Aeropuerto SF\n");
		strcat(string,"{70FBFF}- {FFFFFF}Auto escuela\n");
		strcat(string,"{70FBFF}- {FFFFFF}Omega\n");
		strcat(string,"{70FBFF}- {FFFFFF}Aeropuerto SF {B8B8B8}(Agrandado)\n");
		strcat(string,"{70FBFF}- {FFFFFF}Aeropuerto LS\n");
		strcat(string,"{70FBFF}- {FFFFFF}Woozy\n");
	ShowPlayerDialog(playerid, CAMBIAR_MAPA , DIALOG_STYLE_LIST,"{FFFFFF}Mapas del servidor:",string,"Cambiar","Cancelar");


return true;
}

QCMD:crash(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
	new id, adminname[50], playername[50], sendername[MAX_PLAYER_NAME], string[50],Float:X,Float:Y,Float:Z;
	if(Admin[playerid] < 3) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid,COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/crash [id]");

	if (id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}El jugador no está {0CE705}on.");
    if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA, no seas hijadeputa.");
	if(IsPlayerConnected(id))
	{
		GetPlayerPos(id,X,Y,Z);
		CreatePlayerObject(id,385,X,Y,Z,0,0,0);
		GetPlayerName(id, playername, 128);
		GetPlayerName(playerid, adminname, 128);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		format(string, sizeof(string), "{B8B8B8}Has crasheado a: {FF7B00}%s", playername);
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return 1;
}


QCMD:desbugderby(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
derbycerrado = 0;
dArena1 = 0;
ForPlayers(i){
	if(Equipo[i] == EQUIPO_DERBY){
	SpawnPlayer(i);
	}
}
for(new j; j < Cont_derby;j++){
DestroyVehicle(Vehiculos_derby[j]);
}
Cont_derby = 0;
dcontador = 0;

SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} desbugeó las arenas de derby.",nombre(playerid));
return 1;
}

QCMD:parar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
ForPlayers(i){ TogglePlayerControllable(i,0); }
Pausa = 1;
GameTextForAll("~B~~B~PAUSA", 1000, 5);
return true;
}

QCMD:empezar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
Pausa = 0;
if(Count > -1){
new str[10];
format(str,10,"%d",Count);
GameTextForAll(str, 1000, 5);
ForPlayers(i){ TogglePlayerControllable(i,0); }
SetTimer("CountDownPublic",1000,false);
}else{
GameTextForAll("~B~~B~EMPIEZA!", 1000, 5);
ForPlayers(i){ TogglePlayerControllable(i,1); }
}
return true;
}

QCMD:contar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
CountDown(strval(params));
return true;
}


QCMD:kill(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} se reprimió y murió.",nombre(playerid));
SetPlayerHealth(playerid,-1);
return true;
}

QCMD:rw(){
if(Armas_ww[playerid] == 1) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya tienes activado las armas WW, para usar {007C0E}/rw {FFFFFF}desactiva con {007C0E}/ww");
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Armas_rw[playerid] != 1 || Armas_rw[playerid] == 0){
Armas_rw[playerid] = 1;
ResetPlayerWeapons(playerid);
GivePlayerWeapon(playerid, 22, 9999);
GivePlayerWeapon(playerid, 28, 9999);
GivePlayerWeapon(playerid, 26, 9999);
SendClientMessage(playerid, COLOR_WHITE,"{B8B8B8}Has {007C0E}activado {B8B8B8}tu slot de armas a {007C0E}RW{B8B8B8}, ahora cada vez que spawneas tendrás estas armas.");
}else if(Armas_rw[playerid] == 1){
Armas_rw[playerid] = 0;
ResetPlayerWeapons(playerid);
if(Equipo[playerid] != EQUIPO_SPEC) GivePlayerWeapon(playerid, 26, 9999);
SendClientMessage(playerid, COLOR_WHITE,"{B8B8B8}Has {F60000}desactivado {B8B8B8}tu slot de armas a {007C0E}RW {B8B8B8}.");
}
PlayerPlaySound(playerid,1058, 0.0, 0.0, 0.0);
return true;
}

QCMD:ww(){
if(Armas_rw[playerid] == 1) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Ya tienes activado las armas RW, para usar {007C0E}/ww {FFFFFF}desactiva con {007C0E}/rw");
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Armas_ww[playerid] != 1 || Armas_ww[playerid] == 0){
Armas_ww[playerid] = 1;
ResetPlayerWeapons(playerid);
GivePlayerWeapon(playerid, 24, 9999);
GivePlayerWeapon(playerid, 25, 9999);
GivePlayerWeapon(playerid, 34, 9999);
SendClientMessage(playerid, COLOR_WHITE,"{B8B8B8}Has {007C0E}activado {B8B8B8}tu slot de armas a {007C0E}WW{B8B8B8}, ahora cada vez que spawneas tendrás estas armas.");
}else if(Armas_ww[playerid] == 1){
Armas_ww[playerid] = 0;
ResetPlayerWeapons(playerid);
if(Equipo[playerid] != EQUIPO_SPEC) GivePlayerWeapon(playerid, 26, 9999);
SendClientMessage(playerid, COLOR_WHITE,"{B8B8B8}Has {F60000}desactivado {B8B8B8}tu slot de armas a {007C0E}WW {B8B8B8}.");
}
PlayerPlaySound(playerid,1058, 0.0, 0.0, 0.0);
return true;
}

QCMD:jetpack(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Equipo[playerid] != EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}El jetpack es solo para el equipo {70FBFF}Espectador.");
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
return true;
}

QCMD:spec(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Equipo[playerid] != EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Comando solo para {70FBFF}Espectadores.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/spec [id]");
new id = strval(params);
if(Equipo[id] == EQUIPO_SPEC) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar spec con un espectador.");
if(id == playerid) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes spectearte a ti mismo, idiota.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(!IsPlayerConnected(id)) return  SCM(playerid,COLOR_WHITE,"{FFFFFF}El jugador no está {0CE705}on.");
if(Equipo[id] == EQUIPO_VERDE){
SCMF(playerid, COLOR_WHITE,"{FFFFFF}Desde ahora estas viendo al jugador {0CE705}%s{FFFFFF}, para salir usa {B8B8B8}/specoff", nombre(id));
}else if(Equipo[id] == EQUIPO_NARANJA){
SCMF(playerid, COLOR_WHITE,"{FFFFFF}Desde ahora estas viendo al jugador {0CE705}%s{FFFFFF}, para salir usa {B8B8B8}/specoff", nombre(id));
}
Spec[playerid] = id;
TogglePlayerSpectating(playerid, 1);
new mundo, interior;
interior = GetPlayerInterior(id);
mundo = GetPlayerVirtualWorld(id);
SetPlayerVirtualWorld(playerid, mundo);
SetPlayerInterior(playerid, interior);
PlayerSpectatePlayerEx(playerid, id);
return true;
}

QCMD:specoff(){
if(Spec[playerid] == -1) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}No estas usando el comando /spec");
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
Spec[playerid] = -1;
TogglePlayerSpectating(playerid, 0);
return true;
}

QCMD:unbug(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} se desbugeó",nombre(playerid));
new Float:health;
new Float:x, Float:y, Float:z;
GetPlayerPos(playerid,x,y,z);
GetPlayerHealth(playerid,health);
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid,0);
SpawnPlayer(playerid);
SetPlayerPos(playerid,x,y,z);
SetPlayerHealth(playerid,health);
return true;
}

QCMD:respawn(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} se respawneó",nombre(playerid));
SpawnPlayer(playerid);
SetPlayerHealth(playerid,100);
return true;
}


QCMD:nequipo(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
new team,name[50];
if(sscanf(params,"is",team,name)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/nequipo [0,1] [nombre]");
if(team > 1 || team < 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Elije el valor 0 o 1: {007C0E}/Nombre_equipo [0,1] [nombre]");
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} cambió el nombre del equipo {B8B8B8}%s{FFFFFF} a {B8B8B8}%s",nombre(playerid),Nombre_equipo[team],name);
format(Nombre_equipo[team],50,"%s",name);
UpdateScoreBar();
Estadisticas();
return true;
}
QCMD:reparar(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(isnull(params)) return SCM(playerid,COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/reparar");
if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, 0xFF0000FF,"{FFFFFF}No estás en un {007C0E}vehículo.");
SetVehicleHealth(GetPlayerVehicleID(playerid),1000);
RepairVehicle(GetPlayerVehicleID(playerid));
SendClientMessage(playerid,COLOR_GREEN,"{B8B8B8}Tú vehículo se reparó.");
return true;
}


/*QCMD:rvsp(){
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador ya está siendo revisado, paara terminar la revisión: {FF7B00}/lp [id]");
Sospechoso[id] = 1;
TogglePlayerControllable(id,0);
ShowPlayerDialog(id, SospechosoD, DIALOG_STYLE_MSGBOX, "Revisión de GTA:", "{FFFFFF}Un administrador te congeló para revisar tu GTA, {FF7B00}cleos{FFFFFF}/{FF7B00}dll{FFFFFF}/{FF7B00}exe{FFFFFF}, o {FF7B00}ventajas{FFFFFF}.\nRequiere una aprobación tuya, si en verdad juegas limpio aceptarás la revisión\nSino aceptas serás automáticamente acusado y baneado del server por evadirlo.", "Acepto", "No acepto");
SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} congeló a {B8B8B8}%s {FF7B00}(revisión de GTA)",nombre(playerid),nombre(id));
SCMTAF(BLANCO,"{FFFFFF}Si {B8B8B8}%s {FFFFFF}no acepta la revisión será {FF7B00}baneado {FFFFFF}por evadir la revisión.",nombre(id));
return true;
}



QCMD:sp(){
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador ya está siendo revisado, paara terminar la revisión: {FF7B00}/lp [id]");
Sospechoso[id] = 1;
TogglePlayerControllable(id,0);
SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} congeló a {B8B8B8}%s {FF7B00}(revisión de GTA)",nombre(playerid),nombre(id));
SCMTAF(BLANCO,"{FFFFFF}Si {B8B8B8}%s {FFFFFF}usa {FF7B00}/q {FFFFFF}será {FF7B00}baneado {FFFFFF}por evadir la revisión.",nombre(id));
SendClientMessage(id,BLANCO,"{FFFFFF}- {20FCE2}Un administrador te congeló para revisar tu GTA, {FF7B00}cleos/dll/exe, {20FCE2}o {FF7B00}ventajas{20FCE2}.");
SendClientMessage(id,BLANCO,"{FFFFFF}- {20FCE2}Si te sales del servidor serás automáticamente {FF7B00}acusado {20FCE2}y {FF7B00}baneado{20FCE2} por evadirlo.");
SendClientMessage(id,BLANCO,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
SendClientMessage(id,BLANCO,"{FFFFFF}- {20FCE2}Lee {FF7B00}/rg {20FCE2}por si tienes alguna duda.");
return true;
}


QCMD:rvlp(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
if(Sospechoso[id] == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador no está siendo revisado, para revisarlo usa: {FF7B00}/sp [id]");
Sospechoso[id] = 0;
TogglePlayerControllable(id,1);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} descongeló a {B8B8B8}%s {FF7B00}(revisión de GTA terminado)",nombre(playerid),nombre(id));
SCMTAF(COLOR_WHITE,"{FFFFFF}El jugador {B8B8B8}%s {FFFFFF}ya puede jugar normalmente.",nombre(id));
return true;
}
*/
QCMD:congelar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/congelar [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(Congelado[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este jugador ya está Congelado.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
Congelado[id] = 1;
TogglePlayerControllable(id,0);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} congeló a {B8B8B8}%s {FF7B00}",nombre(playerid),nombre(id));
return true;
}

QCMD:descongelar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"Uso correcto del comando: {B8B8B8}/descongelar [id] ");
new id = strval(params);
if(Congelado[id] == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Este jugador no está Congelado.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
Congelado[id] = 0;
TogglePlayerControllable(id,1);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} descongeló a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}

QCMD:mute(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 2) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/mute [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
SetPVarInt(id,"Muted",1);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} silenció a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}
QCMD:unmute(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 2) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/unmute [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
DeletePVar(id,"Muted");
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} deja escribir emancipadamente a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}



QCMD:texts(){
if(TDraws[playerid] == -1 || TDraws[playerid] == 0){
TextDrawHideForPlayer(playerid, Frames[playerid]);
TextDrawHideForPlayer(playerid, TextdrawWTx);
TextDrawHideForPlayer(playerid, TextdrawD3x);
TextDrawHideForPlayer(playerid, Textdraw15);
TextDrawHideForPlayer(playerid,Textdraw0);
TDraws[playerid] = 1;
PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
SCM(playerid,COLOR_RED,"{FFFFFF}Has ocultado los textdraws del server, para activarlos {007C0E}/texts");
}else if(TDraws[playerid] == 1){
TDraws[playerid] = 0;
TextDrawShowForPlayer(playerid, Frames[playerid]);
TextDrawShowForPlayer(playerid, TextdrawWTx);
TextDrawShowForPlayer(playerid, TextdrawD3x);
TextDrawShowForPlayer(playerid, Textdraw15);
TextDrawShowForPlayer(playerid,Textdraw0);
PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
SCM(playerid,COLOR_RED,"{FFFFFF}Activaste los textdraws del server, para desactivarlos {007C0E}/texts");
}
return 1;
}


QCMD:stats(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new id = strval(params);
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/stats [id]");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
new str[2000], cesta[50], Pais[30], Float:ratio, registrado[15];
if(Muertes[id] == 0) ratio = Kills[id];
else ratio = float(Kills[id])/float(Muertes[id]);
GetPlayerCountry(id, Pais, sizeof(Pais));
format(cesta,50,IPFILE,Ip(id));
new File:a = fopen(cesta,io_read);
new str2[200];
if(GetPVarInt(id,"Logged") != 1) registrado = "{F60000}No";
else registrado = "{007C0E}Si";
if(Modo_juego == 1){
if(Equipo[id] == EQUIPO_NARANJA){
	format(str,2000,
"{FFFFFF}Nick: {FF7B00}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {FF7B00}%s\n{FFFFFF}En cw: {007C0E}Sí\n{FFFFFF}Kills: {A10000}%d\n{FFFFFF}Muertes: {A10000}%d\n{FFFFFF}Ratio: {A10000}%0.2f\n\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f puntos\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
	,nombre(id), registrado,Nombre_equipo[EQUIPO_NARANJA],Kills[id],Muertes[id],ratio,GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);

}else if(Equipo[id] == EQUIPO_VERDE){
	format(str,1200,
	"{FFFFFF}Nick: {007C0E}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {007C0E}%s\n{FFFFFF}En cw: {007C0E}Sí\n{FFFFFF}Kills: {A10000}%d\n{FFFFFF}Muertes: {A10000}%d\n{FFFFFF}Ratio: {A10000}%0.2f\n\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
	,nombre(id), registrado,Nombre_equipo[EQUIPO_VERDE],Kills[id],Muertes[id],ratio,GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);
}else{

format(str,1200,
"{FFFFFF}Nick: {70FBFF}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {70FBFF}Espectador\n{FFFFFF}En cw: {FF0000}No\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
,nombre(id),registrado,GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);
}
}else{
if(Equipo[id] == EQUIPO_NARANJA){

format(str,1200,
"{FFFFFF}Nick: {FF7B00}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {FF7B00}%s\n{FFFFFF}En cw: {FF0000}No\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
,nombre(id),registrado,Nombre_equipo[EQUIPO_NARANJA],GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);


}else if(Equipo[id] == EQUIPO_VERDE){

format(str,1200,
"{FFFFFF}Nick: {007C0E}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {007C0E}%s\n{FFFFFF}En cw: {FF0000}No\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
,nombre(id),registrado,Nombre_equipo[EQUIPO_VERDE],GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);
}else{

format(str,1200,
"{FFFFFF}Nick: {70FBFF}%s\n{FFFFFF}Registrado: %s\n{FFFFFF}Equipo: {70FBFF}Espectador\n{FFFFFF}En cw: {FF0000}No\n{FFFFFF}Fps: {FF7B00}%d\n{FFFFFF}Ping: {FF7B00}%d {B8B8B8}ms\n{FFFFFF}Packetloss: {FF7B00}%.1f {B8B8B8}percent\n{FFFFFF}Pais: {FF7B00}%s\n{FFFFFF}Skin: {FF7B00}%d{FFFFFF}\nRanked: {FF7B00}%.3f\n{FFFFFF}X1 ganados: {FF7B00}%d\n{FFFFFF}X1 perdidos: {FF7B00}%d\n\n{FFFFFF}Cuentas del jugador:{B8B8B8}\n"
,nombre(id),registrado,GetPlayerFPS(id),GetPlayerPing(id),NetStats_PacketLossPercent(id),Pais,GetPlayerSkin(playerid),Puntaje_ranked[id],X1_Ganados[id],X1_Perdidos[id]);
}
}
while(fread(a,str2)){
strcat(str,str2);
}
fclose(a);
ShowPlayerDialog(playerid,3,0,"Información del jugador:",str,"Ok","");
return true;
}

stock Ip(i){
new x[20];
GetPlayerIp(i,x,20);
return x;
}

QCMD:cn(){
    if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
	if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
    if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
	new id,id2;
	if(sscanf(params, "ui", id, id2)) return SendClientMessage(playerid, COLOR_RED, "{B8B8B8}Comando correcto: {FFFFFF}/cn [id] [0-1] (0-activar,1-desactivar)");
	if(GetPVarInt(id,"Logged") != 1) return SCM(playerid,COLOR_WHITE,"El jugador no está {FF0000}registrado.");
	Cambiar_nombre[id] = id2;
	if(id2 == 1){
	    SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha desactivado el cambio de nick para {B8B8B8}%s", nombre(playerid),nombre(id)); //Target receives this message.
	}else{
	    SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha activado el cambio de nick para {B8B8B8}%s", nombre(playerid),nombre(id)); //Target receives this message.
	}
return true;
}

QCMD:cambiarnombre(){
if(Cambiar_nombre[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar tu nick.");
ShowPlayerDialog(playerid, CUENTA_CAMBIAR_NICK, DIALOG_STYLE_INPUT, "{B8B8B8}Cambio de nombre", "{FFFFFF}Ingresa tu nuevo {FF7B00}nombre {FFFFFF}sin poner espacios\nUna vez que lo hagas todos tus stats se pasarán a tu nuevo nick", "Aceptar", "");
return true;
}

QCMD:ban(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
new id,dovod[100];
if(Admin[id] == 2018) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes kickear a este administrador.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/ban [id] [razón]");
if(sscanf(params,"is",id,dovod)) return SCM(playerid,0xFF0000FF,"Uso correcto del comando: {007C0E}/ban [id] [razón]");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha baneado a {B8B8B8}%s{FFFFFF}: {FF7B00}%s",nombre(playerid),nombre(id),dovod);
printf("%s ha baneado a %s por la razon %s",nombre(playerid),nombre(id),dovod);
BanEx(id,dovod);
return true;
}
QCMD:kick(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 2) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
new id,dovod[100];
if(Admin[id] == 2018) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes kickear a este administrador.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/kick [id] [razón]");
if(sscanf(params,"is",id,dovod)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/kick [id] [razón]");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
printf("%s ha kickeado a %s por la razon %s",nombre(playerid),nombre(id),dovod);
new skick[500], skicktodos[256];
format(skick, sizeof(skick), "{7C7C7C}Admin: {FF7B00}%s\n{7C7C7C}Razón: {FF7B00}%s", nombre(playerid), dovod);
ShowPlayerDialog(id, 132, 0,"{7C7C7C}Kickeado: ", skick,"Ok","");
format(skicktodos, sizeof(skicktodos), "{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} kickeó a {B8B8B8}%s{FFFFFF}: {FF7B00}%s", nombre(playerid), nombre(id), dovod);
ForPlayers(i){
	if(i != id){
		SendClientMessage(i, COLOR_WHITE, skicktodos);
	}
}
SetTimerEx("KickT",100,false,"ii",id);
return true;
}

QCMD:spawn(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/spawn [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
SpawnPlayer(id);
SetPlayerHealth(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} respawneó a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}

QCMD:spawnall(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
ForPlayers(i){
if(Equipo[i] != EQUIPO_SPEC){
SpawnPlayer(i);
SetPlayerHealth(i,100);
}
}
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} respawneó a todos los jugadores",nombre(playerid));
return true;
}

QCMD:hp(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/hp [id]");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
SetPlayerHealth(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} le restauró la vida a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}

QCMD:armour(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/hp [id]");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
SetPlayerArmour(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} le restauró la armadura a {B8B8B8}%s",nombre(playerid),nombre(id));
return true;
}

QCMD:hpall(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
ForPlayers(i){
if(Equipo[i] != EQUIPO_SPEC){
SetPlayerHealth(i,100);
}
}
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} les restauró la vida a todos.",nombre(playerid));
return true;
}
QCMD:armourall(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
ForPlayers(i){
if(Equipo[i] != EQUIPO_SPEC){
SetPlayerArmour(i,100);
}
}
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} dio armadura a todos.",nombre(playerid));
return true;
}

QCMD:puntajeverde(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {213BF}/puntajeverde [0:100]");
new id = strval(params);
if(id > 100 || id < 0) return SCM(playerid,COLOR_WHITE,"El limite de puntos es de: {007C0E}100.");
Equipo_puntaje[EQUIPO_VERDE]  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció el puntaje del equipo {007C0E}%s{FFFFFF} a {007C0E}%d",nombre(playerid),Nombre_equipo[EQUIPO_VERDE],id);
UpdateScoreBar();
return true;
}
QCMD:puntajenaranja(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/puntajenaranja [0:100]");
new id = strval(params);
if(id > 100 || id < 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}El limite de puntos es de {007C0E}100.");
Equipo_puntaje[EQUIPO_NARANJA]  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció el puntaje del equipo {F69521}%s{FFFFFF} a {F69521}%d",nombre(playerid),Nombre_equipo[EQUIPO_NARANJA],id);
UpdateScoreBar();
return true;
}
QCMD:rondasnaranja(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/rondasnaranja [0:3]");
new id = strval(params);
if(id > 10 || id < 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}El limite de rondas es de {007C0E}10.");
Equipo_rondas[EQUIPO_NARANJA]  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció las rondas ganadas del equipo {F69521}%s{FFFFFF} a {F69521}%d",nombre(playerid),Nombre_equipo[EQUIPO_NARANJA],id);
UpdateScoreBar();
Estadisticas();
return true;
}
QCMD:rondasverde(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/rondasverde [0:10]");
new id = strval(params);
if(id > 10 || id < 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}El limite de rondas es de {007C0E}10.");
Equipo_rondas[EQUIPO_VERDE]  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció las rondas ganadas del equipo {007C0E}%s{FFFFFF} a {007C0E}%d",nombre(playerid),Equipo_rondas[EQUIPO_VERDE],id);
UpdateScoreBar();
Estadisticas();
return true;
}

QCMD:rondas(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/rondas [0:10]");
new id = strval(params);
if(id > 10 || id < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}El limite de rondas es de {007C0E}10.");
Ronda_maxima  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció las rondas a: {007C0E}%d",nombre(playerid),id);
SCMTAF(COLOR_WHITE,"{B8B8B8}Desde ahora se jugará: {007C0E}%dx%d",Ronda_maxima,Puntaje_maximo);
UpdateScoreBar();
return true;
}
QCMD:puntajederonda(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/puntajederonda [1:100]");
new id = strval(params);
if(id > 100 || id < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}El limite de score es de {007C0E}100.");
Puntaje_maximo  = id;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} estableció el puntaje a {007C0E}%d",nombre(playerid),id);
SCMTAF(COLOR_WHITE,"{B8B8B8}Desde ahora se jugará: {007C0E}%dx%d",Ronda_maxima, Puntaje_maximo);
UpdateScoreBar();
return true;
}


QCMD:naranja(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/naranja [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
Equipo[id] = EQUIPO_NARANJA;
naranja = 0;
verde = 0;
ForPlayers(i){
if(Equipo[i] == EQUIPO_NARANJA) naranja++;
else if(Equipo[i] == EQUIPO_VERDE) verde++;
}
SpawnPlayer(id);
SetPlayerColor(id,COLOR_NARANJA);
SetPlayerHealth(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} añadió a {B8B8B8}%s{FFFFFF} al equipo {F69521}%s",nombre(playerid),nombre(id),Nombre_equipo[EQUIPO_NARANJA]);
return true;
}

QCMD:verde(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/verde [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
Equipo[id] = EQUIPO_VERDE;
naranja = 0;
verde = 0;
ForPlayers(i){
if(Equipo[i] == EQUIPO_NARANJA) naranja++;
else if(Equipo[i] == EQUIPO_VERDE) verde++;
}
SpawnPlayer(id);
SetPlayerColor(id,COLOR_GREEN);
SetPlayerHealth(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} añadió a {B8B8B8}%s{FFFFFF} al equipo {007C0E}%s",nombre(playerid),nombre(id),Nombre_equipo[EQUIPO_VERDE]);
return true;
}

QCMD:espectador(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/espectador [id]");
new id = strval(params);
if(Sospechoso[id] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Este jugador está en una revisión de su carpeta de GTA.");
if(EstaEnX1[id] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes cambiar a este jugador porque está en una arena de duelos.");
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"El jugador no está conectado.");
Equipo[id] = EQUIPO_SPEC;
naranja = 0;
verde = 0;
ForPlayers(i){
if(Equipo[i] == EQUIPO_NARANJA) naranja++;
else if(Equipo[i] == EQUIPO_VERDE) verde++;
}
SpawnPlayer(id);
SetPlayerColor(id,COLOR_WHITE);
SetPlayerHealth(id,100);
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} añadió a {B8B8B8}%s{FFFFFF} al equipo {70FBFF}Espectador",nombre(playerid),nombre(id));
return true;
}

QCMD:reseteartodo(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
Equipo_puntaje[EQUIPO_NARANJA] = 0;
Equipo_puntaje[EQUIPO_VERDE] = 0;
Equipo_rondas[EQUIPO_NARANJA] = 0;
Equipo_rondas[EQUIPO_VERDE] = 0;
Estadisticas();
ForPlayers(i){
//SetPlayerScore(i,0);
Kills[i] = 0;
Muertes[i] = 0;
Equipo_kills[i] = 0;
}
//Equipo_kills[playerid] = 0;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} reseteó todos los puntajes.",nombre(playerid));
UpdateScoreBar();
return true;
}

//QCMD:spawnall(){
//if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
//ForPlayers(i){
//if(Equipo[i] != EQUIPO_SPEC){
//SpawnPlayer(i);
//SetPlayerHealth(i,100);
//}

QCMD:bloqserver(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 2) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/bloqserver [contraseña]");
if(!params[2] || strlen(params) > 49) return SCM(playerid,0xFF0000FF,"{FFFFFF}Por favor, utilice menos de {007C0E}49 {FFFFFF}carácteres.");
format(Contra_servidor,50,"%s",params);
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} bloqueó el servidor con una contraseña",nombre(playerid));
Estadisticas();
return true;
}

QCMD:hablar(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 3) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/hablar [texto]");
if(!params[2] || strlen(params) > 49) return SCM(playerid,0xFF0000FF,"{FFFFFF}Por favor, utilice menos de {007C0E}49 {FFFFFF}caráctere y máximo de 3.");
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} ha enviado un mensaje de voz a todos los usuarios.",nombre(playerid));
format(Voz, sizeof(Voz), "http://audio1.spanishdict.com/audio?lang=es&voice=Duardo&speed=10&text=%s", params);
for(new i = 0; i < MAX_PLAYERS; i++)
PlayAudioStreamForPlayer(i, Voz, 0, 0, 0, 0, 0);
return 1;
}

QCMD:desbloqserver(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 2) return SCM(playerid,0xFF0000FF,"{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
format(Contra_servidor,50," ");
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} desbloqueó el servidor",nombre(playerid));
Estadisticas();
return true;
}

QCMD:bloqequipos(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/bloquearequipos [0:1] (0-desbloquear - 1-bloquear)");
new id = strval(params);
if(id > 1 || id < 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}Escriba bien el comando: {007C0E}/bloquearequipos [0:1] (0-desbloquear - 1-bloquear)");
Equipos_bloq = id;
if( id == 1){SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} bloqueó los equipos.",nombre(playerid));
}else{ SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} desbloqueó los equipos.",nombre(playerid));
}
return true;
}


QCMD:rank(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/fps [id]");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"{B8B8B8}El jugador no está conectado.");
SCMTAF(COLOR_WHITE,"> {B8B8B8}%s{FFFFFF} tiene {F69521}%.3f {FFFFFF}p",nombre(id),Puntaje_ranked[id]);
return true;
}

QCMD:fps(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/fps [id]");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,0xFF0000FF,"{B8B8B8}El jugador no está conectado.");
SCMTAF(COLOR_WHITE,"> {B8B8B8}%s{FFFFFF} tiene {F69521}%d {FFFFFF}FPS",nombre(id),GetPlayerFPS(id));
return true;
}

QCMD:pl(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/pl [id]");
new id = strval(params);
if(!IsPlayerConnected(id)) return  SCM(playerid,COLOR_WHITE,"Error:{7C7C7C} este jugador no está en línea.");
SCMTAF(BLANCO,"> {B8B8B8}%s{FFFFFF} tiene {F69521} %.1f {FFFFFF}percent",nombre(id),NetStats_PacketLossPercent(id));
return true;
}



QCMD:fpsall(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
SCMTA(BLANCO,"");
SCMTA(BLANCO,"> FPS de todos los jugadores:");
ForPlayers(i){
SCMTAF(BLANCO,"- {B8B8B8}%s{FFFFFF} » {F69521}%d {FFFFFF}FPS",nombre(i),GetPlayerFPS(i));
}
return true;
}

QCMD:plall(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
SCMTA(BLANCO,"");
SCMTA(BLANCO,"> PL de todos los jugadores:");
ForPlayers(i){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {F69521}%.1f {FFFFFF}percent",nombre(i),NetStats_PacketLossPercent(i));
}
return true;
}

/*QCMD:scoreall(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
ForPlayers(i){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {F69521}%d {FFFFFF}de score",nombre(i),KillsCW[i]);
}
return true;
}

    QCMD:setscorecw(){
	new id,cantidad;
	if(sscanf(params, "ui", id, cantidad)) return SendClientMessage(playerid, COLOR_RED, "Comando correcto: /setscorecw [id] [cantidad]");
	if(GetPVarInt(id,"Logged") != 1) return SCM(playerid,COLOR_WHITE,"El jugador no está {FF0000}registrado.");
	KillsCW[id] = cantidad;
    SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha cambiado el score del jugador {B8B8B8}%s a {F69521}%d", nombre(playerid),nombre(id), cantidad); //Target receives this message.
	return 1;
}

*/

    QCMD:setscorex1(){
    if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
	if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
    if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
	new id,cantidad;
	if(sscanf(params, "ui", id, cantidad)) return SendClientMessage(playerid, COLOR_RED, "Comando correcto: /setscorex1 [id] [cantidad]");
	if(GetPVarInt(id,"Logged") != 1) return SCM(playerid,COLOR_WHITE,"El jugador no está {FF0000}registrado.");
	X1_Ganados[id] = cantidad;
    SCMTAF(COLOR_WHITE,"{B8B8B8}%s {FFFFFF}ha cambiado el score X1 del jugador {B8B8B8}%s a {F69521}%d", nombre(playerid),nombre(id), cantidad); //Target receives this message.
	return 1;
	}

QCMD:rankedall(){
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
SCMTA(BLANCO,"");
SCMTA(BLANCO,"> Rango de todos los jugadores:");
ForPlayers(i){
if(Puntaje_ranked[i] > 1.500){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {965100}%.3f {FFFFFF}p",nombre(i),Puntaje_ranked[i]);
}else if(Puntaje_ranked[i] > 2.000){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {960020}%.3f {FFFFFF}p",nombre(i),Puntaje_ranked[i]);
}else if(Puntaje_ranked[i] > 2.500){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {19F7FF}%.3f {FFFFFF}p",nombre(i),Puntaje_ranked[i]);
}else{
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {F69521}%.3f {FFFFFF}p",nombre(i),Puntaje_ranked[i]);
}
}
return true;
}

QCMD:scoreall(){
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
SCMTA(BLANCO,"");
SCMTA(BLANCO,"> X1 stats de todos los jugadores:");
ForPlayers(i){
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {F69521}%d {FFFFFF}x1's ganados y {F69521}%d {FFFFFF}perdidos",nombre(i),X1_Ganados[i],X1_Perdidos[i]);
}
return true;
}

QCMD:score(){
if(Admin[playerid] < 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new id = strval(params);
SCMTAF(BLANCO,"- {B8B8B8}%s {FFFFFF}tiene » {F69521}%d {FFFFFF}x1's ganados y {F69521}%d {FFFFFF}perdidos",nombre(id),X1_Ganados[id],X1_Perdidos[id]);
Clan_kills[2]++;
return true;
}

QCMD:sta2(){
new id,level;
if(!IsPlayerAdmin(playerid)){
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
}
if(sscanf(params,"ii",id,level)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/setadmin [id] [0:3]");
if(!IsPlayerConnected(id)) return  SCM(playerid,COLOR_WHITE,"El jugador no está conectado.");
if(GetPVarInt(id,"Logged") != 1) return SCM(playerid,COLOR_WHITE,"El jugador no está {FF0000}registrado.");
new get[128],s[50];
format(s,50,"%s.txt",nombre(id));
GetPVarString(id,"Pass",get,128);
new File:f = fopen(s,io_write);
format(s,128,"%s\r\n%d\r\n%d\r\n%d",get,level,X1_Ganados[id],X1_Perdidos[id]);
fwrite(f,s);
fclose(f);
Admin[id] = level;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} le dio a {B8B8B8}%s {FFFFFF}administrador nivel {007C0E}%d",nombre(playerid),nombre(id),level);
if(level >= 2) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora tienes nivel de administrador alto, puedes acceder a: {007C0E}/acmds2 {FFFFFF}y {007C0E}/acmds");
if(level == 1) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora tienes nivel de administrador bajo, puedes acceder a: {007C0E}/acmds");
if(level == 0) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora ya no tienes nivel de administrador, no podras usar los comandos admin.");
return true;
}


QCMD:setadmin(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new id,level;
if(!IsPlayerAdmin(playerid)){if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");}
if(sscanf(params,"ii",id,level)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/setadmin [id] [0:3]");
if(!IsPlayerConnected(id)) return  SCM(playerid,COLOR_WHITE,"El jugador no está conectado.");
if(level > 3 || level < 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Por favor, solo hay 3 niveles.");
if(GetPVarInt(id,"Logged") != 1) return SCM(playerid,COLOR_WHITE,"El jugador no está {FF0000}registrado.");
new get[128],s[50];
format(s,50,"%s.txt",nombre(id));
GetPVarString(id,"Pass",get,128);
new File:f = fopen(s,io_write);
format(s,128,"%s\r\n%d\r\n%d\r\n%d",get,level,X1_Ganados[id],X1_Perdidos[id]);
fwrite(f,s);
fclose(f);
Admin[id] = level;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} le dio a {B8B8B8}%s {FFFFFF}administrador nivel {007C0E}%d",nombre(playerid),nombre(id),level);
if(level >= 2) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora tienes nivel de administrador alto, puedes acceder a: {007C0E}/acmds2 {FFFFFF}y {007C0E}/acmds");
if(level == 1) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora tienes nivel de administrador bajo, puedes acceder a: {007C0E}/acmds");
if(level == 0) return SCM(id,COLOR_WHITE,"{FFFFFF}Ahora ya no tienes nivel de administrador, no podras usar los comandos admin.");
return true;
}


QCMD:maxping(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(pinglimit == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No está activado el limite de ping, activalo para usar este comando.");
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/maxping [220-500]");
new id = strval(params);
if(id > 500 || id < 220) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/maxping [220-500]");
MAX_PING = id;
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha establecido como limite {F69521}%d{FFFFFF} de ping",nombre(playerid),MAX_PING);
return true;
}

QCMD:minfps(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(fpslimit == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No está activado el limite de fps, activalo para usar este comando.");
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/minfps [25-40]");
new id = strval(params);
if(id > 40 || id < 25) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/minfps [25-40]");
MIN_FPS = id;
SCMTAF(COLOR_WHITE,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha establecido como limite {F69521}%d{FFFFFF} fps.",nombre(playerid),MIN_FPS);
return true;
}

QCMD:est(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
SCMTAF(COLOR_WHITE,"Limite de fps: %d", fpslimit);
SCMTAF(COLOR_WHITE,"Limite de ping: %d", pinglimit);
SCMTAF(COLOR_WHITE,"Fps minimos: %d", MIN_FPS);
SCMTAF(COLOR_WHITE,"Ping maximo: %d", MAX_PING);
return true;
}

QCMD:pinglimite(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/pinglimite [0:1]");
new id = strval(params);
if(id == 1 && pinglimit == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Ya está activado el limite de ping, para desactivarlo {007C0E}/pinglimite 0");
if(id == 0 && pinglimit == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Ya está desactivado el limite de ping, para activarlo {007C0E}/pinglimite 1");
if(id > 1 || id < 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/pinglimite [0:1]");
pinglimit = id;
if(id == 1) SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha activado el limite de ping ({F69521}%d{FFFFFF})",nombre(playerid),MAX_PING);
else SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha desactivado el limite de ping",nombre(playerid));
return true;
}

QCMD:fpslimite(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Admin[playerid] < 3) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(isnull(params)) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/fpslimite [0:1]");
new id = strval(params);
if(id == 1 && fpslimit == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Ya está activado el limite de fps, para desactivarlo {007C0E}/fpslimite 0");
if(id == 0 && fpslimit == 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Ya está desactivado el limite de fps, para activarlo {007C0E}/fpslimite 1");
if(id > 1 || id < 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}Uso correcto del comando: {007C0E}/fpslimite [0:1]");
fpslimit = id;
if(id == 1) SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha activado el limite de fps ({F69521}%d{FFFFFF})",nombre(playerid),MIN_FPS);
else SCMTAF(BLANCO,"{FFFFFF}Administrador {B8B8B8}%s{FFFFFF} ha desactivado el limite de fps",nombre(playerid));
return true;
}

QCMD:cw(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/cw [0:1]");
new id = strval(params);
naranja = 0;
verde = 0;
ForPlayers(i){
if(Equipo[i] == EQUIPO_NARANJA) naranja++;
else if(Equipo[i] == EQUIPO_VERDE) verde++;
}
//if(rojo == 0 || verde == 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}No se puede poner modo CW si no hay jugadores en los dos equipos o son desequivalentes.");
if(id > 1 || id < 0) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/cw [0:1]");
Modo_juego = id;

if(id == 0) SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} ha puesto modo {830000}%s {B8B8B8}(Training)",nombre(playerid),CWTG(id));
else{
/*if(naranja == 1 && verde == 0){
    new name1[50],name2[50];
	ForPlayers(i){
		if(Equipo[i] == EQUIPO_NARANJA){
			name1 = nombre(i);
	    	format(Nombre_equipo[0],50,"%s",name1);
		}
		else if(Equipo[i] == EQUIPO_VERDE)
			name2 = nombre(i);
		    format(Nombre_equipo[1],50,"%s",name2);
		}
	}
*/
if(naranja == 1 && verde == 1) SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} ha puesto modo {F69521}%s {B8B8B8}(1vs1)",nombre(playerid),CWTG(id));
else SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} ha puesto modo {F69521}%s {B8B8B8}(Clan War): {F69521}%d {B8B8B8}vs {007C0E}%d",nombre(playerid),CWTG(id),naranja,verde);
}
Estadisticas();
UpdateScoreBar();
return true;
}

QCMD:asay(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "{FFFFFF}Uso correcto del comando: {007C0E}/asay [mensaje]");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/asay [mensaje]");
new string[200];
new name[128];
if(Admin[playerid] == 1){
	if(Equipo[playerid] == EQUIPO_VERDE){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {007C0E}%d{B8B8B8}] {007C0E}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else if(Equipo[playerid] == EQUIPO_NARANJA){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {007C0E}%d{B8B8B8}] {F69521}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else{
   	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {007C0E}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
    }
}
else if(Admin[playerid] == 2){
	if(Equipo[playerid] == EQUIPO_VERDE){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {830000}%d{B8B8B8}] {007C0E}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else if(Equipo[playerid] == EQUIPO_NARANJA){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {830000}%d{B8B8B8}] {F69521}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else{
   	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {830000}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
    }
}
if(Admin[playerid] == 3){
	if(Equipo[playerid] == EQUIPO_VERDE){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {70FBFF}%d{B8B8B8}] {007C0E}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else if(Equipo[playerid] == EQUIPO_NARANJA){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {70FBFF}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else{
   	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {70FBFF}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
    }
}
else if(Admin[playerid] > 3){
	if(Equipo[playerid] == EQUIPO_VERDE){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {FF7B00}%d{B8B8B8}] {007C0E}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else if(Equipo[playerid] == EQUIPO_NARANJA){
	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {FF7B00}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
	}
    else{
   	GetPlayerName(playerid, name, sizeof(name));
	format(string,sizeof(string),"{B8B8B8}[ADMIN NIVEL {FF7B00}%d{B8B8B8}] {70FBFF}%s{C3C3C3} [%d]{FFFFFF}: {C3C3C3}%s",Admin[playerid],name,playerid,params);
	SendClientMessageToAll(GetPlayerColor(playerid),string);
    }
}
return true;
}

/*QCMD:asay2(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 2) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "{FFFFFF}Uso correcto del comando: {007C0E}/asay2 [mensaje]");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/asay2 [mensaje]");
new string[128];
new name[128];
GetPlayerName(playerid, name, sizeof(name));
format(string,sizeof(string),"{B8B8B8}%s{C3C3C3} [%d]{FFFFFF}: {830000}%s",name,playerid,params);
SendClientMessageToAll(COLOR_WHITE,string);
return true;
}

QCMD:asay3(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "{FFFFFF}Uso correcto del comando: {007C0E}/asay3 [mensaje]");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/asay3 [mensaje]");
new string[128];
new name[128];
GetPlayerName(playerid, name, sizeof(name));
format(string,sizeof(string),"{B8B8B8}%s{C3C3C3} [%d]{FFFFFF}: {FF7B00}%s",name,playerid,params);
SendClientMessageToAll(COLOR_WHITE,string);
return true;
}

*/
QCMD:ann(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 2) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}pueden usar este comando.");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/ann [Texto]");
if(isnull(params)) return SendClientMessage(playerid,-1,"{FFFFFF}Uso correcto del comando: {007C0E}/ann [text]");
{
GameTextForAll(params,3000,3);
}
return 1;
}

QCMD:ann2(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 3) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}3 {FFFFFF}pueden usar este comando.");
if(sscanf(params, "s", params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/ann2 [Texto]");
if(isnull(params)) return SendClientMessage(playerid,-1,"{FFFFFF}Uso correcto del comando: {007C0E}/ann2 [text]");
{
GameTextForAll(params,3000,1);
}
return 1;
}

QCMD:info(){
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new string[1200];
strcat(string,"\n");
strcat(string,"{FFFFFF}> {7C7C7C}Creador del {70FBFF}GM{B8B8B8}: \n");
strcat(string,"{FFFFFF}- Denis 'QWER' Granec (2012)\n");
strcat(string,"\n");
strcat(string,"{FFFFFF}> {7C7C7C}Desarrollador del {70FBFF}GM{B8B8B8}: \n");
strcat(string,"{FFFFFF}- [WTx]Andrew_Manu (2015)\n");
strcat(string,"\n");
strcat(string,"{FFFFFF}> {7C7C7C}Ubicación del hosting: \n");
strcat(string,"{FFFFFF}- Miami, Estados Unidos\n");
strcat(string,"\n");
strcat(string,"{FFFFFF}> {7C7C7C}Anti-cheat: \n");
strcat(string,"{FFFFFF}- SAMPAC.xyz v0.10.0\n");
strcat(string,"\n");
strcat(string,"{FFFFFF}> {7C7C7C}Actualizaciones:\n");
strcat(string,"{FFFFFF}- {7C7C7C}[01/10/18] {FFFFFF}Se añadió el sistema de {70FBFF}ranked, {FFFFFF} para mas info /{70FBFF}ranked{B8B8B8}\n");
strcat(string,"{FFFFFF}- {7C7C7C}[18/01/19] {FFFFFF}Se solucionó el problema de nombres repetidos en el top global /{70FBFF}top{B8B8B8}\n");
strcat(string,"{FFFFFF}- {7C7C7C}[28/01/19] {FFFFFF}Se añadió un{70FBFF}anti-cheat {FFFFFF}al servidor{B8B8B8}\n");
strcat(string,"\n");
strcat(string,"{FFFFFF} {7C7C7C}Contactos:\n");
strcat(string,"{FFFFFF}- wtxclanx@hotmail.com\n");
strcat(string,"{FFFFFF}- danis1999@gmail.com\n");
strcat(string,"\n");
strcat(string,"{FFFFFF}¤ {B8B8B8}Versión: {70FBFF}4.3b{B8B8B8}\n");
strcat(string,"\n");
ShowPlayerDialog(playerid,3,0,"Información sobre el servidor:",string,"Ok","");
return true;
}
QCMD:cmds(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

new string[2000];
strcat(string,"\n");
strcat(string,"{FF0000}Jugadores:\n");
strcat(string,"{FF0000}/{FFFFFF}equipo {FF0000}- {C3C3C3}cambias de equipo.\n");
strcat(string,"{FF0000}/{FFFFFF}kill {FF0000}- {C3C3C3}te suicidas por pendejo.\n");
strcat(string,"{FF0000}/{FFFFFF}unbug {FF0000}- {C3C3C3}te respawnea al spawn de tu equipo.\n");
strcat(string,"{FF0000}/{FFFFFF}pm {B8B8B8}[texto] {FF0000}- {C3C3C3}envias un mensaje privado a tal usuario.\n");
strcat(string,"{FF0000}/{FFFFFF}stats {B8B8B8}[id] {FF0000}- {C3C3C3}muestra todos los datos de tal jugador.\n");
strcat(string,"{FF0000}/{FFFFFF}hora {B8B8B8}[id] {FF0000}- {C3C3C3}cambias la hora de tu gta.\n");
strcat(string,"{FF0000}/{FFFFFF}clima {B8B8B8}[id] {FF0000}- {C3C3C3}cambias el clima de tu gta.\n");
strcat(string,"{FF0000}/{FFFFFF}admins {FF0000}- {C3C3C3}te muestra los administradores conectados.\n");
strcat(string,"{FF0000}/{FFFFFF}skin {B8B8B8}[id] {FF0000}- {C3C3C3}cambias el skin de tu peronsaje.\n");
strcat(string,"{FF0000}/{FFFFFF}info {FF0000}- {C3C3C3}te muestra la información del servidor.\n");
strcat(string,"{FF0000}/{FFFFFF}nomusica {FF0000}- {C3C3C3}desactivas la música que puso un administrador.\n");
strcat(string,"{FF0000}/{FFFFFF}reparar {FF0000}- {C3C3C3}reparas tu auto.\n");
strcat(string,"{FF0000}/{FFFFFF}color {B8B8B8}[id] [id2]{FF0000}- {C3C3C3}cambias el color de tu auto.\n");
strcat(string,"{FF0000}/{FFFFFF}rw {FF0000}- {C3C3C3}activas/desactivas el pack de armas RW.\n");
strcat(string,"{FF0000}/{FFFFFF}ww {FF0000}- {C3C3C3}activas/desactivas el pack de armas WW.\n");
strcat(string,"{FF0000}/{FFFFFF}top {FF0000}- {C3C3C3}top de jugadores conectados.\n");
strcat(string,"\n");
strcat(string,"{70FBFF}Espectadores:\n");
strcat(string,"{70FBFF}/{FFFFFF}spec {B8B8B8}[id]{70FBFF}- {C3C3C3}acosas a un jugador.\n");
strcat(string,"{70FBFF}/{FFFFFF}specoff {70FBFF}- {C3C3C3}dejas de acosar a un jugador.\n");
strcat(string,"{70FBFF}/{FFFFFF}jetpack {70FBFF}- {C3C3C3}sacas un jetpack para observar la partida.\n");
strcat(string,"{70FBFF}/{FFFFFF}x1 {70FBFF}- {C3C3C3}arena de duelos a armas rápidas.\n");
strcat(string,"{70FBFF}/{FFFFFF}x1w {70FBFF}- {C3C3C3}arena de duelos a armas lentas.\n");
strcat(string,"{70FBFF}/{FFFFFF}derby {70FBFF}- {C3C3C3}vas al minijuego de derby.\n");
ShowPlayerDialog(playerid,3,0,"{FFFFFF}Comandos normales:",string,"Salir","");
return true;
}

QCMD:acmds(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");

if(Admin[playerid] < 1) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}1 {FFFFFF}pueden usar este comando.");
new string[3000];
if(Admin[playerid] >= 1){
strcat(string,"{B8B8B8}Admin nivel {70FBFF}1{B8B8B8}:\n");
strcat(string,"\n");
strcat(string,"{70FBFF}/{FFFFFF}cambiarmapa {70FBFF}- {C3C3C3}cambias el mapa del servidor.\n");
strcat(string,"{70FBFF}/{FFFFFF}parar {70FBFF}- {C3C3C3}pausas la partida en proceso.\n");
strcat(string,"{70FBFF}/{FFFFFF}empezar {70FBFF}- {C3C3C3}empiezas o renaudas la partida parada.\n");
strcat(string,"{70FBFF}/{FFFFFF}contar {B8B8B8}[num] {70FBFF}- {C3C3C3}haces un conteo para todos los usuarios.\n");
strcat(string,"{70FBFF}/{FFFFFF}congelar {B8B8B8}[id] {70FBFF}- {C3C3C3}congelas a un usuario.\n");
strcat(string,"{70FBFF}/{FFFFFF}descongelar {B8B8B8}[id] {70FBFF}- {C3C3C3}descongelas al usuario.\n");
strcat(string,"{70FBFF}/{FFFFFF}spawn {B8B8B8}[id] {70FBFF}- {C3C3C3}vuelve a un jugador al spawn de su equipo.\n");
strcat(string,"{70FBFF}/{FFFFFF}spawnall {70FBFF}- {C3C3C3}vuelve a todos los usuarios al spawn de sus equipos.\n");
strcat(string,"{70FBFF}/{FFFFFF}hp {B8B8B8}[id] {70FBFF}- {C3C3C3}le renegeras la vida a tal usuario.\n");
strcat(string,"{70FBFF}/{FFFFFF}hpall {70FBFF}- {C3C3C3}le regeneras la vida a todos los usuarios.\n");
strcat(string,"{70FBFF}/{FFFFFF}armour {B8B8B8}[id] {70FBFF}- {C3C3C3}le renegeras la armadura a tal usuario.\n");
strcat(string,"{70FBFF}/{FFFFFF}armourall {70FBFF}- {C3C3C3}le das chaleco a todos los usuarios menos a los espectadores.\n");
strcat(string,"{70FBFF}/{FFFFFF}fps {B8B8B8}[id]{70FBFF}- {C3C3C3}muestra los fps de tal jugador.\n");
strcat(string,"{70FBFF}/{FFFFFF}fpsall {70FBFF}- {C3C3C3}muestra todos los fps de los usuarios conectados.\n");
strcat(string,"{70FBFF}/{FFFFFF}pl {B8B8B8}[id]{70FBFF}- {C3C3C3}muestra el packet loss de tal jugador.\n");
strcat(string,"{70FBFF}/{FFFFFF}plall {70FBFF}- {C3C3C3}muestra todos los pl de los usuarios conectados.\n");
strcat(string,"{70FBFF}/{FFFFFF}score {B8B8B8}[id] {70FBFF}- {C3C3C3}muestra el scorex1 de tal jugador.\n");
strcat(string,"{70FBFF}/{FFFFFF}scoreall {70FBFF}- {C3C3C3}muestra todos los scores de los usuarios conectados.\n");
strcat(string,"{70FBFF}/{FFFFFF}puntajenaranja {B8B8B8}[num] {70FBFF}- {C3C3C3}especificas un valor al equipo naranja.\n");
strcat(string,"{70FBFF}/{FFFFFF}rondasnaranja {B8B8B8}[num] {70FBFF}- {C3C3C3}especificas las rondas al equipo naranja.\n");
strcat(string,"{70FBFF}/{FFFFFF}puntajeverde {B8B8B8}[num] {70FBFF}- {C3C3C3}'                            ' verde.\n");
strcat(string,"{70FBFF}/{FFFFFF}rondasverde {B8B8B8}[num] {70FBFF}- {C3C3C3}'                             ' verde.\n");
strcat(string,"{70FBFF}/{FFFFFF}nequipo {B8B8B8}[0/1] {70FBFF}- {C3C3C3}cambias el nombre de tal equipo.\n");
strcat(string,"{70FBFF}/{FFFFFF}naranja {B8B8B8}[id] {70FBFF}- {C3C3C3}cambias a un jugador al equipo naranja.\n");
strcat(string,"{70FBFF}/{FFFFFF}verde {B8B8B8}[id] {70FBFF}- {C3C3C3}'                           ' verde.\n");
strcat(string,"{70FBFF}/{FFFFFF}reseteartodo {70FBFF}- {C3C3C3}reseteas todos los puntajes actuales.\n");
strcat(string,"{70FBFF}/{FFFFFF}auto {B8B8B8}[id] {70FBFF}- {C3C3C3}creas un auto.\n");
strcat(string,"{70FBFF}/{FFFFFF}eliminarautos {70FBFF}- {C3C3C3}eliminas todos los autos.\n");
strcat(string,"{70FBFF}/{FFFFFF}refrescarobjetos {70FBFF}- {C3C3C3}reinicias los objetos.\n");
strcat(string,"{70FBFF}/{FFFFFF}bloqequipos {B8B8B8}[0/1] {70FBFF}- {C3C3C3}bloqueas tal equipo para que nadie pueda acceder.\n");
strcat(string,"{70FBFF}/{FFFFFF}asay {B8B8B8}[texto] {70FBFF}- {C3C3C3}mensaje personalizado para el administrador.\n");
}
ShowPlayerDialog(playerid,3,0,"{FFFFFF}Comandos de administrador nivel bajo:",string,"Salir","");
return true;
}
QCMD:acmds2(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 2) return SendClientMessage(playerid, 0xFF0000FF, "{FFFFFF}Solo los administradores con nivel {007C0E}2 {FFFFFF}y {007C0E}3 {FFFFFF}pueden usar este comando.");
new string[3000];
if(Admin[playerid] >= 2){
strcat(string,"{B8B8B8}Admin nivel {007C0E}2{B8B8B8}:\n");
strcat(string,"\n");
strcat(string,"{007C0E}/{FFFFFF}mute {B8B8B8}[id] {007C0E}- {C3C3C3}muteas a tal usuario.\n");
strcat(string,"{007C0E}/{FFFFFF}unmute {B8B8B8}[id] {007C0E}- {C3C3C3}desmuteas al usuario.\n");
strcat(string,"{007C0E}/{FFFFFF}kick {B8B8B8}[id] {007C0E}- {C3C3C3}echas a un usuario del servidor.\n");
strcat(string,"{007C0E}/{FFFFFF}cc {007C0E}- {C3C3C3}borras el chatlog.\n");
strcat(string,"{007C0E}/{FFFFFF}musica {007C0E}- {C3C3C3}pones una música para todos los usuarios.\n");
strcat(string,"{007C0E}/{FFFFFF}slap {B8B8B8}[id] {007C0E}- {C3C3C3}ejectas a un jugador en su posición.\n");
strcat(string,"{007C0E}/{FFFFFF}traer {B8B8B8}[id] {007C0E}- {C3C3C3}traes a tu posición a tal usuario.\n");
strcat(string,"{007C0E}/{FFFFFF}ir {B8B8B8}[id] {007C0E}- {C3C3C3}vas a la posición de tal usuario.\n");
}
if(Admin[playerid] >= 3){
strcat(string,"\n");
strcat(string,"{B8B8B8}Admin nivel {FF7B00}3{B8B8B8}:\n");
strcat(string,"\n");
strcat(string,"{FF7B00}/{FFFFFF}fakechat {B8B8B8}[id] [texto] {FF7B00}- {C3C3C3}mandas un mensaje falso con el nick de tal usuario.\n");
strcat(string,"{FF7B00}/{FFFFFF}crash {B8B8B8}[id] [texto] {FF7B00}- {C3C3C3}crasheas a tal usuario.\n");
strcat(string,"{FF7B00}/{FFFFFF}ban {B8B8B8}[id] [razón] {FF7B00}- {C3C3C3}baneas a un jugador del server.\n");
strcat(string,"{FF7B00}/{FFFFFF}ann2 {B8B8B8}[texto] {FF7B00}- {C3C3C3}anuncio personalizado para admin nivel 3.\n");
strcat(string,"{FF7B00}/{FFFFFF}hablar {B8B8B8}[texto] {FF7B00}- {C3C3C3}mandas un mensaje de voz para todos los usuarios.\n");
strcat(string,"{FF7B00}/{FFFFFF}bloqserver {B8B8B8}[contraseñas] {FF7B00}- {C3C3C3}bloqueas el servidor con una contraseña.\n");
strcat(string,"{FF7B00}/{FFFFFF}desbloqserver {FF7B00}- {C3C3C3}desbloqueas el servidor..\n");
strcat(string,"{FF7B00}/{FFFFFF}abrirx1 {FF7B00}- {C3C3C3}abres las arenas x1.\n");
strcat(string,"{FF7B00}/{FFFFFF}cerrarx1 {FF7B00}- {C3C3C3}cierras las arenas x1 (respawnea a todos los jugadores).\n");
strcat(string,"{FF7B00}/{FFFFFF}fpslimite {B8B8B8}[0/1] {FF7B00}- {C3C3C3}activas el limite de fps, esto kickeara a los jugadores.\n");
strcat(string,"{FF7B00}/{FFFFFF}pinglimite {B8B8B8}[0/1] {FF7B00}- {C3C3C3}activas el limite de ping, esto kickeara a los jugadores.\n");
strcat(string,"{FF7B00}/{FFFFFF}minfps {B8B8B8}[25/40] {FF7B00}- {C3C3C3}especificas el minimo de fps.\n");
strcat(string,"{FF7B00}/{FFFFFF}maxping {B8B8B8}[220/500] {FF7B00}- {C3C3C3}especificas el máximo de ping.\n");
strcat(string,"{FF7B00}/{FFFFFF}setscorex1 {B8B8B8}[id] [cantidad] {FF7B00}- {C3C3C3}especificas el score X1 de tal jugador.\n");
strcat(string,"{FF7B00}/{FFFFFF}setadmin {B8B8B8}[0/3] {FF7B00}- {C3C3C3}das nivel admin a tal usuario o se lo quitas.\n");
strcat(string,"{FF7B00}/{FFFFFF}abrirderby {FF7B00}- {C3C3C3}abres las arenas de derby.\n");
strcat(string,"{FF7B00}/{FFFFFF}cerrarderby {FF7B00}- {C3C3C3}cierras las arenas de derby.\n");
strcat(string,"{FF7B00}/{FFFFFF}maxderby {B8B8B8}[2/8] {FF7B00}- {C3C3C3}le pones un limite de jugadores al derby.\n");
strcat(string,"{FF7B00}/{FFFFFF}desbugderby {FF7B00}- {C3C3C3}desbugeas el derby.\n");
}
ShowPlayerDialog(playerid,3,0,"{FFFFFF}Comandos de administrador nivel alto:",string,"Salir","");
return true;
}

QCMD:ranked(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
new string[2000];
strcat(string,"\n");
strcat(string,"{FFFFFF}Ganar puntos:\n");
strcat(string,"{7C7C7C}> {B8B8B8} Para subir de nivel tienes que jugar 1v1 con las rondas que quieras mientras sea a 10 de score o mayor ({FF7B00}1x10{7C7C7C}).\n");
strcat(string,"\n");
strcat(string,"{7C7C7C}> {59FF2B}Ganando{B8B8B8}:\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si ganas a un jugador que tenga más nivel, {59FF2B}+8 {B8B8B8}puntos.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si ganas a un jugador que tenga el mismo nivel, {59FF2B}+5 {B8B8B8}puntos.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si ganas a un jugador que tenga menos nivel, {59FF2B}+1 {B8B8B8}puntos.\n");
strcat(string,"\n");
strcat(string,"{7C7C7C}> {DB0000}Perdiendo{B8B8B8}:\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si pierdes contra un jugador que tenga más nivel, {DB0000}-1 {B8B8B8}puntos.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si pierdes contra un jugador que tenga el mismo nivel, {DB0000}-4 {B8B8B8}puntos.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Si pierdes contra un jugador que tenga menos nivel, {DB0000}-8 {B8B8B8}puntos.\n");
strcat(string,"\n");
strcat(string,"{7C7C7C}> {F7D91B}Norma de puntaje{B8B8B8}:\n");
strcat(string,"{7C7C7C}- {B8B8B8}Ejemplo: tienes {F7D91B}1.500 p {B8B8B8}.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Un jugador tendrá mayor nivel a ti cuando sobrepase tu puntaje sumado por 100, osea mayor a {F7D91B}1600 p{B8B8B8}.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Un jugador tendrá menor nivel a ti cuando tenga menor puntaje al tuyo restado por 100, osea menor a {F7D91B}1400 p{B8B8B8}.\n");
strcat(string,"{7C7C7C}- {B8B8B8}Un jugador tendrá tu mismo nivel cuando esté en el medio del mayor y menor, osea mayor a {F7D91B}1400 p{B8B8B8} y menor a {F7D91B}1600 p{B8B8B8}.\n");
strcat(string,"\n");
/*strcat(string,"{FFFFFF}\t\t               Cuentas:\n");
strcat(string,"{7C7C7C}> {B8B8B8}Las cuentas se reinician cada cierto tiempo, por lo tanto el nivel de\n");
strcat(string,"{B8B8B8}administrador también, esto se hace para no tener 'lag' en el servidor\n");
strcat(string,"{B8B8B8}ya que es hosteado con un servidor gratis (Ultra-H)\n");
strcat(string,"{7C7C7C}¤ {B8B8B8}Próximo reseteo de cuentas: {FF7B00}no se van a resetear\n");
strcat(string,"\n");
*/ShowPlayerDialog(playerid,3,0,"{FFFFFF}RANKED:",string,"Ok","");
return true;
}

QCMD:rg(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
new string[600];
strcat(string,"\n");
strcat(string,"{FFFFFF}¤ {FF7B00}'RG' {FFFFFF}es una abreviación de {FF7B00}'revisión de gta'{20FCE2}.\n");
strcat(string,"{FFFFFF}¤ {FFFFFF}En este procedimiento un admin encargado revisará tu carpeta de GTA para comprobar si juegas como todos sin ventaja alguna.\n");
strcat(string,"{FFFFFF}¤ {FFFFFF}Se hace a través de un {FF7B00}.exe {FFFFFF}llamado {FF7B00}anydesk{FFFFFF} que pesa tan solo {FF7B00}2MB\n{20FCE2}\n");
strcat(string,"{FFFFFF}¤ {FFFFFF}Después de descargarlo tendrás que pasarle tu {FF7B00}ID{FFFFFF} al administrador y empezar la revisión.");
ShowPlayerDialog(playerid,3,0,"{FFFFFF}Revisión de GTA:",string,"Ok","");
return true;
}

QCMD:refrescarobjetos(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(EstaEnX1[playerid] > 0) return SCM(playerid,COLOR_WHITE,"{FFFFFF}No puedes usar este comando en la arena, usa /salir.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
RecreateObject();
RefreshObject();
Crear_lista();
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} refrescó los objetos.",nombre(playerid));
return true;
}

QCMD:auto(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
if(isnull(params)) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/auto [400 : 611]");
new id = strval(params);
if(id > 611 || id < 400) return SCM(playerid,0xFF0000FF,"{FFFFFF}Uso correcto del comando: {007C0E}/auto [400 : 611]");
if(Cont_vehiculos == 50) return SCM(playerid,0xFF0000FF,"{FFFFFF}Se llegó al limite de autos, para eliminarlos: {007C0E}/eliminarautos");
new Float:X,Float:Y,Float:Z,Float:A;
GetPlayerPos(playerid, X,Y,Z);
GetPlayerFacingAngle(playerid, A);
Vehiculos[Cont_vehiculos] = CreateVehicle(id,X+5,Y+5,Z,A+90,random(128),random(128),-1);
Cont_vehiculos++;
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} creo un auto con id: {007C0E}%d {B8B8B8}(%d/50)",nombre(playerid),id,Cont_vehiculos);
return true;
}


QCMD:color(){
if(GetPlayerState(playerid) != 2) return SendClientMessage(playerid, COLOR_WHITE, "{B8B8B8}Necesitas estar en un auto para este comando.");
new color[2];
if(sscanf(params, "iI(-1)", color[0], color[1])){ return SendClientMessage(playerid, COLOR_WHITE, "{FFFFFF}Uso correcto del comando: {007C0E}/color [color1] [color2]");}
if(color[1] == -1) color[1] = color[0];
new szSuccess[44];
format(szSuccess, sizeof(szSuccess), "{B8B8B8}Se ha cambiado el color de tu auto.");
SendClientMessage(playerid, COLOR_WHITE, szSuccess);
ChangeVehicleColor(GetPlayerVehicleID(playerid), color[0], color[1]);
return 1;
}

QCMD:eliminarautos(){
if(EstaEnDerby[playerid] > 0) return SendClientMessage(playerid, COLOR_WHITE ,"{FFFFFF}Te encuentras en una arena de derby, para salir usa {007C0E}/salirderby");
if(Sospechoso[playerid] == 1) return SCM(playerid,COLOR_WHITE,"{FFFFFF}- {20FCE2}Por favor descarga anydesk: {FF7B00}anydesk.es/download {20FCE2}para proceder.");
if(Admin[playerid] < 1) return SCM(playerid,0xFF0000FF,"{FFFFFF}No tienes {007C0E}nivel.");
for(new i; i < Cont_vehiculos;i++){
DestroyVehicle(Vehiculos[i]);
}
SCMTAF(COLOR_WHITE,"{B8B8B8}%s{FFFFFF} eliminó todos los autos {B8B8B8}(%d)",nombre(playerid),Cont_vehiculos);
Cont_vehiculos = 0;
return true;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys){
	if(Spec[playerid] > -1){
		if(newkeys == KEY_WALK){
			new nasiel = -1;
			for(new id=Spec[playerid]-1; id <= 0;id--){
				if(IsPlayerConnected(id)){
					if(GetPlayerState(id) != PLAYER_STATE_SPECTATING){
						nasiel = id;
						break;
					}
				}
			}
		if(nasiel != -1){
			Spec[playerid] = nasiel;
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayerEx(playerid, nasiel);
		}else{
		for(new id=Spec[playerid]+1; id <= Connects;id++){
			if(id == Spec[playerid]) break;
				if(IsPlayerConnected(id)){
					if(GetPlayerState(id) != PLAYER_STATE_SPECTATING){
						nasiel = id;
						break;
					}
				}
			}
			if(nasiel != -1){
				Spec[playerid] = nasiel;
				TogglePlayerSpectating(playerid, 1);
				PlayerSpectatePlayerEx(playerid, nasiel);
			}
		}
	}
	else if(newkeys == KEY_JUMP){
		new nasiel = -1;
		for(new id=Spec[playerid]+1; id <= Connects;id++){
			if(id == Spec[playerid]) break;
			if(IsPlayerConnected(id)){
				if(GetPlayerState(id) != PLAYER_STATE_SPECTATING){
					nasiel = id;
					break;
				}
			}
		}
	if(nasiel != -1){
		Spec[playerid] = nasiel;
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayerEx(playerid, nasiel);
	}else{
	for(new id=Spec[playerid]-1; id <= 0;id--){
		if(id == Spec[playerid]) break;
		if(IsPlayerConnected(id)){
			if(GetPlayerState(id) != PLAYER_STATE_SPECTATING){
				nasiel = id;
				break;
			}
		}
	}
	if(nasiel != -1){
		Spec[playerid] = nasiel;
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayerEx(playerid, nasiel);
	}
	}
	}
	}
return true;
}



public HideWin(){
TextDrawHideForAll(Textdraw01);
TextDrawHideForAll(Textdraw101);
TextDrawHideForAll(Textdraw100);
TextDrawHideForAll(Textdraw2);
TextDrawHideForAll(Textdraw4);
TextDrawHideForAll(Textdraw5);
TextDrawHideForAll(Textdraw6);
TextDrawHideForAll(Textdraw7);
TextDrawHideForAll(Textdraw8);
TextDrawHideForAll(Textdraw9);
TextDrawHideForAll(Textdraw10);
TextDrawHideForAll(Textdraw11);
TextDrawHideForAll(Textdraw12);
TextDrawHideForAll(Textdraw13);
TextDrawHideForAll(Textdraw14);
ForPlayers(i){
	TogglePlayerControllable(i,1);
	//SetPlayerScore(i,0);
	Kills[i] = 0;
	Muertes[i] = 0;
	Equipo_kills[i] = 0;
}
return true;
}

stock Nombre_mapa(id){
	new s[25];
	if(id == 0){
		format(s,25,"Las Venturas");
		SendRconCommand("mapname Las Venturas");
	}else if(id == 1){
		format(s,25,"Aeropuerto-LV");
		SendRconCommand("mapname Aeropuerto LV");
	}else if(id == 2){
		format(s,25,"Aeropuerto-SF");
		SendRconCommand("mapname Aeropuerto SF");
	}else if(id == 3){
		format(s,25,"Auto-escuela");
		SendRconCommand("mapname Auto-escuela");
	}else if(id == 4){
		format(s,25,"Omega");
		SendRconCommand("mapname Omega");
	}else if(id == 5){
		format(s,25,"Aeropuerto-SF-V2");
		SendRconCommand("mapname AeropuertoSF2");
	}else if(id == 6){
		format(s,25,"Aeropuerto LS");
		SendRconCommand("mapname Aeropuerto LS");
	}else{
		format(s,25,"Woozy");
		SendRconCommand("mapname Woozy");
	}
return s;
}

stock Estadisticas(){
new string[50];
if(Modo_juego == 0){
format(string,50,"Modo [%s]",CWTG(Modo_juego));
}else{
format(string,50,"[%s %d vs %d %s] [%s]",Nombre_equipo[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE],Nombre_equipo[EQUIPO_VERDE],CWTG(Modo_juego));
}
SetGameModeText(string);
return string;
}

stock CWTG(id){
new s[25];
if(id == 0) format(s,25,"TG");
else if (id == 1) format(s,25,"CW");
return s;
}


public OnPlayerCommandText(playerid,cmdtext[]){
return OnPlayerCommand(playerid,cmdtext);
}

stock nombre(playerid){
new n[MAX_PLAYER_NAME];
GetPlayerName(playerid,n,MAX_PLAYER_NAME);
return n;
}

stock ClearKillList()
{
   for(new l=0; l<6; l++) SendDeathMessage(202, 202, 202);
}

stock RefreshObject(){
new str[200];
format(str,200,"{FF8B00}%d{FFFFFF}:{007C0E}%d{FFFFFF}\n{E17B00}%d{FFFFFF}:{005904}%d{FFFFFF}",Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE]);
for(new i; i < 11;i++){
DestroyObject(Objectos[i]);
Objectos[i] = CreateObject(7914, Objects[i][0], Objects[i][1], Objects[i][2],   0.00, 0.00,  Objects[i][3]);
SetObjectMaterialText(Objectos[i],str, 0, OBJECT_MATERIAL_SIZE_256x128,"Arial", 60, 0, 0x00000000, 0x00000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
}

}
/*
        Object[0] = CreateObject(7914, 1337.74, 2094.88, 20.58,   0.00, 0.00, 180.00);
        Object[1] = CreateObject(7914, 1292.11, 2143.55, 20.14,   0.00, 0.00, 90.00);
        Object[2] = CreateObject(7914, 1663.00, 8293.00, 734.00,   0.00, 0.00, 0.00);
        Object[3] = CreateObject(7914, 1664.21, 734.22, 13.11,   0.00, 0.00, 0.00);
        Object[4] = CreateObject(7914, 1663.94, 706.63, 13.11,   0.00, 0.00, 180.04);
        Object[5] = CreateObject(7914, -1234.09, -84.41, 16.39,   0.00, 0.00, -44.94);
        Object[6] = CreateObject(7914, -1195.23, -131.88, 16.39,   0.00, 0.00, -44.94);
        Object[7] = CreateObject(7914, -2096.01, -188.82, 37.45,   0.00, 0.00, 90.04);
        Object[8] = CreateObject(7914, -2011.62, -189.27, 37.45,   0.00, 0.00, -90.04);
*/
stock Crear_lista(){
new Lista_top[1], str[300];
format(str,200,"{FFFFFF}- Top players\n{FFFFFF}1. {007C0E}%s{FFFFFF}\n{FFFFFF}2. {007C0E}%s\n{FFFFFF}3. {007C0E}%s\n{FFFFFF}4. {007C0E}%s\n{FFFFFF}5. {007C0E}%s",Nick_top[0], Nick_top[1],Nick_top[2],Nick_top[3], Nick_top[4]);
Lista_top[0] = CreateObject(7914, -1210.7330, -30.1462, 28.3699, 0.00, 0.00, 0);
SetObjectMaterialText(Lista_top[0], str, 0, OBJECT_MATERIAL_SIZE_256x128 ,"Corbel", 20, 0, 0x00000000, 0x00000000, OBJECT_MATERIAL_TEXT_ALIGN_LEFT);
}

stock RecreateObject(){
new str[200];
format(str,200,"{FF8B00}%d{FFFFFF}:{007C0E}%d{FFFFFF}\n{E17B00}%d{FFFFFF}:{005904}%d{FFFFFF}",Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE],Equipo_rondas[EQUIPO_NARANJA],Equipo_rondas[EQUIPO_VERDE]);
//format(str,100,"{FFFFFF}[{830000}%d{FFFFFF} : {007C0E}%d{FFFFFF}]",Equipo_puntaje[EQUIPO_NARANJA],Equipo_puntaje[EQUIPO_VERDE]);
for(new i; i < 11;i++){
DestroyObject(Objectos[i]);
Objectos[i] = CreateObject(7914, Objects[i][0], Objects[i][1], Objects[i][2],   0.00, 0.00,  Objects[i][3]);
SetObjectMaterialText(Objectos[i],str, 0, OBJECT_MATERIAL_SIZE_256x128,"Arial", 60, 0, 0x00000000, 0x00000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
}


}

stock OnPlayerCommand(playerid,command[])
{
        new     cmd[50],callback[55], params[128], size, len = strlen(command),help;
                for(new i; i < len;i++){
                if(command[i] != ' '){
                if(command[i] >= 'A' && command[i] <= 'Z'){
                command[i] += 32;
                }
                }else{
                size = i;
                break;
                }}

                if(size > 0){
                strmid(cmd,command,1,size,50);
                strmid(params,command,size+1,len,128);
                }else{
                format(cmd,50,command[1]);
                }

        if(!params[0]) params = " ";
        if(!strcmp(params,"help")) help = 1;
        format(callback,50,"cmd_%s",cmd);
                if(CallLocalFunction(callback,"isi",playerid,params,help))
        {
                return true;
                        }else{
                        return false;
        }
}

stock GetPlayerFPS(playerid) return pFPS[playerid];


stock DelChar(tstring[])
{
new ln = strlen(tstring);
if(tstring[ln-2] == '\r')tstring[ln-2] = '\0';
if(tstring[ln-1] == '\n')tstring[ln-1] = '\0';
}

stock fcreate(file[])
    {
        if(fexist(file)) return false;
        new File:cFile = fopen(file,io_write);
        return fclose(cFile);
    }

stock num_hash(buf[])
 {
        new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++) {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
 }

stock qhash(str2[]) {
   new tmpdasdsa[128];
   tmpdasdsa[0]=0;
   valstr(tmpdasdsa,num_hash(str2));
   return tmpdasdsa;
}


stock sscanf(string[], format[], {Float,_}:...)
{
        #if defined isnull
                if (isnull(string))
        #else
                if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
        #endif
                {
                        return format[0];
                }
        #pragma tabsize 4
        new
                formatPos = 0,
                stringPos = 0,
                paramPos = 2,
                paramCount = numargs(),
                delim = ' ';
        while (string[stringPos] && string[stringPos] <= ' ')
        {
                stringPos++;
        }
        while (paramPos < paramCount && string[stringPos])
        {
                switch (format[formatPos++])
                {
                        case '\0':
                        {
                                return 0;
                        }
                        case 'i', 'd':
                        {
                                new
                                        neg = 1,
                                        num = 0,
                                        ch = string[stringPos];
                                if (ch == '-')
                                {
                                        neg = -1;
                                        ch = string[++stringPos];
                                }
                                do
                                {
                                        stringPos++;
                                        if ('0' <= ch <= '9')
                                        {
                                                num = (num * 10) + (ch - '0');
                                        }
                                        else
                                        {
                                                return -1;
                                        }
                                }
                                while ((ch = string[stringPos]) > ' ' && ch != delim);
                                setarg(paramPos, 0, num * neg);
                        }
                        case 'h', 'x':
                        {
                                new
                                        num = 0,
                                        ch = string[stringPos];
                                do
                                {
                                        stringPos++;
                                        switch (ch)
                                        {
                                                case 'x', 'X':
                                                {
                                                        num = 0;
                                                        continue;
                                                }
                                                case '0' .. '9':
                                                {
                                                        num = (num << 4) | (ch - '0');
                                                }
                                                case 'a' .. 'f':
                                                {
                                                        num = (num << 4) | (ch - ('a' - 10));
                                                }
                                                case 'A' .. 'F':
                                                {
                                                        num = (num << 4) | (ch - ('A' - 10));
                                                }
                                                default:
                                                {
                                                        return -1;
                                                }
                                        }
                                }
                                while ((ch = string[stringPos]) > ' ' && ch != delim);
                                setarg(paramPos, 0, num);
                        }
                        case 'c':
                        {
                                setarg(paramPos, 0, string[stringPos++]);
                        }
                        case 'f':
                        {

                                new changestr[16], changepos = 0, strpos = stringPos;
                                while(changepos < 16 && string[strpos] && string[strpos] != delim)
                                {
                                        changestr[changepos++] = string[strpos++];
                                }
                                changestr[changepos] = '\0';
                                setarg(paramPos,0,_:floatstr(changestr));
                        }
                        case 'p':
                        {
                                delim = format[formatPos++];
                                continue;
                        }
                        case '\'':
                        {
                                new
                                        end = formatPos - 1,
                                        ch;
                                while ((ch = format[++end]) && ch != '\'') {}
                                if (!ch)
                                {
                                        return -1;
                                }
                                format[end] = '\0';
                                if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
                                {
                                        if (format[end + 1])
                                        {
                                                return -1;
                                        }
                                        return 0;
                                }
                                format[end] = '\'';
                                stringPos = ch + (end - formatPos);
                                formatPos = end + 1;
                        }
                        case 'u':
                        {
                                new
                                        end = stringPos - 1,
                                        id = 0,
                                        bool:num = true,
                                        ch;
                                while ((ch = string[++end]) && ch != delim)
                                {
                                        if (num)
                                        {
                                                if ('0' <= ch <= '9')
                                                {
                                                        id = (id * 10) + (ch - '0');
                                                }
                                                else
                                                {
                                                        num = false;
                                                }
                                        }
                                }
                                if (num && IsPlayerConnected(id))
                                {
                                        setarg(paramPos, 0, id);
                                }
                                else
                                {
                                        #if !defined foreach
                                                #define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
                                                #define __SSCANF_FOREACH__
                                        #endif
                                        string[end] = '\0';
                                        num = false;
                                        new
                                                name[MAX_PLAYER_NAME];
                                        id = end - stringPos;
                                        foreach (Player, playerid)
                                        {
                                                GetPlayerName(playerid, name, sizeof (name));
                                                if (!strcmp(name, string[stringPos], true, id))
                                                {
                                                        setarg(paramPos, 0, playerid);
                                                        num = true;
                                                        break;
                                                }
                                        }
                                        if (!num)
                                        {
                                                setarg(paramPos, 0, INVALID_PLAYER_ID);
                                        }
                                        string[end] = ch;
                                        #if defined __SSCANF_FOREACH__
                                                #undef foreach
                                                #undef __SSCANF_FOREACH__
                                        #endif
                                }
                                stringPos = end;
                        }
                        case 's', 'z':
                        {
                                new
                                        i = 0,
                                        ch;
                                if (format[formatPos])
                                {
                                        while ((ch = string[stringPos++]) && ch != delim)
                                        {
                                                setarg(paramPos, i++, ch);
                                        }
                                        if (!i)
                                        {
                                                return -1;
                                        }
                                }
                                else
                                {
                                        while ((ch = string[stringPos++]))
                                        {
                                                setarg(paramPos, i++, ch);
                                        }
                                }
                                stringPos--;
                                setarg(paramPos, i, '\0');
                        }
                        default:
                        {
                                continue;
                        }
                }
                while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
                {
                        stringPos++;
                }
                while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
                {
                        stringPos++;
                }
                paramPos++;
        }
        do
        {
                if ((delim = format[formatPos++]) > ' ')
                {
                        if (delim == '\'')
                        {
                                while ((delim = format[formatPos++]) && delim != '\'') {}
                        }
                        else if (delim != 'z')
                        {
                                return delim;
                        }
                }
        }
        while (delim > ' ');
        return 0;

    }

