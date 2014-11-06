#include "tracktik.h"
#include "system.h"

TrackTik *TrackTik::sTrackTik = 0;

// Constructor:
TrackTik::TrackTik(QObject *parent)
{
    Q_UNUSED(parent);
    mSystem = new System(this);
}

// Return kemanage singleton:
TrackTik *TrackTik::instance()
{
    if (!sTrackTik)
        sTrackTik = new TrackTik();

    return sTrackTik;
}

// Startup:
bool TrackTik::startup()
{
    return mSystem->startup();
}

// Shutdown:
void TrackTik::shutdown()
{
    mSystem->shutdown();
}


