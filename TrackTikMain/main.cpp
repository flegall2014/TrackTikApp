#include <QApplication>
#include "tracktik.h"

int main(int argc, char *argv[]) {
    // Main app:
    QApplication app(argc, argv);

    // Launch application:
    TrackTik *trackTik = TrackTik::instance();
    if (!trackTik)
        return 0;

    // Start TrackTik:
    if (trackTik->startup())
        // Run:
        app.exec();

    // Shutdown:
    trackTik->shutdown();

    // Delete TrackTik:
    delete trackTik;

    return 1;
}

