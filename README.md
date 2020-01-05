# `motion-monitor`

HomeAssistant configuration for basic monitoring of a `motion` addon environment.

## Introduction

The [`motion`](http://github.com/dcmartin/hassio-addons/tree/master/motion/README.md) addon for Home Assistant provides means to
configure and collect motion detection images from a variety of sources, including RSTP feeds, MJPEG via HTTP, and 
FTP submissions of motion video segments.

Each motion _event_ is composed of multiple JPEG images which are processed to produce the following:

+ average image
+ blended image
+ motion masks
+ composite image
+ GIF animation
+ GIF mask animation

All these images are published via MQTT on varying topics:

+ _device_`/`_camera_`/event/average`
+ _device_`/`_camera_`/event/blend`
+ _device_`/`_camera_`/event/composite`
+ _device_`/`_camera_`/event/animated`

In addition, a JSON payload is created with the event metadata and a single, key, frame from the sequence; **the image is BASE64 encoded**.

The key frame image is collected by the [`yolo4motion`](http://github.com/dcmartin/open-horizon/tree/master/yolo4motion/README.md) service.
This service utilizes the [YOLO](https://pjreddie.com/darknet/yolo/) object detection and classification software to identify any of the 
entities defined and trained; the default are listed in the [`input_select/detect_entity.yaml`](input_select/detect_entity.yaml) file.


## Example

Below is a screenshot from the system.

![screenshot.png](sample/screenshot.png?raw=true "example")

