#ifndef DISPLAY_H
#define DISPLAY_H
#include <QObject>
#include <QScreen>
#include <QDebug>
#include <QGuiApplication>

class Display : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double scale READ scale WRITE setScale NOTIFY scaleChanged)

public:
    // Constructor:
    explicit Display(QObject *parent) : QObject(parent), mZoom(1.), mScale(0.),
        mPixelDensity(0.), mFactor(6.), mMinZoom(0.7),
        mMaxZoom(2.0), mZoomStep(.1)
    {
        mScreen = QGuiApplication::screens().first();
        mPixelDensity = logicalPixelDensity();
        setScale(mPixelDensity/mFactor*mZoom);
    }


    // Increment zoom:
    Q_INVOKABLE inline void incrZoom()
    {
        mZoom += mZoomStep;
        if (mZoom > mMaxZoom)
            mZoom = mMaxZoom;
        setScale(mPixelDensity/mFactor*mZoom);
    }

    // Decrement zoom:
    Q_INVOKABLE inline void decrZoom()
    {
        mZoom -= mZoomStep;
        if (mZoom < mMinZoom)
            mZoom = mMinZoom;
        setScale(mPixelDensity/mFactor*mZoom);
    }

private:
    // Get scale:
    inline double scale() const
    {
        return mScale;
    }

    // Set scale:
    inline void setScale(double scale)
    {
        mScale = scale;
        emit scaleChanged();
    }

private:
    QScreen *mScreen;
    double mZoom;
    double mScale;
    double mPixelDensity;
    double mFactor;
    double mMinZoom;
    double mMaxZoom;
    double mZoomStep;

private:
    // Logical pixel density = # pixels/mm:
    inline double logicalPixelDensity() const
    {
        if (!mScreen)
            return 0.0;
        return mScreen->physicalDotsPerInch()/25.4;
    }

signals:
    // Scale changed:
    void scaleChanged();
};

#endif // DISPLAY_H
