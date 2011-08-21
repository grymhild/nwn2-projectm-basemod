//:://////////////////////////////////////////////////
//:: dstl_hbdirector
/*
v2.07
	The DS-TL (DSenset Theater Language) NWN2 Version
see documentation

This is supposed to be the OnHeartbeat Event of the director

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"



void main()
{
	int hbsteps;
	int lv;
	int cnt1;
	int agn;
	
	phbs=GetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"phbs");
	if (phbs==-1)
	{
		return;
	}
	
	if (dstl_isbusy(OBJECT_SELF)==TRUE)
	{
		return;
	}
	
	dly=0.0f;
	obj=GetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"obj");
	dividersecs=GetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"dividersecs");
	divider=FloatToInt(6.0f/dividersecs);
	
	wcount=GetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"wcount");
	if (wcount!=0)
	{
		wrange=GetLocalFloat(OBJECT_SELF,DSTL_DSTLPREFIX+"wrange");
		wobj=GetLocalObject(OBJECT_SELF,DSTL_DSTLPREFIX+"wobj");
	}
	
	txt=GetLocalString(OBJECT_SELF,DSTL_DSTLPREFIX+"txt");
	txtl=GetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtl");
	txtc=GetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtc");
	
	for ( hbsteps=0; hbsteps < divider; hbsteps++ )
	{
		if ((txtc>=txtl)&&(phbs!=-1))
		{
			dstl_lookforbook();
			hbsteps=divider+1; // please leave now for 6s...
		}
		else
		{
			do
			{
				agn=FALSE;
				lv=FALSE;
				
				if (dstl_isbusy(OBJECT_SELF)==TRUE) lv=TRUE;
				
				if (phbs>0)
				{
					phbs--;
					SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"phbs",phbs);
					lv=TRUE;
				}
				
				if (lv==FALSE)
				{
					if (wcount>0)
					{
						if (GetDistanceBetween(obj,wobj)>wrange)
						{
							wcount--;
							if (wcount>0)
							{
								lv=TRUE;
							}
							else
							{
								dstl_jumpforce_core(wobj);
								wcount=0;
							}
						}
						else
						{
							wcount=0;
						}
						SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"wcount",wcount);
					}
					
					if (lv==FALSE)
					{
						if (txtc<txtl)
						{
							// ] = LF
							// [ = LF
							// eat them all
							// look for linefeed or command open+command close. Eat possibly one LF after "]"
							cnt1=FindSubString(txt,DSTL_ENDOFLINE,txtc);
							
							if (cnt1==txtc)
							{
								txtc++;
								if (CharToASCII(GetSubString(txt,txtc,1))<32)
								{
									txtc++;
								}
							}
							else
							{
								cnt2=FindSubString(txt,DSTL_PREFIX,txtc);
								if (cnt2==-1) cnt2=2147483646; // max int
								
								if (cnt1<cnt2) // was LF
								{
									line=GetSubString(txt,txtc,cnt1-txtc);
									speak();
									txtc=cnt1+1;
								}
								else // was prefix
								{
									if (cnt2!=txtc)
									{
										line=GetSubString(txt,txtc,cnt2-txtc);
										speak();
									}
									txtc=cnt2+1;
									cnt2=FindSubString(txt,DSTL_POSTFIX,txtc);
									if (cnt2==-1)
									{
										cnt2=2147483646;
									}
									line=GetSubString(txt,txtc,cnt2-txtc);
									evaluateline();
									txtc=cnt2+1;
								
									if (CharToASCII(GetSubString(txt,txtc,1))>=32)
									{
										agn=TRUE;
									}
									else
									{
										txtc++;
										if (CharToASCII(GetSubString(txt,txtc,1))<32)
										{
											txtc++;
										}
									}
								
								}
								
							}
						}
					}
				}
			}
			while (agn==TRUE); //now was LF
		}
		dly=dly+dividersecs;
	}
	
	SetLocalInt(OBJECT_SELF,DSTL_DSTLPREFIX+"txtc",txtc);
}