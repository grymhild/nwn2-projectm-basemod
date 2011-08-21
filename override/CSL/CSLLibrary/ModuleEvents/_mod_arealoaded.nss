#include "_SCInclude_Graves"

//#include "_CSLCore_Environment"

void main()
{
  //DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
   
   object oPC = GetEnteringObject();
   if (GetIsDM(oPC)) return;
   object oArea = OBJECT_SELF;
   if (GetLocalInt(oPC, "TRANSING")) CSLIncrementLocalInt_Timed(oPC, "TRANS", 12.0); //GetPlotFlag(oPC)
   DeleteLocalInt(oPC, "TRANSING"); //   SetPlotFlag(oPC, FALSE);
   
   if (!CSLPCCanEnterArea(oPC, oArea))
   {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1000, DAMAGE_TYPE_MAGICAL), oPC);
      int nMax = GetLocalInt(oArea, "MAXLEVEL");
      PlaySound("vs_favhen4m_no");
      FloatingTextStringOnCreature("You're Too High!", oPC, FALSE);
      SendMessageToPC(oPC, "Bad! " + GetName(oArea) + " is restricted to Levels " + IntToString(nMax) + " and under.");
      AssignCommand(oPC, JumpToObject(GetObjectByTag("dp_return")));
      return;
   }
   
   DoPortInEffect(oPC); // SPECIAL EFFECT ON ENTER WHEN USING PORT STONES
   FloatingTextStringOnCreature(GetFirstName(oPC) + " has loaded " + GetName(OBJECT_SELF), oPC);
   
   string sAreaEnterScript = GetLocalString( oArea, "SCRIPT_AREAONENTER" );
	if ( 1 == 2 && sAreaEnterScript != "" )
	{ // tg_areamod_onenter_underwater
		SendMessageToPC( oPC, "Running on loaded "+sAreaEnterScript );
		DelayCommand( 0.1f, ExecuteScript( sAreaEnterScript, oPC ) );
	}
   
}