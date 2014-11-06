#include "datamgr.h"
#include <QFile>
#include "json.h"
#include <QTextStream>
#include "system.h"
#include "utils.h"
#include <QDate>
#include <QDebug>

// Constructor:
DataMgr::DataMgr(System *system) : QObject(system),
    mSystem(system)
{
}

// Startup:
bool DataMgr::startup()
{
    return true;
}

// Shutdown:
void DataMgr::shutdown()
{

}

// Build a single form:
QObject *DataMgr::buildForm(const QString &formString)
{
    Form *form = new Form(this);
    if (!form->loadJSONFile(formString))
    {
        delete form;
        return 0;
    }
    return form;
}

// Build models:
void DataMgr::buildForms(const QStringList &forms)
{
    for (int i=0; i<forms.size(); i++)
    {
        Form *form = new Form(this);
        if (!form->loadJSONFile(forms[i]))
        {
            delete form;
            continue;
        }
        mForms << form;
    }
    emit nFormsChanged();
}

