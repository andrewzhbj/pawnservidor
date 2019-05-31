#define CLANES "clanes/%s.txt"
#define CLANES_REGISTRADOS      4
#define PARAMETROS              22*CLANES_REGISTRADOS

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

/* OnGameModeInit */
	new Local[100], Clan[50];
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
		 	fread(c,Local); Clan_Cganadas[x] 	= strval(Local);
  			fread(c,Local); Clan_Cperdidas[x] = strval(Local);
		}
	}
	fclose(c);
	
/* OnPlayerConnect */
	Clan_n[playerid] = -1;
	new p = 0;
 	do{
		if(strfind(nombre(playerid), Clanes[p], true) != -1){
			Clan_n[playerid] = p;
			p = 4;
		}else p++;
 	}while(p != 4);

/* OnPlayerDis */
	if(Clan_n[playerid] != -1){
		new Local[100], Clan[50], datos[128];
		new File:c;
		for(new x=0;x<CLANES_REGISTRADOS;x++){
			format(Clan, 50, "%s.txt", Clanes[x]);
			format(Local, 50, CLANES, Clan);
			if(fexist(Local)){
		        c = fopen(Local, io_write);
                format(datos, 128,"%d\r\n%d\r\n%.3f\r\n%d\r\n%d\r\n", Clan_kills[x], Clan_muertes[x], Clan_ratio[x], Clan_Cganadas[x], Clan_Cperdidas[x]);
         		fwrite(c, datos);
         		fclose(c);
			}
 		}
	}
	
/* OnPlayerDeath (CWTG) */
	if(EstaEnX1[playerid] != 0){ /* var x1 */
		if((GetPVarInt(playerid,"Logged") == 1) && (GetPVarInt(killerid,"Logged") == 1)){ /* var log */
		    if(Clan_n[playerid] != 1 && Clan_n[killerid] != 1){
		        Clan_kills[Clan_n[killerid]]++;
		        Clan_muertes[Clan_n[playerid]]--;
		    }
		}
	}
	
/* Score update (CWTG) */
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
				}
				
/* OnDialogResponse.. in switch */
    Ordenar_c(0);
	new str[600];
	format(str, sizeof(str), "{7C7C7C}p.\t{7C7C7C}Clan\t{7C7C7C}Kills\n{7C7C7C}1.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}2.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}3.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d\n{7C7C7C}4.{FFFFFF}> \t{B8B8B8}%s\t{F69521}%d",
	Clanes[Clan_id[0][0]], Clan_kills[Clan_id[0][0]], Clanes[Clan_id[0][1]], Clan_kills[Clan_id[0][1]], Clanes[Clan_id[0][2]], Clan_kills[Clan_id[0][2]], Clanes[Clan_id[0][3]], Clan_kills[Clan_id[0][3]]);
	ShowPlayerDialog(playerid, CLAN_TOP_KILLS, DIALOG_STYLE_TABLIST_HEADERS, "{F69521}Top clan kills:", str , "Ok", "");


/* Stock.. */
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
	switch(s){
	    case 0:
	    {
		for(new x=0;x<CLANES_REGISTRADOS;x++){
	            for(new y=x+1;y<CLANES_REGISTRADOS;y++){
	                if(Clan_top[x][0] < Clan_top[y][0]){
	                    aux = Clan_id[0][x];
						Clan_id[0][x] = Clan_id[0][y];
						Clan_id[0][y] = aux;
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
	 				}
     			}
     		}
		}
	}
}
