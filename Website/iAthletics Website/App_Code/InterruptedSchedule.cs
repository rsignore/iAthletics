using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public enum InterruptedScheduleType
{
    Insert,
    Update
}

/// <summary>
/// This class us used by the TeamSchedule and Venus page to communicate
/// the state of a interupted schedule when the user need to create a new
/// venu.
/// </summary>
public class InterruptedSchedule
{
    private int _appId;
    public int appId 
    {
        get {return _appId;}
        set {_appId = value;}
    }

    private int _teamId;
    public int teamId
    {
        get { return _teamId; }
        set { _teamId = value; }
    }

    private InterruptedScheduleType _interruptType;
    public InterruptedScheduleType interruptType
    {
        get {return _interruptType;}
        set {_interruptType = value;}
    }

	public InterruptedSchedule()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public InterruptedSchedule(int appId, int teamId)
    {
        _appId = appId;
        _teamId = teamId;
    }
}
