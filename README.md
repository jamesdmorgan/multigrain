# multigrain

Utility for managing samples on [Intellijel Multigrain](https://intellijel.com/shop/eurorack/multigrain/)

Run the script in the directory where you have samples you want to process ready for Multigrain

The script uses ffmpeg to perform:

1. 30Hz hipass filter to remove unwanted bottom end
2. [normalisation](https://ffmpeg.org/ffmpeg-filters.html#dynaudnorm) default `dynaudnorm=f=100:g=15`
3. [denoise](https://ffmpeg.org/ffmpeg-filters.html#afftdn) default `afftdn=nf=-25`
4. 16Khz lowpass to remove unwanted higher frequencies after normalising
5. Convert to 16bit audio
6. Trim to 32 seconds

See the [manual](https://intellijel.com/downloads/manuals/multigrain_manual_v1.2_2025.07.04.pdf) for audio requirements

* Original files are kept in a source directory
* Ableton bounce and timestamps are removed
* Whitespace is replaced with hyphens

```
$ multigrain.sh

Processing WAV files in: /Volumes/T7/Samples/Multigrain/Project01/01-start
Filter: highpass=f=30,dynaudnorm=f=100:g=15,afftdn=nf=-25,lowpass=f=16000
Cleaning 100-RING BLD1 (Bounce) (Bounce) (Bounce) [2025-07-20 131355].wav -> 100-RING-BLD1.wav
Processing 100-RING-BLD1.wav and trimming to 32s
Cleaning 101-CIZ1 BASS [2025-07-20 131400].wav -> 101-CIZ1-BASS.wav
Processing 101-CIZ1-BASS.wav and trimming to 32s
Cleaning 102 CIZ1 HI [2025-07-20 131400].wav -> 102-CIZ1-HI.wav
Processing 102-CIZ1-HI.wav and trimming to 32s
Cleaning 103-CIZ2 LOW1 (Bounce) (Bounce) (Bounce) [2025-07-20 131359].wav -> 103-CIZ2-LOW1.wav
Processing 103-CIZ2-LOW1.wav and trimming to 32s
Cleaning 104-CIZ2 MID1 (Bounce) (Bounce) (Bounce) [2025-07-20 131358].wav -> 104-CIZ2-MID1.wav
Processing 104-CIZ2-MID1.wav and trimming to 32s
Cleaning 105-CIZ3 HI1 (Bounce) (Bounce) (Bounce) [2025-07-20 131358].wav -> 105-CIZ3-HI1.wav
Processing 105-CIZ3-HI1.wav and trimming to 32s
Cleaning 106-CIZ3 HI2 (Bounce) (Bounce) (Bounce) [2025-07-20 131357].wav -> 106-CIZ3-HI2.wav
Processing 106-CIZ3-HI2.wav and trimming to 32s
Cleaning 107-RC000002 (Bounce) (Bounce) (Bounce) [2025-07-20 131357].wav -> 107-RC000002.wav
Processing 107-RC000002.wav and trimming to 32s
Cleaning 108-VOX1 (Bounce) (Bounce) (Bounce) [2025-07-20 131356].wav -> 108-VOX1.wav
Processing 108-VOX1.wav and trimming to 32s
Cleaning 109-CIZ3 MEL1 (Bounce) (Bounce) (Bounce) [2025-07-20 131356].wav -> 109-CIZ3-MEL1.wav
Processing 109-CIZ3-MEL1.wav and trimming to 32s
Cleaning 111-RING LOW1 (Bounce) (Bounce) (Bounce) [2025-07-20 131354].wav -> 111-RING-LOW1.wav
Processing 111-RING-LOW1.wav and trimming to 32s
Cleaning 112-RING LOW2 (Bounce) (Bounce) (Bounce) [2025-07-20 131354].wav -> 112-RING-LOW2.wav
Processing 112-RING-LOW2.wav and trimming to 32s
Complete - originals in ./source, processed files renamed and cleaned


.
├── 100-RING-BLD1.wav
├── 101-CIZ1-BASS.wav
├── 102-CIZ1-HI.wav
├── 103-CIZ2-LOW1.wav
├── 104-CIZ2-MID1.wav
├── 105-CIZ3-HI1.wav
├── 106-CIZ3-HI2.wav
├── 107-RC000002.wav
├── 108-VOX1.wav
├── 109-CIZ3-MEL1.wav
├── 111-RING-LOW1.wav
├── 112-RING-LOW2.wav
└── source
    ├── 100-RING BLD1 (Bounce) [2025-07-20 131355].wav
    ├── 101-CIZ1 BASS [2025-07-20 131400].wav
    ├── 102 CIZ1 HI [2025-07-20 131400].wav
    ├── 103-CIZ2 LOW1 (Bounce) [2025-07-20 131359].wav
    ├── 104-CIZ2 MID1 (Bounce) [2025-07-20 131358].wav
    ├── 105-CIZ3 HI1 (Bounce) [2025-07-20 131358].wav
    ├── 106-CIZ3 HI2 (Bounce) [2025-07-20 131357].wav
    ├── 107-RC000002 (Bounce) [2025-07-20 131357].wav
    ├── 108-VOX1 (Bounce) [2025-07-20 131356].wav
    ├── 109-CIZ3 MEL1 (Bounce) [2025-07-20 131356].wav
    ├── 111-RING LOW1 (Bounce) [2025-07-20 131354].wav
    └── 112-RING LOW2 (Bounce) [2025-07-20 131354].wav
```

```
 ffprobe -hide_banner  -show_streams 100-RING-BLD1.wav
Input #0, wav, from '100-RING-BLD1.wav':
  Metadata:
    encoder         : Lavf61.7.100
  Duration: 00:00:32.00, bitrate: 1536 kb/s
  Stream #0:0: Audio: pcm_s16le ([1][0][0][0] / 0x0001), 48000 Hz, 2 channels, s16, 1536 kb/s
[STREAM]
index=0
codec_name=pcm_s16le
codec_long_name=PCM signed 16-bit little-endian
profile=unknown
codec_type=audio
codec_tag_string=[1][0][0][0]
codec_tag=0x0001
sample_fmt=s16
sample_rate=48000
channels=2
channel_layout=unknown
bits_per_sample=16
initial_padding=0
id=N/A
r_frame_rate=0/0
avg_frame_rate=0/0
time_base=1/48000
start_pts=N/A
start_time=N/A
duration_ts=1536000
duration=32.000000
bit_rate=1536000
max_bit_rate=N/A
bits_per_raw_sample=N/A
nb_frames=N/A
nb_read_frames=N/A
nb_read_packets=N/A
DISPOSITION:default=0
DISPOSITION:dub=0
DISPOSITION:original=0
DISPOSITION:comment=0
DISPOSITION:lyrics=0
DISPOSITION:karaoke=0
DISPOSITION:forced=0
DISPOSITION:hearing_impaired=0
DISPOSITION:visual_impaired=0
DISPOSITION:clean_effects=0
DISPOSITION:attached_pic=0
DISPOSITION:timed_thumbnails=0
DISPOSITION:non_diegetic=0
DISPOSITION:captions=0
DISPOSITION:descriptions=0
DISPOSITION:metadata=0
DISPOSITION:dependent=0
DISPOSITION:still_image=0
DISPOSITION:multilayer=0
[/STREAM]
```
