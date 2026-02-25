#pragma once

#include <QObject>

#include "SiYiTcpClient.h"

class SiYiTransmitter : public SiYiTcpClient {
    Q_OBJECT
    Q_PROPERTY(int signalQuality READ signalQuality NOTIFY signalQualityChanged)
    Q_PROPERTY(int inactiveTime READ inactiveTime NOTIFY inactiveTimeChanged)
    Q_PROPERTY(int upStreamEnergy READ upStreamEnergy NOTIFY upStreamEnergyChanged)
    Q_PROPERTY(int downStreamEnergy READ downStreamEnergy NOTIFY downStreamEnergyChanged)
    Q_PROPERTY(int rxBanWidth READ rxBanWidth NOTIFY rxBanWidthChanged)
    Q_PROPERTY(int txBanWidth READ txBanWidth NOTIFY txBanWidthChanged)
    Q_PROPERTY(int rssi READ rssi NOTIFY rssiChanged)
    Q_PROPERTY(int freq READ freq NOTIFY freqChanged)
    Q_PROPERTY(int channel READ channel NOTIFY channelChanged)
    Q_PROPERTY(QString version READ version NOTIFY versionChanged)

   public:
    explicit SiYiTransmitter(QObject* parent = nullptr);
    ~SiYiTransmitter();

    int signalQuality() const { return signalQuality_; }
    int inactiveTime() const { return inactiveTime_; }
    int upStreamEnergy() const { return upStreamEnergy_; }
    int downStreamEnergy() const { return downStreamEnergy_; }
    int rxBanWidth() const { return rxBanWidth_; }
    int txBanWidth() const { return txBanWidth_; }
    int rssi() const { return rssi_; }
    int freq() const { return freq_; }
    int channel() const { return channel_; }
    QString version() const { return version_; }

   signals:
    void signalQualityChanged();
    void inactiveTimeChanged();
    void upStreamEnergyChanged();
    void downStreamEnergyChanged();
    void rxBanWidthChanged();
    void txBanWidthChanged();
    void rssiChanged();
    void freqChanged();
    void channelChanged();
    void versionChanged();

   public slots:
    void onHeartbeatMessageReceived(const QByteArray& msg);

   protected:
    void analyzeMessage() override;
    QByteArray heartbeatMessage() override;

   private:
    int signalQuality_ = 0;
    int inactiveTime_ = 0;
    int upStreamEnergy_ = 0;
    int downStreamEnergy_ = 0;
    int rxBanWidth_ = 0;
    int txBanWidth_ = 0;
    int rssi_ = 0;
    int freq_ = 0;
    int channel_ = 0;
    QString version_;
};
