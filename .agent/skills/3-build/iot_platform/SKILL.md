---
name: iot_platform
description: IoT cloud platform, device management, and connectivity for connected device fleets
---

# IoT Platform Skill

**Purpose**: Design and implement scalable IoT platforms that securely connect, manage, and collect data from device fleets, from protocol selection through cloud data pipelines.

## :dart: TRIGGER COMMANDS

```text
"build IoT platform"
"connect devices to cloud"
"device fleet management"
"Using iot_platform skill: [protocol] [scale] [platform]"
```

## :building_construction: IoT ARCHITECTURE OVERVIEW

```text
┌─────────────┐     ┌──────────────┐     ┌──────────────────┐     ┌─────────────┐
│   Devices    │────>│   Gateway    │────>│  Cloud Platform  │────>│ Application │
│ (sensors,    │     │  (optional)  │     │  (broker, APIs,  │     │ (dashboard, │
│  actuators)  │     │  edge compute│     │   storage, rules)│     │  alerts)    │
└─────────────┘     └──────────────┘     └──────────────────┘     └─────────────┘
       │                    │                      │
       │              ┌─────┴──────┐        ┌──────┴───────┐
       │              │ Edge Logic │        │ Stream Proc  │
       │              │ - Filter   │        │ - Kafka      │
       │              │ - Aggregate│        │ - Rules      │
       │              │ - Offline  │        │ - Analytics  │
       │              └────────────┘        └──────────────┘
       │
  Local Protocols: BLE, Zigbee, Z-Wave, Modbus, 1-Wire
```

## :satellite_antenna: PROTOCOL COMPARISON

| Protocol | Transport | Overhead | Power | Range | Best For |
|---|---|---|---|---|---|
| **MQTT** | TCP | Very low (2-byte header) | Low | Internet | General IoT (recommended default) |
| **HTTP/REST** | TCP | High (headers) | High | Internet | Simple integrations, webhooks |
| **CoAP** | UDP | Very low | Very low | Internet | Constrained devices (8-bit MCUs) |
| **WebSocket** | TCP | Low | Medium | Internet | Real-time bidirectional dashboards |
| **AMQP** | TCP | Medium | Medium | Internet | Enterprise messaging, guaranteed delivery |
| **LoRaWAN** | LoRa RF | Very low | Ultra low | 2-15 km | Remote sensors, agriculture, city-scale |
| **BLE** | BLE RF | Low | Very low | ~100m | Wearables, beacons, local sensors |
| **Zigbee** | IEEE 802.15.4 | Low | Very low | ~100m (mesh) | Home automation, mesh networks |

> [!TIP]
> When in doubt, use MQTT. It was designed specifically for IoT: minimal bandwidth, works over unreliable connections, supports offline buffering, and every cloud platform supports it.

## :mailbox_with_mail: MQTT DEEP DIVE

### Core Concepts

```text
Publisher ──publish──> [Topic: "home/bedroom/temperature"] ──> Broker ──> Subscriber
                                                                 │
                                                          Retained message
                                                          Last Will Testament
                                                          Persistent sessions
```

### QoS Levels

| QoS | Name | Delivery | Use Case |
|---|---|---|---|
| 0 | At most once | Fire and forget, may be lost | Frequent sensor readings (OK to lose one) |
| 1 | At least once | Guaranteed, possible duplicates | Commands, alerts (handle idempotently) |
| 2 | Exactly once | Guaranteed, no duplicates, 4-step handshake | Billing, critical state changes |

### Topic Design Best Practices

```text
# Hierarchical structure: {org}/{site}/{device_type}/{device_id}/{data_type}
acme/factory-1/sensor/temp-001/telemetry      # Sensor data
acme/factory-1/sensor/temp-001/status          # Device status
acme/factory-1/sensor/temp-001/command         # Commands TO device
acme/factory-1/sensor/+/telemetry              # Wildcard: all sensors' telemetry
acme/factory-1/#                                # Wildcard: everything in factory-1

# Reserved topics (convention)
$SYS/broker/clients/connected                   # Broker system topics
devices/{device_id}/shadow/update               # Device shadow updates
devices/{device_id}/shadow/get                  # Device shadow requests
```

### MQTT Broker Comparison

| Broker | Open Source | Clustering | Max Connections | Best For |
|---|---|---|---|---|
| **Mosquitto** | Yes | No (bridge only) | ~100K | Small deployments, development |
| **EMQX** | Yes (+ Enterprise) | Yes (native) | 100M+ | Large-scale production |
| **HiveMQ** | Community + Enterprise | Yes | Millions | Enterprise, compliance |
| **VerneMQ** | Yes | Yes (distributed) | Millions | Self-hosted production |
| **AWS IoT Core** | Managed | N/A | Unlimited (pay per message) | AWS ecosystem |

### ESP32 MQTT Client Example

```cpp
#include <WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>

// Device identity
const char* DEVICE_ID = "sensor-temp-001";
const char* MQTT_BROKER = "mqtt.example.com";
const int   MQTT_PORT = 8883; // TLS
const char* MQTT_USER = "device";
const char* MQTT_PASS = "secure-token";

WiFiClientSecure espClient;
PubSubClient mqtt(espClient);

// Topic definitions
String telemetry_topic = String("devices/") + DEVICE_ID + "/telemetry";
String command_topic = String("devices/") + DEVICE_ID + "/command";
String status_topic = String("devices/") + DEVICE_ID + "/status";

void mqtt_callback(char* topic, byte* payload, unsigned int length) {
    StaticJsonDocument<256> doc;
    deserializeJson(doc, payload, length);

    if (String(topic) == command_topic) {
        const char* action = doc["action"];
        if (strcmp(action, "reboot") == 0) {
            ESP.restart();
        } else if (strcmp(action, "set_interval") == 0) {
            report_interval_ms = doc["value"].as<int>() * 1000;
        }
    }
}

void mqtt_connect() {
    while (!mqtt.connected()) {
        // Last Will Testament: broker publishes this if device disconnects
        String lwt_payload = "{\"status\":\"offline\",\"device\":\"" + String(DEVICE_ID) + "\"}";

        if (mqtt.connect(DEVICE_ID, MQTT_USER, MQTT_PASS,
                         status_topic.c_str(), 1, true, // QoS 1, retained
                         lwt_payload.c_str())) {
            // Publish online status (retained)
            mqtt.publish(status_topic.c_str(),
                        "{\"status\":\"online\"}", true);
            // Subscribe to commands
            mqtt.subscribe(command_topic.c_str(), 1); // QoS 1
        } else {
            delay(5000); // Retry after 5 seconds
        }
    }
}

void publish_telemetry(float temperature, float humidity) {
    StaticJsonDocument<128> doc;
    doc["device_id"] = DEVICE_ID;
    doc["temperature"] = round(temperature * 100) / 100.0;
    doc["humidity"] = round(humidity * 100) / 100.0;
    doc["timestamp"] = millis();
    doc["battery_v"] = read_battery_voltage();

    char buffer[256];
    serializeJson(doc, buffer);
    mqtt.publish(telemetry_topic.c_str(), buffer, false); // QoS 0 for telemetry
}
```

## :cloud: CLOUD PLATFORM COMPARISON

| Platform | Pricing Model | Strengths | Weaknesses |
|---|---|---|---|
| **AWS IoT Core** | Per message ($1/M msgs) | Deepest AWS integration, rules engine | Complex setup, vendor lock-in |
| **Azure IoT Hub** | Per device tier | Device twins, strong enterprise | Expensive at scale |
| **Self-hosted (EMQX)** | Infrastructure cost | Full control, no vendor lock-in | Operational burden |
| **Thingsboard** | Open source + managed | Full platform (UI, rules, dashboards) | Can be heavy for simple needs |

## :ghost: DEVICE SHADOW / DIGITAL TWIN

A device shadow maintains the last known state even when the device is offline.

```json
{
    "state": {
        "reported": {
            "temperature": 23.5,
            "firmware_version": "1.4.2",
            "wifi_rssi": -67,
            "last_seen": "2026-02-08T10:30:00Z"
        },
        "desired": {
            "firmware_version": "1.5.0",
            "report_interval_sec": 30
        },
        "delta": {
            "firmware_version": "1.5.0"
        }
    },
    "metadata": {
        "reported": {
            "temperature": { "timestamp": 1707388200 }
        }
    }
}
```

**Flow**: Cloud sets `desired` state, device reads `delta` (difference between desired and reported), applies changes, then updates `reported` to match.

## :arrows_counterclockwise: OTA (OVER-THE-AIR) UPDATES

### Safe OTA Update Flow

```text
1. Device checks for update     ──> GET /api/ota/check?device_id=X&current_version=1.4.2
2. Server responds with update  ──> { "version": "1.5.0", "url": "...", "sha256": "...", "size": 1234567 }
3. Device downloads firmware    ──> Stream to inactive OTA partition (A/B scheme)
4. Verify SHA256 checksum       ──> Compare downloaded hash vs expected
5. Verify firmware signature    ──> RSA/ECDSA signature check (prevents tampering)
6. Mark new partition as boot   ──> Set OTA boot flag
7. Reboot to new firmware       ──> New firmware starts, runs self-test
8. Report success               ──> MQTT: { "firmware_version": "1.5.0", "ota_status": "success" }
9. If self-test fails           ──> Watchdog triggers, bootloader rolls back to previous
```

### Staged Rollout Strategy

```text
Stage 1:  5% of fleet  ──> Monitor for 24 hours ──> Check crash rate, connectivity
Stage 2: 25% of fleet  ──> Monitor for 24 hours ──> Compare metrics vs control group
Stage 3: 50% of fleet  ──> Monitor for 12 hours ──> Final validation
Stage 4: 100% of fleet ──> Full rollout

Auto-rollback trigger: crash rate > 5% OR connectivity loss > 10%
```

> [!WARNING]
> Never ship OTA without A/B partitioning. A failed OTA update without rollback capability will brick devices in the field. Field recovery is extremely expensive (truck rolls).

## :bar_chart: DATA PIPELINE

```text
Device ──MQTT──> Broker ──webhook──> Ingestion API ──> Stream Processing ──> Time-Series DB
                                                              │                    │
                                                         ┌────┴────┐          ┌────┴────┐
                                                         │ Rules   │          │ Grafana │
                                                         │ Engine  │          │Dashboard│
                                                         └────┬────┘          └─────────┘
                                                              │
                                                         ┌────┴────┐
                                                         │ Alerts  │
                                                         │ (email, │
                                                         │  SMS)   │
                                                         └─────────┘
```

### Node.js MQTT Subscriber and Data Pipeline

```typescript
import mqtt from 'mqtt';
import { InfluxDB, Point } from '@influxdata/influxdb-client';

const mqttClient = mqtt.connect('mqtts://mqtt.example.com:8883', {
    username: 'backend-service',
    password: process.env.MQTT_PASSWORD,
    ca: [fs.readFileSync('./certs/ca.crt')],
});

const influx = new InfluxDB({
    url: 'http://influxdb:8086',
    token: process.env.INFLUX_TOKEN,
});
const writeApi = influx.getWriteApi('iot-org', 'sensor-data');

mqttClient.on('connect', () => {
    console.log('Connected to MQTT broker');
    mqttClient.subscribe('devices/+/telemetry', { qos: 1 });
    mqttClient.subscribe('devices/+/status', { qos: 1 });
});

mqttClient.on('message', (topic: string, payload: Buffer) => {
    const segments = topic.split('/');
    const deviceId = segments[1];
    const dataType = segments[2];

    const data = JSON.parse(payload.toString());

    if (dataType === 'telemetry') {
        // Write to InfluxDB (time-series)
        const point = new Point('sensor_reading')
            .tag('device_id', deviceId)
            .floatField('temperature', data.temperature)
            .floatField('humidity', data.humidity)
            .floatField('battery_v', data.battery_v)
            .timestamp(new Date());

        writeApi.writePoint(point);

        // Check alerting rules
        if (data.temperature > 40) {
            triggerAlert(deviceId, 'HIGH_TEMPERATURE', data.temperature);
        }
        if (data.battery_v < 3.3) {
            triggerAlert(deviceId, 'LOW_BATTERY', data.battery_v);
        }
    }

    if (dataType === 'status') {
        updateDeviceRegistry(deviceId, data);
    }
});
```

### Time-Series Query (InfluxDB Flux)

```flux
from(bucket: "sensor-data")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "sensor_reading")
  |> filter(fn: (r) => r.device_id == "sensor-temp-001")
  |> filter(fn: (r) => r._field == "temperature")
  |> aggregateWindow(every: 15m, fn: mean, createEmpty: false)
  |> yield(name: "avg_temperature")
```

## :closed_lock_with_key: SECURITY CHECKLIST

| Layer | Requirement | Implementation |
|---|---|---|
| Transport | Encrypt all communication | TLS 1.2+ for MQTT (port 8883) |
| Identity | Unique device credentials | X.509 client certificates (preferred) or unique tokens |
| Authentication | Verify device identity | Mutual TLS or username/password per device |
| Authorization | Limit device actions | ACLs: device can only publish to its own topics |
| Firmware | Prevent tampering | Secure boot chain + signed firmware images |
| Storage | Protect credentials on device | Secure element (ATECC608) or encrypted NVS |
| Rotation | Limit credential lifetime | Certificate rotation every 1-2 years, revocation list |
| API | Protect management APIs | OAuth 2.0 / API keys + rate limiting |

### Device Provisioning Flow

```text
Manufacturing:
1. Generate unique device keypair (on secure element if available)
2. Sign device certificate with CA
3. Flash certificate + CA cert to device
4. Register device ID in cloud registry

First Boot:
1. Device connects with its certificate (mTLS)
2. Broker validates certificate against CA
3. Device receives its configuration (shadow/desired)
4. Device starts normal operation
```

> [!TIP]
> For prototyping, username/password authentication is fine. For production, always use X.509 client certificates. A compromised shared password exposes your entire fleet; a compromised certificate exposes one device.

## :busts_in_silhouette: FLEET MANAGEMENT

### Device Registry API

```typescript
// POST /api/devices - Register new device
interface DeviceRegistration {
    device_id: string;
    model: string;           // "sensor-v2", "gateway-v1"
    firmware_version: string;
    location: {
        site: string;        // "factory-1"
        zone: string;        // "warehouse-a"
        lat?: number;
        lng?: number;
    };
    tags: Record<string, string>; // { "customer": "acme", "env": "production" }
}

// GET /api/devices?status=online&model=sensor-v2&site=factory-1
// Response:
{
    "devices": [
        {
            "device_id": "sensor-temp-001",
            "status": "online",
            "last_seen": "2026-02-08T10:30:00Z",
            "firmware_version": "1.4.2",
            "battery_v": 3.7,
            "wifi_rssi": -67,
            "uptime_hours": 720
        }
    ],
    "total": 1247,
    "online": 1198,
    "offline": 49
}
```

### Fleet Health Dashboard Metrics

| Metric | Healthy | Warning | Critical |
|---|---|---|---|
| Online rate | > 95% | 85-95% | < 85% |
| Battery level | > 3.5V | 3.3-3.5V | < 3.3V |
| WiFi RSSI | > -60 dBm | -60 to -75 dBm | < -75 dBm |
| Firmware current | > 90% on latest | 70-90% | < 70% |
| Error rate (24h) | < 1% | 1-5% | > 5% |

## :chart_with_upwards_trend: SCALING TO MILLIONS OF DEVICES

| Challenge | Solution |
|---|---|
| Connection limits | Horizontal MQTT broker cluster (EMQX supports 100M+) |
| Message throughput | Kafka/Kinesis for stream processing behind broker |
| Data storage | Time-series DB with automatic downsampling and retention policies |
| API load | Separate read/write APIs, caching for device registry |
| OTA bandwidth | CDN for firmware distribution, delta updates |
| Edge processing | Filter/aggregate at gateway to reduce cloud traffic by 90% |

## :white_check_mark: EXIT CHECKLIST

- [ ] Devices connect securely via MQTT with TLS (port 8883)
- [ ] Device authentication uses unique credentials per device (certificates or tokens)
- [ ] MQTT topic ACLs prevent cross-device access
- [ ] OTA update pipeline works end-to-end with rollback capability
- [ ] Device shadow/twin syncs desired and reported state correctly
- [ ] Fleet dashboard shows all devices with status, battery, signal strength
- [ ] Data pipeline stores telemetry to time-series database (InfluxDB/TimescaleDB)
- [ ] Alerting rules trigger on threshold violations (temperature, battery, offline)
- [ ] Edge processing reduces unnecessary cloud traffic
- [ ] Monitoring tracks broker health, message throughput, connection counts
- [ ] Device provisioning workflow documented and tested
- [ ] Staged OTA rollout strategy defined with auto-rollback thresholds

*Skill Version: 1.0 | Created: February 2026*
