# `motion-monitor`

HomeAssistant configuration for basic monitoring of a `motion` addon environment.

## Introduction

The [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) addon for Home Assistant provides means to
configure and collect motion detection images from a variety of sources, including RSTP feeds, MJPEG via HTTP, and 
FTP submissions of motion video segments.

These sources are described by a _group_, _device_, and _camera_ combination; by default the group is `motion`, but may be used to distinguish between collections of devices.

A _device_ is a host computer running the [`motion-project.io`](http://motion-project.io) software, typically a RaspberryPi running a version of the `motion` addon for Home Assistant, for example `rpi1`.

Device identifiers cannot include spaces ` `, hyphens `-`, plus `+`, hash `#`, or slash `/` characters.

A _camera_ is associated with a device and may be one of the following types:

+ `rtsp` - a camera providing a real-time stream using RTSP
+ `mjpeg` - a camera providing a motion JPEG stream using HTTP
+ `local` - locally attached camera, e.g. `/dev/video0`
+ `ftpd` - a remote camera sending motion videos via FTP (n.b. requires `ftp` addon)

Each motion _event_ is composed of multiple JPEG images which are processed to produce the following:

+ key image
+ average image
+ blended image
+ composite image
+ GIF animation
+ GIF mask animation

All these images are published via MQTT on varying topics:

+ _group_`/`_device_`/`_camera_`/image/end`
+ _group_`/`_device_`/`_camera_`/image/average`
+ _group_`/`_device_`/`_camera_`/image/blend`
+ _group_`/`_device_`/`_camera_`/image/composite`
+ _group_`/`_device_`/`_camera_`/image/animated`
+ _group_`/`_device_`/`_camera_`/image/animated_mask`

In addition, a JSON payload is created with the event metadata and a single, key, frame from the sequence; **the image is BASE64 encoded**.  This payload is published on the following topic:

+  _group_`/`_device_`/`_camera_`/event/end`

The payload is collected by the [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) service.
This service utilizes the [YOLO](https://pjreddie.com/darknet/yolo/) object detection and classification software to identify any of the 
entities defined and trained; the default are listed in the [`input_select/detect_entity.yaml`](input_select/detect_entity.yaml) file.

The resulting image is added to the original payload and published to MQTT  on the corresponding topic:

+ _group_`/` _device_`/`_camera_`/event/end/`_entity_

The image itself is also published to MQTT on the following topic:

+ _group_`/` _device_`/`_camera_`/image/end/`_entity_

In the above templates, the **entity** defaults to `all`, indicating YOLO is searching for any known entity.

## Example

Below is a screenshot from the system.

![example.gif](sample/example.gif?raw=true "example")

## How to Use

Setup Home Assistant using a recent, standard, appropriate Raspbian or Ubuntu LINUX distribution.  For more details refer to the [instructions](http://github.com/dcmartin/horizon.dcmartin.com/tree/master/HASSIO.md) in a related repository.  Once Home Assistant has become operational, access the host system using `ssh`, for example:

```
% ssh pi41.local -l pi
<login>
```

1) Clone this repository to a local directory on the host device, for example:

```
$ cd /tmp
$ mkdir motion-monitor
$ cd motion-monitor
$ git clone http://github.com/dcmartin/motion-monitor .
```

2) Copy the contents of the directory into the Home Assistant configuration directory; root privilege is required, for example:

```
$ sudo mv .??* * /usr/share/hassio/homeassistant
```

3) Change directory to the Home Assistant configuration (`/usr/share/hassio/homeassistant`) and edit the `secrets.yaml` file for local specifics, notably:

+ `mqtt-broker`
+ `mqtt-username`
+ `mqtt-password`

4) Restart Home Assistant using the `make` command, for example:

```
$ sudo make restart
```


