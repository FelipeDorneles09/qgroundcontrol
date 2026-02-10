/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "Viewer3DManager.h"

#include "OsmParser.h"
#include "Viewer3DQmlBackend.h"

Viewer3DManager::Viewer3DManager() {
    _qmlBackend = new Viewer3DQmlBackend(this);
    _osmParser = new OsmParser();

    _qmlBackend->init(_osmParser);
}

Viewer3DManager::~Viewer3DManager() {
    // _osmParser was created without a parent so delete it.
    delete _osmParser;
    _osmParser = nullptr;

    // _qmlBackend was parented to this object (created with new(..., this)).
    // It will be deleted automatically by QObject's destructor. Avoid manual delete.
    _qmlBackend = nullptr;
}
