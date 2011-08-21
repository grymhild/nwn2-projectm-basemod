/** @file
* @brief Include file for Macros and related User Interfaces, and the theatre scripting language
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


// need to remove this code as well somehow, used to equip weapons

//#include "nw_i0_generic"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_UI"
#include "_CSLCore_Player"
#include "_CSLCore_Reputation"
#include "_CSLCore_Items"
//:://////////////////////////////////////////////////
//:: dstl_include
/*
v2.07
	Include for the DS-TL (see dstl_hbdirector)
constants, wrapper and service routines, debugging

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

//#include "nw_i0_generic"
//#include "nw_i0_plot"
//#include "x0_i0_stringlib"

// * Function declarations

/*
// ds-tl: Use this to pause the director. The functions stack
void dstl_pausedirector(object director);

// ds-tl: Use this to unpause the director. The functions stack
void dstl_unpausedirector(object director);

// ds-tl: returns if item is a valid dstl book
int dstl_isvaliddstlbook(object item);


// ds-tl: The GetObjectByTag of the ds-tl. You should use this when it concerns the ds-tl
object dstl_getobjectbytagwrapper(string tag); //, object target=OBJECT_SELF, int n=1);

// ds-tl: PRIVATE. Don't use. Throw an error
void dstl_error(string st);

// ds-tl: PRIVATE. Don't use. Debug out. Will be commented out for retail
//void dstl_dbg_sndmsg(string st);

// ds-tl: PRIVATE. Don't use
int dstl_isbusy(object o);

// ds-tl: PRIVATE. Don't use
void dstl_pushstacki(object o, int i);

// ds-tl: PRIVATE. Don't use
int dstl_popstacki(object o);
*/

// * Constants

const float DSTL_FORCETIMEOUT=20.0f; // in seconds
const float DSTL_MOVETODISTANCE=2.3f; // don't change - in meters

const float DSTL_JUMPWAIT=0.3f; // don't change
const float DSTL_SPECIALWAIT=0.1f; /* don't change - special wait time for
dstlcom_attack() due to some strange NWN behaviour*/

const float DSTL_MINDELAY=0.001f; // don't change - in seconds
const string DSTL_DSTLPREFIX="d_"; // for variables

// standard speed:
const float DSTL_DIVIDERSECS=6.0f;

// for you to change:
//ONLY ONE CHAR EACH!!

const string DSTL_PREFIX="[";
const string DSTL_POSTFIX="]";
const string DSTL_ENDOFLINE="\n"; // don't change
const string DSTL_SHOUTCODE="@";
const string DSTL_COMMENTOPEN="{";
const string DSTL_COMMENTCLOSE="}";
const string DSTL_DELIMITER="%"; // this is the general purpose delimiter in strings

const string DSTL_OBJECT=":";
const int DSTL_OBJECT_L=1; // string length

const string DSTL_P="P:";
const int DSTL_P_L=2;

const string DSTL_GO="GO:";
const int DSTL_GO_L=3;

const string DSTL_GODONTWAIT="GODONTWAIT:";
const int DSTL_GODONTWAIT_L=11;

const string DSTL_JUMP="JUMP:";
const int DSTL_JUMP_L=5;

const string DSTL_FACE="FACE:";
const int DSTL_FACE_L=5;

const string DSTL_FORWARD="FORWARD:";
const int DSTL_FORWARD_L=8;

const string DSTL_TURN="TURN:";
const int DSTL_TURN_L=5;

const string DSTL_USE="USE:";
const int DSTL_USE_L=4;

const string DSTL_EQUIP="EQUIP:";
const int DSTL_EQUIP_L=6;

const string DSTL_UNEQUIP="UNEQUIP:";
const int DSTL_UNEQUIP_L=8;

const string DSTL_ANIMATION="ANIMATION:";
const int DSTL_ANIMATION_L=10;

const string DSTL_SOUND="SOUND:";
const int DSTL_SOUND_L=6;

const string DSTL_VISUALEFFECTLOCATION="VISUALEFFECTLOCATION:";
const int DSTL_VISUALEFFECTLOCATION_L=21;

const string DSTL_VISUALEFFECTOBJECT="VISUALEFFECTOBJECT:";
const int DSTL_VISUALEFFECTOBJECT_L=19;

const string DSTL_CREATE="CREATE:";
const int DSTL_CREATE_L=7;

const string DSTL_CREATEITEMONOBJECT="CREATEITEMONOBJECT:";
const int DSTL_CREATEITEMONOBJECT_L=19;

const string DSTL_DESTROY="DESTROY:";
const int DSTL_DESTROY_L=8;

const string DSTL_NAME="NAME:";
const int DSTL_NAME_L=5;

const string DSTL_ATTACK="ATTACK:";
const int DSTL_ATTACK_L=7;

const string DSTL_CHANGEFACTION="CHANGEFACTION:";
const int DSTL_CHANGEFACTION_L=14;

const string DSTL_CLEARALLACTIONS="CLEARALLACTIONS:";
const int DSTL_CLEARALLACTIONS_L=16;

const string DSTL_EXECUTE="EXECUTE:";
const int DSTL_EXECUTE_L=8;

const string DSTL_SPEED="SPEED:";
const int DSTL_SPEED_L=6;

const string DSTL_SIGNALEVENT="SIGNALEVENT:";
const int DSTL_SIGNALEVENT_L=12;

const string DSTL_LOCALVAR="LOCALVAR:";
const int DSTL_LOCALVAR_L=9;

const string DSTL_VERSION="VERSION";
const int DSTL_VERSION_L=7;

const string DSTL_IF="IF:";
const int DSTL_IF_L=3;

const string DSTL_IFNOT="IFNOT:";
const int DSTL_IFNOT_L=6;

const string DSTL_ENDIF="ENDIF";
const int DSTL_ENDIF_L=5;

const string DSTL_INCLUDESTRINGVAR="INCLUDESTRINGVAR:";
const int DSTL_INCLUDESTRINGVAR_L=17;

// * Function definitions

/*
void dstl_dbg_sndmsg(string st)
{
object pc;
pc=GetFirstPC();
while (pc!=OBJECT_INVALID)
{
SendMessageToPC(pc,"<The ds-tl. Sender (tag)='"+GetTag(OBJECT_SELF)+"':> "+st);
pc=GetNextPC();
}
}
*/


void CSLMacro_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_MACRO )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	//CSLDMVariable_SetLvmTarget(oPCToShowVars, oTargetToDisplay);
	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_MACRO);
	//CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oTargetToDisplay);
	//SCCacheStats( oTargetToDisplay );
	//DelayCommand( 0.5, SCCharEdit_Build( oTargetToDisplay, oPC, sScreenName ) );
}


void dstl_error(string st)
{
	string book;
	book=GetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"book");
	st="*** scripting error of the ds-tl: '"+st+"' ! Book was tag='"+book+"'. ***";
	object pc;
	pc=GetFirstPC();
	while (pc!=OBJECT_INVALID)
	{
		SendMessageToPC(pc, st);
		pc=GetNextPC();
	}
	PlaySound("gui_error");
}


object dstl_getobjectbytagwrapper(string tag) //, object target=OBJECT_SELF, int n=1)
{
	object o;
	if (tag=="")
	{
		return(OBJECT_SELF); // fake object
	}
	else if (tag=="GETNEARESTPC")
	{
		o=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_TRUE); // fake object
		if (o==OBJECT_INVALID) o=OBJECT_SELF;
		{
			return(o);
		}
	}
	else if (GetTag(OBJECT_SELF)==tag)
	{
		return(OBJECT_SELF);
	}
	else
	{
		//o=GetNearestObjectByTag(tag,target,n);
		o=GetObjectByTag(tag);
		if (o==OBJECT_INVALID)
		{
			dstl_error("dstl_getobjectbytagwrapper. Object not found. Tag= '"+tag+"'");
		}
		return(o);
	}
}

int dstl_isbusy(object o)
{
	if (GetIsInCombat(o)==TRUE)
	{
		return TRUE;
	}
	if (IsInConversation(o)==TRUE)
	{
		return TRUE;
	}
	//if (GetIsDMPossessed(o)==TRUE) return TRUE;
	return FALSE;
}
	
int dstl_isvaliddstlbook(object item)
{
	int bi;
	
	bi=GetBaseItemType(item);
	if (( bi==BASE_ITEM_BOOK) || ( bi==BASE_ITEM_MISCMEDIUM ) )
	{
		if (GetIdentified(item)==TRUE)
		{
			if (GetGoldPieceValue(item)<10)
			{
				return TRUE;
			}
		}
	}
	return FALSE;
}

void dstl_pushstacki(object o, int i)
{
	int stacktop;
	stacktop=GetLocalInt(o,"stacktopi");
	SetLocalInt(o,"stackint_"+IntToString(stacktop),i);
	stacktop++;
	SetLocalInt(o,"stacktopi",stacktop);
}

int dstl_popstacki(object o)
{
	int i;
	int stacktop;
	stacktop=GetLocalInt(o,"stacktopi");
	if (stacktop==0)
		{
			return -9999;
		}
	stacktop--;
	i=GetLocalInt(o,"stackint_"+IntToString(stacktop));
	SetLocalInt(o,"stacktopi",stacktop);
	return i;
}

void dstl_pausedirector(object director)
{
	int phbs;
	phbs=GetLocalInt(director,DSTL_DSTLPREFIX+"pausehbs");
	dstl_pushstacki(director,phbs);
	SetLocalInt(director,DSTL_DSTLPREFIX+"phbs",-1);
}

void dstl_unpausedirector(object director)
{
	int phbs;
	phbs=dstl_popstacki(director);
	if (phbs!=-9999)
	{
		SetLocalInt(director,DSTL_DSTLPREFIX+"phbs",phbs);
	}
	else
	{
		/*
		be silent:
		dstl_error("dstl_pausedirector. director wasn't paused.");
		*/
	}
}

const string DSTL_ME="ds-tl 2.07 NWN2 retail";
const string DSTL_MECHANGEDBY="official release";

string txt; // textbuffer
int txtl; // length of text
int txtc; // read ptr into text

float dly;
string line;
int linelg;
object obj;
int phbs;
int divider;
float dividersecs;
int wcount;
float wrange;
object wobj;

int cnt2;

string para1;
string para2;
string para3;
string para4;
string para5;
string para6;
string para7;
string para8;

void dstlcom_version()
{

	string st;
	int i;
	
	for (i=0;i<10;i++)
	{
		switch(i)
		{
			case 0: st="<- - - - - SHOWING VERSION AND COMPILE - - - - ->"; break;
			case 1: st="DSTL_ME= "+DSTL_ME; break;
			case 2: st="DSTL_MECHANGEDBY= "+DSTL_MECHANGEDBY; break;
			case 3: st="DSTL_DIVIDERSECS= "+FloatToString(DSTL_DIVIDERSECS); break;
			case 4: st="DSTL_MOVETODISTANCE= "+FloatToString(DSTL_MOVETODISTANCE); break;
			case 5: st="DSTL_MINDELAY= "+FloatToString(DSTL_MINDELAY); break;
			case 6: st="DSTL_FORCETIMEOUT= "+FloatToString(DSTL_FORCETIMEOUT); break;
			case 7: st="DSTL_JUMPWAIT= "+FloatToString(DSTL_JUMPWAIT); break;
			case 8: st="DSTL_SPECIALWAIT= "+FloatToString(DSTL_SPECIALWAIT); break;
			case 9: st="<- - - - - - - - - - - - - - - - - - - - - - - ->"; break;
		}
		
		DelayCommand(dly,AssignCommand(obj,SpeakString(st)));
		dly=dly+DSTL_MINDELAY;
	}
}

void parsepara8para(string st)
{
	int cnt;
	
	cnt=FindSubString(st,",");
	if (cnt!=-1)
	{
		para1=GetStringLeft(st,cnt);
		st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
		cnt=FindSubString(st,",");
		if (cnt!=-1)
		{
			para2=GetStringLeft(st,cnt);
			st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
			cnt=FindSubString(st,",");
			if (cnt!=-1)
			{
				para3=GetStringLeft(st,cnt);
				st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
				cnt=FindSubString(st,",");
				if (cnt!=-1)
				{
					para4=GetStringLeft(st,cnt);
					st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
					cnt=FindSubString(st,",");
					if (cnt!=-1)
					{
						para5=GetStringLeft(st,cnt);
						st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
						cnt=FindSubString(st,",");
						if (cnt!=-1)
						{
							para6=GetStringLeft(st,cnt);
							st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
							cnt=FindSubString(st,",");
							if (cnt!=-1)
							{
								para7=GetStringLeft(st,cnt);
								para8=GetStringRight(st,GetStringLength(st)-(cnt+1));
							}
							else
							{
								para7=st;
								para8="";
							}
						}
						else
						{
							para6=st;
							para7="";
							para8="";
						}
					}
					else
					{
						para5=st;
						para6="";
						para7="";
						para8="";
					}
				}
				else
				{
					para4=st;
					para5="";
					para6="";
					para7="";
					para8="";
				}
			}
			else
			{
				para3=st;
				para4="";
				para5="";
				para6="";
				para7="";
				para8="";
			}
		}
		else
		{
			para2=st;
			para3="";
			para4="";
			para5="";
			para6="";
			para7="";
			para8="";
		}
	}
	else
	{
		para1=st;
		para2="";
		para3="";
		para4="";
		para5="";
		para6="";
		para7="";
		para8="";
	}

}

void parsepara6para(string st)
{
	int cnt;
	
	cnt=FindSubString(st,",");
	if (cnt!=-1)
	{
		para1=GetStringLeft(st,cnt);
		st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
		cnt=FindSubString(st,",");
		if (cnt!=-1)
		{
			para2=GetStringLeft(st,cnt);
			st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
			cnt=FindSubString(st,",");
			if (cnt!=-1)
			{
				para3=GetStringLeft(st,cnt);
				st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
				cnt=FindSubString(st,",");
				if (cnt!=-1)
				{
					para4=GetStringLeft(st,cnt);
					st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
					cnt=FindSubString(st,",");
					if (cnt!=-1)
					{
						para5=GetStringLeft(st,cnt);
						para6=GetStringRight(st,GetStringLength(st)-(cnt+1));
					}
					else
					{
						para5=st; para6="";
					}
				}
				else
				{
					para4=st;
					para5="";
					para6="";
				}
			}
			else
			{
				para3=st;
				para4="";
				para5="";
				para6="";
			}
		}
		else
		{
			para2=st;
			para3="";
			para4="";
			para5="";
			para6="";
		}
	}
	else
	{
		para1=st;
		para2="";
		para3="";
		para4="";
		para5="";
		para6="";
	}

}

void parsepara4para(string st)
{
	int cnt;
	cnt=FindSubString(st,",",0);
	if (cnt!=-1)
	{
		para1=GetStringLeft(st,cnt);
		st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
		cnt=FindSubString(st,",");
		if (cnt!=-1)
		{
			para2=GetStringLeft(st,cnt);
			st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
			cnt=FindSubString(st,",");
			if (cnt!=-1)
			{
				para3=GetStringLeft(st,cnt);
				para4=GetStringRight(st,GetStringLength(st)-(cnt+1));
			}
			else
			{
				para3=st; para4="";
			}
		}
		else
		{
			para2=st; para3=""; para4="";
		}
	}
	else
	{
	para1=st; para2=""; para3=""; para4="";
	}

}

void parsepara3para(string st)
{
	int cnt;
	
	cnt=FindSubString(st,",");
	if (cnt!=-1)
	{
		para1=GetStringLeft(st,cnt);
		st=GetSubString(st,cnt+1,GetStringLength(st)-(cnt+1));
		cnt=FindSubString(st,",");
		if (cnt!=-1)
		{
			para2=GetStringLeft(st,cnt);
			para3=GetStringRight(st,GetStringLength(st)-(cnt+1));
		}
		else
		{
			para2=st; para3="";
		}
	}
	else
	{
		para1=st; para2=""; para3="";
	}

}

void parsepara2para(string st)
{
	int cnt;
	
	cnt=FindSubString(st,",");
	if (cnt!=-1)
	{
		para1=GetStringLeft(st,cnt);
		para2=GetStringRight(st,GetStringLength(st)-(cnt+1));
	}
	else {para1=st; para2="";}

}

void dstl_submitpendingmove(location pendingloc)
{
	if (GetObjectType(obj)!=OBJECT_TYPE_PLACEABLE)
	{
		AssignCommand(obj, DelayCommand(dly, ActionForceMoveToLocation(pendingloc,FALSE,DSTL_FORCETIMEOUT)));
		dly=dly+DSTL_MINDELAY;
	}
	
	AssignCommand(obj, DelayCommand(dly, ActionDoCommand( SetFacing(GetFacingFromLocation(pendingloc)))));
	dly=dly+DSTL_MINDELAY;

}

void dstlcom_p()
{

	float seconds;
	int dstlheartbeats;
	
	if (line!="")
	{
		seconds=StringToFloat(GetStringRight(line,linelg-DSTL_P_L));
	}
	else
	{
		seconds=6.0f;
	}
	
	dstlheartbeats=FloatToInt(seconds/dividersecs);
	if (dstlheartbeats<1)
	{
		dstlheartbeats=1;
	}
	
	phbs=dstlheartbeats;
	SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"phbs",phbs);

}

void dstlcom_speed()
{
	float spd;
	line=GetStringRight(line,linelg-DSTL_SPEED_L);
	if (line!="")
	{
		spd=StringToFloat(line);
		if ((spd<0.1f)||(spd>6.01f))
		{
			dstl_error("speed value out of bounds (0.1-6.0)");
		}
		else
		{
			dividersecs=spd;
			divider=FloatToInt((6.0f/dividersecs));
			if (divider<0)
			{
				divider=1;
			}
		}
	}
	else
	{
		dividersecs=DSTL_DIVIDERSECS;
		divider=FloatToInt((6.0f/dividersecs));
		if (divider<0)
		{
			divider=1;
		}
	}
	
	SetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"dividersecs",dividersecs);
}

void dstlcom_object()
{
	obj=dstl_getobjectbytagwrapper(GetSubString(line,DSTL_OBJECT_L,linelg-DSTL_OBJECT_L));
	SetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"obj",obj);
}

void dstlcom_godontwait()
{

	int run;
	float range;
	object destobj;
	
	parsepara3para(GetStringRight(line,linelg-DSTL_GODONTWAIT_L));
	
	if (para2=="") run=0; else run=StringToInt(para2);
	if (para3=="") range=1.0; else range=StringToFloat(para3);
	
	destobj=dstl_getobjectbytagwrapper(para1);
	
	AssignCommand(obj, DelayCommand(dly, ActionForceMoveToObject(destobj,run,range,DSTL_FORCETIMEOUT)));
	dly=dly+DSTL_MINDELAY;

}

void dstl_go_core(int run, float range, object destobj)
{
	AssignCommand(obj, DelayCommand(dly, ActionForceMoveToObject(destobj,run,range,DSTL_FORCETIMEOUT/divider)));
	dly=dly+DSTL_MINDELAY;
	
	wcount=FloatToInt((DSTL_FORCETIMEOUT/6.0)/divider)+1;
	wrange=range+DSTL_MOVETODISTANCE;
	wobj=destobj;
	SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"wcount",wcount);
	SetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"wrange",wrange);
	SetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"wobj",wobj);

}

void dstlcom_go()
{
	int run;
	float range;
	
	parsepara3para(GetStringRight(line,linelg-DSTL_GO_L));
	
	if (para2=="") run=0; else run=StringToInt(para2);
	if (para3=="") range=1.0; else range=StringToFloat(para3);
	
	dstl_go_core(run, range, dstl_getobjectbytagwrapper(para1));
}

void dstlcom_forward()
{
	vector p;
	float f;
	object a;
	location pendingloc;
	
	pendingloc=GetLocation(obj);
	
	a=GetAreaFromLocation(pendingloc);
	p=GetPositionFromLocation(pendingloc);
	f=GetFacingFromLocation(pendingloc);
	
	p=CSLGetChangedPosition(p,StringToFloat(GetStringRight(line,linelg-DSTL_FORWARD_L)),f);
	
	dstl_submitpendingmove(Location(a,p,f));

}

void dstlcom_turn()
{
	object a;
	vector p;
	float f;
	location pendingloc;
	
	pendingloc=GetLocation(obj);
	
	a=GetAreaFromLocation(pendingloc);
	p=GetPositionFromLocation(pendingloc);
	f=GetFacingFromLocation(pendingloc);
	
	f=f+StringToFloat(GetStringRight(line,linelg-DSTL_TURN_L));
	
	dstl_submitpendingmove(Location(a,p,f));

}

void dstlcom_face()
{

	AssignCommand(obj, DelayCommand(dly, ActionDoCommand( SetFacingPoint( GetPosition( dstl_getobjectbytagwrapper( GetStringRight(line,linelg-DSTL_FACE_L)))))));
	
	dly=dly+DSTL_MINDELAY;

}

void dstl_afterjump(object destobj)
{
	int type;
	type=GetObjectType(destobj);
	
	if ((type==OBJECT_TYPE_CREATURE)||(type==OBJECT_TYPE_PLACEABLE))
	{
		// facing the object
		AssignCommand(obj, DelayCommand(dly, ActionDoCommand( SetFacingPoint( GetPosition( destobj )))));
		dly=dly+DSTL_MINDELAY+DSTL_JUMPWAIT;
	}
	else if (type==OBJECT_TYPE_WAYPOINT)
	{
		// facing OF object
		AssignCommand(obj, DelayCommand(dly, ActionDoCommand( SetFacing( GetFacing( destobj)))));
		dly=dly+DSTL_MINDELAY+DSTL_JUMPWAIT;
	}

}

void dstl_jump_core(object destobj)
{
	AssignCommand(obj, DelayCommand(dly, ActionJumpToObject(destobj)));
	dly=dly+DSTL_MINDELAY;
	dstl_afterjump(destobj);
}

void dstl_jumpforce_core(object destobj)
{
	AssignCommand(obj, DelayCommand(dly, JumpToObject(destobj)));
	dly=dly+DSTL_MINDELAY;
	dstl_afterjump(destobj);
}

void dstlcom_jump()
{
	dstl_jump_core(dstl_getobjectbytagwrapper(GetStringRight(line,linelg-DSTL_JUMP_L)));
}

void dstlcom_use()
{
	object destobj;
	
	destobj=dstl_getobjectbytagwrapper(GetStringRight(line,linelg-DSTL_USE_L));
	
	dstl_go_core(0,DSTL_MOVETODISTANCE,destobj);
	
	AssignCommand(obj, DelayCommand(dly, ActionDoCommand( DoPlaceableObjectAction(destobj,PLACEABLE_ACTION_USE))));
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_execute()
{

	int p1;
	float p2;
	
	parsepara4para(GetStringRight(line,linelg-DSTL_EXECUTE_L));
	
	if (para2!="") p1=StringToInt(para2); else p1=0;
	if (para3!="") p2=StringToFloat(para3); else p2=0.0;
	
	SetLocalInt(obj,para1+"_p1",p1);
	SetLocalFloat(obj,para1+"_p2",p2);
	SetLocalString(obj,para1+"_p3",para4);
	
	ExecuteScript(para1,obj);
	dly=dly+DSTL_MINDELAY;

}

void dstlcom_sound()
{
	AssignCommand(obj, DelayCommand(dly, PlaySound( GetStringRight(line,linelg-DSTL_SOUND_L ))));
	
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_animation()
{
	int animation;
	float speed;
	float durationseconds;
	
	parsepara3para(GetStringRight(line,linelg-DSTL_ANIMATION_L));
	
	animation=StringToInt(para1);
	if (para2=="")
	{
		speed=1.0;
	}
	else
	{
		speed=StringToFloat(para2);
	}
	
	if (para3=="")
	{
		durationseconds=0.0;
	}
	else
	{
		durationseconds=StringToFloat(para3);
	}
	
	AssignCommand(obj, DelayCommand(dly, ActionPlayAnimation(animation, speed, durationseconds)));
	
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_signalevent()
{

	int evnum;
	object evobj;
	
	line=GetStringRight(line, linelg-DSTL_SIGNALEVENT_L);
	parsepara6para(line);
	
	evnum=StringToInt(para2);
	
	evobj=dstl_getobjectbytagwrapper(para1);
	SetLocalObject(evobj,DSTL_DSTLPREFIX+"sender",obj);
	SetLocalInt(evobj,DSTL_DSTLPREFIX+"p1",StringToInt(para3));
	SetLocalFloat(evobj,DSTL_DSTLPREFIX+"p2",StringToFloat(para4));
	SetLocalString(evobj,DSTL_DSTLPREFIX+"p3",para5);
	
	SignalEvent(evobj,EventUserDefined(evnum));
	
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_create()
{
	string template;
	string locationtag;
	int objecttype;
	string newtag;
	int useappearanimation;
	
	object locationobj;
	object o;
	location l;
	vector p;
	float f;
	
	parsepara8para( GetStringRight(line,linelg-DSTL_CREATE_L) );
	
	template=para1;
	locationtag=para2;
	if ( (para3=="") || (para3=="p") )
	{
		objecttype=OBJECT_TYPE_PLACEABLE;
	}
	else if (para3=="c")
	{
		objecttype=OBJECT_TYPE_CREATURE;
	}
	else if (para3=="i")
	{
		objecttype=OBJECT_TYPE_ITEM;
	}
	else if (para3=="e")
	{
		objecttype=OBJECT_TYPE_ENCOUNTER;
	}
	else if (para3=="s")
	{
		objecttype=OBJECT_TYPE_STORE;
	}
	else if (para3=="t")
	{
		objecttype=OBJECT_TYPE_TRIGGER;
	}
	else if (para3=="l")
	{
		objecttype=OBJECT_TYPE_LIGHT;
	}
	else if (para3=="f")
	{
		objecttype=OBJECT_TYPE_PLACED_EFFECT;
	}
	else
	{
		objecttype=OBJECT_TYPE_WAYPOINT;
	}
	newtag=para4;
	
	if (para5!="")
	{
		useappearanimation=StringToInt(para5);
	}
	else
	{
		useappearanimation=FALSE;
	}
	
	locationobj=dstl_getobjectbytagwrapper(locationtag);
	l=GetLocation(locationobj);
	
	p=GetPositionFromLocation(l);
	if (para6!="")
	{
		p.z=p.z+StringToFloat(para6);
	}
	if (para7!="")
	{
		p.x=p.x+StringToFloat(para7);
	}
	if (para8!="")
	{
		p.y=p.y+StringToFloat(para8);
	}
	
	f=GetFacingFromLocation(l);
	if (objecttype==OBJECT_TYPE_PLACEABLE)
	{
		f=f+180.0;
	}
	
	l=Location(GetAreaFromLocation(l),p,f);
	o = CreateObject(objecttype,para1,l,useappearanimation,newtag);
	
	SetLocalInt(o,DSTL_DSTLPREFIX+"dynamic",1);
}

void dstlcom_destroy()
{

	int spectaculardeath;
	object destrobj;
	effect e;
	
	parsepara2para(GetStringRight(line,linelg-DSTL_DESTROY_L));
	
	if (para2=="") spectaculardeath=FALSE; else spectaculardeath=StringToInt(para2);
	
	destrobj=dstl_getobjectbytagwrapper(para1);
	SetPlotFlag(destrobj,FALSE);
	
	if ((spectaculardeath==TRUE)&&(GetObjectType(destrobj)==OBJECT_TYPE_CREATURE))
	{
		e=EffectDeath();
		AssignCommand(obj, DelayCommand(dly, ApplyEffectToObject(DURATION_TYPE_INSTANT,e,destrobj)));
	}
	else
	{
		AssignCommand(obj, DestroyObject(destrobj));
	}
		
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_equip()
{
	int slot;
	object item;
	
	parsepara2para(GetStringRight(line,linelg-DSTL_EQUIP_L));
	
	slot=StringToInt(para2);
	
	item=GetItemPossessedBy(obj,para1);
	
	if (item==OBJECT_INVALID)
	{
		dstl_error("dstlcom_equip. Item not found. Tag= '"+para1+"'");
	}
	else
	{
		SetIdentified(item,TRUE);
		
		AssignCommand(obj, DelayCommand(dly, ActionEquipItem(item,slot)));
			
		dly=dly+DSTL_MINDELAY;
	}
}

void dstlcom_unequip()
{

	int slot;
	
	line=GetStringRight(line,linelg-DSTL_UNEQUIP_L);

	if (line!="")
	{
		slot=StringToInt(line);
		DelayCommand(dly, AssignCommand(obj, ActionUnequipItem(GetItemInSlot(slot,obj))));
		dly=dly+DSTL_MINDELAY;
	}
	else
	{
		DelayCommand(dly, AssignCommand(obj, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,obj))));
		dly=dly+DSTL_MINDELAY;
		
		DelayCommand(dly, AssignCommand(obj, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,obj))));
		dly=dly+DSTL_MINDELAY;
		
		DelayCommand(dly, AssignCommand(obj, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_HEAD,obj))));
		dly=dly+DSTL_MINDELAY;
		
		DelayCommand(dly, AssignCommand(obj, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CLOAK,obj))));
		dly=dly+DSTL_MINDELAY;
	}
}

void dstlcom_visualeffectlocation()
{

	string locationtag;
	int effnum;
	int durationtype;
	effect e;
	float dur;
	object desto;
	
	parsepara4para(GetStringRight(line,linelg-DSTL_VISUALEFFECTLOCATION_L));
	
	if (para1!="")
	{
		locationtag=para1;
		desto=dstl_getobjectbytagwrapper(locationtag);
	}
	else
	{
		desto=obj;
	}
	
	effnum=StringToInt(para2);
	
	if (para3=="t") durationtype=DURATION_TYPE_TEMPORARY; else if (para3=="i") durationtype=DURATION_TYPE_INSTANT; else
	durationtype=DURATION_TYPE_PERMANENT;
	
	if (para4!="") dur=StringToFloat(para4);
	else dur=0.0;
	
	e=EffectVisualEffect(effnum);
	e=SupernaturalEffect(e);
	
	DelayCommand(dly, AssignCommand(obj, ApplyEffectAtLocation(durationtype,e,GetLocation(desto),dur/divider)));
		
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_visualeffectobject()
{
	string objecttag;
	int effnum;
	int durationtype;
	effect e;
	float dur;
	object desto;
	
	parsepara4para(GetStringRight(line,linelg-DSTL_VISUALEFFECTOBJECT_L));

	if (para1!="")
	{
		objecttag=para1;
		desto=dstl_getobjectbytagwrapper(objecttag);
	}
	else
	{
		desto=obj;
	}

	effnum=StringToInt(para2);

	if (para3=="t") durationtype=DURATION_TYPE_TEMPORARY; else if (para3=="i") durationtype=DURATION_TYPE_INSTANT; else
	durationtype=DURATION_TYPE_PERMANENT;
	
	if (para4!="")
	{
		dur=StringToFloat(para4);
	}
	else
	{
		dur=0.0;
	}
	
	e=EffectVisualEffect(effnum);
	e=SupernaturalEffect(e);
	
	DelayCommand(dly,
	AssignCommand(obj, ApplyEffectToObject(durationtype,e,desto,dur/divider)));
		
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_clearallactions()
{

	int clearcombatstate;
	
	line=GetStringRight(line,linelg-DSTL_CLEARALLACTIONS_L);
	
	if (line!="") clearcombatstate=StringToInt(line); else
	clearcombatstate=FALSE;
	
	DelayCommand(dly,AssignCommand(obj, ClearAllActions(clearcombatstate)));
		
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_createitemonobject()
{
	
	object o;
	
	line=GetStringRight(line,linelg-DSTL_CREATEITEMONOBJECT_L);
	
	parsepara2para(line);
	
	o=CreateItemOnObject(para1,obj,1,para2);
	
	if (o==OBJECT_INVALID)
	{
		dstl_error("dstlcom_createitemonobject. Object not created. Template= '"+para1+"'");
	}
	
	SetLocalInt(o,DSTL_DSTLPREFIX+"dynamic",1);
}

void dstlcom_attack()
{
	object attackee;
	
	line=GetStringRight(line,linelg-DSTL_ATTACK_L);
	
	attackee=dstl_getobjectbytagwrapper(line);
	
	DelayCommand(dly, SetPlotFlag(attackee,FALSE));
	dly=dly+DSTL_MINDELAY;
	
	DelayCommand(dly,
	SetPlotFlag(obj,FALSE));
	dly=dly+DSTL_MINDELAY;
	
	DelayCommand(dly,
	AssignCommand(obj, ActionEquipMostEffectiveArmor()));
	dly=dly+DSTL_MINDELAY;
	
	dly=dly+DSTL_SPECIALWAIT;
	
	DelayCommand(dly, AssignCommand(obj, CSLEquipAppropriateWeapons(attackee) ) );
	dly=dly+DSTL_MINDELAY;
	
	/*
	DelayCommand(dly,
	ChangeFaction(obj,dstl_getobjectbytagwrapper("holder_actorshostile")));
	dly=dly+DSTL_MINDELAY;
	*/
	
	DelayCommand(dly,
	ChangeToStandardFaction(obj,STANDARD_FACTION_HOSTILE)); // <<<<<<<
	dly=dly+DSTL_MINDELAY;
	
	DelayCommand(dly,
	AssignCommand(obj, ActionAttack(attackee)));
	dly=dly+DSTL_MINDELAY;
	
	DelayCommand(dly, CSLDetermineCombatRound( obj, attackee ) );
	dly=dly+DSTL_MINDELAY;
}

void dstlcom_changefaction()
{
	object destobj;
	
	line=GetStringRight(line,linelg-DSTL_CHANGEFACTION_L);
	
	destobj=GetObjectByTag(line);
	
	if (destobj==OBJECT_INVALID)
	{
		dstl_error("dstlcom_changefaction. Factionholder not found. Tag= '"+line+"'");
	}
	else
	{
		DelayCommand(dly,
		ChangeFaction(obj,destobj));
		dly=dly+DSTL_MINDELAY;
		
		DelayCommand(dly, CSLDetermineCombatRound( obj ) );
		//AssignCommand(obj, SCAIDetermineCombatRound()));
		dly=dly+DSTL_MINDELAY;
	}
}

void dstlcom_localvar()
{

	int valint;
	float valfloat;
	string valstring;
	
	line=GetStringRight(line,linelg-DSTL_LOCALVAR_L);
	parsepara4para(line);
	
	if (para2!="") valint=StringToInt(para2); else valint=0;
	if (para3!="") valfloat=StringToFloat(para3); else valfloat=0.0;
	if (para4!="") valstring=para4; else valstring="";

	if (valint!=0)
	{
		SetLocalInt(obj,para1,valint);
	}
	else
	{
		DeleteLocalInt(obj,para1);
	}

	if (valfloat!=0.0)
	{
		SetLocalFloat(obj,para1,valfloat);
	}
	else
	{
		DeleteLocalFloat(obj,para1);
	}

	if (valstring!="")
	{
		SetLocalString(obj,para1,valstring);
	}
	else
	{
		DeleteLocalString(obj,para1);
	}
}

void dstlcom_name()
{
	line=GetStringRight(line,linelg-DSTL_NAME_L);

	if (CSLNth_GetCount(line, DSTL_DELIMITER)==2)
	{
		string s;
		s=CSLNth_GetNthElement(line,1,DSTL_DELIMITER);
		DelayCommand(dly, SetFirstName(obj,s));
		dly=dly+DSTL_MINDELAY;
		s=CSLNth_GetNthElement(line,2,DSTL_DELIMITER);
		DelayCommand(dly, SetLastName(obj,s));
		dly=dly+DSTL_MINDELAY;
	}
	else
	{
		DelayCommand(dly, SetFirstName(obj,line));
		dly=dly+DSTL_MINDELAY;
	}
}

void dstlcom_if(int inverse)
{
	int checkval1;
	int checkval2;
	int fnd;
	
	if (inverse==FALSE)
	{
		parsepara2para(GetStringRight(line,linelg-DSTL_IF_L));
	}
	else
	{
		parsepara2para(GetStringRight(line,linelg-DSTL_IFNOT_L));
	}
	
	checkval1=GetLocalInt(obj,para1);
	if (para2=="")
	{
		checkval2=1;
	}
	else
	{
		checkval2=StringToInt(para2);
	}
	
	if (  ((inverse==FALSE) && (checkval1!=checkval2)) || ((inverse == TRUE) && (checkval1 == checkval2))  )
	{
		fnd=FindSubString(txt,"[ENDIF]",cnt2+1);
		if (fnd==-1)
		{
			dstl_error("dstlcom_if/ifnot. [ENDIF] not found!");
		}
		else
		{
			cnt2=fnd+6;
		}
	}
}

void dstlcom_includestringvar()
{
	string s;
	int lg;
	
	line=GetStringRight(line,linelg-DSTL_INCLUDESTRINGVAR_L);
	
	s=GetLocalString(obj,line);
	
	if (s!="")
	{
		lg=GetStringLength(s);
		
		txt=InsertString(txt,s,cnt2+1); //insert after this command, don't move txtc
		txtl=txtl+lg;
		SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtl",txtl);
		SetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"txt",txt);
	}
}

void dstl_lookforbook()
{
	object book;
	object item;
	int cnt;
	int cnt2;
	int cmfnd;
	string s1;
	string s2;
	string li;
	
	book=OBJECT_INVALID;
	item=GetFirstItemInInventory(OBJECT_SELF);
	
	while ( item!=OBJECT_INVALID && book==OBJECT_INVALID )
	{
		if (dstl_isvaliddstlbook(item)==TRUE)
		{
			book=item;
		}
		item=GetNextItemInInventory(OBJECT_SELF);
	}
	
	if (book==OBJECT_INVALID)
	{
		phbs=-1;
		SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"phbs",phbs); // < deactivate
		SetPlotFlag(OBJECT_SELF,FALSE);
		DestroyObject(OBJECT_SELF,6.0f+DSTL_DIVIDERSECS+DSTL_MINDELAY);   // <<< destroy yourself
		return;
	}
	else
	{
		SetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"book",GetTag(book));
		
		//GetDescription()-workaround:
		//the placeable is just for one quick reading
		string ptr;
		ptr=GetLocalString(book,"ptr");
		
		if (ptr=="")
		{
			dstl_error("dstl_lookforbook. string var 'ptr' on item not found or empty.");
		}
		
		object tempplc;
		tempplc=CreateObject(OBJECT_TYPE_PLACEABLE,ptr,GetLocation(OBJECT_SELF));
		txt=GetDescription(tempplc);
		DestroyObject(tempplc,0.05f);
		
		if (txt=="")
		{
			dstl_error("dstl_lookforbook. No content.");
		}
		
		//remove comments
		string ri;
		int oldcnt;
		oldcnt=0;
		do
		{
			cmfnd=FALSE;
			cnt=FindSubString(txt,DSTL_COMMENTOPEN,oldcnt);
			if (cnt!=-1)
			{
				cnt2=FindSubString(txt,DSTL_COMMENTCLOSE,cnt+1);
				if (cnt2!=-1)
				{
					s1=GetStringLeft(txt,cnt);
					s2=GetStringRight(txt,GetStringLength(txt)-(cnt2+1));
			
					ri=GetStringLeft(s2,1);
					if (ri=="\n")
					{
						s2=GetStringRight(s2,GetStringLength(s2)-1);
					}
			
					txt=s1+s2;
					cmfnd=TRUE;
					if (cnt>0)
					{
						oldcnt=cnt-1;
					}
					else
					{
						cnt=0;
					}
				}
			}
		} while ( cmfnd==TRUE );
		
		string c;
		c=GetStringRight(txt,1);
		if (c!=DSTL_ENDOFLINE)
		{
			txt=txt+DSTL_ENDOFLINE;
		}
		
		SetPlotFlag(book,FALSE);
		DestroyObject(book);    // <<< destroy book
		
		txtc=0;
		SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtc",txtc);
		SetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"txt",txt);
		txtl=GetStringLength(txt);
		SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtl",txtl);
		
		// reset everything
		wcount=0;
		SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"wcount",wcount);
		
		dividersecs=DSTL_DIVIDERSECS;
		SetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"dividersecs",dividersecs);
		
		obj=OBJECT_SELF;
		SetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"obj",obj);
	
	}
	
	dly=dly+DSTL_MINDELAY;

}

void speak()
{
	if (CharToASCII(GetStringRight(line,1))==13)
	{
		line=GetStringLeft(line,GetStringLength(line)-1);
	}
	
	if (line!="")
	{
		if (GetStringLeft(line,1)!=DSTL_SHOUTCODE)
		{
			AssignCommand(obj, DelayCommand(dly, SpeakString(line,TALKVOLUME_TALK)));
			dly=dly+DSTL_MINDELAY;
		}
		else
		{
			AssignCommand(obj, DelayCommand(dly, SpeakString(GetStringRight(line,GetStringLength(line)-1),TALKVOLUME_SHOUT)));
			// replace with SendChatMessage( oShouter, OBJECT_INVALID, CHAT_MODE_SHOUT, sMsg, FALSE);
			dly=dly+DSTL_MINDELAY;
		}
	}

}

void evaluateline()
{
	linelg=GetStringLength(line);

	if (GetSubString(line,0,DSTL_OBJECT_L)==DSTL_OBJECT)
	{
		dstlcom_object();
		return;
	}
	if (GetSubString(line,0,DSTL_FACE_L)==DSTL_FACE)
	{
		dstlcom_face();
		return;
	}
	if (GetSubString(line,0,DSTL_EXECUTE_L)==DSTL_EXECUTE)
	{
		dstlcom_execute();
		return;
	}
	if (GetSubString(line,0,DSTL_GO_L)==DSTL_GO)
	{
		dstlcom_go();
		return;
	}
	if (GetSubString(line,0,DSTL_SOUND_L)==DSTL_SOUND)
	{
		dstlcom_sound();
		return;
	}
	if (GetSubString(line,0,DSTL_ANIMATION_L)==DSTL_ANIMATION)
	{
		dstlcom_animation();
		return;
	}
	if (GetSubString(line,0,DSTL_GODONTWAIT_L)==DSTL_GODONTWAIT)
	{
		dstlcom_godontwait();
		return;
	}
	if (GetSubString(line,0,DSTL_P_L)==DSTL_P)
	{
		dstlcom_p();
		return;
	}
	if (GetSubString(line,0,DSTL_USE_L)==DSTL_USE)
	{
		dstlcom_use();
		return;
	}
	if (GetSubString(line,0,DSTL_JUMP_L)==DSTL_JUMP)
	{
		dstlcom_jump();
		return;
	}
	if (GetSubString(line,0,DSTL_TURN_L)==DSTL_TURN)
	{
		dstlcom_turn();
		return;
	}
	if (GetSubString(line,0,DSTL_FORWARD_L)==DSTL_FORWARD)
	{
		dstlcom_forward();
		return;
	}
	if (GetSubString(line,0,DSTL_VISUALEFFECTOBJECT_L)==DSTL_VISUALEFFECTOBJECT)
	{
		dstlcom_visualeffectobject();
		return;
	}
	if (GetSubString(line,0,DSTL_VISUALEFFECTLOCATION_L)==DSTL_VISUALEFFECTLOCATION)
	{
		dstlcom_visualeffectlocation();
		return;
	}
	if (GetSubString(line,0,DSTL_CREATE_L)==DSTL_CREATE)
	{
		dstlcom_create();
		return;
	}
	if (GetSubString(line,0,DSTL_DESTROY_L)==DSTL_DESTROY)
	{
		dstlcom_destroy();
		return;
	}
	if (GetSubString(line,0,DSTL_EQUIP_L)==DSTL_EQUIP)
	{
		dstlcom_equip();
		return;
	}
	if (GetSubString(line,0,DSTL_UNEQUIP_L)==DSTL_UNEQUIP)
	{
		dstlcom_unequip();
		return;
	}
	if (GetSubString(line,0,DSTL_CLEARALLACTIONS_L)==DSTL_CLEARALLACTIONS)
	{
		dstlcom_clearallactions();
		return;
	}
	if (GetSubString(line,0,DSTL_SPEED_L)==DSTL_SPEED)
	{
		dstlcom_speed();
		return;
	}
	if (GetSubString(line,0,DSTL_CREATEITEMONOBJECT_L)==DSTL_CREATEITEMONOBJECT)
	{
		dstlcom_createitemonobject();
		return;
	}
	if (GetSubString(line,0,DSTL_NAME_L)==DSTL_NAME)
	{
		dstlcom_name();
		return;
	}
	if (GetSubString(line,0,DSTL_ATTACK_L)==DSTL_ATTACK)
	{
		dstlcom_attack();
		return;
	}
	if (GetSubString(line,0,DSTL_SIGNALEVENT_L)==DSTL_SIGNALEVENT)
	{
		dstlcom_signalevent();
		return;
	}
	if (GetSubString(line,0,DSTL_LOCALVAR_L)==DSTL_LOCALVAR)
	{
		dstlcom_localvar();
		return;
	}
	if (GetSubString(line,0,DSTL_CHANGEFACTION_L)==DSTL_CHANGEFACTION)
	{
		dstlcom_changefaction();
		return;
	}
	if (GetSubString(line,0,DSTL_INCLUDESTRINGVAR_L)==DSTL_INCLUDESTRINGVAR)
	{
		dstlcom_includestringvar();
		return;
	}
	if (GetSubString(line,0,DSTL_ENDIF_L)==DSTL_ENDIF)
	{
		/*do nothing*/ return;
	}
	if (GetSubString(line,0,DSTL_IF_L)==DSTL_IF)
	{
		dstlcom_if(FALSE);
		return;
	}
	if (GetSubString(line,0,DSTL_IFNOT_L)==DSTL_IFNOT)
	{
		dstlcom_if(TRUE);
		return;
	}
	if (GetSubString(line,0,DSTL_VERSION_L)==DSTL_VERSION)
	{
		dstlcom_version();
		return;
	}
	dstl_error("command "+line+" not recognized!");
}