/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "APMAutoPilotPlugin.h"

#include "APMAirframeComponent.h"
#include "APMCameraComponent.h"
#include "APMFlightModesComponent.h"
#include "APMHeliComponent.h"
#include "APMLightsComponent.h"
#include "APMMotorComponent.h"
#include "APMPowerComponent.h"
#include "APMRadioComponent.h"
#include "APMRemoteSupportComponent.h"
#include "APMSafetyComponent.h"
#include "APMSensorsComponent.h"
#include "APMSubFrameComponent.h"
#include "APMTuningComponent.h"
#include "ESP8266Component.h"
#include "ParameterManager.h"
#include "QGCApplication.h"
#include "QGCLoggingCategory.h"
#include "Vehicle.h"
#include "VehicleComponent.h"
#ifdef QT_DEBUG
#include "APMFollowComponent.h"
#include "ArduCopterFirmwarePlugin.h"
#include "ArduRoverFirmwarePlugin.h"
#endif
#ifndef QGC_NO_SERIAL_LINK
#include "QGCSerialPortInfo.h"
#include "SerialLink.h"
#endif

QGC_LOGGING_CATEGORY(APMAutoPilotPluginLog, "AutoPilotPlugins.APM.apmautopilotplugin")

APMAutoPilotPlugin::APMAutoPilotPlugin(Vehicle* vehicle, QObject* parent) : AutoPilotPlugin(vehicle, parent) {
    // qCDebug(APMAutoPilotPluginLog) << Q_FUNC_INFO << this;

#ifndef QGC_NO_SERIAL_LINK
    (void)connect(vehicle->parameterManager(), &ParameterManager::parametersReadyChanged, this,
                  &APMAutoPilotPlugin::_checkForBadCubeBlack);
#endif
}

APMAutoPilotPlugin::~APMAutoPilotPlugin() {
    // qCDebug(APMAutoPilotPluginLog) << Q_FUNC_INFO << this;
}

const QVariantList& APMAutoPilotPlugin::vehicleComponents() {
    if (_components.isEmpty() && !_incorrectParameterVersion) {
        if (_vehicle->parameterManager()->parametersReady()) {
            _sensorsComponent = new APMSensorsComponent(_vehicle, this);
            _sensorsComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue(qobject_cast<VehicleComponent*>(_sensorsComponent)));
        } else {
            qCWarning(APMAutoPilotPluginLog) << "Call to vehicleComponents prior to parametersReady";
        }
    }

    return _components;
}

QString APMAutoPilotPlugin::prerequisiteSetup(VehicleComponent* component) const {
    bool requiresAirframeCheck = false;

    if (qobject_cast<const APMFlightModesComponent*>(component)) {
        if (_airframeComponent && !_airframeComponent->setupComplete()) {
            return _airframeComponent->name();
        }
        if (_radioComponent && !_radioComponent->setupComplete()) {
            return _radioComponent->name();
        }
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMRadioComponent*>(component)) {
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMCameraComponent*>(component)) {
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMPowerComponent*>(component)) {
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMSafetyComponent*>(component)) {
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMTuningComponent*>(component)) {
        requiresAirframeCheck = true;
    } else if (qobject_cast<const APMSensorsComponent*>(component)) {
        requiresAirframeCheck = true;
    }

    if (requiresAirframeCheck) {
        if (_airframeComponent && !_airframeComponent->setupComplete()) {
            return _airframeComponent->name();
        }
    }

    return QString();
}

#ifndef QGC_NO_SERIAL_LINK
void APMAutoPilotPlugin::_checkForBadCubeBlack(bool parametersReady) {
    if (!parametersReady) {
        return;
    }

    const SharedLinkInterfacePtr sharedLink = _vehicle->vehicleLinkManager()->primaryLink().lock();
    if (!sharedLink) {
        return;
    }

    if (sharedLink->linkConfiguration()->type() != LinkConfiguration::TypeSerial) {
        return;
    }

    const SerialLink* serialLink = qobject_cast<const SerialLink*>(sharedLink.get());
    if (!serialLink) {
        return;
    }

    if (!QGCSerialPortInfo(*serialLink->port()).isBlackCube()) {
        return;
    }

    ParameterManager* const paramMgr = _vehicle->parameterManager();

    static const QString paramAcc3 = QStringLiteral("INS_ACC3_ID");
    static const QString paramGyr3 = QStringLiteral("INS_GYR3_ID");
    static const QString paramEnableMask = QStringLiteral("INS_ENABLE_MASK");

    if (paramMgr->parameterExists(-1, paramAcc3) && (paramMgr->getParameter(-1, paramAcc3)->rawValue().toInt() == 0) &&
        paramMgr->parameterExists(-1, paramGyr3) && (paramMgr->getParameter(-1, paramGyr3)->rawValue().toInt() == 0) &&
        paramMgr->parameterExists(-1, paramEnableMask) &&
        (paramMgr->getParameter(-1, paramEnableMask)->rawValue().toInt() >= 7)) {
        qgcApp()->showAppMessage(tr(
            "WARNING: The flight board you are using has a critical service bulletin against it which advises against "
            "flying. "
            "For details see: "
            "https://discuss.cubepilot.org/t/"
            "sb-0000002-critical-service-bulletin-for-cubes-purchased-between-january-2019-to-present-do-not-fly/406"));
    }
}
#endif
