/** @file
* @brief Include File for Save Uses
*
* This is code which can restore a character back to how they were before they rested
* Not needed anymore, but useful to track spells and feats
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/


#include "_CSLCore_Feats"
#include "seed_db_inc"

const string PC_SPELL_LIST = "PC_SPELLS";
const string PC_FEAT_LIST = "PC_FEATS";

const int SPELL_COUNT = 3850;
const int FEAT_COUNT = 3550;
const string LIST_DELIM = " ";
const string USES_DELIM = ":";

string GetFeatList(object oPC)
{
   return GetLocalString(GetModule(), PC_FEAT_LIST + SDB_GetPLID(oPC));
}

//void SetFeatList(object oPC, string sList) {
//   SetLocalString(GetModule(), PC_FEAT_LIST + SDB_GetPLID(oPC), sList);
//}

string GetSpellList(object oPC) {
   return GetLocalString(GetModule(), PC_SPELL_LIST + SDB_GetPLID(oPC));
}

//void SetSpellList(object oPC, string sList) {
 //  SetLocalString(GetModule(), PC_SPELL_LIST + SDB_GetPLID(oPC), sList);
//}


void ReduceSpellUses(object oPC, int iSpellId, int nSet=0) {
   int nUses = GetHasSpell(iSpellId, oPC);
   int nLast = -1;
   while (nUses>nSet) {
      DecrementRemainingSpellUses(oPC, iSpellId);
	  nUses = GetHasSpell(iSpellId, oPC);
	  if (nLast==nUses) return;
	  nLast=nUses;
   }
}

void ReduceFeatUses(object oPC, int nFeatID, int nSet=0) {
   int nUses = GetHasFeat(nFeatID, oPC);
   int nLast = -1;
   while (nUses>nSet) {
      DecrementRemainingFeatUses(oPC, nFeatID);
	  nUses = GetHasFeat(nFeatID, oPC);
	  if (nLast==nUses) return;
	  nLast=nUses;
   }
}

void ClearSpellsIterator( int iStartRow, int iEndRow, object oPC  );

void ClearSpells(object oPC)
{
	AssignCommand( oPC,ClearSpellsIterator( 0, 499, oPC  ) );
	AssignCommand( oPC,ClearSpellsIterator( 500, 999, oPC ) );
    AssignCommand( oPC,ClearSpellsIterator( 1000, 1499, oPC ) );
    AssignCommand( oPC,ClearSpellsIterator( 1500, 1999, oPC ) );
    AssignCommand( oPC,ClearSpellsIterator( 2000, 2135, oPC ) );
    AssignCommand( oPC,ClearSpellsIterator( 3801, 3850, oPC ) );

   //int iSpellId;
   //for (iSpellId=1;iSpellId<SPELL_COUNT;iSpellId++) {
   //   if (CSLGetHasSpell(oPC, iSpellId)) ReduceSpellUses(oPC, iSpellId);
   //}
}

void ClearSpellsIterator( int iStartRow, int iEndRow, object oPC  )
{
	int iSpellId; 
	//SendMessageToPC(oPC, "Spells"));
	for (iSpellId=iStartRow; iSpellId<=iEndRow; iSpellId++)
	{
      if (CSLGetHasSpell(oPC, iSpellId)) 
	  {
        ReduceSpellUses(oPC, iSpellId);
      }
   }
}

void iterateClearFeats( int iStartRow, int iEndRow, object oPC  );

void ClearFeats(object oPC)
{
	AssignCommand( oPC,iterateClearFeats( 0, 499, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 500, 999, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 1000, 1499, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 1500, 1999, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 2000, 2135, oPC ) );	
	AssignCommand( oPC,iterateClearFeats( 2798, 2800, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 2989, 3295, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 3316, 3318, oPC ) );
	AssignCommand( oPC,iterateClearFeats( 3500, 3516, oPC ) );
}


void iterateClearFeats( int iStartRow, int iEndRow, object oPC  )
{
	int nFeatID; 
	
	for (nFeatID=iStartRow; nFeatID<=iEndRow; nFeatID++)
	{
		if ( CSLGetHasFeat(oPC, nFeatID) ) 
		{
			ReduceFeatUses(oPC, nFeatID);
		}
	}
}


string Tokenize(int nID, int nUses) {
   if (!nUses) return "";
   return IntToString(nID) + USES_DELIM + IntToString(CSLGetMin(99, nUses)) + LIST_DELIM; // CAP THIS AT 9 USES FOR SIMPLER STRING SEARCHES
}

int GetToken(string sList, int nID) {
   string sFind = LIST_DELIM + IntToString(nID) + USES_DELIM;
   int nPos = FindSubString(sList, sFind);
   return (nPos==-1) ? 0 : StringToInt(GetSubString(sList, nPos + GetStringLength(sFind), 2));
}

void iterateSpellListStore( int iStartRow, int iEndRow, object oPC, string sPCSpellListVariable  );
void iterateFeatListStore( int iStartRow, int iEndRow, object oPC, string sPCFeatListVariable  );
void StoreSpellList(object oPC)
{
	string sID = SDB_GetPLID(oPC);
	//string sList = LIST_DELIM;
	int iSpellId;
	string sPCSpellListVariable = PC_SPELL_LIST + SDB_GetPLID(oPC) ;
	SetLocalString( GetModule(), sPCSpellListVariable , LIST_DELIM);
	
	AssignCommand( oPC,iterateSpellListStore( 0, 499, oPC, sPCSpellListVariable  ) );
	AssignCommand( oPC,iterateSpellListStore( 500, 999, oPC, sPCSpellListVariable ) );
    AssignCommand( oPC,iterateSpellListStore( 1000, 1499, oPC, sPCSpellListVariable ) );
    AssignCommand( oPC,iterateSpellListStore( 1500, 1999, oPC, sPCSpellListVariable ) );
    AssignCommand( oPC,iterateSpellListStore( 2000, 2135, oPC, sPCSpellListVariable ) );
    
    // take care of the higer level ones now
    AssignCommand( oPC,iterateSpellListStore( 3801, 3850, oPC, sPCSpellListVariable ) );
	//for (iSpellId=0; iSpellId<SPELL_COUNT; iSpellId++)
	//{
	//	if (CSLGetHasSpell(oPC, iSpellId))
	//	sList += Tokenize(iSpellId, GetHasSpell(iSpellId, oPC));
	//}
	//SetSpellList(oPC, sList);
//   CSLTestMsg(oPC, GetName(oPC) + " OnExit spell list: " + sList );
}


void iterateSpellListStore( int iStartRow, int iEndRow, object oPC, string sPCSpellListVariable  )
{
	int iSpellId; 
	   //SendMessageToPC(oPC, "Spells"));
  string sList = GetLocalString( GetModule(), sPCSpellListVariable );
   for (iSpellId=iStartRow; iSpellId<=iEndRow; iSpellId++)
   {
      if (CSLGetHasSpell(oPC, iSpellId)) 
	  {
        sList += Tokenize(iSpellId, GetHasSpell(iSpellId, oPC));
      }
   }
   SetLocalString( GetModule(), sPCSpellListVariable , sList);
}



void StoreFeatList(object oPC)
{
	string sID = SDB_GetPLID(oPC);
	string sList = LIST_DELIM;
	string sPCFeatListVariable = PC_FEAT_LIST + SDB_GetPLID(oPC);
	
	AssignCommand( oPC,iterateFeatListStore( 0, 499, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 500, 999, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 1000, 1499, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 1500, 1999, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 2000, 2135, oPC,  sPCFeatListVariable ) );
	
	AssignCommand( oPC,iterateFeatListStore( 2798, 2800, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 2989, 3295, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 3316, 3318, oPC,  sPCFeatListVariable ) );
	AssignCommand( oPC,iterateFeatListStore( 3500, 3516, oPC,  sPCFeatListVariable ) );
	
	//int nFeatID;
	//for (nFeatID=0; nFeatID<FEAT_COUNT; nFeatID++)
	//if (CSLGetHasFeat(oPC, nFeatID))
	//{
	//	sList += Tokenize(nFeatID, GetHasFeat(nFeatID, oPC));
	//}
   //SetFeatList(oPC, sList);
//   CSLTestMsg(oPC, GetName(oPC) + " OnExit feat list: " + sList );
}

void iterateFeatListStore( int iStartRow, int iEndRow, object oPC, string sPCFeatListVariable  )
{
	int nFeatID; 
	   //SendMessageToPC(oPC, "Spells"));
	string sList = GetLocalString( GetModule(), sPCFeatListVariable );
	
	for (nFeatID=iStartRow; nFeatID<=iEndRow; nFeatID++)
	{
		if (CSLGetHasFeat(oPC, nFeatID)) 
		{
			sList += Tokenize(nFeatID, GetHasFeat(nFeatID, oPC));
		}
	}
	SetLocalString( GetModule(), sPCFeatListVariable , sList);
}


void iterateSpellList( int iStartRow, int iEndRow, object oPC, string sList );

void RestoreSpellList(object oPC) {
   string sList = GetSpellList(oPC);
   if (sList=="") { // JUST IN, CLEAR ALL
      AssignCommand( oPC, ClearSpells(oPC) );
      return;
   }
   
    AssignCommand( oPC,iterateSpellList( 0, 499, oPC, sList ) );
    AssignCommand( oPC,iterateSpellList( 500, 999, oPC, sList ) );
    AssignCommand( oPC,iterateSpellList( 1000, 1499, oPC, sList ) );
    AssignCommand( oPC,iterateSpellList( 1500, 1999, oPC, sList ) );
    AssignCommand( oPC,iterateSpellList( 2000, 2135, oPC, sList ) );
    
    // take care of the higer level ones now
    AssignCommand( oPC,iterateSpellList( 3801, 3850, oPC, sList ) );
   
   /*
   int iSpellId;   
   for (iSpellId=0; iSpellId<SPELL_COUNT; iSpellId++) {
      if (CSLGetHasSpell(oPC, iSpellId)) {
         int nUses = GetHasSpell(iSpellId, oPC);
         if (nUses) {
            int nRemain = GetToken(sList, iSpellId);
//            CSLTestMsg(oPC, GetName(oPC) + ", spell " + IntToString(iSpellId) + " has " + IntToString(nUses) + " and had " + IntToString(nRemain));
            if (nRemain < nUses) ReduceSpellUses(oPC, iSpellId, nRemain);
         }
      }
   }
   */
}


void iterateSpellList( int iStartRow, int iEndRow, object oPC, string sList )
{
	int iSpellId; 
	   //SendMessageToPC(oPC, "Spells"));
  
   for (iSpellId=iStartRow; iSpellId<=iEndRow; iSpellId++) {
      if (CSLGetHasSpell(oPC, iSpellId)) {
         int nUses = GetHasSpell(iSpellId, oPC);
         if (nUses) {
            int nRemain = GetToken(sList, iSpellId);
//            CSLTestMsg(oPC, GetName(oPC) + ", spell " + IntToString(iSpellId) + " has " + IntToString(nUses) + " and had " + IntToString(nRemain));
            if (nRemain < nUses) ReduceSpellUses(oPC, iSpellId, nRemain);
         }
      }
   }
}


void iterateFeatList( int iStartRow, int iEndRow, object oPC, string sList );

void RestoreFeatList(object oPC) {
   string sList = GetFeatList(oPC);
   if (sList=="")
   { // JUST IN, CLEAR ALL
      AssignCommand( oPC, ClearFeats(oPC) );
      return;
   }
  
	AssignCommand( oPC,iterateFeatList( 0, 499, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 500, 999, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 1000, 1499, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 1500, 1999, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 2000, 2135, oPC,  sList ) );
	
	AssignCommand( oPC,iterateFeatList( 2798, 2800, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 2989, 3295, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 3316, 3318, oPC,  sList ) );
	AssignCommand( oPC,iterateFeatList( 3500, 3516, oPC,  sList ) );
  
   /*
   int nFeatID;   
   for (nFeatID=0; nFeatID<500; nFeatID++) {
      if (CSLGetHasFeat(oPC, nFeatID)) {
         int nUses = GetHasFeat(nFeatID, oPC);
         if (nUses) {
            int nRemain = GetToken(sList, nFeatID);
            if (nRemain < nUses) ReduceFeatUses(oPC, nFeatID, nRemain);
         }
      }
   }
   */
}

void iterateFeatList( int iStartRow, int iEndRow, object oPC, string sList )
{
	//SendMessageToPC(oPC, "Feats"));
	int nFeatID;   
	for (nFeatID=iStartRow; nFeatID<=iEndRow; nFeatID++) {
      if (CSLGetHasFeat(oPC, nFeatID)) {
         int nUses = GetHasFeat(nFeatID, oPC);
         if (nUses) {
            int nRemain = GetToken(sList, nFeatID);
            if (nRemain < nUses) ReduceFeatUses(oPC, nFeatID, nRemain);
         }
      }
   }
}



void ClearUses(object oPC) {
   AssignCommand( oPC, ClearSpells(oPC) );
   AssignCommand( oPC, ClearFeats(oPC) );
}

//** only stubs here
void StoreUses(object oPC)
{
	AssignCommand( oPC, StoreSpellList(oPC) );
	AssignCommand( oPC, StoreFeatList(oPC) );
}

void RestoreUses(object oPC)
{
  AssignCommand( oPC,RestoreSpellList(oPC) );
  AssignCommand( oPC,RestoreFeatList(oPC) );
}