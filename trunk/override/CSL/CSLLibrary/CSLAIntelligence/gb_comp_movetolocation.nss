#include "_SCInclude_AI"

// Mithrates did this
void main()
{
	if (!GetLocalInt(OBJECT_SELF,"CombatMovement"))
	{
		return;
	}
	location lDestination=GetLocalLocation(OBJECT_SELF, "MyDestination");
	location lOrigin=GetLocation(OBJECT_SELF);
	if (lDestination==lOrigin)
	{
		CombatMoveTerminate();
		return;
	};
	vector vOrigin=GetPosition(OBJECT_SELF);
	vector vBasePath=GetPositionFromLocation(lDestination)-vOrigin;
	vector vHeading=VectorNormalize(vBasePath);
	float fDistance=VectorMagnitude(vBasePath);
	float fAngle=VectorToAngle(vBasePath);
	object oArea=GetArea(OBJECT_SELF);
	location lStep;
	if (fDistance<1.0) lStep=lDestination;
	else lStep=Location(oArea, vHeading, fAngle);
	int iDir=GetLocalInt(OBJECT_SELF,"PerturbationDirection");
	if (CalcSafeLocation(OBJECT_SELF, lStep, 0.0, TRUE, FALSE)!=lOrigin)
	{
		ActionMoveToLocation(lStep, TRUE);
		if (iDir!=0) DeleteLocalInt(OBJECT_SELF,"PerturbationDirection");
		DelayCommand(0.1, ExecuteScript("gb_comp_movetolocation",OBJECT_SELF));
		return;
	}
	else
	{
		if (iDir==0) 
		{
			iDir=d2();
			if (iDir==2) iDir=-1;
		}
		int i;
		float fNewAngle;
		for (i=1;i<8;i++)
		{
			fNewAngle=fAngle+18.0*i*iDir;
			if (fNewAngle>360.0) fNewAngle-=360.0;
			if (fNewAngle<0.0) fNewAngle+=360.0;
			lStep=Location(oArea, AngleToVector(fNewAngle)+vOrigin, fNewAngle);
			if (CalcSafeLocation(OBJECT_SELF, lStep, 0.0, TRUE, FALSE)!=lOrigin)
			{
				ActionMoveToLocation(lStep, TRUE);
				SetLocalInt(OBJECT_SELF,"PerturbationDirection", iDir);
				DelayCommand(0.1, ExecuteScript("gb_comp_movetolocation",OBJECT_SELF));
				return;
			}
		};
		iDir=iDir*(-1);
		for (i=1;i<8;i++)
		{
			fNewAngle=fAngle+18.0*i*iDir;
			if (fNewAngle>360.0) fNewAngle-=360.0;
			if (fNewAngle<0.0) fNewAngle+=360.0;
			lStep=Location(oArea, AngleToVector(fNewAngle)+vOrigin, fNewAngle);
			if (CalcSafeLocation(OBJECT_SELF, lStep, 0.0, TRUE, FALSE)!=lOrigin)
			{
				ActionMoveToLocation(lStep, TRUE);
				SetLocalInt(OBJECT_SELF,"PerturbationDirection", iDir);
				DelayCommand(0.1, ExecuteScript("gb_comp_movetolocation",OBJECT_SELF));
				return;
			};
		};
		for (i=8; i<14; i++)
		{
			fNewAngle=fAngle+18.0*i*iDir;
			if (fNewAngle>360.0) fNewAngle-=360.0;
			if (fNewAngle<0.0) fNewAngle+=360.0;
			lStep=Location(oArea, AngleToVector(fNewAngle)+vOrigin, fNewAngle);
			if (CalcSafeLocation(OBJECT_SELF, lStep, 0.0, TRUE, FALSE)!=lOrigin)
			{
				ActionMoveToLocation(lStep, TRUE);
				if (iDir!=0) DeleteLocalInt(OBJECT_SELF,"PerturbationDirection");
				DelayCommand(0.1, ExecuteScript("gb_comp_movetolocation",OBJECT_SELF));
				return;
			};
		};
	};
	CombatMoveTerminate();
}